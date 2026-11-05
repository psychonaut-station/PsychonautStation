/datum/dynamic_ruleset/roundstart/shadowling
	name = "Shadowlings"
	config_tag = "Roundstart Shadowlings"
	preview_antag_datum = /datum/antagonist/shadowling

	repeatable = FALSE
	weight = 3
	min_pop = 20

	pref_flag = ROLE_SHADOWLING
	jobban_flag = ROLE_SHADOWLING

	min_antag_cap = 3
	max_antag_cap = 3
	var/decimator = 15

/datum/dynamic_ruleset/roundstart/shadowling/get_always_blacklisted_roles()
	. = ..()
	for(var/datum/job/J as anything in SSjob.all_occupations)
		if(J.job_flags & JOB_HEAD_OF_STAFF)
			. |= J.title

/datum/dynamic_ruleset/roundstart/shadowling/is_valid_candidate(mob/candidate, client/candidate_client)
	. = ..()
	if(!.)
		return FALSE
	if(candidate.mind?.assigned_role?.job_flags & JOB_HEAD_OF_STAFF)
		return FALSE
	return TRUE

/datum/dynamic_ruleset/roundstart/shadowling/proc/target_count_for(population_size)
	if(population_size < min_pop)
		return 0
	var/excess = population_size - min_pop
	return 3 + floor(excess / decimator)

/datum/dynamic_ruleset/roundstart/shadowling/execute()
	var/list/alive_players = get_active_player_list(alive_check = TRUE, afk_check = TRUE)
	var/population_size = length(alive_players)
	var/need_total = clamp(target_count_for(population_size), min_antag_cap, max_antag_cap)
	var/got = length(selected_minds)
	var/need_extra = max(0, need_total - got)

	if(need_extra <= 0)
		return ..()

	var/list/minds_already_taken = list()
	for(var/datum/dynamic_ruleset/roundstart/R in SSdynamic.queued_rulesets)
		for(var/datum/mind/M in R.selected_minds)
			minds_already_taken |= M

	var/list/potential_candidates = list()
	for(var/mob/living/carbon/human/H in alive_players)
		var/datum/mind/M = H.mind
		if(!M || (M in minds_already_taken))
			continue
		potential_candidates += H

	var/list/valid_candidates = trim_candidates(potential_candidates)
	if(!length(valid_candidates))
		return ..()

	valid_candidates = shuffle(valid_candidates)
	for(var/i in 1 to min(need_extra, length(valid_candidates)))
		var/mob/living/carbon/human/H = valid_candidates[i]
		if(H.mind)
			assign_role(H.mind)
			selected_minds |= H.mind

	return ..()

/datum/dynamic_ruleset/roundstart/shadowling/assign_role(datum/mind/candidate)
	candidate.add_antag_datum(/datum/antagonist/shadowling)

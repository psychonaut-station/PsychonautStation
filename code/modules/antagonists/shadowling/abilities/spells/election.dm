/datum/action/cooldown/shadowling/election
	name = "Elect Hive Leader"
	desc = "Initiate an election for the Shadowling hive leader. The winner will be granted Engine Sabotage."
	button_icon_state = "shadow_vote"
	cooldown_time = 0 SECONDS

/datum/action/cooldown/shadowling/election/IsAvailable(feedback = FALSE)
	if(!..())
		return FALSE
	var/datum/team/shadow_hive/hive = get_shadow_hive()
	if(!hive)
		return FALSE
	if(hive.is_shadowling_vote_finished)
		if(feedback && owner)
			to_chat(owner, span_warning("A hive leader has already been chosen."))
		return FALSE
	return TRUE

/datum/action/cooldown/shadowling/election/DoEffect(mob/living/carbon/human/H, atom/_)
	var/datum/team/shadow_hive/hive = get_shadow_hive()
	if(!hive)
		return FALSE
	if(hive.is_shadowling_vote_finished)
		return FALSE

	if(hive.shadowling_vote)
		var/datum/shadow_vote/current = hive.shadowling_vote
		current.prompt_one(H)
		return TRUE

	var/datum/shadow_vote/vote = new(hive)
	vote.start()
	return TRUE

/datum/shadow_vote
	var/datum/team/shadow_hive/hive
	var/duration = 30 SECONDS
	var/active = FALSE
	var/list/candidates = list()
	var/list/votes = list()

/datum/shadow_vote/New(datum/team/shadow_hive/_hive, dur = 30 SECONDS)
	. = ..()
	hive = _hive
	duration = dur
	if(hive)
		hive.shadowling_vote = src

/datum/shadow_vote/proc/start()
	if(active)
		return
	if(!hive)
		qdel(src)
		return
	active = TRUE

	candidates.Cut()
	for(var/mob/living/carbon/human/L in hive.lings)
		if(QDELETED(L) || L.stat == DEAD)
			continue
		candidates += L

	for(var/mob/living/carbon/human/L in hive.lings)
		if(QDELETED(L) || L.stat == DEAD)
			continue
		to_chat(L, span_boldnotice("A vote for the Hive Leader has begun! You have 30 seconds to choose."))

	if(length(candidates) <= 1)
		finalize()
		return

	for(var/mob/living/carbon/human/L in hive.lings)
		if(QDELETED(L) || !L.client || L.stat == DEAD)
			continue
		addtimer(CALLBACK(src, PROC_REF(prompt_one), L), 0)

	addtimer(CALLBACK(src, PROC_REF(finalize)), duration, TIMER_STOPPABLE)

/datum/shadow_vote/proc/prompt_one(mob/living/carbon/human/voter)
	if(!active)
		return
	if(QDELETED(voter))
		return
	if(!(voter in hive.lings))
		return

	var/list/choices = list()
	for(var/mob/living/carbon/human/C in candidates)
		choices["[C.real_name] (\ref[C])"] = C

	var/ans = tgui_input_list(voter, "Choose the hive leader:", "Hive Vote", choices)
	if(!active)
		return

	if(ans && (voter in hive.lings) && !(voter in votes))
		votes[voter] = choices[ans]
		to_chat(voter, span_notice("Your vote has been recorded."))
		for(var/datum/action/cooldown/shadowling/election/A in voter.actions)
			A.Remove(voter)
			qdel(A)

/datum/shadow_vote/proc/finalize()
	if(!active)
		return
	active = FALSE

	var/list/living_candidates = list()
	for(var/mob/living/carbon/human/C in candidates)
		if(!QDELETED(C) && C.stat != DEAD && (C in hive.lings))
			living_candidates += C

	var/list/tally = list()
	for(var/mob/living/carbon/human/C in living_candidates)
		tally[C] = 0
	for(var/mob/living/carbon/human/Voter in votes)
		var/mob/living/carbon/human/Choice = votes[Voter]
		if(Choice && (Choice in tally))
			tally[Choice]++

	var/list/winners = list()
	var/best = -1
	for(var/mob/living/carbon/human/C in tally)
		var/cnt = tally[C]
		if(cnt > best)
			winners = list(C); best = cnt
		else if(cnt == best)
			winners += C
	if(!length(winners))
		winners = living_candidates.Copy()

	var/mob/living/carbon/human/leader = length(winners) ? pick(winners) : null

	if(leader && !QDELETED(leader))
		hive.leader = leader
		if(!hive.is_shadowling_engine_sabotage_used)
			var/datum/action/cooldown/shadowling/engine_sabotage/S = new
			S.Grant(leader)

		for(var/mob/living/carbon/human/L in hive.lings)
			if(QDELETED(L))
				continue
			to_chat(L, span_boldnotice("The hive leader has been chosen: [leader.real_name].[!hive.is_shadowling_engine_sabotage_used ? " They have been granted Engine Sabotage." : ""]"))

	remove_vote_action_from_all()

	hive.is_shadowling_vote_finished = TRUE

	if(hive.shadowling_vote == src)
		hive.shadowling_vote = null

	qdel(src)

/datum/shadow_vote/proc/remove_vote_action_from_all()
	if(!hive)
		return
	var/list/all_members = hive.lings + hive.thralls
	for(var/mob/living/carbon/human/M in all_members)
		if(QDELETED(M))
			continue
		var/list/actions_to_remove = list()
		for(var/datum/action/cooldown/shadowling/election/A in M.actions)
			actions_to_remove += A
		for(var/datum/action/A in actions_to_remove)
			A.Remove(M)
			qdel(A)

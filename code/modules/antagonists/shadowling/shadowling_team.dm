/datum/team/shadow_hive
	name = "\improper Shadow Hive"
	var/shadowling_vote
	var/is_shadowling_vote_finished
	var/is_shadowling_engine_sabotage_used
	var/asc_thralls_needed = 0
	var/mob/leader
	var/list/lings = list()
	var/list/thralls = list()
	var/list/ling_roles = list()
	var/last_sync_thrall_count = 0
	var/max_thralls_reached = 0
	var/is_ascended = FALSE

/datum/team/shadow_hive/New()
	. = ..()
	if(!GLOB.shadowling_hive)
		GLOB.shadowling_hive = src
	if(!(src in GLOB.antagonist_teams))
		GLOB.antagonist_teams += src
	_shadowling_dedupe_teams()

/datum/team/shadow_hive/Destroy()
	if(GLOB.shadowling_hive == src)
		GLOB.shadowling_hive = null
	for(var/mob/living/L as anything in lings)
		if(!QDELETED(L))
			UnregisterSignal(L, COMSIG_QDELETING)
	for(var/mob/living/T as anything in thralls)
		if(!QDELETED(T))
			UnregisterSignal(T, COMSIG_QDELETING)
	lings.Cut()
	thralls.Cut()
	ling_roles.Cut()
	return ..()

/datum/team/shadow_hive/proc/update_objective_explanations()
	if(!islist(objectives))
		return

	for(var/datum/objective/shadowling/enslave_fraction/O in objectives)
		O.update_explanation_text()

/datum/team/shadow_hive/add_member(datum/mind/new_member)
	if(!new_member || is_unassigned_job(new_member.assigned_role))
		return
	. = ..()
	if(!(new_member in members))
		members += new_member

/datum/team/shadow_hive/remove_member(datum/mind/old_member)
	. = ..()
	if(!old_member)
		return
	members -= old_member

/datum/team/shadow_hive/proc/join_member(mob/living/carbon/human/H, role = SHADOWLING_ROLE_THRALL)
	if(!istype(H))
		return
	if(QDELETED(H))
		return
	lings -= H
	thralls -= H
	ling_roles -= H
	UnregisterSignal(H, COMSIG_QDELETING)
	if(role == SHADOWLING_ROLE_THRALL)
		thralls += H
	else
		lings += H
		ling_roles[H] = role
	RegisterSignal(H, COMSIG_QDELETING, PROC_REF(_on_member_qdel))
	if(H.mind && !(H.mind in members))
		members += H.mind
	to_chat(H, span_notice("You feel the whisper of the hive echoing in your mind..."))
	grant_comm_action(H)
	grant_night_vision(H)
	update_objective_explanations()

/datum/team/shadow_hive/proc/leave_member(mob/living/carbon/human/H)
	if(!istype(H))
		return
	lings -= H
	thralls -= H
	ling_roles -= H
	UnregisterSignal(H, COMSIG_QDELETING)
	if(H.mind && (H.mind in members))
		members -= H.mind
	update_objective_explanations()

/datum/team/shadow_hive/proc/_on_member_qdel(mob/living/source)
	SIGNAL_HANDLER
	lings -= source
	thralls -= source
	ling_roles -= source
	UnregisterSignal(source, COMSIG_QDELETING)
	if(source?.mind && (source.mind in members))
		members -= source.mind
	update_objective_explanations()

/datum/team/shadow_hive/proc/sanitize()
	for(var/i = length(lings) to 1 step -1)
		var/mob/living/L = lings[i]
		if(QDELETED(L) || !istype(L, /mob/living))
			lings.Cut(i, i + 1)
	for(var/i = length(thralls) to 1 step -1)
		var/mob/living/T = thralls[i]
		if(QDELETED(T) || !istype(T, /mob/living))
			thralls.Cut(i, i + 1)
	for(var/mob/M as anything in ling_roles.Copy())
		if(!(M in lings))
			ling_roles -= M
	var/list/keep = list()
	for(var/mob/living/carbon/human/K in lings + thralls)
		if(K?.mind)
			keep[K.mind] = TRUE
	for(var/datum/mind/mm as anything in members.Copy())
		if(!keep[mm])
			members -= mm

/datum/team/shadow_hive/proc/count_alive_thralls()
	sanitize()
	var/count = 0
	for(var/mob/living/carbon/human/T in thralls)
		if(QDELETED(T))
			continue
		if(T.stat == DEAD)
			continue
		count++
	return count

/datum/team/shadow_hive/proc/count_max_thralls()
	return max_thralls_reached

/datum/team/shadow_hive/proc/grant_comm_action(mob/living/carbon/human/H)
	if(!istype(H))
		return
	for(var/datum/action/cooldown/shadowling/commune/existing in H.actions)
		return
	var/datum/action/cooldown/shadowling/commune/A = new
	A.Grant(H)

/datum/team/shadow_hive/proc/grant_night_vision(mob/living/carbon/human/H)
	if(!istype(H))
		return
	for(var/datum/action/cooldown/shadowling/toggle_night_vision/existing in H.actions)
		return
	var/datum/action/cooldown/shadowling/toggle_night_vision/A = new
	A.Grant(H)

/datum/team/shadow_hive/proc/get_ling_role(mob/living/carbon/human/H)
	if(!istype(H))
		return null
	if(!(H in lings))
		return null
	return ling_roles[H]

/datum/team/shadow_hive/proc/apply_evac_delay(delay_time = 10 MINUTES)
	if(!SSshuttle || !SSshuttle.emergency)
		return FALSE
	if(SSshuttle.emergency.mode != SHUTTLE_CALL)
		return FALSE
	var/security_num = SSsecurity_level.get_current_level_as_number()
	var/set_coefficient = 1
	switch(security_num)
		if(SEC_LEVEL_GREEN)
			set_coefficient = 2
		if(SEC_LEVEL_BLUE)
			set_coefficient = 1
		else
			set_coefficient = 0.5
	var/new_timer = SSshuttle.emergency.timeLeft(1) + delay_time
	SSshuttle.emergency.setTimer(new_timer)
	var/surplus = new_timer - (SSshuttle.emergency_call_time * set_coefficient)
	if(surplus > 0)
		SSshuttle.block_recall(surplus)
	var/mins = round(delay_time / (1 MINUTES))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(priority_announce), "Power fluctuations detected in the reactor circuit. Emergency shuttle arrival delayed by [mins] minutes.", "Priority Announcement", 'sound/announcer/announcement/announce_syndi.ogg', null, "[command_name()]: Transportation Division"), rand(2 SECONDS, 6 SECONDS))
	return TRUE

/datum/team/shadow_hive/proc/shadowling_set_ascended(mob/living/carbon/human/H, ascended = TRUE)
	if(!istype(H))
		return
	if(ascended)
		H.set_species(/datum/species/shadow/shadowling/ascended)
		is_ascended = TRUE
	else
		H.set_species(/datum/species/shadow/shadowling)

/proc/_shadowling_dedupe_teams()
	var/datum/team/shadow_hive/main = get_shadow_hive()
	if(!main)
		return

	var/list/dupes = list()
	for(var/datum/team/shadow_hive/T in GLOB.antagonist_teams)
		if(T != main)
			dupes += T

	for(var/datum/team/shadow_hive/T in dupes)
		for(var/mob/living/carbon/human/L in T.lings)
			if(L && !(L in main.lings))
				main.lings += L
		for(var/mob/living/carbon/human/THR in T.thralls)
			if(THR && !(THR in main.thralls))
				main.thralls += THR
		for(var/mob/M as anything in T.ling_roles)
			if(M && !main.ling_roles[M])
				main.ling_roles[M] = T.ling_roles[M]
		main.max_thralls_reached = max(main.max_thralls_reached, T.max_thralls_reached)
		for(var/datum/mind/M in T.members)
			if(M && !(M in main.members))
				main.members += M
			if(M)
				var/datum/antagonist/shadowling/SL = M.has_antag_datum(/datum/antagonist/shadowling)
				if(SL)
					SL.shadow_team = main
		GLOB.antagonist_teams -= T
		qdel(T)

/datum/team/shadow_hive/proc/setup_objectives()
	if(length(objectives))
		return

	add_objective(new /datum/objective/shadowling/enslave_fraction)
	add_objective(new /datum/objective/shadowling/ascend)

	refresh_ascension_thralls_needed()

/datum/team/shadow_hive/proc/get_objectives()
	return objectives

/datum/team/shadow_hive/proc/sync_after_event(mob/living/carbon/human/actor)
	sync_hive(actor)

/datum/team/shadow_hive/proc/sync_hive(mob/living/carbon/human/actor)
	if(!istype(actor))
		return
	sanitize()
	refresh_ascension_thralls_needed()
	update_objective_explanations()

	for(var/datum/action/cooldown/shadowling/hive_sync/existing in actor.actions)
		qdel(existing)

	for(var/datum/action/cooldown/shadowling/shadow_grab/old_grab in actor.actions)
		qdel(old_grab)
	for(var/datum/action/cooldown/shadowling/hook/old_hook in actor.actions)
		qdel(old_hook)
	for(var/datum/action/cooldown/shadowling/shadow_smoke/old_smoke in actor.actions)
		qdel(old_smoke)

	if(isshadowling_ascended(actor) || is_ascended)
		for(var/datum/action/cooldown/shadowling/ascend/old_asc in actor.actions)
			qdel(old_asc)
		for(var/datum/action/cooldown/shadowling/hatch/old_hatch in actor.actions)
			qdel(old_hatch)
	else if(isshadowling(actor))
		for(var/datum/action/cooldown/shadowling/hatch/old_hatch in actor.actions)
			qdel(old_hatch)

	var/alive_count = count_alive_thralls()
	max_thralls_reached = max(max_thralls_reached, alive_count)
	last_sync_thrall_count = max_thralls_reached

	var/datum/action/cooldown/shadowling/hive_sync/temp_sync = new
	var/list/new_unlocks = temp_sync.grant_unlocks_for(actor, max_thralls_reached)
	qdel(temp_sync)

	if(length(new_unlocks))
		to_chat(actor, span_notice("Hive synchronized: [alive_count] living thralls. New abilities unlocked: [jointext(new_unlocks, ", ")]."))
	else
		to_chat(actor, span_notice("Hive synchronized: [alive_count] living thralls. No new abilities unlocked."))

/proc/get_shadow_hive()
	if(GLOB.shadowling_hive)
		return GLOB.shadowling_hive

	var/datum/team/shadow_hive/T = new /datum/team/shadow_hive
	GLOB.shadowling_hive = T
	if(!(T in GLOB.antagonist_teams))
		GLOB.antagonist_teams += T
	_shadowling_dedupe_teams()
	return T

/datum/team/shadow_hive/proc/shadowling_grant_hatch(mob/living/carbon/human/H)
	if(!istype(H))
		return null
	if(isshadowling(H) || isshadowling_ascended(H))
		return null
	for(var/datum/action/cooldown/shadowling/hatch/X in H.actions)
		return X
	var/datum/action/cooldown/shadowling/hatch/A = new
	A.Grant(H)
	return A

/datum/team/shadow_hive/proc/shadowling_grant_nightvision(mob/living/carbon/human/H)
	if(!istype(H))
		return null
	for(var/datum/action/cooldown/shadowling/toggle_night_vision/X in H.actions)
		return X
	var/datum/action/cooldown/shadowling/toggle_night_vision/A = new
	A.Grant(H)
	return A

/datum/team/shadow_hive/proc/get_ascension_thralls_needed()
	if(asc_thralls_needed > 0)
		return asc_thralls_needed

	return refresh_ascension_thralls_needed()

/datum/team/shadow_hive/proc/refresh_ascension_thralls_needed()
	var/datum/objective/shadowling/enslave_fraction/obj = null
	if(islist(objectives))
		obj = (locate(/datum/objective/shadowling/enslave_fraction) in objectives)

	if(obj)
		asc_thralls_needed = max(1, obj.required_thralls())
		return asc_thralls_needed

	var/baseline = 0
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(player.ready == PLAYER_READY_TO_PLAY)
			baseline++

	if(!baseline)
		baseline = length(get_crewmember_minds())
	if(baseline <= 0)
		baseline = 1

	asc_thralls_needed = max(1, CEILING((baseline * SHADOWLING_ASCEND_DEFAULT_PERCENT) / 100, 1))
	return asc_thralls_needed

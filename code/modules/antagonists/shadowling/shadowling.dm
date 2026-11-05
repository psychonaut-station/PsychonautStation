/datum/mood_event/shadowling
	description = "The cold darkness within whispers of power."
	mood_change = 12
	hidden = TRUE

// MARK: Antagonist
/datum/antagonist/shadowling
	name = "Shadowling"
	roundend_category = "Shadowlings"
	antagpanel_category = "Shadowling"
	pref_flag = ROLE_SHADOWLING
	stinger_sound = 'sound/antagonists/shadowlings/shadowling_gain.ogg'
	antag_moodlet = /datum/mood_event/shadowling
	hud_icon = 'icons/mob/huds/antag_hud.dmi'
	antag_hud_name = "shadowling"
	ui_name = "AntagInfoShadowling"

	var/ling_role = SHADOWLING_ROLE_MAIN
	var/is_thrall = FALSE
	var/is_ascended = FALSE

	var/datum/team/shadow_hive/shadow_team

/datum/antagonist/shadowling/can_be_owned(datum/mind/new_owner)
	if(new_owner?.has_antag_datum(type))
		return FALSE
	return ..()

/datum/antagonist/shadowling/get_preview_icon()
	var/mob/living/carbon/human/dummy/consistent/dummy = new()
	dummy.set_species(/datum/species/shadow/shadowling, icon_update = TRUE)
	return finish_preview_icon(render_preview_outfit(preview_outfit, dummy))

/datum/antagonist/shadowling/on_gain()
	if(!owner)
		return

	var/datum/team/shadow_hive/hive = get_shadow_hive()
	shadow_team = hive
	shadow_team.setup_objectives()

	shadow_team.add_member(owner)

	var/mob/living/carbon/human/H = owner.current
	if(istype(H))
		shadow_team.join_member(H, ling_role)
		if(!is_thrall)
			hive.shadowling_grant_hatch(H)

	if(is_thrall)
		var/list/thrall_objs = list(
			new /datum/objective/shadow_thrall/survive,
			new /datum/objective/shadow_thrall/assist_ascension,
			new /datum/objective/shadow_thrall/save_shadowlings,
		)
		for(var/datum/objective/O in thrall_objs)
			O.owner = owner
		objectives |= thrall_objs
	else
		objectives |= shadow_team.get_objectives()

	. = ..()

	if(istype(H))
		add_team_hud(H)
		shadow_team.sync_after_event(H)

	owner.announce_objectives()

/datum/antagonist/shadowling/on_removal()
	var/mob/living/carbon/human/H = owner?.current

	var/datum/team/shadow_hive/hive = GLOB.shadowling_hive
	if(istype(H) && hive)
		hive.leave_member(H)

	if(shadow_team && owner)
		shadow_team.remove_member(owner)

	if(istype(H))
		for(var/datum/action/cooldown/ability in H.actions.Copy())
			if(ability.type in typesof(/datum/action/cooldown/shadowling))
				ability.Remove(H)

	. = ..()

/datum/antagonist/shadowling/apply_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/current = owner?.current || mob_override
	if(current)
		add_team_hud(current)

/datum/antagonist/shadowling/proc/set_lesser()
	ling_role = SHADOWLING_ROLE_LESSER

/datum/antagonist/shadowling/proc/set_higher(state)
	is_ascended = state
	var/mob/living/carbon/human/H = owner?.current
	var/datum/team/shadow_hive/hive = get_shadow_hive()
	if(istype(H) && hive)
		hive.shadowling_set_ascended(H, state)

/datum/antagonist/shadow_thrall
	parent_type = /datum/antagonist/shadowling
	name = "Shadow Thrall"
	antagpanel_category = "Shadowlings"
	antag_hud_name = "shadowling_thrall"

	is_thrall = TRUE
	ling_role = SHADOWLING_ROLE_THRALL

/datum/antagonist/shadow_thrall/on_gain()
	. = ..()

	var/mob/living/carbon/H = owner?.current
	if(istype(H) && !H.get_organ_slot(ORGAN_SLOT_BRAIN_THRALL))
		var/obj/item/organ/brain/shadow/tumor_thrall/tumor = new
		tumor.Insert(H)

// MARK: Objectives
/datum/objective/shadowling/enslave_fraction
	name = "Subjugate the crew"
	admin_grantable = TRUE
	var/percent = 50
	var/baseline_population = 0

/datum/objective/shadowling/enslave_fraction/New(pct = null)
	if(isnum(pct))
		percent = clamp(round(pct), 1, 100)
	capture_baseline_population()
	update_explanation_text()
	return ..()

/datum/objective/shadowling/enslave_fraction/proc/capture_baseline_population()
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(player.ready == PLAYER_READY_TO_PLAY)
			baseline_population++
	if(!baseline_population)
		baseline_population = length(get_crewmember_minds())
	if(baseline_population <= 0)
		baseline_population = 1

/datum/objective/shadowling/enslave_fraction/proc/required_thralls()
	return max(1, CEILING((baseline_population * percent) / 100, 1))

/datum/objective/shadowling/enslave_fraction/proc/current_thralls()
	var/datum/team/shadow_hive/hive = get_shadow_hive()
	if(!hive)
		return 0
	return hive.count_alive_thralls()

/datum/objective/shadowling/enslave_fraction/update_explanation_text()
	var/need = required_thralls()
	var/have = current_thralls()
	explanation_text = "Enslave at least [need] crew members. Currently: [have]/[need]."

/datum/objective/shadowling/enslave_fraction/check_completion()
	return current_thralls() >= required_thralls()

/datum/objective/shadowling/enslave_fraction/admin_edit(mob/admin)
	var/new_pct = input(admin, "What percentage of starting crew must be enslaved?", "Shadowling objective", percent) as num|null
	if(isnum(new_pct))
		percent = clamp(round(new_pct), 1, 100)
		update_explanation_text()

		var/datum/team/shadow_hive/hive = get_shadow_hive()
		hive?.refresh_ascension_thralls_needed()

/datum/objective/shadowling/ascend
	name = "Achieve Ascension"
	admin_grantable = TRUE

/datum/objective/shadowling/ascend/update_explanation_text()
	explanation_text = "Ascend, taking on the ultimate form of the Shadowling."

/datum/objective/shadowling/ascend/check_completion()
	if(!owner || !owner.current)
		return FALSE
	var/mob/living/carbon/human/H = owner.current
	return istype(H.dna?.species, /datum/species/shadow/shadowling/ascended)

/datum/antagonist/shadowling/roundend_report()
	var/list/report = list()
	if(!owner)
		CRASH("Antagonist datum without owner")
	report += printplayer(owner)
	var/objectives_complete = TRUE
	if(objectives.len)
		report += printobjectives(objectives)
		for(var/datum/objective/O in objectives)
			if(!O.check_completion())
				objectives_complete = FALSE
				break
	var/datum/team/shadow_hive/hive = get_shadow_hive()
	if(hive)
		var/alive_thralls = hive.count_alive_thralls()
		var/total_lings = 0
		var/alive_lings = 0
		for(var/mob/living/carbon/human/L in hive.lings)
			total_lings++
			if(L.stat != DEAD)
				alive_lings++
		report += "<span class='notice'>Thralls (alive): [alive_thralls]. Shadowlings alive: [alive_lings]/[total_lings].</span>"
	if(objectives.len == 0 || objectives_complete)
		report += "<span class='greentext big'>[name] was successful!</span>"
	else
		report += "<span class='redtext big'>[name] failed!</span>"
	return report.Join("<br>")

/datum/antagonist/shadowling/get_team()
	return shadow_team

/datum/antagonist/shadowling/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, ui_name, "Shadowling Broodmind")
		ui.open()

/datum/antagonist/shadowling/ui_data(mob/user)
	var/list/data = list()
	var/mob/living/carbon/human/H = ishuman(user) ? user : (owner?.current && ishuman(owner.current) ? owner.current : null)
	var/datum/team/shadow_hive/hive = shadow_team || get_shadow_hive()

	var/role_text = "Master Shadowling"
	var/role_code = "master"
	if(is_ascended || (H && isshadowling_ascended(H)))
		role_text = "Ascended Shadowling"
		role_code = "ascended"
	else if(is_thrall)
		role_text = "Shadow Thrall"
		role_code = "thrall"
	else if(ling_role == SHADOWLING_ROLE_LESSER)
		role_text = "Lesser Shadowling"
		role_code = "lesser"

	var/thrall_count = hive ? hive.count_alive_thralls() : 0
	var/thralls_needed = hive ? hive.get_ascension_thralls_needed() : 0

	data["name"] = H?.real_name || "Unknown"
	data["role"] = role_text
	data["role_type"] = role_code
	data["is_ascended"] = is_ascended || (H && isshadowling_ascended(H))
	data["is_thrall"] = is_thrall
	data["is_hatched"] = H && (isshadowling(H) || isshadowling_ascended(H))
	data["hive_name"] = hive?.name || "The Shadow Brood"
	data["thrall_count"] = thrall_count
	data["thralls_needed"] = thralls_needed
	data["ascension_progress"] = thralls_needed > 0 ? min(100, round((thrall_count / thralls_needed) * 100)) : 0
	data["is_hive_ascended"] = hive ? hive.is_ascended : FALSE
	data["leader_name"] = hive?.leader ? hive.leader.real_name : null

	if(hive)
		hive.update_objective_explanations()
	if(is_thrall)
		for(var/datum/objective/O in objectives)
			O.update_explanation_text()

	data["objectives"] = get_objectives()
	data["can_change_objective"] = can_assign_self_objectives

	var/list/roster = list()
	if(hive)
		hive.sanitize()
		for(var/mob/living/carbon/human/ling as anything in hive.lings)
			if(QDELETED(ling))
				continue
			var/ling_stat = "Alive"
			if(istype(ling.loc, /obj/effect/dummy/phased_mob/shadowling) || ling.has_status_effect(/datum/status_effect/shadow/phase))
				ling_stat = "Phased"
			else if(ling.stat == DEAD)
				ling_stat = "Dead"
			else if(IS_UNCONSCIOUS_OR_CRIT(ling) || ling.health <= 0)
				ling_stat = "Critical"

			var/m_role = "Master Shadowling"
			if(isshadowling_ascended(ling))
				m_role = "Ascended Shadowling"
			else if(hive.get_ling_role(ling) == SHADOWLING_ROLE_LESSER)
				m_role = "Lesser Shadowling"

			roster += list(list(
				"name" = ling.real_name || ling.name,
				"role" = m_role,
				"stat" = ling_stat,
				"is_user" = (ling == H),
			))

		for(var/mob/living/carbon/human/thrall as anything in hive.thralls)
			if(QDELETED(thrall))
				continue
			var/thrall_stat = "Alive"
			if(istype(thrall.loc, /obj/effect/dummy/phased_mob/shadowling) || thrall.has_status_effect(/datum/status_effect/shadow/phase))
				thrall_stat = "Phased"
			else if(thrall.stat == DEAD)
				thrall_stat = "Dead"
			else if(IS_UNCONSCIOUS_OR_CRIT(thrall) || thrall.health <= 0)
				thrall_stat = "Critical"

			roster += list(list(
				"name" = thrall.real_name || thrall.name,
				"role" = "Shadow Thrall",
				"stat" = thrall_stat,
				"is_user" = (thrall == H),
			))

	data["roster"] = roster
	data["abilities"] = get_abilities_data(H, hive, thrall_count, thralls_needed)

	return data

/datum/antagonist/shadowling/proc/get_abilities_data(mob/living/carbon/human/H, datum/team/shadow_hive/hive, thrall_count, thralls_needed)
	var/list/innate_types = list(
		/datum/action/cooldown/shadowling/commune,
		/datum/action/cooldown/shadowling/toggle_night_vision,
		/datum/action/cooldown/shadowling/glare,
		/datum/action/cooldown/shadowling/veil,
		/datum/action/cooldown/shadowling/enthrall,
		/datum/action/cooldown/shadowling/recuperation,
		/datum/action/cooldown/shadowling/election,
	)

	var/list/threshold_types = list(
		/datum/action/cooldown/shadowling/shadow_phase = 15,
		/datum/action/cooldown/shadowling/cold_wave = 30,
		/datum/action/cooldown/shadowling/shadow_barrier = 30,
		/datum/action/cooldown/shadowling/shreek = 40,
		/datum/action/cooldown/shadowling/labyrinth = 60,
		/datum/action/cooldown/shadowling/ascend = 100,
	)

	var/list/ascended_types = list(
		/datum/action/cooldown/shadowling/shadow_strike,
		/datum/action/cooldown/shadowling/root,
	)

	var/list/owned_action_types = list()
	if(H)
		for(var/datum/action/A in H.actions)
			for(var/check_path in (innate_types + threshold_types + ascended_types))
				if(istype(A, check_path))
					owned_action_types[check_path] = TRUE

	var/list/ability_list = list()

	for(var/path in innate_types)
		var/datum/action/cooldown/shadowling/sample = path
		var/ch = round(initial(sample.channel_time) / 10)
		if(path == /datum/action/cooldown/shadowling/enthrall)
			ch = 30
		var/req_dark = initial(sample.requires_dark_user) || initial(sample.requires_dark_target)
		ability_list += list(list(
			"name" = initial(sample.name),
			"desc" = initial(sample.desc),
			"icon" = initial(sample.button_icon_state),
			"cooldown" = round(initial(sample.cooldown_time) / 10),
			"channel" = ch,
			"required_thralls" = 0,
			"required_percent" = 0,
			"unlocked" = !isnull(owned_action_types[path]),
			"category" = "Innate",
			"requires_dark" = req_dark,
		))

	for(var/path in threshold_types)
		var/datum/action/cooldown/shadowling/sample = path
		var/pct = threshold_types[path]
		var/calc_thralls = 0
		if(thralls_needed > 0)
			var/count = ceil(thralls_needed * (pct / 100))
			calc_thralls = clamp(count, initial(sample.min_req), initial(sample.max_req))
		var/req_dark = initial(sample.requires_dark_user) || initial(sample.requires_dark_target)
		ability_list += list(list(
			"name" = initial(sample.name),
			"desc" = initial(sample.desc),
			"icon" = initial(sample.button_icon_state),
			"cooldown" = round(initial(sample.cooldown_time) / 10),
			"channel" = round(initial(sample.channel_time) / 10),
			"required_thralls" = calc_thralls,
			"required_percent" = pct,
			"unlocked" = !isnull(owned_action_types[path]),
			"category" = "Threshold",
			"requires_dark" = req_dark,
		))

	for(var/path in ascended_types)
		var/datum/action/cooldown/shadowling/sample = path
		var/req_dark = initial(sample.requires_dark_user) || initial(sample.requires_dark_target) || (path == /datum/action/cooldown/shadowling/root)
		ability_list += list(list(
			"name" = initial(sample.name),
			"desc" = initial(sample.desc),
			"icon" = initial(sample.button_icon_state),
			"cooldown" = round(initial(sample.cooldown_time) / 10),
			"channel" = round(initial(sample.channel_time) / 10),
			"required_thralls" = thralls_needed,
			"required_percent" = 100,
			"unlocked" = !isnull(owned_action_types[path]),
			"category" = "Ascended",
			"requires_dark" = req_dark,
		))

	return ability_list

/datum/antagonist/shadowling/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return TRUE

	var/mob/living/carbon/human/H = ui.user
	if(!istype(H))
		return TRUE

	var/datum/team/shadow_hive/hive = shadow_team || get_shadow_hive()

	switch(action)
		if("sync")
			if(hive)
				hive.sync_hive(H)
			return TRUE
		if("commune")
			for(var/datum/action/cooldown/shadowling/commune/C in H.actions)
				C.Trigger(H)
				break
			return TRUE
		if("change_objectives")
			submit_player_objective()
			return TRUE

/datum/objective/shadow_thrall
	name = "Thrall Objective"
	admin_grantable = TRUE

/datum/objective/shadow_thrall/survive
	name = "Survive"
	explanation_text = "Survive until the end of the round while remaining a thrall of the Shadow."

/datum/objective/shadow_thrall/survive/check_completion()
	if(!owner || !owner.current)
		return FALSE
	if(owner.current.stat == DEAD)
		return FALSE
	return !!owner.has_antag_datum(/datum/antagonist/shadow_thrall, TRUE)

/datum/objective/shadow_thrall/assist_ascension
	name = "Assist Ascension"
	explanation_text = "Help the shadowlings ascend: at least one Ascended Shadowling must exist by the end of the round."

/datum/objective/shadow_thrall/assist_ascension/check_completion()
	var/datum/team/shadow_hive/hive = get_shadow_hive()
	if(!hive)
		return FALSE
	for(var/mob/living/carbon/human/L in hive.lings)
		if(isshadowling_ascended(L))
			return TRUE
	return FALSE

/datum/objective/shadow_thrall/save_shadowlings
	name = "Save your Masters"
	explanation_text = "If the shadowlings are dead or missing: rally the thralls, gather your strength, and find and save your Masters."

/datum/objective/shadow_thrall/save_shadowlings/check_completion()
	var/datum/team/shadow_hive/hive = get_shadow_hive()
	if(!hive)
		return FALSE
	for(var/mob/living/carbon/human/L in hive.lings)
		if(isshadowling_ascended(L) || (L.stat != DEAD && !QDELETED(L)))
			return TRUE
	return FALSE

// MARK: Global shadowling roundender
/proc/shadowling_begin_roundender(mob/living/carbon/human/ascended=null)
	if(GLOB.is_shadowling_roundender_started)
		return
	GLOB.is_shadowling_roundender_started = TRUE

	send_to_playing_players("<span class='shadowradio_win'><b>THE UNIFIED SHADOW CONSUMES THE STATION!</b></span>")
	for(var/mob/player as anything in GLOB.player_list)
		if(player && !isnewplayer(player))
			SEND_SOUND(player, sound(SHADOWLING_RISEN_MUSIC, volume = 70))

	priority_announce(
		text = "Caution! Our long-range sensors have detected an unprecedented surge of paranormal activity. Due to imminent station consumption, immediately mobilize all assets and initiate emergency evacuation procedures. Emergency shuttle launch is authorized and irreversible.",
		title = "[command_name()]: Paranormal Phenomenon Division",
		sound = SSstation.announcer.get_rand_report_sound(),
		has_important_message = TRUE,
	)

	var/datum/hostile_ref = ascended ? ascended : (get_shadow_hive() || "Shadowling Hive")
	SSshuttle.registerHostileEnvironment(hostile_ref)
	SSshuttle.lockdown = TRUE
	SSshuttle.requestEvac(ascended, "Emergency evacuation authorized due to paranormal threat.")

ADMIN_VERB(toggle_shadowling_debug, R_DEBUG, "Toggle Shadowling Debug", "Toggles Shadowling test mode (mindless/carbon enthrall, fast cast, bypass lighting).", ADMIN_CATEGORY_DEBUG)
	GLOB.shadowling_debug_mode = !GLOB.shadowling_debug_mode
	to_chat(usr, span_boldnotice("Shadowling Debug Mode is now [GLOB.shadowling_debug_mode ? "ENABLED" : "DISABLED"]."))
	message_admins("[ADMIN_LOOKUPFLW(usr)] toggled Shadowling Debug Mode to [GLOB.shadowling_debug_mode ? "ENABLED" : "DISABLED"].")

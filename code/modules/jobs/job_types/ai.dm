/datum/job/ai
	title = JOB_AI
	description = "Assist the crew, follow your laws, coordinate your cyborgs."
	auto_deadmin_role_flags = DEADMIN_POSITION_SILICON
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "your laws"
	spawn_type = /mob/living/silicon/ai
	req_admin_notify = TRUE
	minimal_player_age = 30
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_SILICON
	exp_granted_type = EXP_TYPE_CREW
	display_order = JOB_DISPLAY_ORDER_AI
	allow_bureaucratic_error = FALSE
	departments_list = list(
		/datum/job_department/silicon,
	)
	random_spawns_possible = FALSE
	job_flags = JOB_NEW_PLAYER_JOINABLE | JOB_EQUIP_RANK | JOB_BOLD_SELECT_TEXT | JOB_CANNOT_OPEN_SLOTS
	config_tag = "AI"
	alt_titles = list(
		"AI",
		"Station Intelligence",
		"Automated Overseer",
	)

/datum/job/ai/proc/is_viable_data_core(obj/machinery/ai/data_core/core, require_transfer_ready = FALSE, require_empty = TRUE)
	if(!core || QDELETED(core))
		return FALSE
	if(require_empty && (locate(/mob/living/silicon/ai) in core.contents))
		return FALSE
	if(require_transfer_ready && !core.can_transfer_ai())
		return FALSE
	return TRUE

/datum/job/ai/proc/get_preferred_data_core(require_transfer_ready = FALSE, require_empty = TRUE)
	var/obj/machinery/ai/data_core/preferred_core = GLOB.primary_data_core
	if(is_viable_data_core(preferred_core, require_transfer_ready, require_empty))
		return preferred_core

	for(var/obj/machinery/ai/data_core/candidate_core as anything in GLOB.data_cores)
		if(is_viable_data_core(candidate_core, require_transfer_ready, require_empty))
			return candidate_core

	for(var/obj/effect/landmark/start/ai/ai_landmark in GLOB.landmarks_list)
		ai_landmark.bootstrap_decentralized_ai_hardware()

	preferred_core = GLOB.primary_data_core
	if(is_viable_data_core(preferred_core, require_transfer_ready, require_empty))
		return preferred_core
	for(var/obj/machinery/ai/data_core/candidate_core as anything in GLOB.data_cores)
		if(is_viable_data_core(candidate_core, require_transfer_ready, require_empty))
			return candidate_core

	return null

/datum/job/ai/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	var/mob/living/silicon/ai/ai_spawn = spawned
	if(!istype(ai_spawn))
		return

	if(!ai_spawn.ensure_data_core_residency(TRUE))
		ai_spawn.pending_roundstart_link = TRUE
		ai_spawn.complete_roundstart_relocation()

	if(SSticker.current_state == GAME_STATE_SETTING_UP)
		for(var/mob/living/silicon/robot/robot in GLOB.silicon_mobs)
			if(!robot.connected_ai)
				robot.TryConnectToAI()

	if(player_client)
		ai_spawn.set_gender(player_client)

	ai_spawn.log_current_laws()

/datum/job/ai/get_roundstart_spawn_point()
	var/obj/machinery/ai/data_core/roundstart_core = get_preferred_data_core(TRUE)
	if(roundstart_core)
		return roundstart_core
	roundstart_core = get_preferred_data_core()
	if(roundstart_core)
		return roundstart_core
	return get_latejoin_spawn_point()

/datum/job/ai/get_latejoin_spawn_point()
	var/obj/machinery/ai/data_core/latejoin_core = get_preferred_data_core(TRUE)
	if(latejoin_core)
		return latejoin_core
	latejoin_core = get_preferred_data_core()
	if(latejoin_core)
		return latejoin_core

	var/list/primary_spawn_points = list()
	var/list/secondary_spawn_points = list()
	for(var/obj/effect/landmark/start/ai/spawn_point in GLOB.landmarks_list)
		if(spawn_point.used)
			secondary_spawn_points += list(spawn_point)
			continue
		if(spawn_point.primary_ai)
			primary_spawn_points = list(spawn_point)
			break
		primary_spawn_points += spawn_point

	var/obj/effect/landmark/start/ai/chosen_spawn_point
	if(length(primary_spawn_points))
		chosen_spawn_point = pick(primary_spawn_points)
	else if(length(secondary_spawn_points))
		chosen_spawn_point = pick(secondary_spawn_points)
	else
		CRASH("Failed to find any AI spawn points.")

	chosen_spawn_point.bootstrap_decentralized_ai_hardware()
	latejoin_core = get_preferred_data_core()
	if(latejoin_core)
		return latejoin_core

	chosen_spawn_point.used = TRUE
	return chosen_spawn_point

/datum/job/ai/special_check_latejoin(client/C)
	return !!get_preferred_data_core(TRUE) || !!get_preferred_data_core()

/datum/job/ai/announce_job(mob/living/joining_mob)
	. = ..()
	if(SSticker.HasRoundStarted())
		minor_announce("[joining_mob] has been downloaded to the central AI network.")

/datum/job/ai/config_check()
	return CONFIG_GET(flag/allow_ai)

/datum/job/ai/get_radio_information()
	return "<b>Prefix your message with :b to speak with cyborgs and other AIs.</b>"

/datum/job/ai/on_respawn(mob/new_character)
	new_character.AIize()

/datum/job/ai/get_lobby_icon()
	return icon('icons/mob/huds/hud.dmi', "hudai")

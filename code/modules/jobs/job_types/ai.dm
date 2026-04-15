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

/datum/job/ai/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	var/mob/living/silicon/ai/ai_spawn = spawned
	if(!istype(ai_spawn))
		return

	var/obj/machinery/ai/data_core/start_core = ai_spawn.available_ai_cores(TRUE)
	if(!start_core)
		for(var/obj/effect/landmark/start/ai/ai_landmark in GLOB.landmarks_list)
			ai_landmark.bootstrap_decentralized_ai_hardware()
		start_core = ai_spawn.available_ai_cores(TRUE)

	if(!start_core)
		start_core = GLOB.primary_data_core
	if(!start_core)
		for(var/obj/machinery/ai/data_core/fallback_core as anything in GLOB.data_cores)
			start_core = fallback_core
			break

	if(start_core && !QDELETED(start_core))
		start_core.transfer_ai_mob(ai_spawn)
		if(start_core.can_transfer_ai())
			ai_spawn.claim_default_network_resources()
			ai_spawn.pending_roundstart_link = FALSE
		else
			ai_spawn.pending_roundstart_link = TRUE
	else
		ai_spawn.complete_roundstart_relocation()

	if(SSticker.current_state == GAME_STATE_SETTING_UP)
		for(var/mob/living/silicon/robot/robot in GLOB.silicon_mobs)
			if(!robot.connected_ai)
				robot.TryConnectToAI()

	if(player_client)
		ai_spawn.set_gender(player_client)

	ai_spawn.log_current_laws()

/datum/job/ai/get_roundstart_spawn_point()
	return get_latejoin_spawn_point()

/datum/job/ai/get_latejoin_spawn_point()
	for(var/obj/structure/ai_core/latejoin_inactive/inactive_core as anything in GLOB.latejoin_ai_cores)
		if(!inactive_core.is_available())
			continue
		GLOB.latejoin_ai_cores -= inactive_core
		inactive_core.available = FALSE
		var/turf/core_turf = get_turf(inactive_core)
		qdel(inactive_core)
		return core_turf

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

	chosen_spawn_point.used = TRUE
	return chosen_spawn_point

/datum/job/ai/special_check_latejoin(client/C)
	for(var/obj/machinery/ai/data_core/latejoin_core as anything in GLOB.data_cores)
		if(latejoin_core.valid_data_core())
			return TRUE
	return FALSE

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

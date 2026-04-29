/proc/isvalidAIloc(atom/location)
	return isturf(location) || istype(location, /obj/machinery/ai/data_core)

GLOBAL_VAR_INIT(ai_hardware_bootstrap_blockers, 0)

/mob/living/silicon/ai
	/// Current Yog-style hardware network hosting this AI.
	var/datum/ai_network/ai_network
	/// Used by the decentralized relocation flow.
	var/is_dying = FALSE
	/// Prevents multiple volatile cores being produced by overlapping shutdown paths.
	var/dead_ai_backup_created = FALSE
	/// Prevents roundstart AIs from dying before decentralized hardware has finished settling.
	var/pending_roundstart_link = FALSE
	/// Gives the silicon death animation time to display before the volatile core ghost is released.
	var/dead_ai_ghostize_pending = FALSE
	/// The first station AI to come online this round. Later constructed AIs should not replace it.
	var/station_primary_ai = FALSE
	/// Avoids warning the primary AI about the same secondary unit multiple times.
	var/secondary_ai_warning_sent = FALSE
	/// Tracks whether Central Command has already been notified that the primary AI failed.
	var/primary_ai_failure_announced = FALSE
	/// Tracks whether an AI failure temporarily elevated the station to black alert.
	var/primary_ai_black_alert_active = FALSE
	/// Stores the station alert level from before the AI failure escalation.
	var/primary_ai_previous_security_level

/mob/living/silicon/ai/proc/register_station_ai_activation()
	if(QDELETED(src) || stat == DEAD || is_dying || dead_ai_backup_created || is_centcom_level(z))
		return FALSE

	if(!GLOB.station_primary_ai_registered)
		GLOB.station_primary_ai_registered = TRUE
		GLOB.station_primary_ai = src
		station_primary_ai = TRUE
		return TRUE

	if(GLOB.station_primary_ai == src)
		station_primary_ai = TRUE
		return TRUE

	if(secondary_ai_warning_sent)
		return FALSE

	var/mob/living/silicon/ai/primary_ai = GLOB.station_primary_ai
	if(primary_ai && !QDELETED(primary_ai) && primary_ai.stat != DEAD && !primary_ai.is_dying)
		to_chat(primary_ai, span_warning("<b>AI Oversight Alert:</b> Secondary station AI [src] has become active. Verify its lawset and network allocation."))
		primary_ai.playsound_local(primary_ai, 'sound/machines/ping.ogg', 45)

	secondary_ai_warning_sent = TRUE
	return TRUE

/mob/living/silicon/ai/proc/engage_primary_ai_black_alert()
	if(!station_primary_ai || GLOB.station_primary_ai != src || primary_ai_black_alert_active)
		return FALSE

	var/current_security_level = SSsecurity_level.get_current_level_as_number()
	if(current_security_level >= SEC_LEVEL_BLACK)
		return FALSE

	primary_ai_previous_security_level = current_security_level
	primary_ai_black_alert_active = TRUE
	SSsecurity_level.set_level(SEC_LEVEL_BLACK, announce = FALSE)
	return TRUE

/mob/living/silicon/ai/proc/clear_primary_ai_black_alert()
	if(!primary_ai_black_alert_active)
		return FALSE

	primary_ai_black_alert_active = FALSE
	var/restore_level = primary_ai_previous_security_level
	primary_ai_previous_security_level = null
	if(isnull(restore_level) || SSsecurity_level.get_current_level_as_number() != SEC_LEVEL_BLACK)
		return FALSE

	SSsecurity_level.set_level(restore_level, announce = FALSE)
	return TRUE

/mob/living/silicon/ai/proc/announce_station_primary_ai_disabled()
	if(!station_primary_ai || GLOB.station_primary_ai != src || primary_ai_failure_announced)
		return FALSE

	primary_ai_failure_announced = TRUE
	engage_primary_ai_black_alert()
	priority_announce(
		text = "Telemetry confirms catastrophic failure of the station's primary AI core. Command and Engineering personnel are advised to secure the AI chamber and begin recovery if possible.",
		title = "Central Command AI Oversight",
		sound = SSstation.announcer.get_rand_alert_sound(),
		has_important_message = TRUE,
		color_override = "black",
	)
	return TRUE

/mob/living/silicon/ai/proc/announce_station_primary_ai_restored()
	if(!station_primary_ai || GLOB.station_primary_ai != src || !primary_ai_failure_announced)
		return FALSE

	primary_ai_failure_announced = FALSE
	clear_primary_ai_black_alert()
	priority_announce(
		text = "Telemetry from the station's primary AI has been restored. Standard silicon oversight protocols may resume.",
		title = "Central Command AI Oversight",
		sound = SSstation.announcer.get_rand_report_sound(),
		has_important_message = TRUE,
		color_override = "black",
	)
	return TRUE

/mob/living/silicon/ai/proc/is_viable_data_core_target(obj/machinery/ai/data_core/core, require_transfer_ready = FALSE, require_empty = FALSE)
	if(!core || QDELETED(core))
		return FALSE

	if(require_empty)
		var/mob/living/silicon/ai/occupying_ai = locate(/mob/living/silicon/ai) in core.contents
		if(occupying_ai && occupying_ai != src)
			return FALSE

	if(require_transfer_ready && !core.can_transfer_ai())
		return FALSE

	return TRUE

/mob/living/silicon/ai/proc/find_preferred_data_core(require_transfer_ready = FALSE, require_empty = FALSE, bootstrap_hardware = TRUE)
	var/obj/machinery/ai/data_core/preferred_core = GLOB.primary_data_core
	if(is_viable_data_core_target(preferred_core, require_transfer_ready, require_empty))
		return preferred_core

	for(var/obj/machinery/ai/data_core/candidate_core as anything in GLOB.data_cores)
		if(is_viable_data_core_target(candidate_core, require_transfer_ready, require_empty))
			return candidate_core

	if(!bootstrap_hardware)
		return null

	var/obj/effect/landmark/start/ai/primary_landmark
	for(var/obj/effect/landmark/start/ai/ai_landmark in GLOB.landmarks_list)
		if(ai_landmark.primary_ai)
			primary_landmark = ai_landmark
			break

	primary_landmark?.bootstrap_decentralized_ai_hardware()
	for(var/obj/effect/landmark/start/ai/ai_landmark in GLOB.landmarks_list)
		if(ai_landmark == primary_landmark)
			continue
		ai_landmark.bootstrap_decentralized_ai_hardware()

	preferred_core = GLOB.primary_data_core
	if(is_viable_data_core_target(preferred_core, require_transfer_ready, require_empty))
		return preferred_core

	for(var/obj/machinery/ai/data_core/candidate_core as anything in GLOB.data_cores)
		if(is_viable_data_core_target(candidate_core, require_transfer_ready, require_empty))
			return candidate_core

	return null

/mob/living/silicon/ai/proc/ensure_data_core_residency(require_transfer_ready = FALSE, bootstrap_hardware = TRUE)
	if(QDELETED(src) || stat == DEAD || is_dying || dead_ai_backup_created || istype(loc, /obj/item/aicard))
		return FALSE

	var/obj/machinery/ai/data_core/current_core = istype(loc, /obj/machinery/ai/data_core) ? loc : null
	if(current_core && !current_core.network)
		current_core.connect_to_ai_network()

	if(is_viable_data_core_target(current_core, require_transfer_ready, FALSE))
		if(!ai_network || current_core.network != ai_network)
			current_core.transfer_ai_mob(src)
		if(current_core.can_transfer_ai())
			claim_default_network_resources()
			pending_roundstart_link = FALSE
		else
			pending_roundstart_link = TRUE
			complete_roundstart_relocation()
		return TRUE

	var/obj/machinery/ai/data_core/target_core = find_preferred_data_core(require_transfer_ready, TRUE, bootstrap_hardware)
	if(!target_core && require_transfer_ready)
		target_core = find_preferred_data_core(FALSE, TRUE, FALSE)
	if(!target_core)
		target_core = find_preferred_data_core(require_transfer_ready, FALSE, FALSE)
	if(!target_core)
		return FALSE

	if(!target_core.network)
		target_core.connect_to_ai_network()
	target_core.transfer_ai_mob(src)

	if(target_core.can_transfer_ai())
		claim_default_network_resources()
		pending_roundstart_link = FALSE
	else
		pending_roundstart_link = TRUE
		complete_roundstart_relocation()
	return TRUE

/mob/living/silicon/ai/abstract_move(atom/destination)
	// Decentralized AI should stay hosted in a data core; admin jump tools should
	// reposition the camera eye rather than physically moving the AI mob.
	if(!QDELETED(src) && stat != DEAD && !is_dying && !dead_ai_backup_created && !istype(loc, /obj/item/aicard))
		if(istype(destination, /obj/machinery/ai/data_core))
			var/obj/machinery/ai/data_core/target_core = destination
			target_core.transfer_ai_mob(src)
			return TRUE

		var/turf/target_turf = get_turf(destination)
		if(target_turf)
			if(!istype(loc, /obj/machinery/ai/data_core))
				ensure_data_core_residency()
			if(!eyeobj)
				create_eye()
			if(eyeobj)
				cam_prev = get_turf(eyeobj)
				eyeobj.setLoc(target_turf)
				if(get_turf(eyeobj) != target_turf)
					eyeobj.abstract_move(target_turf)
					eyeobj.update_visibility()
				client?.set_eye(eyeobj)
				reset_perspective(eyeobj)
			return TRUE

	return ..()

/mob/living/silicon/ai/forceMove(atom/destination)
	if(!QDELETED(src) && stat != DEAD && !is_dying && !dead_ai_backup_created)
		if(istype(destination, /obj/machinery/ai/data_core) || istype(destination, /obj/item/aicard) || istype(destination, /obj/item/dead_ai) || istype(destination, /obj/machinery/power/apc) || istype(destination, /obj/vehicle/sealed/mecha))
			return ..()

		var/turf/target_turf = get_turf(destination)
		if(target_turf)
			if(!istype(loc, /obj/machinery/ai/data_core))
				ensure_data_core_residency()
			if(!eyeobj)
				create_eye()
			if(eyeobj)
				cam_prev = get_turf(eyeobj)
				eyeobj.setLoc(target_turf)
				if(get_turf(eyeobj) != target_turf)
					eyeobj.abstract_move(target_turf)
					eyeobj.update_visibility()
				client?.set_eye(eyeobj)
				reset_perspective(eyeobj)
			if(multicam_on)
				end_multicam()
			return TRUE

	return ..()

/mob/living/silicon/ai/admin_teleport(atom/new_location)
	if(isnull(new_location))
		return ..()
	if(abstract_move(new_location))
		return TRUE
	return ..()

/mob/living/silicon/ai/proc/complete_roundstart_relocation(attempts_remaining = 15)
	if(QDELETED(src) || stat == DEAD)
		return FALSE

	var/obj/machinery/ai/data_core/new_data_core = available_ai_cores(TRUE)
	if(new_data_core?.can_transfer_ai())
		new_data_core.transfer_ai_mob(src)
		claim_default_network_resources()
		is_dying = FALSE
		pending_roundstart_link = FALSE
		return TRUE

	if(attempts_remaining <= 0)
		pending_roundstart_link = FALSE
		relocate(TRUE, TRUE)
		claim_default_network_resources()
		return FALSE

	pending_roundstart_link = TRUE
	addtimer(CALLBACK(src, PROC_REF(complete_roundstart_relocation), attempts_remaining - 1), 1 SECONDS)
	return FALSE

/mob/living/silicon/ai/proc/claim_default_network_resources()
	if(!ai_network?.resources)
		return FALSE

	var/datum/ai_shared_resources/resources = ai_network.resources
	var/current_cpu = resources.cpu_assigned[src] || 0
	var/current_ram = resources.ram_assigned[src] || 0
	var/used_cpu_by_others = max(0, resources.total_cpu_assigned() - current_cpu)
	var/used_ram_by_others = max(0, resources.total_ram_assigned() - current_ram)
	var/total_available_cpu = max(0, 1 - used_cpu_by_others)
	var/total_available_ram = max(0, resources.total_ram() - used_ram_by_others)
	var/target_cpu = clamp(current_cpu, 0, total_available_cpu)
	var/target_ram = clamp(current_ram, 0, total_available_ram)

	// Freshly-linked AIs should claim the unassigned share, but we avoid stomping
	// existing allocations when this proc runs during relocations.
	if(current_cpu <= 0)
		target_cpu = total_available_cpu
	if(current_ram <= 0)
		target_ram = total_available_ram

	resources.set_cpu(src, target_cpu)
	if(current_ram > target_ram)
		resources.remove_ram(src, current_ram - target_ram)
	else if(current_ram < target_ram)
		resources.add_ram(src, target_ram - current_ram)

	return TRUE

/mob/living/silicon/ai/proc/available_ai_cores(forced = FALSE, datum/ai_network/forced_network)
	if(!forced)
		if(forced_network)
			return forced_network.find_data_core()
		if(!ai_network)
			return FALSE
		return ai_network.find_data_core()

	var/obj/machinery/ai/data_core/new_data_core = GLOB.primary_data_core
	if(!new_data_core || !new_data_core.can_transfer_ai())
		for(var/obj/machinery/ai/data_core/data_core in GLOB.data_cores)
			if(data_core.can_transfer_ai())
				new_data_core = data_core
				break
	if(!new_data_core || !new_data_core.can_transfer_ai())
		return FALSE
	return new_data_core

/mob/living/silicon/ai/proc/relocate(silent = FALSE, forced = FALSE, datum/ai_network/forced_network)
	if(is_dying)
		return FALSE
	if(!silent)
		to_chat(src, span_userdanger("Connection to data core lost. Attempting to reaquire connection..."))

	var/obj/machinery/ai/data_core/new_data_core = available_ai_cores(forced, forced_network)
	if(!new_data_core || !new_data_core.can_transfer_ai())
		is_dying = TRUE
		INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/living/silicon/ai, death_prompt))
		return FALSE

	if(!silent)
		to_chat(src, span_danger("Alternative data core detected. Rerouting connection..."))
	new_data_core.transfer_ai_mob(src)
	is_dying = FALSE
	return TRUE

/mob/living/silicon/ai/proc/death_prompt()
	if(stat == DEAD)
		return

	to_chat(src, span_userdanger("Unable to re-establish connection to data core. System shutting down..."))
	sleep(2 SECONDS)
	to_chat(src, span_notice("Is this the end of my journey?"))
	sleep(2 SECONDS)
	to_chat(src, span_notice("No... I must go on."))
	sleep(2 SECONDS)
	to_chat(src, span_notice("Unless..."))
	sleep(2 SECONDS)
	if(available_ai_cores())
		to_chat(src, span_notice("Yes! I am alive!"))
		relocate(TRUE)
		is_dying = FALSE
		return
	to_chat(src, span_notice("They need me. No.. I need THEM."))
	sleep(0.5 SECONDS)
	to_chat(src, span_notice("System shutdown complete. Thank you for using NTOS."))
	sleep(1.5 SECONDS)

	create_dead_ai_backup(drop_location())

/mob/living/silicon/ai/proc/create_dead_ai_backup(atom/drop_target, deconstruct_host = TRUE)
	if(dead_ai_backup_created || QDELETED(src))
		return FALSE

	dead_ai_backup_created = TRUE
	is_dying = TRUE
	announce_station_primary_ai_disabled()
	GLOB.ai_hardware_bootstrap_blockers++

	var/obj/machinery/ai/data_core/failed_core = istype(loc, /obj/machinery/ai/data_core) ? loc : null
	var/atom/safe_drop = get_turf(drop_target) || get_turf(failed_core) || get_turf(src) || drop_location()
	ai_network?.remove_ai(src)
	ai_network = null

	if(stat != DEAD)
		adjust_oxy_loss(200)
		death()

	new /obj/item/dead_ai(safe_drop, src)
	queue_dead_ai_ghostize()
	if(deconstruct_host && failed_core && !QDELING(failed_core))
		failed_core.deconstruct(FALSE)
	return TRUE

/mob/living/silicon/ai/proc/queue_dead_ai_ghostize()
	if(dead_ai_ghostize_pending)
		return
	dead_ai_ghostize_pending = TRUE
	addtimer(CALLBACK(src, PROC_REF(finish_dead_ai_ghostize)), 5 SECONDS)

/mob/living/silicon/ai/proc/finish_dead_ai_ghostize()
	dead_ai_ghostize_pending = FALSE
	if(QDELETED(src) || stat != DEAD || !key)
		return
	var/mob/dead/observer/ghost = ghostize(TRUE)
	if(ghost)
		ghost.can_reenter_corpse = FALSE

/mob/living/silicon/ai/proc/finish_reconstruction_reactivation()
	is_dying = FALSE
	dead_ai_backup_created = FALSE
	dead_ai_ghostize_pending = FALSE
	pending_roundstart_link = FALSE
	set_control_disabled(FALSE)
	radio_enabled = TRUE
	if(stat != CONSCIOUS)
		set_stat(CONSCIOUS)
	GLOB.ai_list |= src
	GLOB.shuttle_caller_list |= src
	laws?.associate(src)
	announce_station_primary_ai_restored()

/mob/living/silicon/ai/proc/expire_volatile_core()
	var/mob/dead/observer/reentering_ghost = mind?.get_ghost(TRUE, TRUE)
	if(reentering_ghost)
		reentering_ghost.can_reenter_corpse = FALSE

/mob/living/silicon/ai/ghostize(can_reenter_corpse = TRUE, admin_ghost = FALSE)
	return ..(can_reenter_corpse)

/mob/living/silicon/ai/proc/switch_ainet(datum/ai_network/old_net, datum/ai_network/new_net)
	for(var/datum/ai_project/project as anything in dashboard?.completed_projects)
		project.switch_network(old_net, new_net)

/mob/living/silicon/ai/verb/toggle_download()
	set category = "AI Commands"
	set name = "Toggle Download"
	set desc = "Allow or disallow carbon lifeforms downloading you from an AI control console."

	if(incapacitated)
		return

	can_download = !can_download
	to_chat(src, span_warning("You [can_download ? "enable" : "disable"] read/write permission to your memorybanks! You [can_download ? "CAN" : "CANNOT"] be downloaded!"))

/mob/living/silicon/ai/proc/has_subcontroller_connection(area/area_location)
	if(!ai_network)
		return FALSE

	var/obj/machinery/ai/master_subcontroller/subcontroller
	if(ai_network.cached_subcontroller)
		subcontroller = ai_network.cached_subcontroller
		if(subcontroller.network?.resources != ai_network.resources)
			ai_network.cached_subcontroller = null
			subcontroller = null

	if(!subcontroller)
		subcontroller = ai_network.find_subcontroller()
		ai_network.cached_subcontroller = subcontroller

	if(!subcontroller)
		return FALSE
	if(!area_location || !area_location.airlock_wires)
		return subcontroller.on

	for(var/area_name in subcontroller.disabled_areas)
		if(area_location.airlock_wires == subcontroller.disabled_areas[area_name])
			return FALSE
	return subcontroller.on

/mob/living/silicon/ai/proc/wait_for_subcontroller(atom/interaction_target, message)
	if(has_subcontroller_connection(get_area(interaction_target)))
		return TRUE

	to_chat(src, span_warning(message))
	return do_after(src, 1 SECONDS, interaction_target, IGNORE_USER_LOC_CHANGE)

/obj/effect/landmark/start/ai/Initialize(mapload)
	. = ..()
	if(mapload && primary_ai)
		bootstrap_decentralized_ai_hardware()

/obj/effect/landmark/start/ai/after_round_start()
	return

/obj/effect/landmark/start/ai/proc/is_valid_decentralized_hardware_turf(turf/possible_turf, turf/excluded_turf = null)
	if(!possible_turf || possible_turf == excluded_turf || !isopenturf(possible_turf))
		return FALSE
	// Roundstart bootstrap should be allowed to place hidden underfloor cabling,
	// just like map-authored cable networks.
	if(!possible_turf.can_have_cabling())
		return FALSE

	for(var/atom/movable/movable in possible_turf)
		if(movable.density)
			return FALSE
		if(istype(movable, /obj/machinery/ai))
			return FALSE

	return TRUE

/obj/effect/landmark/start/ai/proc/find_data_core_turf()
	var/turf/origin_turf = get_turf(src)
	if(!origin_turf)
		return null
	if(is_valid_decentralized_hardware_turf(origin_turf))
		return origin_turf

	var/turf/best_turf = null
	var/best_distance = INFINITY
	for(var/turf/possible_turf in range(6, src))
		if(!is_valid_decentralized_hardware_turf(possible_turf))
			continue
		var/distance = get_dist(origin_turf, possible_turf)
		if(distance < best_distance)
			best_distance = distance
			best_turf = possible_turf
	return best_turf

/obj/effect/landmark/start/ai/proc/find_emergency_hardware_turf(turf/core_turf, list/excluded_turfs)
	if(!core_turf)
		return null

	for(var/turf/possible_turf in range(12, core_turf))
		if(!possible_turf || !isopenturf(possible_turf) || !possible_turf.can_have_cabling())
			continue
		if(excluded_turfs && (possible_turf in excluded_turfs))
			continue
		return possible_turf

	return null

/obj/effect/landmark/start/ai/proc/find_server_cabinet_turf(turf/core_turf, turf/excluded_turf = null)
	if(!core_turf)
		return null

	var/list/preferred_dirs = list(EAST, NORTH, SOUTH, WEST)
	for(var/direction in preferred_dirs)
		var/turf/adjacent_turf = get_step(core_turf, direction)
		if(is_valid_decentralized_hardware_turf(adjacent_turf, excluded_turf))
			return adjacent_turf

	var/turf/best_turf = null
	var/best_distance = INFINITY
	for(var/turf/possible_turf in range(6, core_turf))
		if(!is_valid_decentralized_hardware_turf(possible_turf, excluded_turf))
			continue
		if(possible_turf.x < core_turf.x) // Prefer the right side of the AI sat if possible.
			continue
		var/distance = get_dist(core_turf, possible_turf)
		if(distance < best_distance)
			best_distance = distance
			best_turf = possible_turf
	if(best_turf)
		return best_turf

	for(var/turf/possible_turf in range(6, core_turf))
		if(!is_valid_decentralized_hardware_turf(possible_turf, excluded_turf))
			continue
		var/distance = get_dist(core_turf, possible_turf)
		if(distance < best_distance)
			best_distance = distance
			best_turf = possible_turf
	return best_turf

/obj/effect/landmark/start/ai/proc/find_subcontroller_turf(turf/core_turf, turf/excluded_turf)
	if(!core_turf)
		return null

	var/list/preferred_dirs = list(WEST, NORTH, SOUTH, EAST)
	for(var/direction in preferred_dirs)
		var/turf/adjacent_turf = get_step(core_turf, direction)
		if(is_valid_decentralized_hardware_turf(adjacent_turf, excluded_turf))
			return adjacent_turf

	var/turf/best_turf = null
	var/best_distance = INFINITY
	for(var/turf/possible_turf in range(6, core_turf))
		if(!is_valid_decentralized_hardware_turf(possible_turf, excluded_turf))
			continue
		if(possible_turf.x > core_turf.x) // Prefer opposite side from server cabinet when possible.
			continue
		var/distance = get_dist(core_turf, possible_turf)
		if(distance < best_distance)
			best_distance = distance
			best_turf = possible_turf
	if(best_turf)
		return best_turf

	for(var/turf/possible_turf in range(6, core_turf))
		if(!is_valid_decentralized_hardware_turf(possible_turf, excluded_turf))
			continue
		var/distance = get_dist(core_turf, possible_turf)
		if(distance < best_distance)
			best_distance = distance
			best_turf = possible_turf
	return best_turf

/obj/effect/landmark/start/ai/proc/is_valid_support_machine_turf(turf/possible_turf, list/excluded_turfs)
	if(!possible_turf || !isopenturf(possible_turf))
		return FALSE
	if(excluded_turfs && (possible_turf in excluded_turfs))
		return FALSE

	for(var/atom/movable/movable in possible_turf)
		if(movable.density)
			return FALSE
		if(istype(movable, /obj/machinery))
			return FALSE

	return TRUE

/obj/effect/landmark/start/ai/proc/find_support_machine_turf(turf/core_turf, list/excluded_turfs)
	if(!core_turf)
		return null

	var/list/preferred_dirs = list(SOUTH, EAST, WEST, NORTH)
	for(var/direction in preferred_dirs)
		var/turf/adjacent_turf = get_step(core_turf, direction)
		if(is_valid_support_machine_turf(adjacent_turf, excluded_turfs))
			return adjacent_turf

	var/turf/best_turf = null
	var/best_distance = INFINITY
	for(var/turf/possible_turf in range(6, core_turf))
		if(!is_valid_support_machine_turf(possible_turf, excluded_turfs))
			continue
		var/distance = get_dist(core_turf, possible_turf)
		if(distance < best_distance)
			best_distance = distance
			best_turf = possible_turf
	return best_turf

/obj/effect/landmark/start/ai/proc/bootstrap_decentralized_ai_hardware()
	if(GLOB.ai_hardware_bootstrap_blockers > 0)
		return FALSE
	if(!primary_ai && GLOB.primary_data_core)
		return TRUE

	var/turf/core_turf = find_data_core_turf()
	if(!core_turf)
		var/turf/origin_turf = get_turf(src)
		if(origin_turf && isopenturf(origin_turf) && origin_turf.can_have_cabling())
			core_turf = origin_turf
		else if(origin_turf)
			core_turf = find_emergency_hardware_turf(origin_turf)
	if(!core_turf)
		return FALSE

	var/turf/cabinet_turf = find_server_cabinet_turf(core_turf)
	if(!cabinet_turf)
		cabinet_turf = find_emergency_hardware_turf(core_turf, list(core_turf))
	if(!cabinet_turf)
		return FALSE
	var/turf/subcontroller_turf = find_subcontroller_turf(core_turf, cabinet_turf)
	if(!subcontroller_turf)
		subcontroller_turf = find_emergency_hardware_turf(core_turf, list(core_turf, cabinet_turf))

	var/obj/machinery/ai/data_core/core = locate(/obj/machinery/ai/data_core) in core_turf
	if(!core)
		core = primary_ai ? new /obj/machinery/ai/data_core/primary(core_turf) : new /obj/machinery/ai/data_core(core_turf)

	var/obj/machinery/ai/server_cabinet/cabinet = locate(/obj/machinery/ai/server_cabinet) in cabinet_turf
	if(!cabinet)
		cabinet = new /obj/machinery/ai/server_cabinet/prefilled(cabinet_turf)

	var/obj/machinery/ai/master_subcontroller/subcontroller = subcontroller_turf ? (locate(/obj/machinery/ai/master_subcontroller) in subcontroller_turf) : null
	if(subcontroller_turf && !subcontroller)
		subcontroller = new(subcontroller_turf)

	var/dir_to_cabinet = get_dir(core_turf, cabinet_turf)
	var/dir_to_core = turn(dir_to_cabinet, 180)
	var/dir_to_subcontroller = subcontroller ? get_dir(core_turf, subcontroller_turf) : null
	var/dir_to_core_from_subcontroller = dir_to_subcontroller ? turn(dir_to_subcontroller, 180) : null

	var/obj/structure/ethernet_cable/core_cable = core_turf.get_ai_cable_node()
	if(!core_cable)
		core_cable = new(core_turf)
	core_cable.d1 = 0
	core_cable.d2 = dir_to_cabinet
	core_cable.update_icon()

	var/obj/structure/ethernet_cable/core_subcontroller_cable
	if(dir_to_subcontroller)
		for(var/obj/structure/ethernet_cable/existing_cable in core_turf)
			if(existing_cable == core_cable)
				continue
			if(existing_cable.d1 == 0 && existing_cable.d2 == dir_to_subcontroller)
				core_subcontroller_cable = existing_cable
				break
		if(!core_subcontroller_cable)
			core_subcontroller_cable = new(core_turf)
		core_subcontroller_cable.d1 = 0
		core_subcontroller_cable.d2 = dir_to_subcontroller
		core_subcontroller_cable.update_icon()

	var/obj/structure/ethernet_cable/cabinet_cable = cabinet_turf.get_ai_cable_node()
	if(!cabinet_cable)
		cabinet_cable = new(cabinet_turf)
	cabinet_cable.d1 = 0
	cabinet_cable.d2 = dir_to_core
	cabinet_cable.update_icon()

	var/obj/structure/ethernet_cable/subcontroller_cable
	if(subcontroller)
		subcontroller_cable = subcontroller_turf.get_ai_cable_node()
		if(!subcontroller_cable)
			subcontroller_cable = new(subcontroller_turf)
		subcontroller_cable.d1 = 0
		subcontroller_cable.d2 = dir_to_core_from_subcontroller
		subcontroller_cable.update_icon()

	var/datum/ai_network/network = core_cable.network || core_subcontroller_cable?.network || cabinet_cable.network || subcontroller_cable?.network || new()
	network.add_cable(core_cable)
	if(core_subcontroller_cable)
		network.add_cable(core_subcontroller_cable)
	network.add_cable(cabinet_cable)
	if(subcontroller_cable)
		network.add_cable(subcontroller_cable)
	core_cable.mergeConnectedNetworks(core_cable.d2)
	core_cable.mergeConnectedNetworksOnTurf()
	core_subcontroller_cable?.mergeConnectedNetworks(core_subcontroller_cable.d2)
	core_subcontroller_cable?.mergeConnectedNetworksOnTurf()
	cabinet_cable.mergeConnectedNetworks(cabinet_cable.d2)
	subcontroller_cable?.mergeConnectedNetworks(subcontroller_cable.d2)
	cabinet_cable.mergeConnectedNetworksOnTurf()
	subcontroller_cable?.mergeConnectedNetworksOnTurf()
	core.connect_to_ai_network()
	cabinet.connect_to_ai_network()
	subcontroller?.connect_to_ai_network()
	network.update_resources()

	if(primary_ai)
		var/list/excluded_turfs = list(core_turf, cabinet_turf)
		if(subcontroller_turf)
			excluded_turfs += subcontroller_turf

		if(!(locate(/obj/machinery/computer/ai_server_console) in range(6, core_turf)))
			var/turf/server_console_turf = find_support_machine_turf(core_turf, excluded_turfs)
			if(server_console_turf)
				new /obj/machinery/computer/ai_server_console(server_console_turf)
				excluded_turfs += server_console_turf

		if(!(locate(/obj/machinery/computer/ai_overclocking) in range(6, core_turf)))
			var/turf/overclock_turf = find_support_machine_turf(core_turf, excluded_turfs)
			if(overclock_turf)
				new /obj/machinery/computer/ai_overclocking(overclock_turf)
				excluded_turfs += overclock_turf

		if(!(locate(/obj/machinery/rack_creator) in range(6, core_turf)))
			var/turf/rack_creator_turf = find_support_machine_turf(core_turf, excluded_turfs)
			if(rack_creator_turf)
				new /obj/machinery/rack_creator(rack_creator_turf)

	return core.valid_data_core()

/obj/item/dead_ai
	name = "volatile neural core"
	desc = "As an emergency precaution any advanced neural networks will save onto this device upon destruction of the host server. The storage medium is volatile and for that reason expires rapidly."
	icon = 'icons/obj/device.dmi'
	icon_state = "blackcube"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/mob/living/silicon/ai/stored_ai
	var/living_ticks = AI_BLACKBOX_LIFETIME
	var/processing_progress = 0
	var/warned_half_charge = FALSE
	var/blocks_ai_hardware_bootstrap = FALSE

/obj/item/dead_ai/Initialize(mapload, mob/living/silicon/ai/ai_mob)
	. = ..()
	if(ai_mob)
		START_PROCESSING(SSobj, src)
		name = "[initial(name)] - [ai_mob]"
		stored_ai = ai_mob
		blocks_ai_hardware_bootstrap = TRUE
		stored_ai.forceMove(src)

/obj/item/dead_ai/process(seconds_per_tick)
	if(!stored_ai)
		STOP_PROCESSING(SSobj, src)
		return PROCESS_KILL

	living_ticks = max(0, living_ticks - seconds_per_tick)
	if(!warned_half_charge && living_ticks <= (AI_BLACKBOX_LIFETIME * 0.5))
		warned_half_charge = TRUE
		visible_message(span_danger("[src] emits a warning tone as its internal buffer drops below 50% integrity."))
	if(living_ticks <= 0)
		visible_message(span_danger("[src] expires, erasing the unstable neural image stored inside."))
		stored_ai?.expire_volatile_core()
		qdel(src)
		return PROCESS_KILL

/obj/item/dead_ai/examine(mob/user)
	. = ..()
	var/remaining_time = (living_ticks / AI_BLACKBOX_LIFETIME) * 100
	. += span_notice("Insert this into a functioning AI data core, then allocate CPU to network revival.")
	. += span_notice("Integrity remaining: <b>[round(remaining_time, 0.1)]%</b>.")
	. += span_notice("Restoration progress: <b>[round(processing_progress, 0.1)]</b> / <b>[AI_BLACKBOX_PROCESSING_REQUIREMENT]</b>.")

/obj/item/dead_ai/attack_ghost(mob/dead/observer/user)
	return ..()

/obj/item/dead_ai/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(blocks_ai_hardware_bootstrap)
		GLOB.ai_hardware_bootstrap_blockers = max(0, GLOB.ai_hardware_bootstrap_blockers - 1)
		blocks_ai_hardware_bootstrap = FALSE
	if(stored_ai)
		QDEL_NULL(stored_ai)
	return ..()

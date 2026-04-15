/datum/ai_project/room_lockdown
	name = "Room Lockdown"
	description = "Adds a rechargeable lockdown signal that closes and bolts a room after a short warning."
	research_cost = 2500
	ram_required = 0
	category = AI_PROJECT_CROWD_CONTROL
	can_be_run = FALSE
	ability_path = /datum/action/innate/ai/ranged/room_lockdown
	ability_recharge_cost = 1750

/datum/ai_project/room_lockdown/finish()
	add_ability(ability_path)

/datum/action/innate/ai/ranged/room_lockdown
	name = "Room Lockdown"
	desc = "Closes and bolts working airlocks in a clicked area, then resets after a short duration."
	button_icon_state = "lockdown"
	uses = 1
	delete_on_empty = FALSE
	enable_text = span_notice("You queue a room lockdown pulse.")
	disable_text = span_notice("You stand down the lockdown pulse.")

/datum/action/innate/ai/ranged/room_lockdown/proc/lock_room(area/target_area)
	if(!target_area)
		return FALSE
	if(!is_station_level(target_area.z))
		return FALSE

	log_game("[key_name(owner)] initiated a Yog AI room lockdown in [target_area].")
	minor_announce("Lockdown commencing in [target_area] within 2.5 seconds.", "Network Alert:", TRUE)
	addtimer(CALLBACK(src, PROC_REF(_lock_room), target_area), 2.5 SECONDS)
	return TRUE

/datum/action/innate/ai/ranged/room_lockdown/proc/_lock_room(area/target_area)
	if(QDELETED(target_area))
		return

	var/list/obj/machinery/door/airlock/locked_airlocks = list()
	var/list/obj/machinery/firealarm/used_firealarms = list()

	for(var/obj/machinery/door/airlock/airlock in target_area)
		if(QDELETED(airlock) || !airlock.is_operational || istype(airlock, /obj/machinery/door/airlock/external))
			continue
		airlock.close(BYPASS_DOOR_CHECKS)
		airlock.bolt()
		locked_airlocks += airlock

	for(var/obj/machinery/firealarm/firealarm as anything in target_area.firealarms.Copy())
		firealarm.alarm(owner, TRUE)
		used_firealarms += firealarm

	addtimer(CALLBACK(src, PROC_REF(_unlock_room), locked_airlocks, used_firealarms), 20 SECONDS)

/datum/action/innate/ai/ranged/room_lockdown/proc/_unlock_room(list/locked_airlocks, list/used_firealarms)
	for(var/obj/machinery/door/airlock/airlock as anything in locked_airlocks)
		if(QDELETED(airlock))
			continue
		airlock.unbolt()

	for(var/obj/machinery/firealarm/firealarm as anything in used_firealarms)
		if(QDELETED(firealarm))
			continue
		firealarm.reset(owner, TRUE)

/datum/action/innate/ai/ranged/room_lockdown/do_ability(mob/living/clicker, atom/target)
	if(!target)
		return FALSE

	var/area/target_area = get_area(target)
	var/turf/target_turf = get_turf(target)
	if(!target_area || !target_turf)
		to_chat(owner, span_warning("No valid area detected."))
		return FALSE
	if(istype(target_area, /area/station/maintenance))
		to_chat(owner, span_warning("Maintenance cannot be room-locked due to poor networking coverage."))
		return FALSE
	if(!is_station_level(target_turf.z))
		to_chat(owner, span_warning("Only station areas can be room-locked."))
		return FALSE

	if(!lock_room(target_area))
		return FALSE

	adjust_uses(-1)
	unset_ranged_ability(clicker)
	to_chat(owner, span_notice("Lockdown queued for [target_area]."))
	return TRUE

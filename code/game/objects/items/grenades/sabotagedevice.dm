/obj/item/traitor_machine_trapper
	name = "suspicious device"
	desc = "It looks dangerous."
	icon = 'icons/obj/weapons/grenade.dmi'
	icon_state = "boobytrap"

	var/explosion_range = 3
	var/deploy_time = 10 SECONDS
	var/deployed_by = null



/obj/item/traitor_machine_trapper/examine(mob/user)
	. = ..()
	if(!IS_TRAITOR(user))
		return
	else
		. += span_notice("This device must be placed by <b>clicking on a machine</b> with it. It can be removed with a screwdriver.")
	. += span_notice("Remember, you may leave behind fingerprints on the device. Wear <b>gloves</b> when handling it to be safe!")

/obj/item/traitor_machine_trapper/pre_attack(atom/target, mob/living/user, params)
	. = ..()
	if (. || !istype(target, /obj/machinery))
		return
	var/obj/machinery/M = target
	if(!M.machine_sabotage)
		balloon_alert(user, "can't trap this machine!")
		return
	balloon_alert(user, "planting device...")
	if(!do_after(user, delay = deploy_time, target = src, interaction_key = DOAFTER_SOURCE_PLANTING_DEVICE))
		return TRUE
	deployed_by = user
	target.AddComponent(\
		/datum/component/interaction_booby_trap,\
		additional_triggers = list(COMSIG_STASIS_OCCUPANT_ENTERED,
                                   COMSIG_STASIS_OCCUPANT_LEFT,
								   COMSIG_CARBON_BUMPED_AIRLOCK_OPEN),\
		on_triggered_callback = CALLBACK(src, PROC_REF(on_triggered)),\
		on_defused_callback = CALLBACK(src, PROC_REF(on_defused)),\
	)
	RegisterSignal(target, COMSIG_QDELETING, GLOBAL_PROC_REF(qdel), src)
	moveToNullspace()
	return TRUE
/obj/item/traitor_machine_trapper/proc/on_triggered(atom/machine)
	qdel(src)


/obj/item/traitor_machine_trapper/proc/on_defused(atom/machine, mob/defuser, obj/item/tool)
	UnregisterSignal(machine, COMSIG_QDELETING)
	playsound(machine, 'sound/effects/structure_stress/pop3.ogg', 100, vary = TRUE)
	forceMove(get_turf(machine))
	visible_message(span_warning("A [src] falls out from the [machine]!"))





/obj/vehicle/sealed/mecha/phazon
	desc = "This is a Phazon exosuit. The pinnacle of scientific research and pride of Nanotrasen, it uses cutting edge anomalous technology and expensive materials."
	name = "\improper Phazon"
	icon_state = "phazon"
	base_icon_state = "phazon"
	movedelay = 2
	step_energy_drain = 4
	phasing_energy_drain = parent_type::phasing_energy_drain * 2
	max_integrity = 200
	armor_type = /datum/armor/mecha_phazon
	max_temperature = 25000
	accesses = list(ACCESS_MECH_SCIENCE, ACCESS_MECH_SECURITY)
	destruction_sleep_duration = 40
	exit_delay = 40
	wreckage = /obj/structure/mecha_wreckage/phazon
	mech_type = EXOSUIT_MODULE_PHAZON
	force = 15
	max_equip_by_category = list(
		MECHA_L_ARM = 1,
		MECHA_R_ARM = 1,
		MECHA_UTILITY = 3,
		MECHA_POWER = 1,
		MECHA_ARMOR = 2,
	)
	phase_state = "phazon-phase"
	var/phasing_disabled = FALSE
	var/was_phasing = FALSE

/datum/armor/mecha_phazon
	melee = 30
	bullet = 30
	laser = 30
	energy = 30
	bomb = 30
	fire = 100
	acid = 100

/obj/vehicle/sealed/mecha/phazon/generate_actions()
	. = ..()
	initialize_passenger_action_type(/datum/action/vehicle/sealed/mecha/mech_toggle_phasing)
	initialize_passenger_action_type(/datum/action/vehicle/sealed/mecha/mech_switch_damtype)

/obj/vehicle/sealed/mecha/phazon/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return .
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/vehicle/sealed/mecha/phazon, restore_phasing)), 8 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	phasing_disabled = TRUE
	if(phasing)
		phasing = ""
		was_phasing = TRUE
		if(isclosedturf(loc))
			var/turf/emergency_destination = get_teleport_loc(loc, src, distance = 0, closed_turf_check = TRUE, errorx = 1, errory = 1)
			if(emergency_destination)
				if(!try_step_multiz(get_dir(src, emergency_destination)))
					forceMove(emergency_destination)
		for(var/mob/occupant as anything in occupants)
			balloon_alert(occupant, "phasing interrupted")
			var/datum/action/action = locate(/datum/action/vehicle/sealed/mecha/mech_toggle_phasing) in occupant.actions
			action.button_icon_state = "mech_phasing_off"
			action.build_all_button_icons()

/obj/vehicle/sealed/mecha/phazon/proc/restore_phasing()
	phasing_disabled = FALSE
	if(was_phasing)
		for(var/mob/occupant as anything in occupants)
			SEND_SOUND(occupant, sound('sound/machines/beep/triple_beep.ogg', volume=50))
			balloon_alert(occupant, "phasing restored")
	was_phasing = FALSE

/datum/action/vehicle/sealed/mecha/mech_switch_damtype
	name = "Reconfigure arm microtool arrays"
	button_icon_state = "mech_damtype_brute"

/datum/action/vehicle/sealed/mecha/mech_switch_damtype/Trigger(trigger_flags)
	if(!..())
		return
	if(!chassis || !(owner in chassis.occupants))
		return
	var/new_damtype
	switch(chassis.damtype)
		if(TOX)
			new_damtype = BRUTE
			chassis.balloon_alert(owner, "your punches will now deal brute damage")
		if(BRUTE)
			new_damtype = BURN
			chassis.balloon_alert(owner, "your punches will now deal burn damage")
		if(BURN)
			new_damtype = TOX
			chassis.balloon_alert(owner,"your punches will now deal toxin damage")
	chassis.damtype = new_damtype
	button_icon_state = "mech_damtype_[new_damtype]"
	playsound(chassis, 'sound/vehicles/mecha/mechmove01.ogg', 50, TRUE)
	build_all_button_icons()

/datum/action/vehicle/sealed/mecha/mech_toggle_phasing
	name = "Toggle Phasing"
	button_icon_state = "mech_phasing_off"

/datum/action/vehicle/sealed/mecha/mech_toggle_phasing/Trigger(trigger_flags)
	if(!..())
		return
	if(!chassis || !(owner in chassis.occupants))
		return
	var/obj/vehicle/sealed/mecha/phazon/phazon_chassis = chassis
	if(istype(phazon_chassis) && phazon_chassis.phasing_disabled)
		chassis.balloon_alert(owner, "malfunctioning!")
		return
	chassis.phasing = chassis.phasing ? "" : "phasing"
	button_icon_state = "mech_phasing_[chassis.phasing ? "on" : "off"]"
	chassis.balloon_alert(owner, "[chassis.phasing ? "enabled" : "disabled"] phasing")
	build_all_button_icons()

/obj/vehicle/sealed/mecha/phazon
	desc = "This is a Phazon exosuit. The pinnacle of scientific research and pride of Nanotrasen, it uses cutting edge anomalous technology and expensive materials."
	name = "\improper Phazon"
	icon_state = "phazon"
	base_icon_state = "phazon"
	movedelay = 2
	step_energy_drain = 4
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

/datum/action/vehicle/sealed/mecha/mech_switch_damtype
	name = "Reconfigure arm microtool arrays"
	button_icon_state = "mech_damtype_brute"

/datum/action/vehicle/sealed/mecha/mech_switch_damtype/Trigger(mob/clicker, trigger_flags)
	if(!..())
		return
	if(!chassis || !(owner in chassis.occupants))
		return
	var/new_damtype
	switch(chassis.damtype)
		if(BRUTE)
			new_damtype = BURN
			chassis.balloon_alert(owner, "your punches will now deal burn damage")
		if(BURN)
			new_damtype = BRUTE
			chassis.balloon_alert(owner, "your punches will now deal brute damage")
	chassis.damtype = new_damtype
	button_icon_state = "mech_damtype_[new_damtype]"
	playsound(chassis, 'sound/vehicles/mecha/mechmove01.ogg', 50, TRUE)
	build_all_button_icons()

/datum/action/vehicle/sealed/mecha/mech_toggle_phasing
	name = "Toggle Phasing"
	button_icon_state = "mech_phasing_off"
	var/phase_time = 2 SECONDS
	var/phase_cooldown_time = 15 SECONDS

// Force stop the phasing ability
/datum/action/vehicle/sealed/mecha/mech_toggle_phasing/proc/stop_phasing()
	if(chassis.phasing == "phasing")
		chassis.balloon_alert(owner, "disabled phasing")

	chassis.phasing = ""
	button_icon_state = "mech_phasing_off"
	build_all_button_icons()
	if(!TIMER_COOLDOWN_RUNNING(chassis, COOLDOWN_MECHA_PHASE))
		S_TIMER_COOLDOWN_START(chassis, COOLDOWN_MECHA_PHASE, phase_cooldown_time)

/datum/action/vehicle/sealed/mecha/mech_toggle_phasing/Trigger(mob/clicker, trigger_flags)
	if(!..())
		return
	if(!chassis || !(owner in chassis.occupants))
		return
	if (chassis.phasing == "phasing")
		stop_phasing()
		return
	if(TIMER_COOLDOWN_RUNNING(chassis, COOLDOWN_MECHA_PHASE))
		var/time_left = S_TIMER_COOLDOWN_TIMELEFT(chassis, COOLDOWN_MECHA_PHASE)
		chassis.balloon_alert(owner, "on cooldown, [DisplayTimeText(time_left, 1)]...")
		return

	// enable phasing
	chassis.phasing = "phasing"
	button_icon_state = "mech_phasing_on"
	chassis.balloon_alert(owner, "enabled phasing")
	build_all_button_icons()
	addtimer(CALLBACK(src, PROC_REF(stop_phasing)), phase_time)

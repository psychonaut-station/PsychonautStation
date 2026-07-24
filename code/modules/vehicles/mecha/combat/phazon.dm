/obj/vehicle/sealed/mecha/phazon
	name = "\improper Phazon"
	desc = "This is a Phazon exosuit. The pinnacle of scientific research and pride of Nanotrasen, it uses cutting edge anomalous technology and expensive materials."
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

	/// Are we currently phasing through walls?
	var/phasing = FALSE
	/// Power we use every time we phaze through something
	var/phasing_energy_drain = 0.2 * STANDARD_CELL_CHARGE
	/// Icon_state for flick() when phasing
	var/phase_state = "phazon-phase"

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

/obj/vehicle/sealed/mecha/phazon/CanPassThrough(atom/blocker, movement_dir, blocker_opinion)
	if(!phasing || get_charge() <= phasing_energy_drain || throwing)
		return ..()
	if(phase_state)
		flick(phase_state, src)
	var/turf/destination_turf = get_step(loc, movement_dir)
	if(!check_teleport_valid(src, destination_turf) || SSmapping.level_trait(destination_turf.z, ZTRAIT_NOPHASE))
		return FALSE
	return TRUE

/obj/vehicle/sealed/mecha/phazon/vehicle_move(direction, forcerotate)
	. = ..()
	if(. && phasing)
		use_energy(phasing_energy_drain)

/obj/vehicle/sealed/mecha/phazon/try_bumpsmash(atom/obstacle)
	if(phasing) // Theres only one cause for phasing canpass fails
		to_chat(occupants, "[icon2html(src, occupants)][span_warning("A dull, universal force is preventing you from phasing here!")]")
		spark_system.start()
		return
	return ..()

/obj/vehicle/sealed/mecha/phazon/update_energy_drain()
	. = ..()
	if(capacitor)
		phasing_energy_drain = initial(phasing_energy_drain) / capacitor.rating
	else
		phasing_energy_drain = initial(phasing_energy_drain)

/obj/vehicle/sealed/mecha/phazon/can_interact_with(atom/target, mob/user, list/modifiers)
	. = ..()
	if (!. || !phasing)
		return
	balloon_alert(user, "not while phasing!")
	return FALSE

/datum/action/vehicle/sealed/mecha/mech_switch_damtype
	name = "Reconfigure arm microtool arrays"
	button_icon_state = "mech_damtype_brute"

/datum/action/vehicle/sealed/mecha/mech_switch_damtype/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
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
	. = ..()
	if(!.)
		return
	if(!chassis || !(owner in chassis.occupants))
		return
<<<<<<< HEAD
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
=======
	var/obj/vehicle/sealed/mecha/phazon/phazon = chassis
	phazon.phasing = !phazon.phasing
	button_icon_state = "mech_phasing_[phazon.phasing ? "on" : "off"]"
	phazon.balloon_alert(owner, "[phazon.phasing ? "enabled" : "disabled"] phasing")
>>>>>>> d5b35827c5ee63a46e4588d8293d7083804a7aa6
	build_all_button_icons()
	addtimer(CALLBACK(src, PROC_REF(stop_phasing)), phase_time)

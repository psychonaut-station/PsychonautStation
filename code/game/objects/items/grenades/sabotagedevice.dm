/obj/item/mes_device
	name = "M-E-S Device"
	desc = "A compact maintenance device with an industrial casing and minimal external markings. It appears to be designed for interfacing with machinery during diagnostics or repair procedures. Several warning symbols are etched into its surface, but they are partially worn and unreadable."
	icon = 'icons/obj/weapons/grenade.dmi'
	icon_state = "boobytrap"
	w_class = WEIGHT_CLASS_SMALL

	var/explosion_range = 6
	var/deploy_time = 10 SECONDS
	var/deployed_by = null
	var/turf/deploy_turf = null
	var/static/list/blacklist = typecacheof(list(
	/obj/machinery/power,
	/obj/machinery/door,
	/obj/machinery/atmospherics,
	/obj/machinery/gravity_generator,
	/obj/machinery/transformer,
	/obj/machinery/status_display,
	/obj/machinery/light,
	/obj/machinery/airalarm,
	/obj/machinery/camera,
	/obj/machinery/meter
	))

/obj/item/mes_device/examine(mob/user)
	. = ..()
	if(!IS_TRAITOR(user))
		return .
	. += span_notice("This device must be placed by <b>clicking on a machine</b> with it. It can be removed with a screwdriver.")
	. += span_notice("Remember, you may leave behind fingerprints on the device. Wear <b>gloves</b> when handling it to be safe!")

/obj/item/mes_device/pre_attack(atom/target, mob/living/user, params)
	. = ..()
	if (. || !istype(target, /obj/machinery))
		return
	var/obj/machinery/machine = target
	if(is_type_in_typecache(machine, blacklist))
		balloon_alert(user, "device incompatible!")
		return
	balloon_alert(user, "planting device...")
	if(!do_after(user, delay = deploy_time, target = src, interaction_key = DOAFTER_SOURCE_PLANTING_DEVICE))
		return TRUE
	deployed_by = user
	deploy_turf = get_turf(target)
	target.AddComponent(\
		/datum/component/interaction_booby_trap,\
		explosion_light_range = 4,\
		explosion_heavy_range = 2,\
		additional_triggers = list(COMSIG_MACHINERY_SET_OCCUPANT),\
		on_triggered_callback = CALLBACK(src, PROC_REF(on_triggered)),\
		on_defused_callback = CALLBACK(src, PROC_REF(on_defused)),\
	)
	RegisterSignal(target, COMSIG_QDELETING, GLOBAL_PROC_REF(qdel), src)
	forceMove(target)
	log_message("[key_name(user)] planted a machine trap on [machine] at [COORD(deploy_turf)].")
	message_admins("[key_name_admin(user)] planted a machine trap on [machine] at [ADMIN_COORDJMP(deploy_turf)].")
	return TRUE

/obj/item/mes_device/proc/on_triggered(atom/machine)
	log_message("A machine trap  triggered at [COORD(deploy_turf)].")
	message_admins("A machine trap triggered at [ADMIN_COORDJMP(deploy_turf)].")
	qdel(src)

/obj/item/mes_device/proc/on_defused(atom/machine, mob/defuser, obj/item/tool)
	UnregisterSignal(machine, COMSIG_QDELETING)
	playsound(machine, 'sound/effects/structure_stress/pop3.ogg', 100, vary = TRUE)
	forceMove(get_turf(machine))
	visible_message(span_warning("A [src] falls out from the [machine]!"))

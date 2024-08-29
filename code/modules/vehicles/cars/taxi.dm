/obj/vehicle/sealed/car/taxi
	name = "Taxi"
	desc = "Sadece Taksi."
	icon = 'icons/psychonaut/mob/rideables/vehicles.dmi'
	icon_state = "taxi"
	max_integrity = 150
	max_occupants = 4
	movedelay = 6
	armor_type = /datum/armor/taxi
	key_type = /obj/item/key/atv
	light_system = OVERLAY_LIGHT_DIRECTIONAL
	light_range = 6
	light_power = 2
	light_on = FALSE
	integrity_failure = 0.5
	var/headlight_colors = list(COLOR_YELLOW,)

/datum/armor/taxi
	melee = 50
	bullet = 25
	laser = 20
	bomb = 50
	fire = 60
	acid = 60

	// Araç yüklenirken yapılacak işlemler
/obj/vehicle/sealed/car/taxi/Initialize(mapload)
		. = ..()
		START_PROCESSING(SSobj,src)
		RegisterSignal(src, COMSIG_MOVABLE_CROSS_OVER,)

/obj/vehicle/sealed/car/taxi/process()
	if(light_on && (obj_flags & EMAGGED))
		set_light_color(pick(headlight_colors))

/obj/vehicle/sealed/car/taxi/generate_actions()
	. = ..()
	initialize_controller_action_type(/datum/action/vehicle/sealed/horn, VEHICLE_CONTROL_DRIVE)
	initialize_controller_action_type(/datum/action/vehicle/sealed/headlights, VEHICLE_CONTROL_DRIVE)

	// Araç tamir işlemleri
/obj/vehicle/sealed/car/taxi/welder_act(mob/living/user, obj/item/W)
	if(user.combat_mode)
		return
	. = TRUE
	if(DOING_INTERACTION(user, src))
		balloon_alert(user, "you're already repairing it!")
		return
	if(atom_integrity >= max_integrity)
		balloon_alert(user, "it's not damaged!")
		return
	if(!W.tool_start_check(user, amount=1))
		return
	user.balloon_alert_to_viewers("started welding [src]", "started repairing [src]")
	audible_message(span_hear("You hear welding."))
	var/did_the_thing
	while(atom_integrity < max_integrity)
		if(W.use_tool(src, user, 2.5 SECONDS, volume=50))
			did_the_thing = TRUE
			atom_integrity += min(10, (max_integrity - atom_integrity))
			audible_message(span_hear("You hear welding."))
		else
			break
	if(did_the_thing)
		user.balloon_alert_to_viewers("[(atom_integrity >= max_integrity) ? "fully" : "partially"] repaired [src]")
	else
		user.balloon_alert_to_viewers("stopped welding [src]", "interrupted the repair!")

/obj/vehicle/sealed/car/taxi/atom_break()
	START_PROCESSING(SSobj, src)
	return ..()

/obj/vehicle/sealed/car/taxi/process(seconds_per_tick)
	if(atom_integrity >= integrity_failure * max_integrity)
		return PROCESS_KILL
	if(SPT_PROB(10, seconds_per_tick))
		return
	var/datum/effect_system/fluid_spread/smoke/smoke = new
	smoke.set_up(0, holder = src, location = src)
	smoke.start()

/obj/vehicle/sealed/car/taxi/bullet_act(obj/projectile/P)
	if(prob(50) || !LAZYLEN(buckled_mobs))
		return ..()
	for(var/mob/buckled_mob as anything in buckled_mobs)
		buckled_mob.bullet_act(P)
	return BULLET_ACT_HIT

/obj/vehicle/sealed/car/taxi/atom_destruction()
	explosion(src, devastation_range = -1, light_impact_range = 2, flame_range = 3, flash_range = 4)
	return ..()

/obj/vehicle/sealed/car/taxi/Destroy()
	STOP_PROCESSING(SSobj,src)
	return ..()

/datum/movespeed_modifier/shadowling/phase
	multiplicative_slowdown = -0.6
	priority = 30
	movetypes = GROUND

// MARK: Status effects
/datum/status_effect/shadow/phase
	id = "shadow_phase"
	tick_interval = 0.2 SECONDS
	alert_type = null
	duration = STATUS_EFFECT_PERMANENT

	var/light_immunity = FALSE

/datum/status_effect/shadow/phase/on_apply()
	. = ..()
	owner.add_movespeed_modifier(/datum/movespeed_modifier/shadowling/phase)
	ADD_TRAIT(owner, TRAIT_UNDENSE, REF(src))

	return TRUE

/datum/status_effect/shadow/phase/on_remove()
	. = ..()
	if(!istype(owner))
		return

	owner.remove_movespeed_modifier(/datum/movespeed_modifier/shadowling/phase)
	REMOVE_TRAIT(owner, TRAIT_UNDENSE, REF(src))

	var/is_inside = FALSE
	if(istype(owner.loc, /obj/effect/dummy/phased_mob/shadowling))
		is_inside = TRUE

	if(is_inside)
		var/obj/effect/dummy/phased_mob/shadowling/P = owner.loc
		P.eject_jaunter(FALSE)

	animate(owner, alpha = 255, time = 0.3 SECONDS)

/datum/status_effect/shadow/phase/tick(seconds_between_ticks)
	if(!istype(owner))
		return

	if(light_immunity)
		return

	var/turf/T = get_turf(owner)
	if(!T)
		return

// MARK: Object visual effects
/obj/effect/dummy/phased_mob/shadowling
	parent_type = /obj/effect/dummy/phased_mob/shadow
	name = "shadows"
	phased_mob_icon_state = "purple_laser"

	var/light_immunity = FALSE
	light_max = SHADOWLING_LIGHT_THRESHOLD
	movespeed = 3
	density = FALSE

	var/light_grace_period = 5 SECONDS
	var/light_time_remaining = 0
	var/last_light_second = 0

/obj/effect/dummy/phased_mob/shadowling/projectile_hit(obj/projectile/hitting_projectile, def_zone, piercing_hit, blocked)
	if(jaunter)
		jaunter.bullet_act(hitting_projectile, def_zone, piercing_hit, blocked)
		return BULLET_ACT_HIT
	return BULLET_ACT_FORCE_PIERCE

/obj/effect/dummy/phased_mob/shadowling/check_light_level(atom/location_to_check)
	if(light_immunity)
		return FALSE

	var/atom/place = location_to_check || src
	var/turf/T = get_turf(place)
	if(!istype(T))
		return FALSE

	var/brightness = T.get_lumcount()
	if(isnull(brightness))
		return FALSE

	return brightness > light_max

/obj/effect/dummy/phased_mob/shadowling/process(seconds_per_tick)
	var/turf/T = get_turf(src)
	if(!T)
		qdel(src)
		return

	if(!jaunter || jaunter.loc != src)
		qdel(src)
		return

	if(check_light_level(T))
		if(!light_time_remaining)
			light_time_remaining = light_grace_period
			last_light_second = CEILING(light_time_remaining / (1 SECONDS), 1)
			to_chat(jaunter, span_warning("The light burns away your shadow! You will be forced out in [last_light_second] seconds."))
		var/current_second = CEILING(light_time_remaining / (1 SECONDS), 1)
		if(current_second != last_light_second)
			last_light_second = current_second
			to_chat(jaunter, span_warning("The light burns away your shadow! You will be forced out in [current_second] seconds."))
		new /obj/effect/temp_visual/shadow_phase_smoke(T)
		light_time_remaining -= seconds_per_tick * (1 SECONDS)
		if(light_time_remaining <= 0)
			eject_jaunter(TRUE)
	else
		light_time_remaining = 0
		last_light_second = 0

	if(!QDELETED(jaunter) && isliving(jaunter))
		var/mob/living/living_jaunter = jaunter
		living_jaunter.heal_overall_damage(brute = (healing_rate * seconds_per_tick), burn = (healing_rate * seconds_per_tick), required_bodytype = BODYTYPE_ORGANIC)

/obj/effect/dummy/phased_mob/shadowling/relaymove(mob/living/user, direction)
	var/turf/newloc = phased_check(user, direction)
	if(!newloc)
		return
	if(direction in GLOB.alldirs)
		setDir(direction)
	forceMove(newloc)

/obj/effect/dummy/phased_mob/shadowling/phased_check(mob/living/user, direction)
	var/turf/newloc = ..()
	if(newloc && isspaceturf(newloc) && !light_immunity)
		to_chat(user, span_warning("It really would not be wise to go into space."))
		return null
	return newloc

/obj/effect/dummy/phased_mob/shadowling/Destroy()
	if(jaunter && jaunter.loc == src)
		eject_jaunter(TRUE)
	return ..()

/obj/effect/dummy/phased_mob/shadowling/eject_jaunter(forced_out = FALSE)
	var/mob/living/L = jaunter
	var/turf/cur_turf = get_turf(src)
	if(!isopenturf(cur_turf))
		var/turf/open_turf = pick_adjacent_open_turf(cur_turf)
		if(open_turf)
			forceMove(open_turf)

	. = ..()

	if(istype(L))
		animate(L, alpha = 255, time = 0.3 SECONDS)

		if(forced_out && !light_immunity)
			L.Knockdown(1 SECONDS)
			L.Paralyze(1 SECONDS)
			var/datum/action/cooldown/shadowling/shadow_phase/SP = locate(/datum/action/cooldown/shadowling/shadow_phase) in L.actions
			if(SP)
				SP.StartCooldown(30 SECONDS)

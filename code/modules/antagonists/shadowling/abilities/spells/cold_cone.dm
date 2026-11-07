#define COLD_WAVE_STAMINA_DAMAGE 30
#define COLD_WAVE_SLOW_DURATION (10 SECONDS)
#define COLD_WAVE_TEMP_DROP -260
#define COLD_WAVE_FROSTOIL_AMOUNT 8
#define COLD_WAVE_BLIND_DURATION (10 SECONDS)
#define COLD_WAVE_BURN_DAMAGE 20

// MARK: Effects
/obj/effect/temp_visual/dir_setting/shadow_plume
	icon = 'icons/effects/160x160.dmi'
	icon_state = "entropic_plume"
	duration = 3 SECONDS
	color = "#015fff"
	alpha = 220

/obj/effect/temp_visual/dir_setting/shadow_plume/setDir(dir)
	. = ..()
	switch(dir)
		if(NORTH)
			pixel_x = -64
		if(SOUTH)
			pixel_x = -64
			pixel_y = -128
		if(EAST)
			pixel_y = -64
		if(WEST)
			pixel_y = -64
			pixel_x = -128

// MARK: Status effects
/datum/status_effect/cloudstruck/shadow
	id = "cloudstruck_shadow"
	var/disable_blind = TRUE
	var/static/mutable_appearance/mob_overlay_shadow

/datum/status_effect/cloudstruck/shadow/on_creation(mob/living/new_owner, duration = 2 SECONDS)
	src.duration = duration
	if(!mob_overlay_shadow)
		mob_overlay_shadow = mutable_appearance('icons/effects/eldritch.dmi', "cloud_swirl", ABOVE_MOB_LAYER)
		mob_overlay_shadow.color = "#66ccff"
	return ..()

/datum/status_effect/cloudstruck/shadow/on_apply()
	owner.add_overlay(mob_overlay_shadow)
	owner.become_blind(id)
	return TRUE

/datum/status_effect/cloudstruck/shadow/on_remove()
	owner.cure_blind(id)
	owner.cut_overlay(mob_overlay_shadow)

// MARK: Movespeed modifier
/datum/movespeed_modifier/shadowling/cold_wave
	multiplicative_slowdown = 1.25
	priority = 20
	movetypes = GROUND

// MARK: Ability
/datum/action/cooldown/shadowling/cold_wave
	name = "Glacial Wave"
	desc = "A blast of freezing darkness in a 45° cone over 4 tiles, dealing 30 stamina damage and slowing enemies for 10 seconds."
	button_icon_state = "shadow_cold"
	cooldown_time = 40 SECONDS
	requires_dark_user = FALSE
	requires_dark_target = FALSE
	max_range = 4
	channel_time = 0
	var/const/fov_degree = 45
	var/static/sfx_cold = 'sound/antagonists/shadowlings/abilities/cold_wave.ogg'
	var/reagent_type = /datum/reagent/consumable/frostoil
	min_req = 1
	max_req = 10
	required_thralls = 30

/datum/action/cooldown/shadowling/cold_wave/DoEffect(mob/living/carbon/human/H, atom/_)
	play_cold_fx(H)
	var/list/targets = collect_cone_targets(H)
	if(!length(targets))
		H.balloon_alert(H, "missed")
		return TRUE

	for(var/mob/living/carbon/human/T in targets)
		if(QDELETED(T))
			continue

		var/temp_drop = COLD_WAVE_TEMP_DROP
		var/frostoil_amt = COLD_WAVE_FROSTOIL_AMOUNT
		var/burn_amt = COLD_WAVE_BURN_DAMAGE
		T.adjust_fire_loss(burn_amt)
		T.adjust_stamina_loss(COLD_WAVE_STAMINA_DAMAGE)
		apply_slow(T, COLD_WAVE_SLOW_DURATION)
		T.adjust_bodytemperature(temp_drop)

		if(T.reagents)
			T.reagents.add_reagent(reagent_type, frostoil_amt)

		T.apply_status_effect(/datum/status_effect/cloudstruck/shadow, COLD_WAVE_SLOW_DURATION)

	return TRUE

/datum/action/cooldown/shadowling/cold_wave/collect_cone_targets(mob/living/carbon/human/H)
	var/list/out = list()
	var/datum/team/shadow_hive/hive = get_shadow_hive()
	for(var/mob/living/carbon/human/T in view(max_range, H))
		if(T == H)
			continue
		if(!in_front_cone(H, T, fov_degree))
			continue
		if(hive)
			if(T in hive.lings)
				continue
			if(T in hive.thralls)
				continue
		out += T
	return out

/datum/action/cooldown/shadowling/cold_wave/proc/collect_cold_cone_turfs(mob/living/carbon/human/H, range_tiles, fov_deg)
	var/list/turfs_in_cone = list()
	if(!istype(H))
		return turfs_in_cone
	var/turf/origin = get_turf(H)
	if(!origin)
		return turfs_in_cone
	for(var/turf/T in range(range_tiles, origin))
		if(!in_front_cone(H, T, fov_deg))
			continue
		turfs_in_cone += T
	return turfs_in_cone

/datum/action/cooldown/shadowling/cold_wave/proc/apply_slow(mob/living/L, duration)
	if(!istype(L))
		return
	L.add_movespeed_modifier(/datum/movespeed_modifier/shadowling/cold_wave)
	addtimer(CALLBACK(src, PROC_REF(_remove_slow), L), duration, TIMER_UNIQUE | TIMER_OVERRIDE)

/datum/action/cooldown/shadowling/cold_wave/proc/_remove_slow(mob/living/L)
	if(!istype(L))
		return
	L.remove_movespeed_modifier(/datum/movespeed_modifier/shadowling/cold_wave)

/datum/action/cooldown/shadowling/cold_wave/proc/play_cold_fx(mob/living/carbon/human/H)
	if(!istype(H))
		return
	playsound(get_turf(H), sfx_cold, 70, TRUE)

	var/turf/anchor = get_step(H, H.dir)
	if(!anchor) anchor = get_turf(H)
	new /obj/effect/temp_visual/dir_setting/shadow_plume(anchor, H.dir)

#undef COLD_WAVE_STAMINA_DAMAGE
#undef COLD_WAVE_SLOW_DURATION
#undef COLD_WAVE_TEMP_DROP
#undef COLD_WAVE_FROSTOIL_AMOUNT
#undef COLD_WAVE_BLIND_DURATION
#undef COLD_WAVE_BURN_DAMAGE

// MARK: Effects
/obj/effect/shadow_bind_anchor
	name = "writhing shadows"
	desc = "Tendrils of shadow coil here."
	icon = 'icons/mob/antagonists/shadowling/shadowling_objects.dmi'
	icon_state = "tendril"

	layer = EFFECTS_LAYER
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	resistance_flags = INDESTRUCTIBLE
	obj_flags = IGNORE_DENSITY

	can_buckle = TRUE
	max_buckled_mobs = 1
	buckle_lying = FALSE
	buckle_requires_restraints = FALSE

	var/grapple_time = 10 SECONDS
	var/mob/living/caster

/obj/effect/shadow_bind_anchor/attack_hand(mob/user)
	return TRUE

/obj/effect/shadow_bind_anchor/attackby(obj/item/I, mob/user, params)
	return TRUE

/obj/effect/shadow_bind_anchor/attackby_secondary(obj/item/weapon, mob/user, list/modifiers, list/attack_modifiers)
	return

/obj/effect/shadow_bind_anchor/attack_hand_secondary(mob/user, list/modifiers)
	return

/obj/effect/shadow_bind_anchor/Initialize(mapload, mob/living/caster_ref)
	. = ..()
	caster = caster_ref
	START_PROCESSING(SSobj, src)
	addtimer(CALLBACK(src, PROC_REF(_gc_if_empty)), 2 SECONDS)

/obj/effect/shadow_bind_anchor/Destroy()
	STOP_PROCESSING(SSobj, src)
	for(var/mob/living/L in buckled_mobs)
		unbuckle_mob(L, force = TRUE)
	return ..()

/obj/effect/shadow_bind_anchor/process(seconds_per_tick)
	if(!isturf(loc))
		qdel(src)
		return

	if(!has_buckled_mobs())
		qdel(src)
		return

	var/turf/T = get_turf(src)
	if(T.get_lumcount() >= SHADOWLING_DIM_THRESHOLD)
		visible_message(
			span_warning("Bright light dissolves the shadows!"),
			span_userdanger("The light shatters your bindings!")
		)
		release()

/obj/effect/shadow_bind_anchor/proc/apply_to(mob/living/victim)
	if(!istype(victim) || QDELETED(victim) || victim.stat == DEAD)
		qdel(src)
		return FALSE

	if(has_buckled_mobs())
		return FALSE

	if(!buckle_mob(victim, force = TRUE))
		qdel(src)
		return FALSE

	if(isturf(loc))
		visible_message(
			span_danger("Shadows surge around [victim]!"),
			span_userdanger("Shadowy roots ensnare your feet — you cannot move!")
		)

	playsound(victim, 'sound/effects/magic/enter_blood.ogg', 75, TRUE)
	addtimer(CALLBACK(src, PROC_REF(release)), grapple_time, TIMER_STOPPABLE)
	return TRUE

/obj/effect/shadow_bind_anchor/proc/release()
	if(QDELETED(src))
		return
	if(!has_buckled_mobs())
		qdel(src)
		return
	for(var/mob/living/L in buckled_mobs)
		unbuckle_mob(L, force = TRUE)
	QDEL_IN(src, 0.4 SECONDS)

/obj/effect/shadow_bind_anchor/proc/_gc_if_empty()
	if(!has_buckled_mobs())
		qdel(src)

// MARK: Ability
/datum/action/cooldown/shadowling/root
	name = "Shadow Roots"
	desc = "Harness the grasping tendrils of the dark. Left-Click an enemy in darkness to ensnare them with shadow roots. Right-Click in any direction to launch a shadow hook and pull targets or objects to you."
	button_icon_state = "shadow_grasp"
	check_flags = AB_CHECK_CONSCIOUS
	cooldown_time = 20 SECONDS
	click_to_activate = TRUE
	unset_after_click = TRUE
	requires_dark_user = FALSE
	requires_dark_target = FALSE
	channel_time = 0
	max_range = 8
	var/targeting = FALSE
	var/secondary_mode = FALSE
	var/last_used_secondary = FALSE
	var/static/sfx_fire = 'sound/effects/splat.ogg'
	var/static/sfx_hit = 'sound/items/weapons/shove.ogg'

/datum/action/cooldown/shadowling/root/is_action_active(atom/movable/screen/movable/action_button/_btn)
	return targeting

/datum/action/cooldown/shadowling/root/unset_click_ability(mob/on_who, refund_cooldown)
	. = ..()
	targeting = FALSE
	secondary_mode = FALSE
	if(refund_cooldown)
		button_icon_state = last_used_secondary ? "shadow_hook" : "shadow_grasp"
		build_all_button_icons(UPDATE_BUTTON_ICON, force = TRUE)
	apply_button_overlay()

/datum/action/cooldown/shadowling/root/set_click_ability(mob/on_who, refund_cooldown)
	. = ..()
	targeting = TRUE
	apply_button_overlay()

/datum/action/cooldown/shadowling/root/can_use(mob/living/carbon/human/H)
	if(!..())
		return FALSE
	if(istype(H.loc, /obj/effect/dummy/phased_mob/shadowling) || H.has_status_effect(/datum/status_effect/shadow/phase))
		owner.balloon_alert(owner, "ability unavailable while phased")
		return FALSE
	return TRUE

/datum/action/cooldown/shadowling/root/Trigger(mob/clicker, trigger_flags, atom/target)
	if(!istype(owner))
		return FALSE
	if(!can_use(owner))
		return FALSE
	if(trigger_flags & TRIGGER_SECONDARY_ACTION)
		secondary_mode = !last_used_secondary
	else
		secondary_mode = last_used_secondary
	button_icon_state = secondary_mode ? "shadow_hook" : "shadow_grasp"
	build_all_button_icons(UPDATE_BUTTON_ICON, force = TRUE)
	return ..()

/datum/action/cooldown/shadowling/root/InterceptClickOn(mob/living/clicker, params, atom/target)
	if(!istype(clicker))
		unset_click_ability(clicker, TRUE)
		return FALSE

	if(!can_use(clicker))
		unset_click_ability(clicker, TRUE)
		return FALSE

	var/mob/living/carbon/human/H = clicker
	var/list/modifiers = params2list(params)
	var/is_hook
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		is_hook = !secondary_mode
	else
		is_hook = secondary_mode
	secondary_mode = FALSE

	var/turf/start_turf = get_turf(H)
	var/turf/click_turf = get_turf(target)
	if(!istype(start_turf) || !istype(click_turf))
		return FALSE

	if(is_hook)
		var/turf/aim_turf = (click_turf == start_turf) ? get_step(H, H.dir) : click_turf
		var/obj/projectile/magic/shadow_hand_sl/P = new(start_turf)
		P.firer = H
		P.range = max_range
		P.hitsound = sfx_hit
		P.aim_projectile(aim_turf, H)
		playsound(start_turf, sfx_fire, 55, TRUE)
		P.fire()

		last_used_secondary = TRUE
		button_icon_state = "shadow_hook"
		build_all_button_icons(UPDATE_BUTTON_ICON, force = TRUE)
		unset_click_ability(clicker, FALSE)
		StartCooldown()
		return TRUE

	var/mob/living/carbon/human/T
	if(ishuman(target))
		T = target
	else if(istype(target?.loc, /mob/living/carbon/human))
		T = target.loc

	if(!istype(T))
		H.balloon_alert(H, "invalid target")
		return FALSE

	if(T == H)
		H.balloon_alert(H, "cannot target yourself")
		return FALSE

	if(get_dist(H, T) > max_range)
		H.balloon_alert(H, "target out of range")
		return FALSE

	if(T.stat == DEAD)
		H.balloon_alert(H, "target is dead")
		return FALSE

	var/datum/team/shadow_hive/hive = get_shadow_hive()
	if(hive)
		if(T in hive.lings)
			H.balloon_alert(H, "allies cannot be targeted")
			return FALSE
		if(T in hive.thralls)
			H.balloon_alert(H, "allies cannot be targeted")
			return FALSE

	var/turf/tturf = get_turf(T)
	if(!tturf || tturf.get_lumcount() >= SHADOWLING_DIM_THRESHOLD)
		H.balloon_alert(H, "target not in darkness")
		return FALSE

	var/obj/effect/shadow_bind_anchor/A = new /obj/effect/shadow_bind_anchor(tturf, H)
	if(!A.apply_to(T))
		qdel(A)
		H.balloon_alert(H, "failed to ensnare")
		return FALSE

	last_used_secondary = FALSE
	button_icon_state = "shadow_grasp"
	build_all_button_icons(UPDATE_BUTTON_ICON, force = TRUE)
	unset_click_ability(clicker, FALSE)
	StartCooldown()
	return TRUE


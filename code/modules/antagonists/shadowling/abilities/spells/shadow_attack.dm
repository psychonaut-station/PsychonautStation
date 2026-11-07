// MARK: Ability
/datum/action/cooldown/shadowling/shadow_strike
	name = "Shadow Strike"
	desc = "Target a mortal while incorporeal. Left-Click to teleport and deliver a devastating strike (25 brute damage). Right-Click to teleport and grab them by the neck."
	button_icon_state = "shadow_strike"
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_INCAPACITATED
	cooldown_time = 5 SECONDS
	click_to_activate = TRUE
	unset_after_click = TRUE
	requires_dark_user = FALSE
	requires_dark_target = FALSE
	channel_time = 0
	max_range = 3

	var/grab_range = 2
	var/attack_value = 25
	var/target_grab_level = GRAB_NECK
	var/static/sfx_activate = 'sound/effects/magic/demon_attack1.ogg'
	var/targeting = FALSE
	var/secondary_mode = FALSE

/datum/action/cooldown/shadowling/shadow_strike/is_action_active(atom/movable/screen/movable/action_button/_btn)
	return targeting

/datum/action/cooldown/shadowling/shadow_strike/unset_click_ability(mob/on_who, refund_cooldown)
	. = ..()
	targeting = FALSE
	secondary_mode = FALSE
	button_icon_state = "shadow_strike"
	build_all_button_icons(UPDATE_BUTTON_ICON, force = TRUE)
	apply_button_overlay()

/datum/action/cooldown/shadowling/shadow_strike/set_click_ability(mob/on_who, refund_cooldown)
	. = ..()
	targeting = TRUE
	apply_button_overlay()

/datum/action/cooldown/shadowling/shadow_strike/can_use(mob/living/carbon/human/H)
	if(!..())
		return FALSE
	if(!isopenturf(H.loc) && !istype(H.loc, /obj/effect/dummy/phased_mob/shadowling))
		owner.balloon_alert(owner, "cannot use while enclosed")
		return FALSE
	if(istype(H.loc, /obj/effect/dummy/phased_mob/shadowling))
		return TRUE
	if(H.has_status_effect(/datum/status_effect/shadow/phase))
		return TRUE
	owner.balloon_alert(owner, "you must be incorporeal")
	return FALSE

/datum/action/cooldown/shadowling/shadow_strike/Trigger(mob/clicker, trigger_flags, atom/target)
	if(!istype(owner))
		return FALSE
	if(!can_use(owner))
		return FALSE
	secondary_mode = (trigger_flags & TRIGGER_SECONDARY_ACTION) ? TRUE : FALSE
	button_icon_state = secondary_mode ? "shadow_grab" : "shadow_strike"
	build_all_button_icons(UPDATE_BUTTON_ICON, force = TRUE)
	return ..()

/datum/action/cooldown/shadowling/shadow_strike/InterceptClickOn(mob/living/clicker, params, atom/target)
	if(!istype(clicker))
		unset_click_ability(clicker, TRUE)
		return FALSE

	if(!can_use(clicker))
		unset_click_ability(clicker, TRUE)
		return FALSE

	var/mob/living/carbon/human/H = clicker
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

	var/list/modifiers = params2list(params)
	var/is_grab = LAZYACCESS(modifiers, RIGHT_CLICK) ? TRUE : secondary_mode
	secondary_mode = FALSE

	var/dist = get_dist(H, T)
	if(is_grab)
		if(H.usable_hands <= 0 || HAS_TRAIT(H, TRAIT_HANDS_BLOCKED))
			H.balloon_alert(H, "hands not free")
			return FALSE
		if(T.anchored)
			H.balloon_alert(H, "target cannot be grabbed")
			return FALSE
		if(dist > grab_range)
			H.balloon_alert(H, "too far to grab")
			return FALSE
	else
		if(dist > max_range)
			H.balloon_alert(H, "too far to strike")
			return FALSE

	var/turf/nearby = pick_adjacent_open_turf(get_turf(T))
	if(!nearby)
		H.balloon_alert(H, "no space near target")
		return FALSE
	var/datum/action/cooldown/shadowling/shadow_phase/SP
	for(var/datum/action/cooldown/shadowling/shadow_phase/X in H.actions)
		SP = X
		break
	if(SP)
		SP.materialize_near(H, nearby, FALSE)
	else
		if(istype(H.loc, /obj/effect/dummy/phased_mob/shadowling))
			var/obj/effect/dummy/phased_mob/shadowling/P = H.loc
			if(istype(nearby))
				P.forceMove(nearby)
			P.eject_jaunter(FALSE)
		else
			H.remove_status_effect(/datum/status_effect/shadow/phase)
		H.alpha = 255

	for(var/datum/action/cooldown/shadowling/A in H.actions)
		A.build_all_button_icons(UPDATE_BUTTON_STATUS, TRUE)

	if(get_dist(H, T) > 1)
		step_towards(H, T)

	if(QDELETED(H))
		return FALSE

	if(QDELETED(T) || get_dist(H, T) > 1)
		H.balloon_alert(H, is_grab ? "too far to grab" : "too far to strike")
		unset_click_ability(H, TRUE)
		return FALSE

	if(is_grab)
		if(H.grab(T) != GRAB_SUCCESS)
			unset_click_ability(H, TRUE)
			return FALSE

		for(var/i in 1 to 3)
			if(H.grab_state >= target_grab_level)
				break
			if(!H.pulling || H.pulling != T)
				break
			if(!T.grippedby(H, TRUE))
				break

		if(H.pulling != T)
			unset_click_ability(H, TRUE)
			return FALSE

		H.visible_message(
			span_boldwarning("[H] bursts from the shadows and lunges at [T]'s throat!"),
			span_userdanger("You burst from the shadows and grab [T] by the neck!"),
			ignored_mobs = null
		)
		T.log_message("was grabbed from shadows by [H]", LOG_ATTACK, color = "#8a2be2")
		button_icon_state = "shadow_grab"
	else
		H.visible_message(
			span_boldwarning("[H] bursts from the shadows and strikes [T]!"),
			span_userdanger("You burst from the shadows and strike [T]!"),
			ignored_mobs = null
		)
		T.apply_damage(attack_value, BRUTE, null, sharpness = SHARP_POINTY)
		H.do_attack_animation(T)
		playsound(get_turf(H), sfx_activate, 65, TRUE)
		T.log_message("was hit by [H] with shadow strike for [attack_value] brute", LOG_ATTACK, color = "#8a2be2")
		button_icon_state = "shadow_strike"

	build_all_button_icons(UPDATE_BUTTON_ICON, force = TRUE)
	unset_click_ability(H, refund_cooldown = FALSE)
	StartCooldown()
	return TRUE


// MARK: Ability
/datum/action/cooldown/shadowling/labyrinth
	name = "Labyrinth"
	desc = "Mark a target standing in shadows (within 6 tiles and view), then click on a dark tile to teleport them there, shrouded in dark smoke."
	button_icon_state = "shadow_labyrinth"
	cooldown_time = 20 SECONDS
	click_to_activate = TRUE
	unset_after_click = TRUE
	min_req = 1
	max_req = 30
	required_thralls = 60
	var/selection_range = 6
	var/selection_timer
	var/mob/living/carbon/human/stored_target

/datum/action/cooldown/shadowling/labyrinth/Remove(mob/remove_from)
	. = ..()
	_cancel_selection(remove_from, refund = TRUE)

/datum/action/cooldown/shadowling/labyrinth/is_action_active(atom/movable/screen/movable/action_button/_btn)
	return stored_target != null

/datum/action/cooldown/shadowling/labyrinth/unset_click_ability(mob/on_who, refund_cooldown)
	. = ..()
	apply_button_overlay()

/datum/action/cooldown/shadowling/labyrinth/set_click_ability(mob/on_who, refund_cooldown)
	. = ..()
	apply_button_overlay()

/datum/action/cooldown/shadowling/labyrinth/Trigger(mob/clicker, trigger_flags, atom/target)
	. = ..()
	apply_button_overlay()
	if(!istype(clicker) || !IsAvailable(TRUE) || !can_use(clicker))
		return FALSE
	if(stored_target)
		owner.balloon_alert(owner, "cancelled")
		_cancel_selection(clicker, refund = TRUE)
		return TRUE
	var/mob/living/carbon/human/T = find_target(clicker)
	if(!T)
		owner.balloon_alert(owner, "no valid targets")
		return FALSE
	stored_target = T
	clicker.balloon_alert(clicker, "target locked")
	to_chat(clicker, span_notice("Click on a visible dark tile to teleport the victim. Right-click to cancel."))
	set_click_ability(clicker)
	_start_timeout(clicker)
	return TRUE

/datum/action/cooldown/shadowling/labyrinth/proc/find_target(mob/living/carbon/human/H)
	var/datum/team/shadow_hive/hive = get_shadow_hive()
	var/mob/living/carbon/human/best
	var/best_d = 1e9
	for(var/mob/living/carbon/human/T in view(selection_range, H))
		if(T == H || T.stat == DEAD)
			continue
		if(hive)
			if(T in hive.lings)
				continue
			if(T in hive.thralls)
				continue
		if(!is_dark(T))
			continue
		if(!in_front_cone(H, T, 90))
			continue
		var/d = get_dist(H, T)
		if(d < best_d)
			best_d = d
			best = T
	return best

/datum/action/cooldown/shadowling/labyrinth/InterceptClickOn(mob/living/clicker, params, atom/target)
	if(!stored_target || QDELETED(stored_target))
		_cancel_selection(owner, refund = TRUE)
		return FALSE
	if(!can_use(clicker) || !IsAvailable(TRUE))
		_cancel_selection(clicker, refund = TRUE)
		return FALSE
	var/list/p = params2list(params)
	if(p && ("right" in p))
		owner.balloon_alert(owner, "cancelled")
		_cancel_selection(clicker, refund = TRUE)
		return TRUE
	var/turf/T = get_turf(target)
	if(!istype(T))
		owner.balloon_alert(owner, "invalid tile")
		return FALSE
	if(isspaceturf(T) || !istype(T, /turf/open/floor))
		clicker.balloon_alert(clicker, "invalid destination")
		return FALSE
	if(!is_dark(T))
		owner.balloon_alert(owner, "too bright")
		return FALSE
	if(!(T in view(selection_range, clicker)))
		owner.balloon_alert(owner, "too far")
		return FALSE
	if(T.is_blocked_turf(TRUE) || T.density)
		owner.balloon_alert(owner, "blocked location")
		return FALSE
	var/mob/living/carbon/human/V = stored_target
	if(QDELETED(V))
		_cancel_selection(clicker, refund = TRUE)
		return FALSE
	var/turf/src_turf = get_turf(V)
	playsound(src_turf, 'sound/effects/smoke.ogg', 40, TRUE, -3)
	shadow_spawn_smoke(src_turf, owner, 2, 3, 6, 3 SECONDS, 20, 1 SECONDS)
	V.forceMove(T)
	playsound(T, 'sound/effects/smoke.ogg', 40, TRUE, -3)
	shadow_spawn_smoke(T, owner, 2, 3, 6, 3 SECONDS, 20, 1 SECONDS)
	to_chat(owner, span_notice("[V.real_name] vanishes into smoke and re-emerges elsewhere."))
	to_chat(V, span_danger("The shadows warp space around you!"))
	_cancel_selection(clicker, refund = FALSE)
	StartCooldown()
	return TRUE

/datum/action/cooldown/shadowling/labyrinth/proc/_start_timeout(mob/living/carbon/human/H)
	deltimer(selection_timer)
	selection_timer = addtimer(CALLBACK(src, PROC_REF(_on_timeout), H), 8 SECONDS, TIMER_STOPPABLE)

/datum/action/cooldown/shadowling/labyrinth/proc/_on_timeout(mob/living/carbon/human/H)
	if(H?.click_intercept == src)
		owner.balloon_alert(owner, "time ran out")
	_cancel_selection(H, refund = TRUE)

/datum/action/cooldown/shadowling/labyrinth/proc/_cancel_selection(mob/living/carbon/human/H, refund)
	deltimer(selection_timer)
	selection_timer = null
	stored_target = null
	if(istype(H) && H.click_intercept == src)
		unset_click_ability(H, refund_cooldown = refund)

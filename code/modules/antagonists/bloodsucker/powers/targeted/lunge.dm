/datum/action/cooldown/bloodsucker/targeted/lunge
	name = "Predatory Rush"
	desc = "Brace and unleash a terrifying beastial charge, violently slamming and pinning your prey to the deck."
	button_icon_state = "power_lunge"
	power_explanation = "Predatory Rush:\n\
		Brace your unholy sinews and surge forward in a terrifying high-speed charge toward your quarry.\n\
		Colliding with a victim violently tackles them to the deck, inflicting heavy physical trauma and securing an aggressive hold over their body.\n\
		Deepening mastery sharpens your predatory instinct, greatly quickening your preparation time and amplifying the sheer violence and stunning impact of the collision."
	power_flags = NONE
	check_flags = BP_CANT_USE_IN_TORPOR | BP_CANT_USE_IN_FRENZY | BP_CANT_USE_WHILE_INCAPACITATED | BP_CANT_USE_WHILE_UNCONSCIOUS
	purchase_flags = BLOODSUCKER_CAN_BUY | VASSAL_CAN_BUY
	bloodcost = 10
	sol_multiplier = 15
	cooldown_time = 8 SECONDS
	power_activates_immediately = FALSE
	target_range = 8

	/// If the user is currently charging
	var/actively_moving = FALSE
	/// List of charging mobs managed by this datum
	var/list/charging_mobs = list()
	/// Target atom of current charge
	var/atom/charge_target

/datum/action/cooldown/bloodsucker/targeted/lunge/Destroy()
	if(owner && (owner in charging_mobs))
		charge_end(owner)
	return ..()

/datum/action/cooldown/bloodsucker/targeted/lunge/can_deactivate()
	return !(owner in charging_mobs)

/datum/action/cooldown/bloodsucker/targeted/lunge/can_use(mob/living/carbon/user, trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	if(user in charging_mobs)
		return FALSE
	// Are we being grabbed?
	if(!QDELETED(user.pulledby) && user.pulledby.grab_state >= GRAB_AGGRESSIVE)
		owner.balloon_alert(user, "grabbed!")
		return FALSE
	if(!QDELETED(user.pulling))
		owner.balloon_alert(user, "grabbing someone!")
		return FALSE
	if(user.body_position == LYING_DOWN || HAS_TRAIT(owner, TRAIT_IMMOBILIZED))
		owner.balloon_alert(user, "cannot move!")
		return FALSE
	return TRUE

/datum/action/cooldown/bloodsucker/targeted/lunge/CheckValidTarget(atom/target_atom)
	. = ..()
	if(!.)
		return FALSE
	return isliving(target_atom) || isturf(target_atom)

/datum/action/cooldown/bloodsucker/targeted/lunge/CheckCanTarget(atom/target_atom)
	. = ..()
	if(!.)
		return FALSE
	var/turf/target_turf = get_turf(target_atom)
	if(!target_turf)
		return FALSE
	var/mob/living/user = owner
	if(user.body_position == LYING_DOWN || HAS_TRAIT(owner, TRAIT_IMMOBILIZED))
		return FALSE
	return TRUE

/// Calculates the startup time: decreases as power level increases!
/datum/action/cooldown/bloodsucker/targeted/lunge/proc/get_charge_startup_time()
	return max(0.2 SECONDS, 1.4 SECONDS - (level_current * 0.3 SECONDS))

/datum/action/cooldown/bloodsucker/targeted/lunge/FireTargetedPower(atom/target_atom)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(execute_charge), target_atom)
	return TRUE

/datum/action/cooldown/bloodsucker/targeted/lunge/proc/execute_charge(atom/target_atom)
	if(!can_pay_cost() || !can_use(owner) || !CheckCanTarget(target_atom))
		DeactivatePower()
		return

	unset_click_ability(owner)
	pay_cost()
	StartCooldown()

	var/mob/living/charger = owner
	var/turf/chargeturf = get_turf(target_atom)
	if(!chargeturf || !charger)
		DeactivatePower()
		return

	var/dir = get_dir(charger, target_atom)
	var/turf/destination_turf = get_ranged_target_turf(chargeturf, dir, 2) || chargeturf

	if(charger in charging_mobs)
		GLOB.move_manager.stop_looping(charger)

	charging_mobs += charger
	actively_moving = FALSE
	charge_target = target_atom

	RegisterSignal(charger, COMSIG_MOVABLE_BUMP, PROC_REF(on_bump), override = TRUE)
	RegisterSignal(charger, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(on_move), override = TRUE)
	RegisterSignal(charger, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved), override = TRUE)
	RegisterSignal(charger, COMSIG_LIVING_DEATH, PROC_REF(charge_end), override = TRUE)

	charger.setDir(dir)

	// Startup delay: decreases with power level!
	var/startup_delay = get_charge_startup_time()
	charger.balloon_alert(charger, "preparing charge...")
	charger.Shake(2, 2, startup_delay)

	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(charger.loc, charger)
	animate(D, alpha = 0, color = COLOR_RED, transform = matrix() * 1.5, time = 3)
	playsound(charger, 'sound/effects/magic/demon_attack1.ogg', 40, TRUE)

	SLEEP_CHECK_DEATH(startup_delay, charger)

	if(charger.stat == DEAD || charger.incapacitated || charger.body_position == LYING_DOWN)
		charge_end(charger)
		return

	playsound(charger, 'sound/effects/meteorimpact.ogg', 50, TRUE)

	var/charge_speed = 0.5
	var/time_to_hit = min(get_dist(charger, destination_turf), target_range) * charge_speed

	var/datum/move_loop/new_loop = GLOB.move_manager.home_onto(charger, destination_turf, delay = charge_speed, timeout = time_to_hit, priority = MOVEMENT_ABOVE_SPACE_PRIORITY)
	if(!new_loop)
		charge_end(charger)
		return

	RegisterSignal(new_loop, COMSIG_MOVELOOP_PREPROCESS_CHECK, PROC_REF(pre_move), override = TRUE)
	RegisterSignal(new_loop, COMSIG_MOVELOOP_POSTPROCESS, PROC_REF(post_move), override = TRUE)
	RegisterSignal(new_loop, COMSIG_QDELETING, PROC_REF(on_loop_ended), override = TRUE)

	// In case target was already adjacent
	if(isliving(target_atom) && charger.Adjacent(target_atom))
		hit_target(charger, target_atom)
		return

	sleep(time_to_hit + charge_speed)
	if(charger in charging_mobs)
		charger.setDir(dir)
		charge_end(charger)

/datum/action/cooldown/bloodsucker/targeted/lunge/proc/pre_move(datum/source)
	SIGNAL_HANDLER
	actively_moving = TRUE

/datum/action/cooldown/bloodsucker/targeted/lunge/proc/post_move(datum/source)
	SIGNAL_HANDLER
	actively_moving = FALSE

/datum/action/cooldown/bloodsucker/targeted/lunge/proc/on_move(atom/source, atom/new_loc)
	SIGNAL_HANDLER
	if(!actively_moving)
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE
	new /obj/effect/temp_visual/decoy/fading(source.loc, source)

/datum/action/cooldown/bloodsucker/targeted/lunge/proc/on_moved(atom/source)
	SIGNAL_HANDLER
	var/mob/living/charger = source
	if(charge_target && isliving(charge_target) && charger.Adjacent(charge_target))
		hit_target(charger, charge_target)

/datum/action/cooldown/bloodsucker/targeted/lunge/proc/on_bump(atom/movable/source, atom/target)
	SIGNAL_HANDLER
	if(source == target)
		return
	if(isliving(target))
		hit_target(source, target)
		return
	if(target.density)
		source.visible_message(span_danger("[source] smashes into [target]!"))
		playsound(get_turf(source), 'sound/effects/meteorimpact.ogg', 50, TRUE)
		shake_camera(source, 2, 2)
		charge_end(source)

/datum/action/cooldown/bloodsucker/targeted/lunge/proc/hit_target(atom/movable/source, mob/living/target)
	if(!isliving(target))
		return
	var/mob/living/charger = source
	if(charger)
		GLOB.move_manager.stop_looping(charger)

	target.visible_message(
		span_danger("[charger] ferociously charges into [target]!"),
		span_userdanger("[charger] charges into you!")
	)
	var/damage_dealt = 15 + (level_current * 3)
	target.apply_damage(damage_dealt, BRUTE, wound_bonus = CANT_WOUND)
	playsound(get_turf(target), 'sound/effects/meteorimpact.ogg', 80, TRUE)
	shake_camera(target, 4, 3)

	var/knockdown_duration = 2 SECONDS + (level_current * 0.5 SECONDS)
	target.Knockdown(knockdown_duration)

	target.grabbedby(charger)
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		carbon_target.grippedby(charger, instant = TRUE)
	charger.start_pulling(target)

	charge_end(charger)

/datum/action/cooldown/bloodsucker/targeted/lunge/proc/on_loop_ended(datum/source)
	SIGNAL_HANDLER
	if(owner)
		charge_end(owner)

/datum/action/cooldown/bloodsucker/targeted/lunge/proc/charge_end(atom/movable/charger)
	SIGNAL_HANDLER
	if(istype(charger, /datum/move_loop))
		var/datum/move_loop/loop = charger
		charger = loop.moving
	if(!charger)
		charger = owner
	if(charger)
		GLOB.move_manager.stop_looping(charger)
		UnregisterSignal(charger, list(COMSIG_MOVABLE_BUMP, COMSIG_MOVABLE_PRE_MOVE, COMSIG_MOVABLE_MOVED, COMSIG_LIVING_DEATH))
	actively_moving = FALSE
	charging_mobs -= charger
	charge_target = null
	DeactivatePower()

/datum/action/cooldown/bloodsucker/targeted/lunge/DeactivatePower()
	if(owner && (owner in charging_mobs))
		GLOB.move_manager.stop_looping(owner)
		charge_end(owner)
	return ..()

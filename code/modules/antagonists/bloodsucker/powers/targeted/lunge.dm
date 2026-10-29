/datum/action/cooldown/bloodsucker/targeted/lunge
	name = "Predatory Rush"
	desc = "Brace and unleash a terrifying beastial charge, violently slamming and pinning your prey to the deck."
	button_icon_state = "power_lunge"
	power_explanation = "Predatory Rush:\n\
		Brace your unholy sinews and surge forward in a terrifying high-speed charge toward your quarry.\n\
		Colliding with a victim violently tackles them to the deck, inflicting heavy physical trauma and securing an aggressive hold over their body.\n\
		Deepening mastery sharpens your predatory savagery: upon impact, you voraciously tear into the victim to gorge on their vital blood while inflicting escalating physical ruin—tearing open bleeding lacerations, wrenching limbs from their sockets, and ultimately shattering bones to dust."
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

/// Startup time remains fixed for fair telegraph and counterplay
/datum/action/cooldown/bloodsucker/targeted/lunge/proc/get_charge_startup_time()
	return 1 SECONDS

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
	RegisterSignal(new_loop, COMSIG_QDELETING, PROC_REF(charge_end), override = TRUE)

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
		INVOKE_ASYNC(src, PROC_REF(hit_target), charger, charge_target)

/datum/action/cooldown/bloodsucker/targeted/lunge/proc/on_bump(atom/movable/source, atom/target)
	SIGNAL_HANDLER
	if(source == target)
		return
	if(isliving(target))
		INVOKE_ASYNC(src, PROC_REF(hit_target), source, target)
		return
	if(target.density)
		var/mob/living/charger = source
		if(!charger || !(charger in charging_mobs))
			return
		source.visible_message(span_danger("[source] smashes into [target]!"))
		playsound(get_turf(source), 'sound/effects/meteorimpact.ogg', 50, TRUE)
		shake_camera(source, 2, 2)
		charge_end(charger)

/datum/action/cooldown/bloodsucker/targeted/lunge/proc/hit_target(atom/movable/source, mob/living/target)
	if(!isliving(target))
		return
	var/mob/living/charger = source
	if(!charger || !(charger in charging_mobs))
		return
	charge_end(charger)

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

	charger.start_pulling(target)
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		var/effective_level = clamp(level_current, 1, 4)

		// 1. Predatory Leech: 15 / 20 / 25 / 30 blood stolen
		var/blood_to_steal = 10 + (effective_level * 5)
		if(carbon_target.blood_volume > 0 && !HAS_TRAIT(carbon_target, TRAIT_NOBLOOD))
			var/blood_taken = min(blood_to_steal, carbon_target.blood_volume)
			carbon_target.blood_volume = max(0, carbon_target.blood_volume - blood_taken)
			if(bloodsuckerdatum_power)
				bloodsuckerdatum_power.AddBloodVolume(blood_taken)
			else
				var/datum/antagonist/bloodsucker/vamp = charger.mind?.has_antag_datum(/datum/antagonist/bloodsucker)
				vamp?.AddBloodVolume(blood_taken)
			charger.balloon_alert(charger, "+[blood_taken] blood")
			playsound(get_turf(target), 'sound/items/weapons/bite.ogg', 60, TRUE)

		// 2. Wound progression:
		var/obj/item/bodypart/chosen_part
		var/list/obj/item/bodypart/jointed_parts = list()
		for(var/obj/item/bodypart/part as anything in carbon_target.bodyparts)
			if(part.biological_state & BIO_JOINTED)
				jointed_parts += part
		if(length(jointed_parts))
			chosen_part = pick(jointed_parts)
		else if(length(carbon_target.bodyparts))
			chosen_part = pick(carbon_target.bodyparts)

		switch(effective_level)
			if(1)
				// Level 1: Minik kanama (%50 ihtimal)
				if(prob(50))
					carbon_target.cause_wound_of_type_and_severity(WOUND_SLASH, chosen_part, WOUND_SEVERITY_MODERATE, wound_source = "predatory rush")
			if(2)
				// Level 2: Daha yüksek kanama (%60 ağır, aksi halde %40 minik)
				if(prob(60))
					carbon_target.cause_wound_of_type_and_severity(WOUND_SLASH, chosen_part, WOUND_SEVERITY_SEVERE, wound_source = "vicious predatory rush")
				else if(prob(40))
					carbon_target.cause_wound_of_type_and_severity(WOUND_SLASH, chosen_part, WOUND_SEVERITY_MODERATE, wound_source = "predatory rush")
			if(3)
				// Level 3: Ağır kanama + %30 ihtimalle eklem çıkarma (Joint Dislocation)
				if(prob(70))
					carbon_target.cause_wound_of_type_and_severity(WOUND_SLASH, chosen_part, WOUND_SEVERITY_SEVERE, wound_source = "savage predatory rush")
				if(prob(30))
					carbon_target.cause_wound_of_type_and_severity(WOUND_BLUNT, chosen_part, WOUND_SEVERITY_MODERATE, wound_source = "predatory joint wrench")
			if(4)
				// Level 4: Kritik/Ağır kanama + %35 kemik kırma, olmazsa %30 eklem çıkarma
				if(prob(45))
					carbon_target.cause_wound_of_type_and_severity(WOUND_SLASH, chosen_part, WOUND_SEVERITY_CRITICAL, wound_source = "monstrous predatory rush")
				else if(prob(65))
					carbon_target.cause_wound_of_type_and_severity(WOUND_SLASH, chosen_part, WOUND_SEVERITY_SEVERE, wound_source = "savage predatory rush")
				if(prob(35))
					carbon_target.cause_wound_of_type_and_severity(WOUND_BLUNT, chosen_part, WOUND_SEVERITY_CRITICAL, wound_source = "bone-crushing predatory tackle")
				else if(prob(30))
					carbon_target.cause_wound_of_type_and_severity(WOUND_BLUNT, chosen_part, WOUND_SEVERITY_MODERATE, wound_source = "predatory joint wrench")

	charger.start_pulling(target)

/datum/action/cooldown/bloodsucker/targeted/lunge/proc/charge_end(datum/source)
	SIGNAL_HANDLER
	var/atom/movable/charger = source
	if(istype(source, /datum/move_loop))
		var/datum/move_loop/loop = source
		charger = loop.moving
	if(!charger)
		charger = owner
	if(!charger || !(charger in charging_mobs))
		return
	charging_mobs -= charger
	UnregisterSignal(charger, list(COMSIG_MOVABLE_BUMP, COMSIG_MOVABLE_PRE_MOVE, COMSIG_MOVABLE_MOVED, COMSIG_LIVING_DEATH))
	actively_moving = FALSE
	charge_target = null
	if(!istype(source, /datum/move_loop))
		GLOB.move_manager.stop_looping(charger)
	DeactivatePower()

/datum/action/cooldown/bloodsucker/targeted/lunge/DeactivatePower()
	if(owner && (owner in charging_mobs))
		charge_end(owner)
		return
	return ..()

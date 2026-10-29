/datum/action/cooldown/bloodsucker/fortitude
	name = "Fortitude"
	desc = "Harden your flesh and bone like tempered steel to shrug off physical trauma, piercing strikes, and debilitating shocks."
	button_icon_state = "power_fortitude"
	power_explanation = "Fortitude:\n\
		Harden flesh, sinew, and bone to shrug off piercing strikes, severe impacts, and dismemberment.\n\
		The immense supernatural density prevents running; attempting to sprint will crush you under your own unyielding mass.\n\
		The crushing weight of Fortitude cannot be sustained alongside Immortal Haste.\n\
		As your rank increases, your resilience hardens further against physical trauma and exhausting blows, ultimately granting absolute immunity to stunning shocks."
	power_flags = BP_AM_TOGGLE | BP_AM_COSTLESS_UNCONSCIOUS
	check_flags = BP_CANT_USE_IN_TORPOR | BP_CANT_USE_IN_FRENZY
	purchase_flags = BLOODSUCKER_CAN_BUY | VASSAL_CAN_BUY
	bloodcost = 30
	cooldown_time = 8 SECONDS
	constant_bloodcost = 0.2
	sol_multiplier = 3
	var/was_running
	var/fortitude_resist // So we can raise and lower your brute resist based on what your level_current WAS.

/datum/action/cooldown/bloodsucker/fortitude/can_use(mob/living/carbon/user, trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	for(var/datum/action/cooldown/bloodsucker/haste/haste_power in bloodsuckerdatum_power?.powers)
		if(haste_power.active)
			owner.balloon_alert(owner, "cannot use with haste!")
			return FALSE
	return TRUE

/datum/action/cooldown/bloodsucker/fortitude/ActivatePower(trigger_flags)
	. = ..()
	owner.balloon_alert(owner, "fortitude turned on.")
	to_chat(owner, span_notice("Your flesh, skin, and muscles become as steel."))
	// Traits & Effects
	owner.add_traits(list(TRAIT_PIERCEIMMUNE, TRAIT_ANALGESIA, TRAIT_NODISMEMBER, TRAIT_PUSHIMMUNE), FORTITUDE_TRAIT)
	if(level_current >= 4)
		owner.add_traits(list(TRAIT_STUNIMMUNE, TRAIT_CANT_STAMCRIT), FORTITUDE_TRAIT) // They'll get stun resistance + this, who cares.
	var/mob/living/carbon/human/bloodsucker_user = owner
	if(IS_BLOODSUCKER(owner) || IS_VASSAL(owner))
		fortitude_resist = max(0.3, 0.7 - level_current * 0.1)
		MODIFY_PHYSIOLOGY(bloodsucker_user, BRUTE, fortitude_resist)
		MODIFY_PHYSIOLOGY(bloodsucker_user, STAMINA, fortitude_resist)

	was_running = (bloodsucker_user.move_intent == MOVE_INTENT_RUN)
	if(was_running)
		bloodsucker_user.toggle_move_intent()

/datum/action/cooldown/bloodsucker/fortitude/process(seconds_per_tick)
	// Checks that we can keep using this.
	. = ..()
	if(!.)
		return
	if(!active)
		return
	var/mob/living/carbon/user = owner
	/// Prevents running while on Fortitude
	if(user.move_intent != MOVE_INTENT_WALK)
		user.toggle_move_intent()
		user.balloon_alert(user, "you attempt to run, crushing yourself.")
		user.take_overall_damage(brute = rand(5, 15))
	/// We don't want people using fortitude being able to use vehicles
	if(user.buckled && istype(user.buckled, /obj/vehicle))
		user.buckled.unbuckle_mob(user, force = TRUE)

/datum/action/cooldown/bloodsucker/fortitude/DeactivatePower()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/bloodsucker_user = owner
	if(IS_BLOODSUCKER(owner) || IS_VASSAL(owner))
		MODIFY_PHYSIOLOGY(bloodsucker_user, BRUTE, 1 / fortitude_resist)
		MODIFY_PHYSIOLOGY(bloodsucker_user, STAMINA, 1 / fortitude_resist)
	// Remove Traits & Effects
	owner.remove_traits(list(TRAIT_PIERCEIMMUNE, TRAIT_ANALGESIA, TRAIT_NODISMEMBER, TRAIT_PUSHIMMUNE, TRAIT_STUNIMMUNE, TRAIT_CANT_STAMCRIT), FORTITUDE_TRAIT)

	if(was_running && bloodsucker_user.move_intent == MOVE_INTENT_WALK)
		bloodsucker_user.toggle_move_intent()
	owner.balloon_alert(owner, "fortitude turned off.")

	return ..()

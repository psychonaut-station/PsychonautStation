/datum/actionspeed_modifier/bloodsucker_haste
	variable = TRUE
	id = "bloodsucker_haste"

/datum/action/cooldown/bloodsucker/haste
	name = "Immortal Haste"
	desc = "Accelerate your perception and reflexes to superhuman extremes. Evade gunfire and perform interactions at blinding speed."
	button_icon_state = "power_speed"
	power_explanation = "Immortal Haste:\n\
		Toggled ability that accelerates your reflexes to supernatural levels;\n\
		- Grants a chance to evade incoming bullets and projectiles (starts at 15% at Level 1, +15% per level up to max 60% at Level 4).\n\
		- Your action and interaction speed is greatly increased (starts at +15% at Level 1, +15% per level up to max +60% at Level 4).\n\
		- Leaves behind ghostly afterimages while moving.\n\
		- Upon initial activation, slips out of any grab.\n\
		- Cannot be used simultaneously with Fortitude.\n\
		Higher levels increase projectile evasion chance and interaction speed (max Level 4)."
	power_flags = BP_AM_TOGGLE
	check_flags = BP_CANT_USE_IN_TORPOR | BP_CANT_USE_IN_FRENZY | BP_CANT_USE_WHILE_STAKED | BP_CANT_USE_WHILE_INCAPACITATED | BP_CANT_USE_WHILE_UNCONSCIOUS
	purchase_flags = BLOODSUCKER_CAN_BUY | VASSAL_CAN_BUY
	bloodcost = 10
	constant_bloodcost = 0.2
	sol_multiplier = 3
	cooldown_time = 8 SECONDS

/datum/action/cooldown/bloodsucker/haste/can_use(mob/living/carbon/user, trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	for(var/datum/action/cooldown/bloodsucker/fortitude/fortitude_power in bloodsuckerdatum_power?.powers)
		if(fortitude_power.active)
			owner.balloon_alert(owner, "cannot use with fortitude!")
			return FALSE
	return TRUE

/datum/action/cooldown/bloodsucker/haste/ActivatePower(trigger_flags)
	. = ..()
	var/mob/living/user = owner

	// Slips out of grab once upon initial activation
	if(user.pulledby)
		to_chat(user.pulledby, span_warning("[user] slips out of your grasp with blinding speed!"))
		to_chat(user, span_notice("You slip out of [user.pulledby]'s grasp!"))
		user.pulledby.stop_pulling()

	user.balloon_alert(user, "haste turned on.")
	to_chat(user, span_notice("Your perception and reflexes accelerate into a supernatural blur."))
	playsound(user, 'sound/items/weapons/punchmiss.ogg', 40, TRUE)

	// After image trail while moving
	user.AddComponent(/datum/component/after_image, 6, 0.5, FALSE)

	// Register bullet dodge signal
	RegisterSignal(user, COMSIG_ATOM_PRE_BULLET_ACT, PROC_REF(dodge_bullets))

	// Fast interaction speed (+15% at level 0, +15% per level, max +60%)
	apply_actionspeed()

/datum/action/cooldown/bloodsucker/haste/ContinueActive(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	if(user.stat != CONSCIOUS)
		return FALSE
	return TRUE

/datum/action/cooldown/bloodsucker/haste/DeactivatePower()
	if(!active)
		return
	var/mob/living/user = owner
	if(user)
		UnregisterSignal(user, COMSIG_ATOM_PRE_BULLET_ACT)
		qdel(user.GetComponent(/datum/component/after_image))
		user.remove_actionspeed_modifier("bloodsucker_haste")
		user.balloon_alert(user, "haste turned off.")

	return ..()

/datum/action/cooldown/bloodsucker/haste/Destroy()
	if(active)
		DeactivatePower()
	return ..()

/datum/action/cooldown/bloodsucker/haste/Remove(mob/user)
	if(active)
		DeactivatePower()
	return ..()

/datum/action/cooldown/bloodsucker/haste/upgrade_power()
	if(level_current >= 4)
		return
	. = ..()
	if(active && owner)
		apply_actionspeed()

/datum/action/cooldown/bloodsucker/haste/proc/apply_actionspeed()
	if(!ismob(owner))
		return
	var/mob/living/user = owner
	// SS13 actionspeed uses 'multiplicative_slowdown' where final delay = delay * (1 + sum_of_slowdowns).
	// Therefore, negative values reduce interaction delay (e.g. -0.15 = 15% faster, -0.60 = 60% faster).
	var/speed_mult = min(0.60, max(1, level_current) * 0.15)
	user.add_or_update_variable_actionspeed_modifier(/datum/actionspeed_modifier/bloodsucker_haste, TRUE, -speed_mult)

/datum/action/cooldown/bloodsucker/haste/proc/dodge_bullets(mob/living/source, obj/projectile/hitting_projectile, def_zone)
	SIGNAL_HANDLER

	if(source.stat != CONSCIOUS || source.incapacitated)
		return NONE

	var/dodge_chance = min(60, max(1, level_current) * 15)
	if(!prob(dodge_chance))
		return NONE

	source.visible_message(
		span_danger("[source] blurs in supernatural speed, evading [hitting_projectile]!"),
		span_danger("You blur in supernatural speed, evading [hitting_projectile]!"),
	)
	playsound(source, SFX_BULLET_MISS, 75, TRUE)
	return COMPONENT_BULLET_PIERCED

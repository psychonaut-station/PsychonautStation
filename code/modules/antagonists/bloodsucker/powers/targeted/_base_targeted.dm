/datum/action/cooldown/bloodsucker/targeted
	click_to_activate = TRUE
	unset_after_click = TRUE
	power_flags = NONE

	///If set, how far the target has to be for the power to work.
	var/target_range
	///Message sent to chat when clicking on the power, before you use it.
	var/prefire_message
	///Most powers happen the moment you click. Some, like Mesmerize, require time and shouldn't cost you if they fail.
	var/power_activates_immediately = TRUE
	///Is this power LOCKED due to being used?
	var/power_in_use = FALSE

/// Modify description to add notice that this is aimed.
/datum/action/cooldown/bloodsucker/targeted/New(Target)
	desc += "<br>\[<i>Targeted Power</i>\]"
	return ..()

/datum/action/cooldown/bloodsucker/targeted/Trigger(mob/clicker, trigger_flags, atom/target)
	SHOULD_CALL_PARENT(FALSE)
	if(!owner)
		return FALSE
	find_bloodsucker_datum()
	var/mob/user = clicker || owner
	if(user.click_intercept == src && !target)
		unset_click_ability(user, refund_cooldown = TRUE)
		return FALSE
	if(!IsAvailable(feedback = TRUE) || !can_pay_cost() || !can_use(owner, trigger_flags))
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_ACTION_TRIGGER, src) & COMPONENT_ACTION_BLOCK_TRIGGER)
		return FALSE
	var/datum/action/cooldown/already_set = user.click_intercept
	if(istype(already_set) && already_set != src)
		already_set.unset_click_ability(user, refund_cooldown = TRUE)
	if(try_trigger_instant(user, trigger_flags))
		return TRUE
	if(!QDELETED(target))
		return InterceptClickOn(user, null, target)
	return set_click_ability(user)

/datum/action/cooldown/bloodsucker/targeted/set_click_ability(mob/on_who)
	. = ..()
	if(!.)
		return
	build_all_button_icons(UPDATE_BUTTON_BACKGROUND)
	if(prefire_message)
		to_chat(on_who, span_announce("[prefire_message]"))

/datum/action/cooldown/bloodsucker/targeted/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	. = ..()
	if(.)
		build_all_button_icons(UPDATE_BUTTON_BACKGROUND)

/// Hook for targeted powers that can resolve immediately on trigger without aiming.
/datum/action/cooldown/bloodsucker/targeted/proc/try_trigger_instant(mob/user, trigger_flags)
	return FALSE

/// Check if target is VALID (wall, turf, or character?)
/datum/action/cooldown/bloodsucker/targeted/proc/is_valid_target(atom/target_atom)
	if(target_atom == owner)
		return FALSE
	return TRUE

/// Check if valid target meets conditions
/datum/action/cooldown/bloodsucker/targeted/proc/can_target(atom/target_atom)
	if(target_range)
		// Out of Range
		if(!(target_atom in view(target_range, owner)))
			if(target_range > 1) // Only warn for range if it's greater than 1. Brawn doesn't need to announce itself.
				owner.balloon_alert(owner, "out of range.")
			return FALSE
	return istype(target_atom)

/// The power went off! We now pay the cost of the power.
/datum/action/cooldown/bloodsucker/targeted/proc/complete_targeted_activation()
	if(owner?.click_intercept == src)
		unset_click_ability(owner, refund_cooldown = FALSE)
	pay_cost()
	StartCooldown()
	if(power_flags & BP_AM_SINGLEUSE)
		remove_after_use()

/datum/action/cooldown/bloodsucker/targeted/InterceptClickOn(mob/living/clicker, params, atom/target)
	if(power_in_use || !IsAvailable(feedback = TRUE) || QDELETED(target))
		return FALSE
	if(!is_valid_target(target))
		return FALSE
	if(!can_pay_cost() || !can_use(owner) || !can_target(target))
		return TRUE
	PreActivate(target)
	if(unset_after_click && !QDELETED(clicker) && clicker.click_intercept == src)
		unset_click_ability(clicker, refund_cooldown = FALSE)
	clicker.next_click = world.time + click_cd_override
	return TRUE

/datum/action/cooldown/bloodsucker/targeted/PreActivate(atom/target)
	if(SEND_SIGNAL(owner, COMSIG_MOB_ABILITY_STARTED, src, target) & COMPONENT_BLOCK_ABILITY_START)
		return FALSE
	power_in_use = TRUE
	. = Activate(target)
	power_in_use = FALSE
	if(!QDELETED(src) && !QDELETED(owner))
		SEND_SIGNAL(owner, COMSIG_MOB_ABILITY_FINISHED, src)

/datum/action/cooldown/bloodsucker/targeted/Activate(atom/target)
	log_combat(owner, target, "used [name] on")
	if(power_activates_immediately)
		complete_targeted_activation()
	return TRUE

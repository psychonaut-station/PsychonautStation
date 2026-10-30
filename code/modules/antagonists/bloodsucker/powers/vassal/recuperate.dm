/// Used by Vassals
/datum/action/cooldown/bloodsucker/recuperate
	name = "Sanguine Recuperation"
	desc = "Draw upon your Master's immortal bloodline to slowly knit your flesh and purge toxins, at the expense of your stamina."
	button_icon_state = "power_recup"
	power_explanation = "Sanguine Recuperation:\n\
		Channel the supernatural vitae gifted by your Master to slowly knit torn flesh and purge dangerous toxins from your bloodstream.\n\
		The grueling process exhausts your mortal endurance and sips vitality from both you and your Master, collapsing should you succumb to incapacitation."
	power_flags = BP_AM_TOGGLE
	check_flags = BP_CANT_USE_WHILE_UNCONSCIOUS
	purchase_flags = NONE
	bloodcost = 1.5
	cooldown_time = 10 SECONDS

/datum/action/cooldown/bloodsucker/recuperate/can_use(mob/living/carbon/user, trigger_flags)
	. = ..()
	if(!.)
		return
	if(user.blood_volume <= BLOOD_VOLUME_OKAY)
		user.balloon_alert(user, "not enough blood!")
		return FALSE
	if(user.stat >= DEAD)
		user.balloon_alert(user, "you are incapacitated...")
		return FALSE
	return TRUE


/datum/action/cooldown/bloodsucker/recuperate/ActivatePower(trigger_flags)
	. = ..()
	to_chat(owner, span_notice("Your muscles clench as your master's immortal blood mixes with your own, knitting your wounds."))
	owner.balloon_alert(owner, "recuperate turned on.")

/datum/action/cooldown/bloodsucker/recuperate/process(seconds_per_tick)
	. = ..()
	if(!.)
		return
	if(!active)
		return
	var/mob/living/carbon/user = owner
	var/datum/antagonist/vassal/vassaldatum = IS_VASSAL(user)
	if(vassaldatum?.master && vassaldatum.master.bloodsucker_blood_volume > 5)
		vassaldatum.master.AddBloodVolume(-1)
	user.set_timed_status_effect(5 SECONDS, /datum/status_effect/jitter, only_if_higher = TRUE)
	user.adjust_stamina_loss(bloodcost * 1.1)
	user.heal_overall_damage(brute = 2.5, updating_health = FALSE)
	user.adjust_tox_loss(-2, updating_health = FALSE, forced = TRUE)
	// Plasmamen won't lose blood, they don't have any, so they don't heal from Burn.
	if(!HAS_TRAIT(user, TRAIT_NOBLOOD))
		user.blood_volume -= bloodcost
		user.adjust_fire_loss(-1.5, updating_health = FALSE)
	user.updatehealth() // only update health once after we've healed everything we might've
	// Stop Bleeding
	if(istype(user) && user.is_bleeding())
		for(var/obj/item/bodypart/part in user.bodyparts)
			part.generic_bleedstacks = max(0, part.generic_bleedstacks - 1)

/datum/action/cooldown/bloodsucker/recuperate/ContinueActive(mob/living/user, mob/living/target)
	if(QDELETED(user))
		return FALSE
	if(user.stat >= DEAD)
		return FALSE
	if(user.incapacitated)
		owner.balloon_alert(owner, "too exhausted...")
		return FALSE
	return TRUE

/datum/action/cooldown/bloodsucker/recuperate/DeactivatePower()
	owner?.balloon_alert(owner, "recuperate turned off.")
	return ..()

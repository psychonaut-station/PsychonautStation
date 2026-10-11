/datum/action/cooldown/bloodsucker/veil
	name = "Veil of Many Faces"
	desc = "Disguise yourself in the illusion of another identity."
	button_icon_state = "power_veil"
	power_explanation = "Veil of Many Faces: \n\
		Activating Veil of Many Faces will shroud you in smoke and forge you a new identity.\n\
		Your name and appearance will be completely randomized, and turning the ability off again will undo it all.\n\
		Clothes, gear, and Security/Medical HUD status is kept the same while this power is active."
	power_flags = BP_AM_TOGGLE
	check_flags = BP_CANT_USE_IN_FRENZY | BP_CANT_USE_DURING_SOL
	purchase_flags = BLOODSUCKER_DEFAULT_POWER | VASSAL_CAN_BUY
	can_level = FALSE
	bloodcost = 15
	constant_bloodcost = 0.1
	cooldown_time = 10 SECONDS
	/// A reference to a COPY of the DNA of the mob prior to transformation.
	var/datum/dna/old_dna

/datum/action/cooldown/bloodsucker/veil/ActivatePower(trigger_flags)
	. = ..()
	cast_effect()
	veil_user()
	owner.balloon_alert(owner, "veil turned on.")

/datum/action/cooldown/bloodsucker/veil/proc/veil_user()
	var/mob/living/carbon/human/user = owner
	to_chat(owner, span_warning("You mystify the air around your person. Your identity is now altered."))
	src.old_dna = new()
	user.dna.copy_dna(old_dna)
	randomize_human_normie(user)

/datum/action/cooldown/bloodsucker/veil/DeactivatePower()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/user = owner

	if(!QDELING(owner)) // Don't really need to do appearance stuff if we're being deleted
		old_dna.copy_dna(user.dna)
		user.updateappearance(mutcolor_update = TRUE)
		user.domutcheck()

	user.real_name = old_dna.real_name // Name is fine though
	user.name = user.get_visible_name()

	cast_effect() // POOF
	owner.balloon_alert(owner, "veil turned off.")


// CAST EFFECT // General effect (poof, splat, etc) when you cast. Doesn't happen automatically!
/datum/action/cooldown/bloodsucker/veil/proc/cast_effect()
	// Effect
	playsound(get_turf(owner), 'sound/effects/magic/smoke.ogg', 20, 1)
	var/datum/effect_system/basic/steam_spread/puff = new(get_turf(owner), 3, FALSE)
	puff.start()
	owner.spin(8, 1) //Spin around like a loon.

/datum/ai_project/cyborg_management_basic
	name = "Cyborg Management Basics"
	description = "Prerequisite theory for remote cyborg recovery and recovery signaling."
	research_cost = 2500
	can_be_run = FALSE
	category = AI_PROJECT_CYBORG

/datum/ai_project/cyborg_management_unlock
	name = "Cyborg Management - Unlock"
	description = "Adds a rechargeable one-time signal that unlocks a connected cyborg."
	research_cost = 2500
	research_requirements_text = "Cyborg Management Basics"
	research_requirements = list(/datum/ai_project/cyborg_management_basic)
	category = AI_PROJECT_CYBORG
	can_be_run = FALSE
	ability_path = /datum/action/innate/ai/ranged/remote_unlock
	ability_recharge_cost = 2500

/datum/ai_project/cyborg_management_unlock/finish()
	add_ability(ability_path)

/datum/action/innate/ai/ranged/remote_unlock
	name = "Unlock Cyborg"
	desc = "Unlock an active connected cyborg."
	button_icon_state = "flightsuit_lock"
	uses = 1
	delete_on_empty = FALSE
	enable_text = span_notice("You mimic a robotics console unlock packet. Click a connected cyborg to release its lockdown.")
	disable_text = span_notice("You abort the unlock packet.")

/datum/action/innate/ai/ranged/remote_unlock/do_ability(mob/living/clicker, atom/clicked_on)
	if(!isAI(clicker) || !iscyborg(clicked_on))
		to_chat(owner, span_warning("You can only unlock connected cyborgs."))
		return FALSE

	var/mob/living/silicon/robot/cyborg = clicked_on
	var/mob/living/silicon/ai/ai_owner = clicker
	if(cyborg.stat == DEAD)
		to_chat(ai_owner, span_warning("You cannot unlock dead cyborgs."))
		return FALSE
	if(!(cyborg in ai_owner.connected_robots))
		to_chat(ai_owner, span_warning("You can only unlock cyborgs connected to you."))
		return FALSE
	if(!cyborg.lockcharge)
		to_chat(ai_owner, span_warning("[cyborg] is not currently locked down."))
		return FALSE

	unset_ranged_ability(ai_owner)
	adjust_uses(-1)
	cyborg.SetLockdown(FALSE)
	playsound(cyborg, 'sound/machines/ping.ogg', 50, FALSE)
	cyborg.audible_message(span_warning("Beeping sounds emit from [cyborg]."))
	return TRUE

/datum/ai_project/cyborg_management_reset
	name = "Cyborg Management - Reset"
	description = "Adds a rechargeable remote reset for a connected cyborg's current module loadout."
	research_cost = 2500
	research_requirements_text = "Cyborg Management Basics"
	research_requirements = list(/datum/ai_project/cyborg_management_basic)
	category = AI_PROJECT_CYBORG
	can_be_run = FALSE
	ability_path = /datum/action/innate/ai/ranged/remote_reset
	ability_recharge_cost = 2500

/datum/ai_project/cyborg_management_reset/finish()
	add_ability(ability_path)

/datum/action/innate/ai/ranged/remote_reset
	name = "Reset Cyborg Module"
	desc = "Triggers a module rebuild on an active connected cyborg."
	button_icon = 'icons/mob/actions/actions_revenant.dmi'
	button_icon_state = "malfunction"
	uses = 1
	delete_on_empty = FALSE
	enable_text = span_notice("You prepare a remote cyborg module reset packet.")
	disable_text = span_notice("You abort the module reset packet.")

/datum/action/innate/ai/ranged/remote_reset/do_ability(mob/living/clicker, atom/clicked_on)
	if(!isAI(clicker) || !iscyborg(clicked_on))
		to_chat(owner, span_warning("You can only reset connected cyborgs."))
		return FALSE

	var/mob/living/silicon/robot/cyborg = clicked_on
	var/mob/living/silicon/ai/ai_owner = clicker
	if(cyborg.stat == DEAD)
		to_chat(ai_owner, span_warning("You cannot reset dead cyborgs."))
		return FALSE
	if(!(cyborg in ai_owner.connected_robots))
		to_chat(ai_owner, span_warning("You can only reset cyborgs connected to you."))
		return FALSE
	if(!cyborg.model)
		to_chat(ai_owner, span_warning("[cyborg] has not selected a module yet."))
		return FALSE

	unset_ranged_ability(ai_owner)
	adjust_uses(-1)
	cyborg.model.transform_to(cyborg.model.type, forced = TRUE, transform = FALSE)
	playsound(cyborg, 'sound/machines/ping.ogg', 50, FALSE)
	cyborg.audible_message(span_warning("A diagnostic reset chime rings out from [cyborg]."))
	return TRUE

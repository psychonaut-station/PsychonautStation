/**
 *	# Assigning Sol
 *
 *	Sol is the sunlight, during this period, all Bloodsuckers must be in their coffin, else they burn.
 */

/// Start Sol, called when someone is assigned Bloodsucker
/datum/antagonist/bloodsucker/proc/check_start_sunlight()
	var/list/existing_suckers = get_antag_minds(/datum/antagonist/bloodsucker) - owner
	if(!length(existing_suckers))
		message_admins("New Sol has been created due to Bloodsucker assignment.")
		SSsunlight.can_fire = TRUE

/// End Sol, if you're the last Bloodsucker
/datum/antagonist/bloodsucker/proc/check_cancel_sunlight()
	var/list/existing_suckers = get_antag_minds(/datum/antagonist/bloodsucker) - owner
	if(!length(existing_suckers))
		message_admins("Sol has been deleted due to the lack of Bloodsuckers")
		SSsunlight.can_fire = FALSE

///Ranks the Bloodsucker up, called by Sol.
/datum/antagonist/bloodsucker/proc/sol_rank_up(atom/source)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(RankUp))

///Called when Sol is near starting.
/datum/antagonist/bloodsucker/proc/sol_near_start(atom/source)
	SIGNAL_HANDLER
	if(bloodsucker_lair_area && !(locate(/datum/action/cooldown/bloodsucker/gohome) in powers))
		BuyPower(new /datum/action/cooldown/bloodsucker/gohome)

///Called when Sol first ends.
/datum/antagonist/bloodsucker/proc/on_sol_end(atom/source)
	SIGNAL_HANDLER
	check_end_torpor()
	for(var/datum/action/cooldown/bloodsucker/gohome/power in powers)
		RemovePower(power)

/// Cycle through all vamp antags and check if they're inside a closet.
/datum/antagonist/bloodsucker/proc/handle_sol()
	SIGNAL_HANDLER
	if(!owner?.current)
		return
	var/mob/living/carbon/user = owner.current

	var/in_coffin = FALSE
	var/in_locker = FALSE
	if(istype(user.loc, /obj/structure/closet/crate/coffin))
		var/obj/structure/closet/crate/coffin/coffin_loc = user.loc
		if(!coffin_loc.opened)
			in_coffin = TRUE
	else if(istype(user.loc, /obj/structure/closet))
		var/obj/structure/closet/closet_loc = user.loc
		if(!closet_loc.opened)
			in_locker = TRUE

	// 1. In a Coffin: All ranks are completely safe and sheltered from sunlight
	if(in_coffin)
		user.remove_status_effect(/datum/status_effect/bloodsucker_sol)
		if(user.am_staked() && COOLDOWN_FINISHED(src, bloodsucker_spam_sol_burn))
			to_chat(user, span_userdanger("You are staked! Remove the offending weapon from your heart before sleeping."))
			COOLDOWN_START(src, bloodsucker_spam_sol_burn, BLOODSUCKER_SPAM_SOL)
		if(!is_in_torpor() && user.stat != DEAD)
			check_begin_torpor(TRUE)
			user.add_mood_event("vampsleep", /datum/mood_event/coffinsleep)
		return

	// 2. Dead in sunlight: Disintegrates into dust
	// Fledgling corpses (Rank 0-1) inside closed lockers are shielded; all others turn to dust immediately
	if(user.stat == DEAD)
		if(in_locker && bloodsucker_level <= 1)
			return
		to_chat(user, span_userdanger("The morning sun completely incinerates your dead form into dust!"))
		final_death(dusted = TRUE)
		return

	// 3. Exposed to Sol outside coffin: Apply solar debuff
	user.apply_status_effect(/datum/status_effect/bloodsucker_sol)

	// 4. Locker survival check: Rank 0 and 1 can survive in a closed locker
	if(in_locker && bloodsucker_level <= 1)
		if(COOLDOWN_FINISHED(src, bloodsucker_spam_sol_burn))
			COOLDOWN_START(src, bloodsucker_spam_sol_burn, 10 SECONDS)
			to_chat(user, span_notice("The dark locker barely shields your fledgling form from the deadly solar flares outside."))
		return

	// 5. Calculate burn damage: Higher ranks take more damage!
	var/burn_damage = 0
	if(in_locker)
		// Higher ranks take burn damage even inside lockers
		burn_damage = 5 * bloodsucker_level
		if(COOLDOWN_FINISHED(src, bloodsucker_spam_sol_burn))
			COOLDOWN_START(src, bloodsucker_spam_sol_burn, 6 SECONDS)
			to_chat(user, span_userdanger("The thin locker fails to block the solar radiation! Your ancient blood boils from within!"))
	else
		// Open sunlight exposure: scaling burn damage, fire, and smoke
		burn_damage = 10 + (bloodsucker_level * 5)
		user.adjust_fire_stacks(1)
		user.ignite_mob()
		new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(user))
		playsound(user, 'sound/effects/fire_puff.ogg', 40, TRUE)
		if(COOLDOWN_FINISHED(src, bloodsucker_spam_sol_burn))
			COOLDOWN_START(src, bloodsucker_spam_sol_burn, 6 SECONDS)
			to_chat(user, span_userdanger("The morning sun scorches your unholy flesh! Seek shelter in a coffin immediately!"))
			user.visible_message(span_danger("[user]'s flesh sizzles and bursts into flames under the blinding sunlight!"))

	user.apply_damage(burn_damage, BURN)

	// 6. If killed by sunlight / fire damage fatal: Turn into dust
	if(user.stat == DEAD || user.get_fire_loss() >= (user.maxHealth * 2))
		to_chat(user, span_userdanger("The relentless morning sun incinerates your soul and body into dust!"))
		final_death(dusted = TRUE)

/datum/antagonist/bloodsucker/proc/give_warning(atom/source, danger_level, vampire_warning_message, vassal_warning_message)
	SIGNAL_HANDLER
	if(!owner || !owner.current)
		return
	to_chat(owner, vampire_warning_message)

	switch(danger_level)
		if(DANGER_LEVEL_FIRST_WARNING)
			owner.current.playsound_local(null, 'sound/bloodsuckers/griffin_3.ogg', vol = 50, vary = TRUE)
		if(DANGER_LEVEL_SECOND_WARNING)
			owner.current.playsound_local(null, 'sound/bloodsuckers/griffin_5.ogg', vol = 50, vary = TRUE)
		if(DANGER_LEVEL_THIRD_WARNING)
			owner.current.playsound_local(null, 'sound/effects/alert.ogg', vol = 75, vary = TRUE)
		if(DANGER_LEVEL_SOL_ROSE)
			owner.current.playsound_local(null, 'sound/ambience/misc/ambimystery.ogg', vol = 75, vary = TRUE)
		if(DANGER_LEVEL_SOL_ENDED)
			owner.current.playsound_local(null, 'sound/ambience/weather/ashstorm/outside/weak_end.ogg', vol = 90, vary = TRUE)

/**
 * # Torpor
 *
 * Torpor is what deals with the Bloodsucker falling asleep, their healing, the effects, ect.
 * This is basically what Sol is meant to do to them, but they can also trigger it manually if they wish to heal, as Burn is only healed through Torpor.
 * You cannot manually exit Torpor, it is instead entered/exited by:
 *
 * Torpor is triggered by:
 * - Being in a Coffin while Sol is on, dealt with by Sol
 * - Entering a Coffin with more than 10 combined Brute/Burn damage, dealt with by /closet/crate/coffin/close() [bloodsucker_coffin.dm]
 * - Death, dealt with by /handle_death()
 * Torpor is ended by:
 * - Having less than 10 Brute damage while OUTSIDE of your Coffin while it isnt Sol.
 * - Having less than 10 Brute & Burn Combined while INSIDE of your Coffin while it isnt Sol.
 * - Sol being over, dealt with by /sunlight/process() [bloodsucker_daylight.dm]
*/
/datum/antagonist/bloodsucker/proc/check_begin_torpor(SkipChecks = FALSE)
	/// Are we entering Torpor via Sol/Death? Then entering it isnt optional!
	if(SkipChecks)
		torpor_begin()
		return
	var/mob/living/carbon/user = owner.current
	var/total_brute = user.getBruteLoss_nonProsthetic()
	var/total_burn = user.getFireLoss_nonProsthetic()
	var/total_damage = total_brute + total_burn
	/// Checks - Not daylight & Has more than 10 Brute/Burn & not already in Torpor
	if(!SSsunlight.sunlight_active && (total_damage >= 10 && !is_in_torpor()))
		torpor_begin()

/datum/antagonist/bloodsucker/proc/check_end_torpor()
	var/mob/living/carbon/user = owner.current
	var/total_brute = user.getBruteLoss_nonProsthetic()
	var/total_burn = user.getFireLoss_nonProsthetic()
	var/total_damage = total_brute + total_burn
	if(total_burn >= 199)
		return FALSE
	if(SSsunlight.sunlight_active)
		return FALSE
	// You are in a Coffin, so instead we'll check TOTAL damage, here.
	if(istype(user.loc, /obj/structure/closet/crate/coffin))
		if(total_damage <= 10)
			torpor_end()
	else
		if(total_brute <= 10)
			torpor_end()

/datum/antagonist/bloodsucker/proc/is_in_torpor()
	if(QDELETED(owner.current))
		return FALSE
	return HAS_TRAIT_FROM(owner.current, TRAIT_NODEATH, TORPOR_TRAIT)

/datum/antagonist/bloodsucker/proc/torpor_begin()
	to_chat(owner.current, span_notice("You enter the horrible slumber of deathless Torpor. You will heal until you are renewed."))
	// Force them to go to sleep
	REMOVE_TRAIT(owner.current, TRAIT_SLEEPIMMUNE, BLOODSUCKER_TRAIT)
	// Without this, you'll just keep dying while you recover.
	owner.current.add_traits(torpor_traits, TORPOR_TRAIT)
	owner.current.set_timed_status_effect(0 SECONDS, /datum/status_effect/jitter, only_if_higher = TRUE)
	// Disable ALL Powers
	DisableAllPowers()

/datum/antagonist/bloodsucker/proc/torpor_end()
	owner.current.remove_status_effect(/datum/status_effect/bloodsucker_sol)
	owner.current.grab_ghost()
	to_chat(owner.current, span_warning("You have recovered from Torpor."))
	owner.current.remove_traits(torpor_traits, TORPOR_TRAIT)
	if(!HAS_TRAIT(owner.current, TRAIT_MASQUERADE))
		ADD_TRAIT(owner.current, TRAIT_SLEEPIMMUNE, BLOODSUCKER_TRAIT)
	heal_vampire_organs()
	owner.current.update_stat()
	SEND_SIGNAL(src, BLOODSUCKER_EXIT_TORPOR)

/datum/status_effect/bloodsucker_sol
	id = "bloodsucker_sol"
	tick_interval = -1
	alert_type = /atom/movable/screen/alert/status_effect/bloodsucker_sol
	var/list/datum/action/cooldown/bloodsucker/burdened_actions
	var/static/list/sol_traits = list(
		TRAIT_EASILY_WOUNDED,
	)

/datum/status_effect/bloodsucker_sol/on_apply()
	if(!SSsunlight.sunlight_active || istype(owner.loc, /obj/structure/closet/crate/coffin))
		return FALSE
	RegisterSignal(SSsunlight, COMSIG_SOL_END, PROC_REF(on_sol_end))
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(on_owner_moved))
	owner.add_traits(sol_traits, id)
	owner.remove_filter(id)
	owner.add_filter(id, 2, drop_shadow_filter(x = 0, y = 0, size = 3, offset = 1.5, color = "#ee7440"))
	owner.add_movespeed_modifier(/datum/movespeed_modifier/bloodsucker_sol)
	owner.add_actionspeed_modifier(/datum/actionspeed_modifier/bloodsucker_sol)
	to_chat(owner, span_userdanger("Sol has risen! Your powers are suppressed, your body is burdened, and you will not heal outside of a coffin!"), type = MESSAGE_TYPE_INFO)
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		MODIFY_PHYSIOLOGY(human_owner, BURN, 1.5)
	for(var/datum/action/cooldown/bloodsucker/power in owner.actions)
		if(power.sol_multiplier)
			power.bloodcost *= power.sol_multiplier
			power.constant_bloodcost *= power.sol_multiplier
			if(power.active)
				to_chat(owner, span_warning("[power.name] is harder to upkeep during Sol, now requiring [power.constant_bloodcost] blood while the solar flares last!"), type = MESSAGE_TYPE_INFO)
			LAZYSET(burdened_actions, power, TRUE)
		power.update_desc(rebuild = FALSE)
		power.build_all_button_icons(UPDATE_BUTTON_NAME | UPDATE_BUTTON_STATUS)
	return TRUE

/datum/status_effect/bloodsucker_sol/on_remove()
	UnregisterSignal(SSsunlight, COMSIG_SOL_END)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	owner.remove_traits(sol_traits, id)
	owner.remove_filter(id)
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/bloodsucker_sol)
	owner.remove_actionspeed_modifier(/datum/actionspeed_modifier/bloodsucker_sol)
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		MODIFY_PHYSIOLOGY(human_owner, BURN, 1 / 1.5)
	for(var/datum/action/cooldown/bloodsucker/power in owner.actions)
		if(LAZYACCESS(burdened_actions, power))
			power.bloodcost /= power.sol_multiplier
			power.constant_bloodcost /= power.sol_multiplier
		power.update_desc(rebuild = FALSE)
		power.build_all_button_icons(UPDATE_BUTTON_NAME | UPDATE_BUTTON_STATUS)
	LAZYNULL(burdened_actions)

/datum/status_effect/bloodsucker_sol/get_examine_text()
	return span_warning("[owner.p_They()] seem[owner.p_s()] sickly and painfully overburned!")

/datum/status_effect/bloodsucker_sol/proc/on_sol_end()
	SIGNAL_HANDLER
	if(!QDELING(src))
		to_chat(owner, span_big(span_boldnotice("Sol has ended, your vampiric powers are no longer strained!")), type = MESSAGE_TYPE_INFO)
		qdel(src)

/datum/status_effect/bloodsucker_sol/proc/on_owner_moved()
	SIGNAL_HANDLER
	if(istype(owner.loc, /obj/structure/closet/crate/coffin))
		qdel(src)

/atom/movable/screen/alert/status_effect/bloodsucker_sol
	name = "Solar Flares"
	desc = "Solar flares bombard the station, heavily weakening your vampiric abilities and burdening your body!\nSleep in a coffin to avoid the effects of the solar flare!"
	icon = 'icons/bloodsuckers/actions_bloodsucker.dmi'
	icon_state = "sol_alert"

/datum/actionspeed_modifier/bloodsucker_sol
	multiplicative_slowdown = 1
	id = "bloodsucker_sol_actionspeed"

/datum/movespeed_modifier/bloodsucker_sol
	multiplicative_slowdown = 0.45
	id = "bloodsucker_sol_movementspeed"

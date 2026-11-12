/datum/antagonist/bloodsucker/proc/on_examine(datum/source, mob/examiner, examine_text)
	SIGNAL_HANDLER

	if(!iscarbon(source))
		return
	var/vamp_examine = return_vamp_examine(examiner)
	if(vamp_examine)
		examine_text += vamp_examine

///Called when a Bloodsucker buys a power: (power)
/datum/antagonist/bloodsucker/proc/BuyPower(datum/action/cooldown/bloodsucker/power)
	for(var/datum/action/cooldown/bloodsucker/current_powers as anything in powers)
		if(current_powers.type == power.type)
			return FALSE
	powers += power
	power.Grant(owner.current)
	log_uplink("[key_name(owner.current)] purchased [power].")
	return TRUE

///Called when a Bloodsucker loses a power: (power)
/datum/antagonist/bloodsucker/proc/RemovePower(datum/action/cooldown/bloodsucker/power)
	if(power.active)
		power.DeactivatePower()
	powers -= power
	power.Remove(owner.current)
	qdel(power)

///When a Bloodsucker breaks the Masquerade, they get their HUD icon changed, and Malkavian Bloodsuckers get alerted.
/datum/antagonist/bloodsucker/proc/break_masquerade(mob/admin)
	if(broke_masquerade)
		return
	owner.current.playsound_local(null, 'sound/bloodsuckers/lunge_warn.ogg', 100, FALSE, pressure_affected = FALSE)
	to_chat(owner.current, span_cult_bold_italic("You have broken the Masquerade!"))
	to_chat(owner.current, span_warning("Bloodsucker Tip: When you break the Masquerade, you become open for termination by fellow Bloodsuckers, and your Vassals are no longer completely loyal to you, as other Bloodsuckers can steal them for themselves!"))
	broke_masquerade = TRUE
	antag_hud_name = "masquerade_broken"
	add_team_hud(owner.current)

///This is admin-only of reverting a broken masquerade, sadly it doesn't remove the Malkavian objectives yet.
/datum/antagonist/bloodsucker/proc/fix_masquerade(mob/admin)
	if(!broke_masquerade)
		return
	to_chat(owner.current, span_cult_bold_italic("You have re-entered the Masquerade."))
	broke_masquerade = FALSE
	masquerade_infractions = 0
	antag_hud_name = "bloodsucker"
	add_team_hud(owner.current)

/datum/antagonist/bloodsucker/proc/give_masquerade_infraction()
	if(broke_masquerade)
		return
	masquerade_infractions++
	if(masquerade_infractions >= 3)
		break_masquerade()
	else
		to_chat(owner.current, span_cult_bold("You violated the Masquerade! Break the Masquerade [3 - masquerade_infractions] more times and you will become a criminal to the Bloodsucker's Cause!"))

/datum/antagonist/bloodsucker/proc/RankUp()
	if(!owner || !owner.current || IS_FAVORITE_VASSAL(owner.current))
		return
	bloodsucker_level_unspent++
	update_hud()
	to_chat(owner, span_notice("<EM>You have grown more ancient! Awaken from your coffin to thicken your blood and embrace new power.</EM>"))
	if(bloodsucker_level_unspent >= 2 && !istype(owner.current.loc, /obj/structure/closet/crate/coffin))
		to_chat(owner, span_announce("Bloodsucker Tip: If you cannot find or steal a coffin to use, you can build one from wood or metal."))

/datum/antagonist/bloodsucker/proc/RankDown()
	if(bloodsucker_level_unspent <= 0)
		return FALSE
	bloodsucker_level_unspent--
	update_hud()
	return TRUE

/datum/antagonist/bloodsucker/proc/remove_nondefault_powers(return_levels = FALSE)
	for(var/datum/action/cooldown/bloodsucker/power as anything in powers.Copy())
		if(power.purchase_flags & BLOODSUCKER_DEFAULT_POWER)
			continue
		RemovePower(power)
		if(return_levels)
			bloodsucker_level_unspent++

/datum/antagonist/bloodsucker/proc/LevelUpPowers()
	for(var/datum/action/cooldown/bloodsucker/power as anything in powers)
		power.upgrade_power()

/datum/antagonist/bloodsucker/proc/DowngradePowers()
	for(var/datum/action/cooldown/bloodsucker/power as anything in powers)
		power.downgrade_power()

/datum/antagonist/bloodsucker/proc/DemoteRank()
	if(!owner || !owner.current)
		return FALSE
	if(bloodsucker_level <= 0)
		return FALSE

	bloodsucker_level--
	bloodsucker_regen_rate = max(initial(bloodsucker_regen_rate), bloodsucker_regen_rate - 0.05)
	max_blood_volume = max(initial(max_blood_volume), max_blood_volume - 100)
	bloodsucker_blood_volume = min(bloodsucker_blood_volume, max_blood_volume)

	if(ishuman(owner.current))
		var/mob/living/carbon/human/human_user = owner.current
		var/obj/item/bodypart/user_left_hand = human_user.get_bodypart(BODY_ZONE_L_ARM)
		var/obj/item/bodypart/user_right_hand = human_user.get_bodypart(BODY_ZONE_R_ARM)
		if(user_left_hand)
			user_left_hand.unarmed_damage_low = max(initial(user_left_hand.unarmed_damage_low) + 1, user_left_hand.unarmed_damage_low - 0.5)
			user_left_hand.unarmed_damage_high = max(initial(user_left_hand.unarmed_damage_high) + 1, user_left_hand.unarmed_damage_high - 0.5)
		if(user_right_hand)
			user_right_hand.unarmed_damage_low = max(initial(user_right_hand.unarmed_damage_low) + 1, user_right_hand.unarmed_damage_low - 0.5)
			user_right_hand.unarmed_damage_high = max(initial(user_right_hand.unarmed_damage_high) + 1, user_right_hand.unarmed_damage_high - 0.5)

	DowngradePowers()

	var/list/bought_powers = list()
	for(var/datum/action/cooldown/bloodsucker/power as anything in powers)
		if((power.purchase_flags & BLOODSUCKER_CAN_BUY) && !(power.purchase_flags & BLOODSUCKER_DEFAULT_POWER))
			bought_powers += power
	if(length(bought_powers) > bloodsucker_level)
		var/datum/action/cooldown/bloodsucker/latest_power = bought_powers[length(bought_powers)]
		RemovePower(latest_power)

	var/list/favorite_vassals = special_vassals?[FAVORITE_VASSAL]
	for(var/datum/antagonist/vassal/favorite/fav_vassal as anything in favorite_vassals)
		fav_vassal.set_vassal_level()

	update_hud()
	return TRUE

///Disables all powers, accounting for torpor
/datum/antagonist/bloodsucker/proc/DisableAllPowers(forced = FALSE)
	for(var/datum/action/cooldown/bloodsucker/power as anything in powers)
		if(forced || ((power.check_flags & BP_CANT_USE_IN_TORPOR) && is_in_torpor()))
			if(power.active)
				power.DeactivatePower()

/datum/antagonist/bloodsucker/proc/SpendRank(mob/living/carbon/human/target, cost_rank = TRUE, blood_cost)
	if(!owner || !owner.current || !owner.current.client || (cost_rank && bloodsucker_level_unspent <= 0))
		return
	INVOKE_ASYNC(src, PROC_REF(spend_rank), target, cost_rank, blood_cost)

/datum/antagonist/bloodsucker/proc/spend_rank(mob/living/carbon/target, cost_rank = TRUE, blood_cost)
	var/list/options = list()
	var/list/radial_display = list()
	for(var/datum/action/cooldown/bloodsucker/power as anything in all_bloodsucker_powers)
		if((initial(power.purchase_flags) & BLOODSUCKER_CAN_BUY) && !(locate(power) in powers))
			options[initial(power.name)] = power
			var/datum/radial_menu_choice/option = new
			option.image = image(icon = initial(power.button_icon), icon_state = initial(power.button_icon_state))
			option.info = "[initial(power.name)] - [span_boldnotice(initial(power.desc))]"
			radial_display[initial(power.name)] = option

	var/is_mastery = FALSE
	if(!length(options))
		is_mastery = TRUE
		var/datum/radial_menu_choice/option = new
		option.image = image(icon = 'icons/bloodsuckers/actions_bloodsucker.dmi', icon_state = "power_feed")
		option.info = "Ancient Mastery - [span_boldnotice("All gifts mastered. Deepen your ancient blood to advance your Rank, enhancing all existing powers and vitality.")]"
		radial_display["Ancient Mastery"] = option
		options["Ancient Mastery"] = TRUE

	to_chat(owner.current, span_notice("As you awaken from your slumber, your ancient blood thickens. Select a gift to advance your Rank."))
	var/choice = show_radial_menu(owner.current, owner.current, radial_display)
	if(QDELETED(src) || !owner || !owner.current || QDELETED(owner.current))
		return
	if(cost_rank && bloodsucker_level_unspent <= 0)
		return
	if(!choice || !options[choice])
		to_chat(owner.current, span_notice("You hold back the surge of ancient blood for now, but you may embrace it when you next awaken."))
		return

	if(is_mastery)
		owner.current.balloon_alert(owner.current, "bloodline deepened!")
		to_chat(owner.current, span_notice("Having mastered all gifts, your ancient blood thickens, empowering your existing abilities!"))
	else
		if(locate(options[choice]) in powers)
			to_chat(owner.current, span_notice("You already possess this gift."))
			return

		var/datum/action/cooldown/bloodsucker/purchased_power = options[choice]
		var/datum/action/cooldown/bloodsucker/new_power = new purchased_power
		if(!BuyPower(new_power))
			qdel(new_power)
			to_chat(owner.current, span_warning("Failed to unlock [choice]. Please try again."))
			return
		owner.current.balloon_alert(owner.current, "learned [choice]!")
		to_chat(owner.current, span_notice("You have unlocked the gift of [choice]!"))

	finalize_spend_rank(cost_rank, blood_cost, target)

/datum/antagonist/bloodsucker/proc/finalize_spend_rank(cost_rank = TRUE, blood_cost, mob/living/carbon/target)
	LevelUpPowers()
	bloodsucker_regen_rate += 0.05
	max_blood_volume += 100

	if(ishuman(owner.current))
		var/mob/living/carbon/human/human_user = owner.current
		var/obj/item/bodypart/user_left_hand = human_user.get_bodypart(BODY_ZONE_L_ARM)
		var/obj/item/bodypart/user_right_hand = human_user.get_bodypart(BODY_ZONE_R_ARM)
		if(user_left_hand)
			user_left_hand.unarmed_damage_low += 0.5
			user_left_hand.unarmed_damage_high += 0.5
		if(user_right_hand)
			user_right_hand.unarmed_damage_low += 0.5
			user_right_hand.unarmed_damage_high += 0.5

	// We're almost done - Spend your Rank now.
	bloodsucker_level++
	var/list/favorite_vassals = special_vassals?[FAVORITE_VASSAL]
	for(var/datum/antagonist/vassal/favorite/fav_vassal as anything in favorite_vassals)
		fav_vassal.set_vassal_level()
	if(cost_rank)
		bloodsucker_level_unspent = max(0, bloodsucker_level_unspent - 1)
	if(blood_cost)
		AddBloodVolume(-blood_cost)

	// Ranked up enough to get your true Reputation?
	if(bloodsucker_level == 4)
		SelectReputation(am_fledgling = FALSE, forced = TRUE)

	to_chat(owner.current, span_notice("You are now a rank [bloodsucker_level] Bloodsucker. \
		Your strength, health, feed rate, regen rate, and maximum blood capacity have all increased! \n\
		* Your existing powers have all ranked up as well!"))
	owner.current.playsound_local(null, 'sound/effects/pope_entry.ogg', 25, TRUE, pressure_affected = FALSE)
	update_hud()

	if(cost_rank && bloodsucker_level_unspent > 0)
		INVOKE_ASYNC(src, PROC_REF(spend_rank), target, cost_rank, blood_cost)

/datum/antagonist/bloodsucker/proc/interact_with_vassal(datum/antagonist/vassal/vassaldatum)
	if(vassaldatum.special_type)
		to_chat(owner.current, span_notice("This Vassal was already assigned a special position."))
		return FALSE
	if(!vassaldatum.owner.can_make_special(creator = owner))
		to_chat(owner.current, span_notice("This Vassal is unable to gain a Special rank due to innate features."))
		return FALSE
	if(bloodsucker_blood_volume < 150)
		to_chat(owner.current, span_warning("You need at least 150 blood to elevate a Vassal!"))
		return FALSE

	var/list/options = list()
	var/list/radial_display = list()
	for(var/datum/antagonist/vassal/vassaldatums as anything in subtypesof(/datum/antagonist/vassal))
		if(length(special_vassals[initial(vassaldatums.special_type)]))
			continue
		options[initial(vassaldatums.name)] = vassaldatums

		var/datum/radial_menu_choice/option = new
		option.image = image(icon = initial(vassaldatums.hud_icon), icon_state = initial(vassaldatums.antag_hud_name))
		option.info = "[initial(vassaldatums.name)] - [span_boldnotice(initial(vassaldatums.vassal_description))]"
		radial_display[initial(vassaldatums.name)] = option

	if(!length(options))
		return

	to_chat(owner.current, span_notice("You can change who this Vassal is, who are they to you?"))
	var/vassal_response = show_radial_menu(owner.current, vassaldatum.owner.current, radial_display)
	if(!vassal_response)
		return
	vassal_response = options[vassal_response]
	if(QDELETED(src) || QDELETED(owner.current) || QDELETED(vassaldatum.owner.current))
		return FALSE
	vassaldatum.make_special(vassal_response)
	AddBloodVolume(-150)
	update_hud()
	return TRUE

/datum/antagonist/bloodsucker/proc/on_favorite_vassal(datum/antagonist/vassal/vassaldatum)
	vassaldatum.BuyPower(new /datum/action/cooldown/bloodsucker/targeted/brawn)
	if(istype(vassaldatum, /datum/antagonist/vassal/favorite))
		var/datum/antagonist/vassal/favorite/fav = vassaldatum
		fav.set_vassal_level()

/**
 * Called when a Bloodsucker reaches Final Death
 * Releases all Vassals.
 */
/datum/antagonist/bloodsucker/proc/free_all_vassals()
	for(var/datum/antagonist/vassal/all_vassals as anything in vassals.Copy())
		// Skip over any Bloodsucker Vassals, they're too far gone to have all their stuff taken away from them
		if(all_vassals.owner?.has_antag_datum(/datum/antagonist/bloodsucker))
			all_vassals.owner.current?.remove_status_effect(/datum/status_effect/agent_pinpointer/vassal_edition)
			continue
		all_vassals.owner?.remove_antag_datum(/datum/antagonist/vassal)

/**
 * Returns a Vampire's examine strings.
 * Args:
 * viewer - The person examining.
 */
/datum/antagonist/bloodsucker/proc/return_vamp_examine(mob/living/viewer)
	if(!viewer.mind)
		return FALSE
	// Viewer is Target's Vassal?
	if(viewer.mind.has_antag_datum(/datum/antagonist/vassal) in vassals)
		var/returnString = "\[<span class='warning'><EM>This is your Master!</EM></span>\]"
		var/returnIcon = "[icon2html('icons/bloodsuckers/vampiric.dmi', world, "bloodsucker")]"
		returnString += "\n"
		return returnIcon + returnString
	// Viewer not a Vamp AND not the target's vassal?
	if(!viewer.mind.has_antag_datum((/datum/antagonist/bloodsucker)) && !(viewer in vassals))
		if(!(broke_masquerade))
			return FALSE
	// Default String
	var/returnString = "\[<span class='warning'><EM>[return_full_name()]</EM></span>\]"
	var/returnIcon = "[icon2html('icons/bloodsuckers/vampiric.dmi', world, "bloodsucker")]"

	// In Disguise (Veil)?
	//if (name_override != null)
	//	returnString += "<span class='suicide'> ([real_name] in disguise!) </span>"

	//returnString += "\n"  Don't need spacers. Using . += "" in examine.dm does this on its own.
	return returnIcon + returnString

/**
 * CARBON INTEGRATION
 *
 * All overrides of mob/living and mob/living/carbon
 */
/// Brute
/mob/living/proc/getBruteLoss_nonProsthetic()
	return get_brute_loss()

/mob/living/carbon/getBruteLoss_nonProsthetic()
	if(dna?.species?.inherent_biotypes & MOB_ROBOTIC) // technically it's not a prosthetic if it's a "natural" part of their species
		return get_brute_loss()
	. = 0
	for(var/obj/item/bodypart/chosen_bodypart as anything in bodyparts)
		if(!IS_ORGANIC_LIMB(chosen_bodypart))
			continue
		. += chosen_bodypart.brute_dam

/// Burn
/mob/living/proc/getFireLoss_nonProsthetic()
	return get_fire_loss()

/mob/living/carbon/getFireLoss_nonProsthetic()
	if(dna?.species?.inherent_biotypes & MOB_ROBOTIC) // technically it's not a prosthetic if it's a "natural" part of their species
		return get_fire_loss()
	. = 0
	for(var/obj/item/bodypart/chosen_bodypart as anything in bodyparts)
		if(!IS_ORGANIC_LIMB(chosen_bodypart))
			continue
		. += chosen_bodypart.burn_dam

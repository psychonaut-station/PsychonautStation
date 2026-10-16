//////////////////////
//     BLOODBAG     //
//////////////////////

#define BLOODBAG_GULP_SIZE 5

/// Taken from drinks.dm
/obj/item/reagent_containers/blood/attack(mob/living/victim, mob/living/attacker, params)
	if(!can_drink(victim, attacker))
		return

	if(victim != attacker)
		if(!do_after(victim, 5 SECONDS, attacker))
			return
		attacker.visible_message(
			span_notice("[attacker] forces [victim] to drink from the [src]."),
			span_notice("You put the [src] up to [victim]'s mouth."))
		reagents.trans_to(victim, BLOODBAG_GULP_SIZE, transferred_by = attacker, methods = INGEST)
		playsound(victim.loc, 'sound/items/drink.ogg', 30, 1)
		return TRUE

	while(do_after(victim, 1 SECONDS, timed_action_flags = IGNORE_USER_LOC_CHANGE, extra_checks = CALLBACK(src, PROC_REF(can_drink), victim, attacker)))
		victim.visible_message(
			span_notice("[victim] puts the [src] up to their mouth."),
			span_notice("You take a sip from the [src]."),
		)
		reagents.trans_to(victim, BLOODBAG_GULP_SIZE, transferred_by = attacker, methods = INGEST)
		playsound(victim.loc, 'sound/items/drink.ogg', 30, 1)
	return TRUE

#undef BLOODBAG_GULP_SIZE

/obj/item/reagent_containers/blood/proc/can_drink(mob/living/victim, mob/living/attacker)
	if(!canconsume(victim, attacker))
		return FALSE
	if(!reagents || !reagents.total_volume)
		to_chat(victim, span_warning("[src] is empty!"))
		return FALSE
	return TRUE

//////////////////////
//      STAKES      //
//////////////////////
/obj/item/stack/sheet/mineral/wood/attackby(obj/item/item, mob/user, params)
	if(!item.get_sharpness())
		return ..()
	user.visible_message(
		span_notice("[user] begins whittling [src] into a pointy object."),
		span_notice("You begin whittling [src] into a sharp point at one end."),
		span_hear("You hear wood carving."),
	)
	// 5 Second Timer
	if(!do_after(user, 5 SECONDS, src, NONE, TRUE))
		return
	// Make Stake
	var/obj/item/stake/new_item = new(user.loc)
	user.visible_message(
		span_notice("[user] finishes carving a stake out of [src]."),
		span_notice("You finish carving a stake out of [src]."),
	)
	// Prepare to Put in Hands (if holding wood)
	var/obj/item/stack/sheet/mineral/wood/wood_stack = src
	var/replace = (user.get_inactive_held_item() == wood_stack)
	// Use Wood
	wood_stack.use(1)
	// If stack depleted, put item in that hand (if it had one)
	if(!wood_stack && replace)
		user.put_in_hands(new_item)

/// Do I have a stake in my heart?
/mob/living/proc/am_staked()
	var/obj/item/bodypart/chosen_bodypart = get_bodypart(BODY_ZONE_CHEST)
	if(!chosen_bodypart)
		return FALSE
	for(var/obj/item/embedded_stake in chosen_bodypart.embedded_objects)
		if(istype(embedded_stake, /obj/item/stake))
			return TRUE
	return FALSE

/// You can't go to sleep in a coffin with a stake in you.
/mob/living/proc/StakeCanKillMe()
	if(IsSleeping())
		return TRUE
	if(stat >= UNCONSCIOUS)
		return TRUE
	if(HAS_TRAIT_FROM(src, TRAIT_NODEATH, TORPOR_TRAIT))
		return TRUE
	return FALSE

/obj/item/stake
	name = "wooden stake"
	desc = "A simple wooden stake carved to a sharp point."
	icon = 'icons/bloodsuckers/stakes.dmi'
	icon_state = "wood"
	inhand_icon_state = "wood"
	lefthand_file = 'icons/bloodsuckers/bs_leftinhand.dmi'
	righthand_file = 'icons/bloodsuckers/bs_rightinhand.dmi'
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	attack_verb_continuous = list("staked", "stabbed", "tore into")
	attack_verb_simple = list("staked", "stabbed", "tore into")
	sharpness = SHARP_EDGED
	embed_type = /datum/embedding/wooden_stake
	force = 6
	throwforce = 10
	max_integrity = 30

	///Time it takes to embed the stake into someone's chest.
	var/staketime = 12 SECONDS

/datum/embedding/wooden_stake
	embed_chance = 20

/obj/item/stake/attack(mob/living/target, mob/living/user, params)
	. = ..()
	if(.)
		return
	// Invalid Target, or not targetting the chest?
	if(check_zone(user.zone_selected) != BODY_ZONE_CHEST)
		return
	if(target == user)
		return
	if(!target.can_be_staked()) // Oops! Can't.
		to_chat(user, span_danger("You can't stake [target] when they are moving about! They have to be laying down or grabbed by the neck!"))
		return
	if(HAS_TRAIT(target, TRAIT_PIERCEIMMUNE))
		to_chat(user, span_danger("[target]'s chest resists the stake. It won't go in."))
		return

	to_chat(user, span_notice("You put all your weight into embedding the stake into [target]'s chest..."))
	playsound(user, 'sound/effects/magic/Demon_consume.ogg', 50, 1)
	if(!do_after(user, staketime, target, extra_checks = CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon, can_be_staked)))) // user / target / time / uninterruptable / show progress bar / extra checks
		return
	// Drop & Embed Stake
	user.visible_message(
		span_danger("[user.name] drives the [src] into [target]'s chest!"),
		span_danger("You drive the [src] into [target]'s chest!"),
	)
	playsound(get_turf(target), 'sound/effects/splat.ogg', 40, 1)
	if(force_embed(target.get_bodypart(BODY_ZONE_CHEST), TRUE, TRUE)) //and if it embeds successfully in their chest, cause a lot of pain
		target.apply_damage(max(10, force * 1.2), BRUTE, BODY_ZONE_CHEST, wound_bonus = 0, sharpness = TRUE)
	if(QDELETED(src)) // in case trying to embed it caused its deletion (say, if it's DROPDEL)
		return
	if(!target.mind)
		return
	var/datum/antagonist/bloodsucker/bloodsuckerdatum = target.mind.has_antag_datum(/datum/antagonist/bloodsucker)
	if(bloodsuckerdatum)
		// If DEAD or TORPID... Kill Bloodsucker!
		if(target.StakeCanKillMe())
			bloodsuckerdatum.final_death()
		else
			to_chat(target, span_userdanger("You have been staked! Your powers are useless, your death forever, while it remains in place."))
			target.balloon_alert(target, "you have been staked!")

///Can this target be staked? If someone stands up before this is complete, it fails. Best used on someone stationary.
/mob/living/proc/can_be_staked()
	return FALSE

/mob/living/carbon/can_be_staked()
	if(!(mobility_flags & MOBILITY_MOVE))
		return TRUE
	return FALSE

/// Created by welding and acid-treating a simple stake.
/obj/item/stake/hardened
	name = "hardened stake"
	desc = "A wooden stake carved to a sharp point and hardened by fire."
	icon_state = "hardened"
	force = 8
	throwforce = 12
	armour_penetration = 10
	embed_type = /datum/embedding/hardened_stake
	staketime = 80

/datum/embedding/hardened_stake
	embed_chance = 35

/obj/item/stake/hardened/silver
	name = "silver stake"
	desc = "Polished and sharp at the end. For when some mofo is always trying to iceskate uphill."
	icon_state = "silver"
	inhand_icon_state = "silver"
	siemens_coefficient = 1 //flags = CONDUCT // var/siemens_coefficient = 1 // for electrical admittance/conductance (electrocution checks and shit)
	force = 9
	armour_penetration = 25
	embed_type = /datum/embedding/silver_stake
	staketime = 60

/datum/embedding/silver_stake
	embed_chance = 65

////////////////////////////////////////////////////////////////////////////////
//                       BLOODSUCKER ADMIN RELICS                            //
////////////////////////////////////////////////////////////////////////////////

/obj/item/bloodsucker_relic
	gender = NEUTER
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/item/bloodsucker_relic/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(isliving(interacting_with))
		apply_relic(interacting_with, user)
		return ITEM_INTERACT_SUCCESS
	return NONE

/obj/item/bloodsucker_relic/attack_self(mob/living/user)
	apply_relic(user, user)

/obj/item/bloodsucker_relic/proc/apply_relic(mob/living/target, mob/living/user)
	return

// --- RANK ADVANCEMENT ---
/obj/item/bloodsucker_relic/rank_up
	name = "\improper Phylactery of Primordial Vitae"
	desc = "An ancient reliquary of cold-forged obsidian and cursed silver, enclosing a swirling vortex of pitch-black primordial vitae that throbs with an unholy heartbeat. When uncorked in the presence of a Bloodsucker, the progenitor's blood surges hungrily into their veins, violently awakening dormant powers and advancing their Rank."
	icon = 'icons/obj/antags/eldritch.dmi'
	icon_state = "phylactery_2"
	inhand_icon_state = "phylactery"
	light_range = 2
	light_power = 1.5
	light_color = "#990000"

/obj/item/bloodsucker_relic/rank_up/apply_relic(mob/living/target, mob/living/user)
	if(!isliving(target))
		return
	var/datum/antagonist/bloodsucker/vamp = target.mind?.has_antag_datum(/datum/antagonist/bloodsucker)
	if(vamp)
		vamp.RankUp()
		playsound(target, 'sound/effects/magic/demon_consume.ogg', 70, TRUE)
		do_sparks(4, TRUE, target)
		target.visible_message(
			span_danger("[target]'s eyes blaze with baleful crimson fire as [src] floods [target.p_their()] veins with primordial vitae!"),
			span_boldnotice("The ancient blood surges through your dead veins like liquid fire, awakening dormant power and elevating your Rank!")
		)
		user.balloon_alert(user, "rank advanced!")
		log_admin("[key_name_admin(user)] used [src] on [key_name_admin(target)], advancing Bloodsucker rank (now Rank [vamp.bloodsucker_level] with [vamp.bloodsucker_level_unspent] unspent).")
		if(vamp.my_clan)
			INVOKE_ASYNC(vamp, TYPE_PROC_REF(/datum/antagonist/bloodsucker, SpendRank))
		return

	target.visible_message(
		span_warning("[target] convulses violently as the primordial vitae scorches [target.p_their()] mortal veins!"),
		span_userdanger("The primordial vitae burns through your mortal veins like boiling acid!")
	)
	target.adjust_tox_loss(30)
	target.Knockdown(2 SECONDS)
	playsound(target, 'sound/effects/splat.ogg', 40, TRUE)
	user.balloon_alert(user, "rejected by mortal flesh!")

// --- RANK DEGRADATION ---
/obj/item/bloodsucker_relic/rank_down
	name = "\improper Crucible of Sanguine Withering"
	desc = "A suffocating, ashen relic carved from weeping argentum and dusted with the calcified remains of an apostate vampire dynasty. Emitting a hollow, chilling vibration, its touch dissolves the density of supernatural vitae, draining the unholy might from any Bloodsucker and withering them down a Rank."
	icon = 'icons/obj/antags/cult/items.dmi'
	icon_state = "shuttlecurse"
	light_range = 2
	light_power = 1
	light_color = "#440044"

/obj/item/bloodsucker_relic/rank_down/apply_relic(mob/living/target, mob/living/user)
	if(!isliving(target))
		return
	var/datum/antagonist/bloodsucker/vamp = target.mind?.has_antag_datum(/datum/antagonist/bloodsucker)
	if(vamp)
		if(vamp.DemoteRank())
			playsound(target, 'sound/effects/tendril_destroyed.ogg', 70, TRUE)
			new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(target))
			target.visible_message(
				span_danger("[target] gasps in agony as pale vapor hisses from [target.p_their()] pores, [target.p_their()] vampiric essence withering away!"),
				span_userdanger("The consecrated ash chills your core! Your ancient vitae thins and withers, casting you down a Rank! (Now Rank [vamp.bloodsucker_level])")
			)
			user.balloon_alert(user, "rank withered!")
			log_admin("[key_name_admin(user)] used [src] on [key_name_admin(target)], demoting Bloodsucker rank (now Rank [vamp.bloodsucker_level] with [vamp.bloodsucker_level_unspent] unspent).")
		else
			user.balloon_alert(user, "cannot wither further!")
			to_chat(user, span_warning("[target]'s bloodline is already at its baseline fledgling stage and cannot wither further."))
		return

	user.balloon_alert(user, "no effect on mortals")
	to_chat(user, span_notice("The cold ash rests inert against mortal skin."))


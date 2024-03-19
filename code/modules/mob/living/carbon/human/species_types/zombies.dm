/datum/species/zombie
	// 1spooky
	name = "High-Functioning Zombie"
	id = SPECIES_ZOMBIE
	sexes = FALSE
	meat = /obj/item/food/meat/slab/human/mutant/zombie
	mutanttongue = /obj/item/organ/internal/tongue/zombie
	inherent_traits = list(
		// SHARED WITH ALL ZOMBIES
		TRAIT_EASILY_WOUNDED,
		TRAIT_EASYDISMEMBER,
		TRAIT_FAKEDEATH,
		TRAIT_LIMBATTACHMENT,
		TRAIT_LIVERLESS_METABOLISM,
		TRAIT_NOBREATH,
		TRAIT_NODEATH,
		TRAIT_NOHUNGER,
		TRAIT_NO_DNA_COPY,
		TRAIT_NO_ZOMBIFY,
		TRAIT_RADIMMUNE,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_TOXIMMUNE,
		// HIGH FUNCTIONING UNIQUE
		TRAIT_NOBLOOD,
		TRAIT_SUCCUMB_OVERRIDE,
	)
	mutantstomach = null
	mutantheart = null
	mutantliver = null
	mutantlungs = null
	inherent_biotypes = MOB_UNDEAD|MOB_HUMANOID
	inherent_factions = list(FACTION_ZOMBIE)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | ERT_SPAWN
	bodytemp_normal = T0C // They have no natural body heat, the environment regulates body temp
	bodytemp_heat_damage_limit = FIRE_MINIMUM_TEMPERATURE_TO_EXIST // Take damage at fire temp
	bodytemp_cold_damage_limit = MINIMUM_TEMPERATURE_TO_MOVE // take damage below minimum movement temp

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/zombie,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/zombie,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/zombie,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/zombie,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/zombie,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/zombie
	)

	/// Spooky growls we sometimes play while alive
	var/static/list/spooks = list(
		'sound/hallucinations/growl1.ogg',
		'sound/hallucinations/growl2.ogg',
		'sound/hallucinations/growl3.ogg',
		'sound/hallucinations/veryfar_noise.ogg',
		'sound/hallucinations/wail.ogg',
	)

/// Zombies do not stabilize body temperature they are the walking dead and are cold blooded
/datum/species/zombie/body_temperature_core(mob/living/carbon/human/humi, seconds_per_tick, times_fired)
	return

/datum/species/zombie/check_roundstart_eligible()
	if(check_holidays(HALLOWEEN))
		return TRUE
	return ..()

/datum/species/zombie/get_physical_attributes()
	return "Zombies are undead, and thus completely immune to any enviromental hazard, or any physical threat besides blunt force trauma and burns. \
		Their limbs are easy to pop off their joints, but they can somehow just slot them back in."

/datum/species/zombie/get_species_description()
	return "A rotting zombie! They descend upon Space Station Thirteen Every year to spook the crew! \"Sincerely, the Zombies!\""

/datum/species/zombie/get_species_lore()
	return list("Zombies have long lasting beef with Botanists. Their last incident involving a lawn with defensive plants has left them very unhinged.")

// Override for the default temperature perks, so we can establish that they don't care about temperature very much
/datum/species/zombie/create_pref_temperature_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "thermometer-half",
		SPECIES_PERK_NAME = "No Body Temperature",
		SPECIES_PERK_DESC = "Having long since departed, Zombies do not have anything \
			regulating their body temperature anymore. This means that \
			the environment decides their body temperature - which they don't mind at \
			all, until it gets a bit too hot.",
	))

	return to_add

/datum/species/zombie/infectious
	name = "Infectious Zombie"
	id = SPECIES_ZOMBIE_INFECTIOUS
	examine_limb_id = SPECIES_ZOMBIE
	damage_modifier = 20 // 120 damage to KO a zombie, which kills it
	mutanteyes = /obj/item/organ/internal/eyes/zombie
	mutantbrain = /obj/item/organ/internal/brain/zombie
	mutanttongue = /obj/item/organ/internal/tongue/zombie
	changesource_flags = MIRROR_BADMIN | WABBAJACK | ERT_SPAWN

	inherent_traits = list(
		// SHARED WITH ALL ZOMBIES
		TRAIT_EASILY_WOUNDED,
		TRAIT_EASYDISMEMBER,
		TRAIT_FAKEDEATH,
		TRAIT_LIMBATTACHMENT,
		TRAIT_LIVERLESS_METABOLISM,
		TRAIT_NOBREATH,
		TRAIT_NODEATH,
		TRAIT_NOHUNGER,
		TRAIT_NO_DNA_COPY,
		TRAIT_RADIMMUNE,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_TOXIMMUNE,
		// INFECTIOUS UNIQUE
		TRAIT_STABLEHEART, // Replacement for noblood. Infectious zombies can bleed but don't need their heart.
		TRAIT_STABLELIVER, // Not necessary but for consistency with above
	)

	// Infectious zombies have slow legs
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/zombie,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/zombie,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/zombie,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/zombie,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/zombie/infectious,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/zombie/infectious,
	)

/datum/species/zombie/infectious/on_species_gain(mob/living/carbon/human/new_zombie, datum/species/old_species)
	. = ..()
	new_zombie.set_combat_mode(TRUE)

	// Deal with the source of this zombie corruption
	// Infection organ needs to be handled separately from mutant_organs
	// because it persists through species transitions
	var/obj/item/organ/internal/zombie_infection/infection = new_zombie.get_organ_slot(ORGAN_SLOT_ZOMBIE)
	if(isnull(infection))
		infection = new()
		infection.Insert(new_zombie)

	new_zombie.AddComponent( \
		/datum/component/mutant_hands, \
		mutant_hand_path = /obj/item/mutant_hand/zombie, \
	)
	new_zombie.AddComponent( \
		/datum/component/regenerator, \
		regeneration_delay = 6 SECONDS, \
		brute_per_second = 0.5, \
		burn_per_second = 0.5, \
		tox_per_second = 0.5, \
		oxy_per_second = 0.25, \
		heals_wounds = TRUE, \
	)

/datum/species/zombie/infectious/on_species_loss(mob/living/carbon/human/was_zombie, datum/species/new_species, pref_load)
	. = ..()
	qdel(was_zombie.GetComponent(/datum/component/mutant_hands))
	qdel(was_zombie.GetComponent(/datum/component/regenerator))

/datum/species/zombie/infectious/check_roundstart_eligible()
	return FALSE

/datum/species/zombie/infectious/spec_stun(mob/living/carbon/human/H,amount)
	return min(2 SECONDS, amount)

/datum/species/zombie/infectious/spec_life(mob/living/carbon/carbon_mob, seconds_per_tick, times_fired)
	. = ..()
	carbon_mob.set_combat_mode(TRUE) // THE SUFFERING MUST FLOW

	if(!HAS_TRAIT(carbon_mob, TRAIT_CRITICAL_CONDITION) && SPT_PROB(2, seconds_per_tick))
		playsound(carbon_mob, pick(spooks), 50, TRUE, 10)

/datum/species/zombie/infectious/walkers //TWD referance
	ai_controlled_species = TRUE

/datum/species/zombie/infectious/walkers/on_species_gain(mob/living/carbon/human/Z, datum/species/old_species)
	. = ..()
	Z.become_husk(SPECIES_TRAIT)

/datum/species/zombie/infectious/walkers/on_species_loss(mob/living/carbon/human/Z, datum/species/new_species, pref_load)
	. = ..()
	Z.cure_husk(SPECIES_TRAIT)

//miniboss
/datum/species/zombie/infectious/walkers/freak
	damage_modifier = 50 //50% less damage
	/// Dash ability
	var/datum/action/cooldown/mob_cooldown/dash/dash

/datum/species/zombie/infectious/walkers/freak/on_species_gain(mob/living/carbon/human/Z, datum/species/old_species)
	. = ..()
	dash = new
	dash.Grant(Z)
	RegisterSignal(Z, COMSIG_ATOM_EX_ACT, PROC_REF(ex_act))

/datum/species/zombie/infectious/walkers/freak/on_species_loss(mob/living/carbon/human/Z, datum/species/new_species, pref_load)
	. = ..()
	if(dash)
		dash.Remove(Z)
		dash = null
	UnregisterSignal(Z, COMSIG_ATOM_EX_ACT)

/datum/species/zombie/infectious/walkers/freak/proc/ex_act(severity, target)
	SIGNAL_HANDLER
	dash.Trigger(target = target)

// Your skin falls off
/datum/species/human/krokodil_addict
	name = "\improper Krokodil Human"
	id = SPECIES_ZOMBIE_KROKODIL
	examine_limb_id = SPECIES_HUMAN
	changesource_flags = MIRROR_BADMIN | WABBAJACK | ERT_SPAWN
	inherent_factions = list(FACTION_ZOMBIE) // smells like zombie

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/zombie,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/zombie,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/zombie,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/zombie,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/zombie,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/zombie
	)

// Zombie AI
/datum/ai_controller/zombie
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
		BB_TARGET_MINIMUM_STAT = HARD_CRIT,
		BB_REINFORCEMENTS_SAY = "Braainnss..!"
	)

	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/zombie,
	)

/datum/ai_planning_subtree/basic_melee_attack_subtree/zombie
	melee_attack_behavior=/datum/ai_behavior/zombie_attack

/datum/ai_behavior/zombie_attack
	action_cooldown = 0.2 SECONDS // We gotta check unfortunately often because we're in a race condition with nextmove
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	///do we finish this action after hitting once?
	var/terminate_after_action = FALSE

/datum/ai_behavior/zombie_attack/setup(datum/ai_controller/controller, target_key, targeting_strategy_key, hiding_location_key)
	. = ..()
	if(!controller.blackboard[targeting_strategy_key])
		CRASH("No targeting strategy was supplied in the blackboard for [controller.pawn]")
	if(HAS_TRAIT(controller.pawn, TRAIT_HANDS_BLOCKED))
		return FALSE
	//Hiding location is priority
	var/atom/target = controller.blackboard[hiding_location_key] || controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE

	set_movement_target(controller, target)

/datum/ai_behavior/zombie_attack/perform(seconds_per_tick, datum/ai_controller/controller, target_key, targeting_strategy_key, hiding_location_key)
	if (isliving(controller.pawn))
		var/mob/living/pawn = controller.pawn
		if (world.time < pawn.next_move)
			return

	. = ..()
	var/mob/living/carbon/C = controller.pawn
	//targeting strategy will kill the action if not real anymore
	var/atom/target = controller.blackboard[target_key]
	var/datum/targeting_strategy/targeting_strategy = GET_TARGETING_STRATEGY(controller.blackboard[targeting_strategy_key])

	if(!targeting_strategy.can_attack(C, target))
		finish_action(controller, FALSE, target_key)
		return

	var/hiding_target = targeting_strategy.find_hidden_mobs(C, target) //If this is valid, theyre hidden in something!

	controller.set_blackboard_key(hiding_location_key, hiding_target)

	C.set_combat_mode(TRUE)
	if(hiding_target) //Slap it!
		C.ClickOn(hiding_target)
	else
		C.ClickOn(target)

	if(terminate_after_action)
		finish_action(controller, TRUE, target_key)

/datum/ai_behavior/zombie_attack/finish_action(datum/ai_controller/controller, succeeded, target_key, targeting_strategy_key, hiding_location_key)
	. = ..()
	if(!succeeded)
		controller.clear_blackboard_key(target_key)

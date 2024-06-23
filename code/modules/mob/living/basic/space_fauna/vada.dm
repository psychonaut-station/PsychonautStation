/mob/living/basic/vada
	name = "Vada"
	desc = "Vadas are peaceful creatures born from plasma research."
	icon = 'icons/psychonaut/mob/simple/vada.dmi'
	icon_state = "vada"
	icon_living = "vada"
	icon_dead = "vada_dead"
	speak_emote = list("vadee.", "aminake!!",)
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_ORGANIC|MOB_BUG
	obj_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 10
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	butcher_results = list(/obj/item/stack/ore/plasma = 1)
	gold_core_spawnable = FRIENDLY_SPAWN
	faction = list(FACTION_NEUTRAL)
	can_be_held = TRUE
	health = 100
	maxHealth = 100
	light_range = 1.5 // Bioluminescence!
	minimum_survivable_temperature = T20C - 100
	maximum_survivable_temperature = T20C + 120
	light_color = "#d43229" // The ants that comprise the giant ant still glow red despite the sludge.
	death_sound = 'sound/_psychonaut/aminake.ogg'

	ai_controller = /datum/ai_controller/basic_controller/vada

/mob/living/basic/vada/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)
	AddElement(/datum/element/pet_bonus, "clacks happily!")
	AddElement(/datum/element/ai_retaliate)
	AddElement(/datum/element/footstep, FOOTSTEP_MOB_CLAW)

/datum/ai_controller/basic_controller/vada
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
	)

	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/find_nearest_thing_which_attacked_me_to_flee,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/random_speech/vada,
	)

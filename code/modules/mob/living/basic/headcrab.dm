/mob/living/basic/headcrab
	name = "Headcrab"
	desc = "It can hug."
	icon = 'icons/psychonaut/mob/nonhuman-player/headcrab.dmi'
	icon_state = "headcrab"
	icon_living = "headcrab"
	icon_dead = "headcrab_dead"
	health = 10
	maxHealth = 10
	melee_attack_cooldown = 1.5 SECONDS
	melee_damage_lower = 0
	melee_damage_upper = 0
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	combat_mode = FALSE
	faction = list(FACTION_ZOMBIE)
	pressure_resistance = 200
	ai_controller = /datum/ai_controller/basic_controller/headcrab
	var/hctype = /obj/item/organ/external/headcrab/default

/mob/living/basic/headcrab/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(stat == DEAD)
		icon_state = initial(icon_dead)
	else
		icon_state = initial(icon_living)
	if(. || !ishuman(hit_atom))
		return
	var/mob/living/carbon/human/hit_human = hit_atom
	var/obj/item/organ/external/headcrab/hcorgan = new hctype(src)
	hcorgan.hc = src
	forceMove(hcorgan)
	visible_message(span_danger("\The [src] jumps to the [hit_human]s face!"))
	hcorgan.Insert(hit_human)

/mob/living/basic/headcrab/throw_at(atom/target, range, speed, mob/thrower, spin=FALSE, diagonals_first = FALSE, datum/callback/callback, gentle, quickstart = TRUE)
	if(stat != DEAD)
		icon_state = "headcrab_jump"
	return ..(target, range, speed, thrower, FALSE, diagonals_first, callback, quickstart = quickstart)

/datum/ai_controller/basic_controller/headcrab
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
	)

	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/headcrab_jump
	)

/datum/ai_planning_subtree/headcrab_jump
	var/datum/ai_behavior/headcrab_jump/hcjump = /datum/ai_behavior/headcrab_jump

/datum/ai_planning_subtree/headcrab_jump/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	if(!controller.blackboard_key_exists(BB_BASIC_MOB_CURRENT_TARGET))
		return
	controller.queue_behavior(hcjump, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETING_STRATEGY, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
	return SUBTREE_RETURN_FINISH_PLANNING //we are going into battle...no distractions.

/datum/ai_behavior/headcrab_jump
	action_cooldown = 1 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM
	required_distance = 6
	/// range we will try chasing the target before giving up
	var/chase_range = 6
	///do we care about avoiding friendly fire?
	var/avoid_friendly_fire =  TRUE

/datum/ai_behavior/headcrab_jump/setup(datum/ai_controller/controller, target_key, targeting_strategy_key, hiding_location_key)
	. = ..()
	if(HAS_TRAIT(controller.pawn, TRAIT_HANDS_BLOCKED))
		return FALSE
	var/atom/target = controller.blackboard[hiding_location_key] || controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	set_movement_target(controller, target)

/datum/ai_behavior/headcrab_jump/perform(seconds_per_tick, datum/ai_controller/controller, target_key, targeting_strategy_key, hiding_location_key)
	var/mob/living/basic/basic_mob = controller.pawn
	//targeting strategy will kill the action if not real anymore
	var/atom/target = controller.blackboard[target_key]
	var/datum/targeting_strategy/targeting_strategy = GET_TARGETING_STRATEGY(controller.blackboard[targeting_strategy_key])
	var/mob/living/basic/headcrab/hc = basic_mob
	if(!istype(hc))
		return

	if(!ishuman(target))
		return

	if(!targeting_strategy.can_attack(basic_mob, target, chase_range))
		finish_action(controller, FALSE, target_key)
		return

	if(!can_see(basic_mob, target, required_distance))
		return

	if(avoid_friendly_fire && check_friendly_in_path(basic_mob, target, targeting_strategy))
		adjust_position(basic_mob, target)
		return ..()

	hc.throw_at(target, required_distance, 2, hc)
	return ..() //only start the cooldown when the shot is shot

/datum/ai_behavior/headcrab_jump/finish_action(datum/ai_controller/controller, succeeded, target_key, targeting_strategy_key, hiding_location_key)
	. = ..()
	if(!succeeded)
		controller.clear_blackboard_key(target_key)

/datum/ai_behavior/headcrab_jump/proc/check_friendly_in_path(mob/living/source, atom/target, datum/targeting_strategy/targeting_strategy)
	var/list/turfs_list = calculate_trajectory(source, target)
	for(var/turf/possible_turf as anything in turfs_list)

		for(var/mob/living/potential_friend in possible_turf)
			if(!targeting_strategy.can_attack(source, potential_friend))
				return TRUE

	return FALSE

/datum/ai_behavior/headcrab_jump/proc/adjust_position(mob/living/living_pawn, atom/target)
	var/turf/our_turf = get_turf(living_pawn)
	var/list/possible_turfs = list()

	for(var/direction in GLOB.alldirs)
		var/turf/target_turf = get_step(our_turf, direction)
		if(isnull(target_turf))
			continue
		if(target_turf.is_blocked_turf() || get_dist(target_turf, target) > get_dist(living_pawn, target))
			continue
		possible_turfs += target_turf

	if(!length(possible_turfs))
		return
	var/turf/picked_turf = get_closest_atom(/turf, possible_turfs, target)
	step(living_pawn, get_dir(living_pawn, picked_turf))

/datum/ai_behavior/headcrab_jump/proc/calculate_trajectory(mob/living/source , atom/target)
	var/list/turf_list = get_line(source, target)
	var/list_length = length(turf_list) - 1
	for(var/i in 1 to list_length)
		var/turf/current_turf = turf_list[i]
		var/turf/next_turf = turf_list[i+1]
		var/direction_to_turf = get_dir(current_turf, next_turf)
		if(!ISDIAGONALDIR(direction_to_turf))
			continue

		for(var/cardinal_direction in GLOB.cardinals)
			if(cardinal_direction & direction_to_turf)
				turf_list += get_step(current_turf, cardinal_direction)

	turf_list -= get_turf(source)
	turf_list -= get_turf(target)

	return turf_list

/datum/sprite_accessory/headcrab
	icon = 'icons/psychonaut/mob/nonhuman-player/headcrab.dmi'

/datum/sprite_accessory/headcrab/default
	name = "Headcrab"
	icon_state = "headcrab_worn"

/obj/item/organ/external/headcrab
	name = "headcrab"
	desc = "A crab in head??"
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_HEADCRAB
	use_mob_sprite_as_obj_sprite = TRUE
	bodypart_overlay = /datum/bodypart_overlay/mutant/headcrab
	var/mob/living/basic/headcrab/hc

/obj/item/organ/external/headcrab/Insert(mob/living/carbon/receiver, special, movement_flags)
	. = ..()
	if(hc)
		var/is_head_protected = FALSE
		for(var/obj/item/clothing/equipped in receiver.get_equipped_items())
			if((equipped.body_parts_covered & HEAD) && (equipped.get_armor_rating(BIO) == 100))
				is_head_protected = TRUE
		if(!is_head_protected)
			try_to_zombie_infect(receiver)

/obj/item/organ/external/headcrab/Remove(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	if(hc)
		hc.apply_damage(hc.health)
		hc.forceMove(get_turf(src))
		qdel(src)

/obj/item/organ/external/headcrab/default
	sprite_accessory_override = /datum/sprite_accessory/headcrab/default

/datum/bodypart_overlay/mutant/headcrab
	layers = ALL_EXTERNAL_OVERLAYS
	feature_key = "headcrab"

/datum/bodypart_overlay/mutant/headcrab/can_draw_on_bodypart(mob/living/carbon/human/human)
	return TRUE

/datum/bodypart_overlay/mutant/headcrab/get_global_feature_list() 
	return GLOB.headcrab_list 

/datum/bodypart_overlay/mutant/headcrab/get_base_icon_state() 
	return sprite_datum.icon_state

/datum/bodypart_overlay/mutant/headcrab/get_image(image_layer, obj/item/bodypart/limb)
	if(!sprite_datum)
		CRASH("Trying to call get_image() on [type] while it didn't have a sprite_datum. This shouldn't happen, report it as soon as possible.")

	var/mutable_appearance/appearance = mutable_appearance(sprite_datum.icon, sprite_datum.icon_state, layer = image_layer)

	if(sprite_datum.center)
		center_image(appearance, sprite_datum.dimension_x, sprite_datum.dimension_y)
	return appearance

/obj/item/kinetic_crusher/hammer
	name = "proto-kinetic hammer"
	desc = "An older version of the kinetic crusher that was discountinued due to its size and weight. However our mining department insisted on making a newer model that lacks backstab mechanism but grants it the abitilty to swing their opponents into rocks.Aside from that it is just a big ass hammer."
	icon = 'icons/psychonaut/obj/weapons/pkhammer.dmi'
	icon_state = "pkhammer"
	icon_angle = -45
	base_icon_state = "pkhammer"
	lefthand_file = 'icons/psychonaut/mob/inhands/weapons/pkhammer_lefthand.dmi'
	righthand_file = 'icons/psychonaut/mob/inhands/weapons/pkhammer_righthand.dmi'
	hitsound = 'sound/items/weapons/sonic_jackhammer.ogg'
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_GIGANTIC
	attack_verb_continuous = list("smashes", "crushes", "hammers", "clubs", "pummels")
	attack_verb_simple = list("smash", "crush", "hammer", "club", "pummel")
	armour_penetration = 0
	sharpness = NONE
	attack_speed = CLICK_CD_SLOW
	charge_time = 3 SECONDS
	detonation_damage = 55
	force_wielded = 20
	var/hammer_push_damage = 35
	var/hammer_push_distance = 2

/obj/item/kinetic_crusher/hammer/afterattack(mob/living/target, mob/living/user, list/modifiers, list/attack_modifiers)
	if(isliving(target) && HAS_TRAIT(src, TRAIT_WIELDED) && user && target.has_status_effect(/datum/status_effect/crusher_mark))
		hammer_push_target(target, user)
	return ..()

/obj/item/kinetic_crusher/hammer/proc/hammer_push_target(mob/living/target, mob/living/user)
	if(!target || !user || target == user)
		return

	var/push_dir = get_dir(user, target)
	if(!push_dir)
		return

	var/turf/current_turf = get_turf(target)
	for(var/i in 1 to hammer_push_distance)
		if(!current_turf)
			break
		var/turf/next_turf = get_step(current_turf, push_dir)
		if(!next_turf)
			break
		if(next_turf.is_blocked_turf(exclude_mobs = TRUE, source_atom = target))
			target.apply_damage(hammer_push_damage, BRUTE, blocked = target.getarmor(type = BOMB))
			break
		current_turf = next_turf
		target.forceMove(next_turf)
		playsound(user, 'sound/effects/meteorimpact.ogg', 80, TRUE)


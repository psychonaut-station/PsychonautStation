/// The unassuming, unkillable, unstoppable snail. Player-controlled.
/mob/living/basic/snail/angry/killer
	name = "Just a Super Ordinary Snnnnnnail"
	desc = "İstasyondaki bir gerizekalı ölümsüz ve çok zengin olmayı dilediği için bir zamanlar tanrı ona ceza olarak bu salyangozu verdi, tebrikler artık bu salyangoz sizinde sorununuz!!"

	health = 1
	maxHealth = 1

	speed = 20

	melee_damage_lower = 1000
	melee_damage_upper = 1000
	obj_damage = 1000

/mob/living/basic/snail/angry/killer/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/wall_tearer, allow_reinforced = TRUE, tear_time = 2 SECONDS)

/mob/living/basic/snail/angry/killer/proc/kill_victim(mob/living/carbon/human/H)
	if(QDELETED(H) || H.undergoing_cardiac_arrest())
		return

	H.set_heartattack(TRUE)

/mob/living/basic/snail/angry/killer/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	if(!proximity_flag)
		return

	if(ishuman(attack_target))
		var/mob/living/carbon/human/H = attack_target

		if(H.undergoing_cardiac_arrest())
			return TRUE

		do_attack_animation(H)

		H.visible_message(
			span_danger("[H] suddenly clutches at [H.p_their()] chest!"),
			span_userdanger("You feel a terrible pain in your chest. You can't breathe properly...")
		)

		H.losebreath += 4
		H.adjust_eye_blur(4 SECONDS)

		addtimer(CALLBACK(src, PROC_REF(kill_victim), H), 2 SECONDS)

		return TRUE

	return ..()

/mob/living/basic/snail/angry/killer/ex_act(severity, target)
	return

/mob/living/basic/snail/angry/killer/death(gibbed)
	return

/mob/living/basic/snail/angry/killer/bullet_act(obj/projectile/hitting_projectile)
	. = ..()
	return BULLET_ACT_BLOCK

/mob/living/basic/snail/angry/killer/fire_act()
	return

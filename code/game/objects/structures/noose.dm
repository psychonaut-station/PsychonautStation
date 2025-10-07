/obj/structure/noose
	name = "noose"
	desc = "Well this just got a whole lot more morbid."
	icon_state = "noose"
	icon = 'icons/psychonaut/obj/noose.dmi'
	layer = FLY_LAYER
	can_buckle = TRUE
	buckle_lying = 0
	anchored = TRUE
	density = FALSE
	/// our noose overlay
	var/mutable_appearance/overlay

/obj/structure/noose/Initialize(mapload)
	. = ..()
	pixel_y += 16 // Noose looks like it's "hanging" in the air
	overlay = image(icon, "noose_overlay")
	overlay.layer = FLY_LAYER
	add_overlay(overlay)
	AddComponent(/datum/component/simple_rotation, ROTATION_IGNORE_ANCHORED)

/obj/structure/noose/examine(mob/user)
	. = ..()
	. += span_notice("It is currently facing [dir2text(dir)].")

/obj/structure/noose/wirecutter_act(mob/living/user, obj/item/tool)
	user.visible_message(span_notice("[user] cuts the noose."), span_notice("You cut the noose."))

	if(has_buckled_mobs())
		var/mob/living/buckled_mob = buckled_mobs[1] // we can only hold one person anyway
		if(buckled_mob.has_gravity())
			buckled_mob.visible_message(span_danger("[buckled_mob] falls over and hits the ground!"), span_userdanger("You fall over and hit the ground!"))
			buckled_mob.adjustBruteLoss(10)

	deconstruct()
	return ITEM_INTERACT_SUCCESS

/obj/structure/noose/atom_deconstruct(disassembled = TRUE)
	new /obj/item/stack/cable_coil/thirty(drop_location())

/obj/structure/noose/post_buckle_mob(mob/living/carbon/buckled)
	layer = MOB_LAYER
	START_PROCESSING(SSobj, src)

	var/height_offset = 8 // kinda messes up at basically most extreme heights but its more accurate

	if(ishuman(buckled))
		var/mob/living/carbon/human/buckled_human = buckled
		height_offset += /mob/living/carbon/human::mob_height - buckled_human.mob_height

	buckled.add_offsets(REF(src), y_add = initial(pixel_y) + height_offset, time = 8, easing = LINEAR_EASING)
	ADD_TRAIT(buckled, TRAIT_NO_STAGGER, BUCKLED_TRAIT) // messes with the animation, also youre hanging how you gonna stagger

/obj/structure/noose/post_unbuckle_mob(mob/living/buckled)
	buckled.remove_offsets(REF(src))
	pixel_x = base_pixel_x
	layer = initial(layer)
	STOP_PROCESSING(SSobj, src)
	REMOVE_TRAIT(buckled, TRAIT_NO_STAGGER, BUCKLED_TRAIT)

/obj/structure/noose/user_unbuckle_mob(mob/living/unbuckled, mob/living/user)
	if(unbuckled != user)
		user.visible_message(span_notice("[user] begins to untie the noose over [unbuckled]'s neck..."))
		to_chat(user, span_notice("You begin to untie the noose over [unbuckled]'s neck..."))

		if(!do_after(user, 10 SECONDS, unbuckled))
			return

		user.visible_message(span_notice("[user] unties the noose over [unbuckled]'s neck!"))
		to_chat(user,span_notice("You untie the noose over [unbuckled]'s neck!"))
	else
		unbuckled.visible_message(span_warning("[unbuckled] struggles to untie the noose over their neck!"))
		to_chat(unbuckled, span_notice("You struggle to untie the noose over your neck... (Stay still for 15 seconds.)"))

		if(!do_after(unbuckled, 15 SECONDS, target = src))
			if(!isnull(unbuckled) && unbuckled.buckled)
				to_chat(unbuckled, span_warning("You fail to untie yourself!"))
			return

		if(!unbuckled.buckled)
			return

		unbuckled.visible_message(span_warning("[unbuckled] unties the noose over their neck!"))
		to_chat(unbuckled, span_notice("You untie the noose over your neck!"))

	unbuckled.Knockdown(5 SECONDS)
	unbuckle_all_mobs(force = TRUE)
	add_fingerprint(user)

/obj/structure/noose/user_buckle_mob(mob/living/carbon/human/victim, mob/user, check_loc = TRUE)
	if(!is_user_buckle_possible(victim, user, check_loc) || !iscarbon(victim))
		return FALSE

	if (!victim.get_bodypart(BODY_ZONE_HEAD))
		to_chat(user, span_warning("[victim] has no head!"))
		return FALSE

	if(victim.loc != loc)
		return FALSE // Can only noose someone if they're on the same tile as noose

	add_fingerprint(user)
	log_combat(user, victim, "attempted to hang", src)
	victim.visible_message(span_danger("[user] attempts to tie \the [src] over [victim]'s neck!"))

	if(user != victim)
		to_chat(user, span_notice("It will take 20 seconds and you have to stand still."))

	if(do_after(user, user == victim ? 0 : 20 SECONDS, victim))
		if(buckle_mob(victim))
			user.visible_message(span_warning("[user] ties \the [src] over [victim]'s neck!"))

			if(user == victim)
				to_chat(victim, span_userdanger("You tie \the [src] over your neck!"))
			else
				to_chat(victim, span_userdanger("[user] ties \the [src] over your neck!"))

			playsound(user.loc, 'sound/effects/noosed.ogg', 50, 1, -1)
			log_combat(user, victim, "hanged", src)
			return TRUE

	user.visible_message(span_warning("[user] fails to tie \the [src] over [victim]'s neck!"))
	to_chat(user, span_warning("You fail to tie \the [src] over [victim]'s neck!"))
	return FALSE

/obj/structure/noose/process()
	if(!has_buckled_mobs())
		return PROCESS_KILL

	var/mob/living/buckled_mob = buckled_mobs[1] // this is a noose how are you tying two people

	if(!buckled_mob.get_bodypart(BODY_ZONE_HEAD)) // you need a neck to get hanged
		buckled_mob.visible_message(span_danger("[buckled_mob] drops from the noose!"))
		unbuckle_all_mobs(force=TRUE)
		return

	if(!buckled_mob.has_gravity()) // entirely skip swaying in no gravity; swaying is a motion that requires gravity
		return // also hanging someone needs gravity so it just skips that

	// animate our swaying motion
	if(pixel_x >= 0)
		animate(src, pixel_x = -3, time = 4.5 SECONDS, easing = ELASTIC_EASING)
		animate(buckled_mob, pixel_x = -3, time = 4.5 SECONDS, easing = ELASTIC_EASING)
	else
		animate(src, pixel_x = 3, time = 4.5 SECONDS, easing = ELASTIC_EASING)
		animate(buckled_mob, pixel_x = 3, time = 4.5 SECONDS, easing = ELASTIC_EASING)

	playsound(buckled_mob.loc, 'sound/effects/noose_idle.ogg', 25, 1, -3)

	if(buckled_mob.stat == DEAD || HAS_TRAIT(buckled_mob, TRAIT_NOBREATH))
		return

	buckled_mob.adjustOxyLoss(5)

	if(prob(30))
		buckled_mob.emote("gasp")

	if(prob(20))
		var/flavor_text = list(
			span_suicide("[buckled_mob]'s legs flail for anything to stand on."),
			span_suicide("[buckled_mob]'s hands are desperately clutching the noose."),
			span_suicide("[buckled_mob]'s limbs sway back and forth with diminishing strength.")
		)

		buckled_mob.visible_message(pick(flavor_text))

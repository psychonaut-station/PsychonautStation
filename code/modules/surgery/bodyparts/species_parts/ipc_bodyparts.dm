#define ROBOTIC_LIGHT_BRUTE_MSG "marred"
#define ROBOTIC_MEDIUM_BRUTE_MSG "dented"
#define ROBOTIC_HEAVY_BRUTE_MSG "falling apart"

#define ROBOTIC_LIGHT_BURN_MSG "scorched"
#define ROBOTIC_MEDIUM_BURN_MSG "charred"
#define ROBOTIC_HEAVY_BURN_MSG "smoldering"

/obj/item/bodypart/head/ipc
	icon = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
	icon_static = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
	icon_greyscale = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
	disabled_wound_penalty = 10
	icon_state = "blackipc_head"
	limb_id = "blackipc"
	dmg_overlay_type = "synth"
	attack_verb_simple = list("slapped", "punched")
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_ROBOTIC | BODYTYPE_IPC
	brute_modifier = 1
	burn_modifier = 1.3
	dmg_overlay_type = "robotic"
	head_flags = NONE
	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG
	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG
	examine_bodypart_id = SPECIES_IPC
	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT)
	biological_state = (BIO_ROBOTIC|BIO_JOINTED)
	var/datum/action/innate/change_monitor/change_monitor

/obj/item/bodypart/head/ipc/apply_ownership(mob/living/carbon/new_owner)
	. = ..()
	RegisterSignal(new_owner, COMSIG_ATOM_EMAG_ACT, PROC_REF(on_emag_act))
	change_monitor = new(new_owner)
	change_monitor.Grant(new_owner)

/obj/item/bodypart/head/ipc/clear_ownership(mob/living/carbon/old_owner)
	. = ..()
	UnregisterSignal(old_owner, COMSIG_ATOM_EMAG_ACT)
	QDEL_NULL(change_monitor)

/obj/item/bodypart/head/ipc/receive_damage(brute = 0, burn = 0, blocked = 0, updating_health = TRUE, forced = FALSE, required_bodytype = null, wound_bonus = 0, exposed_wound_bonus = 0, sharpness = NONE, attack_direction = null, damage_source, wound_clothing = TRUE)
	. = ..()
	if(owner)
		var/mob/living/carbon/oldowner = owner
		if(get_damage() >= 75)
			if(prob(50))
				drop_limb()
				oldowner.apply_damages(brute = brute_dam * 4/5, burn = burn_dam * 4/5, def_zone = BODY_ZONE_CHEST)
				heal_damage(brute = brute_dam * 9/10, burn = burn_dam * 9/10)
				return

/obj/item/bodypart/head/ipc/proc/on_emag_act(mob/living/carbon/human/source, mob/user)
	SIGNAL_HANDLER
	if(obj_flags & EMAGGED)
		return FALSE
	obj_flags |= EMAGGED
	return TRUE

/obj/item/bodypart/head/ipc/emp_effect(severity, protection)
	. = ..()
	if(!. || isnull(owner))
		return

	to_chat(owner, span_danger("Your [plaintext_zone]'s optical transponders glitch out and malfunction!"))

	var/glitch_duration = AUGGED_HEAD_EMP_GLITCH_DURATION
	if (severity == EMP_HEAVY)
		glitch_duration *= 2

	owner.add_client_colour(/datum/client_colour/malfunction)

	addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living/carbon/human, remove_client_colour), /datum/client_colour/malfunction), glitch_duration)
	return

/obj/item/bodypart/chest/ipc
	icon = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
	icon_static = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
	icon_greyscale = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
	icon_state = "blackipc_chest"
	limb_id = "blackipc"
	dmg_overlay_type = "synth"
	attack_verb_simple = list("slapped", "punched")
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_ROBOTIC | BODYTYPE_IPC
	brute_modifier = 1
	burn_modifier = 1.3
	dmg_overlay_type = "robotic"
	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG
	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG
	examine_bodypart_id = SPECIES_IPC
	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT)
	wing_types = list(/obj/item/organ/wings/functional/robotic)
	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

/obj/item/bodypart/chest/ipc/emp_act(severity)
	. = ..()
	if(!.)
		return
	to_chat(owner, span_danger("Your [src.name]'s logic boards temporarily become unresponsive!"))
	if(severity == EMP_HEAVY)
		owner.Stun(6 SECONDS)
		owner.Shake(pixelshiftx = 5, pixelshifty = 2, duration = 4 SECONDS)
		return

	owner.Stun(3 SECONDS)
	owner.Shake(pixelshiftx = 3, pixelshifty = 0, duration = 2.5 SECONDS)

/obj/item/bodypart/arm/left/ipc
	icon = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
	icon_static = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
	icon_greyscale = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
	icon_state = "blackipc_l_arm"
	limb_id = "blackipc"
	dmg_overlay_type = "synth"
	attack_verb_simple = list("kicked", "stomped")
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_ROBOTIC | BODYTYPE_IPC
	brute_modifier = 1
	burn_modifier = 1.3
	dmg_overlay_type = "robotic"
	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG
	examine_bodypart_id = SPECIES_IPC
	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT)
	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

/obj/item/bodypart/arm/right/ipc
	icon = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
	icon_static = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
	icon_greyscale = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
	icon_state = "blackipc_r_arm"
	limb_id = "blackipc"
	dmg_overlay_type = "synth"
	attack_verb_simple = list("kicked", "stomped")
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_ROBOTIC | BODYTYPE_IPC
	brute_modifier = 1
	burn_modifier = 1.3
	dmg_overlay_type = "robotic"
	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG
	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG
	examine_bodypart_id = SPECIES_IPC
	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT)
	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

/obj/item/bodypart/leg/left/ipc
	icon = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
	icon_static = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
	icon_greyscale = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
	icon_state = "blackipc_l_leg"
	limb_id = "blackipc"
	dmg_overlay_type = "synth"
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_ROBOTIC | BODYTYPE_IPC
	brute_modifier = 1
	burn_modifier = 1.3
	dmg_overlay_type = "robotic"
	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG
	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG
	examine_bodypart_id = SPECIES_IPC
	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT)
	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

/obj/item/bodypart/leg/left/ipc/emp_act(severity)
	. = ..()
	if(!. || isnull(owner))
		return

	var/knockdown_time = AUGGED_LEG_EMP_KNOCKDOWN_TIME
	if (severity == EMP_HEAVY)
		knockdown_time *= 2
	owner.Knockdown(knockdown_time)
	if(INCAPACITATED_IGNORING(owner, INCAPABLE_RESTRAINTS|INCAPABLE_GRAB)) // So the message isn't duplicated. If they were stunned beforehand by something else, then the message not showing makes more sense anyways.
		return
	to_chat(owner, span_danger("As your [plaintext_zone] unexpectedly malfunctions, it causes you to fall to the ground!"))
	return

/obj/item/bodypart/leg/right/ipc
	icon = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
	icon_static = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
	icon_greyscale = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
	icon_state = "blackipc_r_leg"
	limb_id = "blackipc"
	dmg_overlay_type = "synth"
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_ROBOTIC | BODYTYPE_IPC
	brute_modifier = 1
	burn_modifier = 1.3
	dmg_overlay_type = "robotic"
	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG
	examine_bodypart_id = SPECIES_IPC
	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT)
	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

/obj/item/bodypart/leg/right/ipc/emp_act(severity)
	. = ..()
	if(!. || isnull(owner))
		return

	var/knockdown_time = AUGGED_LEG_EMP_KNOCKDOWN_TIME
	if (severity == EMP_HEAVY)
		knockdown_time *= 2
	owner.Knockdown(knockdown_time)
	if(INCAPACITATED_IGNORING(owner, INCAPABLE_RESTRAINTS|INCAPABLE_GRAB)) // So the message isn't duplicated. If they were stunned beforehand by something else, then the message not showing makes more sense anyways.
		return
	to_chat(owner, span_danger("As your [plaintext_zone] unexpectedly malfunctions, it causes you to fall to the ground!"))
	return

#undef ROBOTIC_LIGHT_BRUTE_MSG
#undef ROBOTIC_MEDIUM_BRUTE_MSG
#undef ROBOTIC_HEAVY_BRUTE_MSG

#undef ROBOTIC_LIGHT_BURN_MSG
#undef ROBOTIC_MEDIUM_BURN_MSG
#undef ROBOTIC_HEAVY_BURN_MSG

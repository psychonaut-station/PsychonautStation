#define ROBOTIC_LIGHT_BRUTE_MSG "marred"
#define ROBOTIC_MEDIUM_BRUTE_MSG "dented"
#define ROBOTIC_HEAVY_BRUTE_MSG "falling apart"

#define ROBOTIC_LIGHT_BURN_MSG "scorched"
#define ROBOTIC_MEDIUM_BURN_MSG "charred"
#define ROBOTIC_HEAVY_BURN_MSG "smoldering"

/obj/item/bodypart/arm/left/synthetic
	name = "synthetic left arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case. Especially for synthetics."
	limb_id = SPECIES_SYNTHETIC
	attack_verb_simple = list("slapped", "punched")
	icon_greyscale = 'icons/mob/species/synthetic/bodyparts_greyscale.dmi'
	icon_state = "synth_l_arm"
	bodytype = BODYTYPE_ROBOTIC | BODYTYPE_SYNTHETIC
	bodyshape = BODYSHAPE_HUMANOID
	dmg_overlay_type = "robotic"

	brute_modifier = 5
	burn_modifier = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT)
	disabling_threshold_percentage = 1

/obj/item/bodypart/arm/right/synthetic
	name = "synthetic right arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case. Especially for synthetics."
	limb_id = SPECIES_SYNTHETIC
	attack_verb_simple = list("slapped", "punched")
	icon_greyscale = 'icons/mob/species/synthetic/bodyparts_greyscale.dmi'
	icon_state = "synth_r_arm"
	bodytype = BODYTYPE_ROBOTIC | BODYTYPE_SYNTHETIC
	bodyshape = BODYSHAPE_HUMANOID
	dmg_overlay_type = "robotic"

	brute_modifier = 5
	burn_modifier = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT)
	disabling_threshold_percentage = 1

/obj/item/bodypart/leg/left/synthetic
	name = "synthetic left leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case. Especially for synthetics."
	limb_id = SPECIES_SYNTHETIC
	attack_verb_simple = list("kicked", "stomped")
	icon_greyscale = 'icons/mob/species/synthetic/bodyparts_greyscale.dmi'
	icon_state = "synth_l_leg"
	bodytype = BODYTYPE_ROBOTIC | BODYTYPE_SYNTHETIC
	bodyshape = BODYSHAPE_HUMANOID
	dmg_overlay_type = "robotic"

	brute_modifier = 5
	burn_modifier = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT)
	disabling_threshold_percentage = 1

/obj/item/bodypart/leg/left/synthetic/emp_act(severity)
	. = ..()
	if(!.)
		return
	owner.Knockdown(severity == EMP_HEAVY ? 20 SECONDS : 10 SECONDS)
	if(owner.incapacitated(IGNORE_RESTRAINTS|IGNORE_GRAB)) // So the message isn't duplicated. If they were stunned beforehand by something else, then the message not showing makes more sense anyways.
		return
	to_chat(owner, span_danger("As your [src.name] unexpectedly malfunctions, it causes you to fall to the ground!"))
/obj/item/bodypart/leg/right/synthetic
	name = "synthetic right leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case. Especially for synthetics."
	limb_id = SPECIES_SYNTHETIC
	attack_verb_simple = list("kicked", "stomped")
	icon_greyscale = 'icons/mob/species/synthetic/bodyparts_greyscale.dmi'
	icon_state = "synth_r_leg"
	bodytype = BODYTYPE_ROBOTIC | BODYTYPE_SYNTHETIC
	bodyshape = BODYSHAPE_HUMANOID
	dmg_overlay_type = "robotic"

	brute_modifier = 5
	burn_modifier = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT)
	disabling_threshold_percentage = 1

/obj/item/bodypart/leg/right/synthetic/emp_act(severity)
	. = ..()
	if(!.)
		return
	owner.Knockdown(severity == EMP_HEAVY ? 20 SECONDS : 10 SECONDS)
	if(owner.incapacitated(IGNORE_RESTRAINTS|IGNORE_GRAB)) // So the message isn't duplicated. If they were stunned beforehand by something else, then the message not showing makes more sense anyways.
		return
	to_chat(owner, span_danger("As your [src.name] unexpectedly malfunctions, it causes you to fall to the ground!"))

/obj/item/bodypart/chest/synthetic
	name = "synthetic torso"
	desc = "A heavily reinforced case containing cyborg logic boards, with space for a standard power cell. Especially for synthetics."
	limb_id = SPECIES_SYNTHETIC
	icon_greyscale = 'icons/mob/species/synthetic/bodyparts_greyscale.dmi'
	icon_state = "synth_chest"
	bodytype = BODYTYPE_ROBOTIC | BODYTYPE_SYNTHETIC
	bodyshape = BODYSHAPE_HUMANOID
	dmg_overlay_type = "robotic"
	is_dimorphic = FALSE

	brute_modifier = 5
	burn_modifier = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT)
	wing_types = list(/obj/item/organ/external/wings/functional/robotic)

/obj/item/bodypart/chest/synthetic/emp_act(severity)
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

/obj/item/bodypart/head/synthetic
	name = "synthetic head"
	desc = "A standard reinforced braincase, with spine-plugged neural socket and sensor gimbals. Especially for synthetics."
	limb_id = SPECIES_SYNTHETIC
	icon_greyscale = 'icons/mob/species/synthetic/bodyparts_greyscale.dmi'
	icon_state = "synth_head"
	bodytype = BODYTYPE_ROBOTIC | BODYTYPE_SYNTHETIC
	bodyshape = BODYSHAPE_HUMANOID
	dmg_overlay_type = "robotic"
	is_dimorphic = FALSE

	brute_modifier = 5
	burn_modifier = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT)

/obj/item/bodypart/head/synthetic/emp_act(severity)
	. = ..()
	if(!.)
		return
	to_chat(owner, span_danger("Your [src.name]'s optical transponders glitch out and malfunction!"))

	var/glitch_duration = severity == EMP_HEAVY ? 15 SECONDS : 7.5 SECONDS

	owner.add_client_colour(/datum/client_colour/malfunction)

	addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living/carbon/human, remove_client_colour), /datum/client_colour/malfunction), glitch_duration)

#undef ROBOTIC_LIGHT_BRUTE_MSG
#undef ROBOTIC_MEDIUM_BRUTE_MSG
#undef ROBOTIC_HEAVY_BRUTE_MSG

#undef ROBOTIC_LIGHT_BURN_MSG
#undef ROBOTIC_MEDIUM_BURN_MSG
#undef ROBOTIC_HEAVY_BURN_MSG

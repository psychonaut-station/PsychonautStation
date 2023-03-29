#define ROBOTIC_LIGHT_BRUTE_MSG "marred"
#define ROBOTIC_MEDIUM_BRUTE_MSG "dented"
#define ROBOTIC_HEAVY_BRUTE_MSG "falling apart"

#define ROBOTIC_LIGHT_BURN_MSG "scorched"
#define ROBOTIC_MEDIUM_BURN_MSG "charred"
#define ROBOTIC_HEAVY_BURN_MSG "smoldering"

/obj/item/bodypart/arm/left/synthetic
	name = "synthetic left arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	limb_id = SPECIES_SYNTHETIC
	attack_verb_simple = list("slapped", "punched")
	icon_greyscale = 'icons/mob/species/synthetic/bodyparts_greyscale.dmi'
	flags_1 = CONDUCT_1
	is_dimorphic = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC
	dmg_overlay_type = "robotic"

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT, CLONE = DEFAULT_CLONE_EXAMINE_TEXT)
	disabling_threshold_percentage = 1

/obj/item/bodypart/arm/right/synthetic
	name = "synthetic right arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	attack_verb_simple = list("slapped", "punched")
	icon_greyscale = 'icons/mob/species/synthetic/bodyparts_greyscale.dmi'
	limb_id = SPECIES_SYNTHETIC
	flags_1 = CONDUCT_1
	is_dimorphic = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC
	dmg_overlay_type = "robotic"

	brute_reduction = 5
	burn_reduction = 4
	disabling_threshold_percentage = 1

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT, CLONE = DEFAULT_CLONE_EXAMINE_TEXT)

/obj/item/bodypart/leg/left/synthetic
	name = "synthetic left leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	attack_verb_simple = list("kicked", "stomped")
	icon_greyscale = 'icons/mob/species/synthetic/bodyparts_greyscale.dmi'
	limb_id = SPECIES_SYNTHETIC
	flags_1 = CONDUCT_1
	is_dimorphic = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC
	dmg_overlay_type = "robotic"

	brute_reduction = 5
	burn_reduction = 4
	disabling_threshold_percentage = 1

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT, CLONE = DEFAULT_CLONE_EXAMINE_TEXT)

/obj/item/bodypart/leg/right/synthetic
	name = "synthetic right leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	attack_verb_simple = list("kicked", "stomped")
	icon_greyscale = 'icons/mob/species/synthetic/bodyparts_greyscale.dmi'
	limb_id = SPECIES_SYNTHETIC
	flags_1 = CONDUCT_1
	is_dimorphic = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC
	dmg_overlay_type = "robotic"

	brute_reduction = 5
	burn_reduction = 4
	disabling_threshold_percentage = 1

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT, CLONE = DEFAULT_CLONE_EXAMINE_TEXT)

/obj/item/bodypart/chest/synthetic
	name = "synthetic torso"
	desc = "A heavily reinforced case containing synthetic logic boards, with space for a standard power cell."
	icon_greyscale = 'icons/mob/species/synthetic/bodyparts_greyscale.dmi'
	limb_id = SPECIES_SYNTHETIC
	flags_1 = CONDUCT_1
	is_dimorphic = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC
	dmg_overlay_type = "robotic"

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT, CLONE = DEFAULT_CLONE_EXAMINE_TEXT)

/obj/item/bodypart/head/synthetic
	name = "synthetic head"
	desc = "A standard reinforced braincase, with spine-plugged neural socket and sensor gimbals."
	icon_greyscale = 'icons/mob/species/synthetic/bodyparts_greyscale.dmi'
	limb_id = SPECIES_SYNTHETIC
	flags_1 = CONDUCT_1
	is_dimorphic = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC
	dmg_overlay_type = "robotic"

	brute_reduction = 5
	burn_reduction = 4

	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT, CLONE = DEFAULT_CLONE_EXAMINE_TEXT)

#undef ROBOTIC_LIGHT_BRUTE_MSG
#undef ROBOTIC_MEDIUM_BRUTE_MSG
#undef ROBOTIC_HEAVY_BRUTE_MSG

#undef ROBOTIC_LIGHT_BURN_MSG
#undef ROBOTIC_MEDIUM_BURN_MSG
#undef ROBOTIC_HEAVY_BURN_MSG

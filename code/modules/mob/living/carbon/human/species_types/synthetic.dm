/datum/species/synthetic
	name = "Synthetic"
	id = SPECIES_SYNTHETIC
	inherent_traits = list(
		TRAIT_LIVERLESS_METABOLISM,
		TRAIT_NO_BLOOD_OVERLAY,
		TRAIT_NO_DNA_COPY,
		TRAIT_MINDSHIELD,
		TRAIT_GENELESS,
		TRAIT_LIMBATTACHMENT,
		TRAIT_NOBREATH,
		TRAIT_NOFIRE,
		TRAIT_NOHUNGER,
		TRAIT_PIERCEIMMUNE,
		TRAIT_RADIMMUNE,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHEAT,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_TOXIMMUNE,
		TRAIT_NOBLOOD,
		TRAIT_VIRUSIMMUNE,
		TRAIT_TRUE_NIGHT_VISION,
		TRAIT_QUICK_BUILD,
		TRAIT_NOFLASH,
		TRAIT_XENO_IMMUNE,
		TRAIT_NOLIMBDISABLE,
		TRAIT_NODISMEMBER,
		TRAIT_USES_SKINTONES,

		// Skills
		TRAIT_KNOW_ROBO_WIRES,
		TRAIT_KNOW_ENGI_WIRES,
		TRAIT_LIGHTBULB_REMOVER,
	)

	damage_modifier = 0.5
	coldmod = 0
	heatmod = 1.5
	stunmod = 0.3

	sexes = FALSE
	inherent_biotypes = MOB_ROBOTIC | MOB_HUMANOID
	meat = null
	mutanttongue = /obj/item/organ/tongue/robot
	mutantstomach = null
	mutantheart = null
	mutantliver = null
	mutantlungs = null
	mutantappendix = null
	species_language_holder = /datum/language_holder/synthetic
	changesource_flags = MIRROR_BADMIN

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/synthetic,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/synthetic,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/synthetic,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/synthetic,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/synthetic,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/synthetic,
	)
	examine_limb_id = SPECIES_SYNTHETIC

	var/old_gender = PLURAL
	var/old_physique = MALE
	var/old_age = 30

/datum/species/synthetic/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()

	old_gender = C.gender
	C.gender = NEUTER

	old_physique = C.physique
	C.physique = MALE

	old_age = C.age
	C.age = 30

	C.update_body(0)

	var/datum/atom_hud/sec_hud = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	var/datum/atom_hud/health_hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	var/datum/atom_hud/diagnostic_hud = GLOB.huds[DATA_HUD_DIAGNOSTIC]

	sec_hud.show_to(C)
	health_hud.show_to(C)
	diagnostic_hud.show_to(C)

/datum/species/synthetic/on_species_loss(mob/living/carbon/human/C)
	. = ..()

	C.gender = old_gender
	C.physique = old_physique
	C.age = old_age

	var/datum/atom_hud/sec_hud = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	var/datum/atom_hud/health_hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	var/datum/atom_hud/diagnostic_hud = GLOB.huds[DATA_HUD_DIAGNOSTIC]

	sec_hud.hide_from(C)
	health_hud.hide_from(C)
	diagnostic_hud.hide_from(C)

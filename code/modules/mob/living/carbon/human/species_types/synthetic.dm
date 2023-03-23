/datum/species/synthetic
	name = "Synthetic"
	id = SPECIES_SYNTHETIC
	species_traits = list(
		NO_DNA_COPY,
		NOTRANSSTING,
		NO_UNDERWEAR,
		NOBLOODOVERLAY,
	)
	inherent_traits = list(
		TRAIT_MINDSHIELD,
		TRAIT_GENELESS,
		TRAIT_LIMBATTACHMENT,
		TRAIT_NOBREATH,
		TRAIT_NOCLONELOSS,
		TRAIT_NOFIRE,
		TRAIT_NOHUNGER,
		TRAIT_NOMETABOLISM,
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
		TRAIT_PACIFISM,
		TRAIT_NOLIMBDISABLE,
		TRAIT_NODISMEMBER,

		// Skills
		TRAIT_KNOW_CYBORG_WIRES,
		TRAIT_KNOW_ENGI_WIRES,
		TRAIT_LIGHTBULB_REMOVER,

		// bruh
		TRAIT_PREVENT_ANTAG_OBJECTIVE,
	)

	brutemod = 0.35
	burnmod = 0.35
	coldmod = 0
	heatmod = 1.5
	stunmod = 0.3

	sexes = FALSE
	inherent_biotypes = MOB_ROBOTIC | MOB_HUMANOID
	meat = null
	mutanttongue = /obj/item/organ/internal/tongue/robot
	mutantstomach = null
	mutantheart = null
	mutantliver = null
	mutantlungs = null
	species_language_holder = /datum/language_holder/synthetic
	wing_types = list(/obj/item/organ/external/wings/functional/robotic)
	changesource_flags = MIRROR_BADMIN

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/robot,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/robot,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/robot,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/robot,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/robot,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/robot,
	)
	examine_limb_id = SPECIES_HUMAN

/datum/species/synthetic/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()

	C.set_safe_hunger_level()

	var/datum/atom_hud/sec_hud = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	var/datum/atom_hud/health_hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	sec_hud.show_to(C)
	health_hud.show_to(C)

/datum/species/abductor/on_species_loss(mob/living/carbon/C)
	. = ..()

	var/datum/atom_hud/sec_hud = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	var/datum/atom_hud/health_hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	sec_hud.hide_from(C)
	health_hud.hide_from(C)

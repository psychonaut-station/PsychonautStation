/datum/species/arachnid
	name = "Arachnid"
	id = SPECIES_ARACHNID
	examine_limb_id = SPECIES_ARACHNID
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	inherent_factions = list(FACTION_SPIDER)
	species_language_holder = /datum/language_holder/fly
	payday_modifier = 1.0
	sexes = FALSE
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
	)
	meat = /obj/item/food/meat/slab/spider
	siemens_coeff = 1.3
	mutanteyes = /obj/item/organ/internal/eyes/night_vision/arachnid
	mutanttongue = /obj/item/organ/internal/tongue/arachnid
	mutant_organs = list(
		/obj/item/organ/external/arachnid_appendages = "Long",
	)
	inert_mutation = /datum/mutation/human/webbing
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/arachnid,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/arachnid,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/arachnid,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/arachnid,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/arachnid,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/arachnid,
	)

/datum/species/arachnid/handle_chemical(datum/reagent/chem, mob/living/carbon/human/H, seconds_per_tick, times_fired)
	. = ..()
	if(. & COMSIG_MOB_STOP_REAGENT_CHECK)
		return
	if(chem.type == /datum/reagent/toxin/pestkiller)
		H.adjustToxLoss(3 * REM * seconds_per_tick)

/datum/species/arachnid/on_species_gain(mob/living/carbon/human/H, datum/species/old_species, pref_load)
	. = ..()
	RegisterSignal(H, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS, PROC_REF(damage_weakness))

/datum/species/arachnid/on_species_loss(mob/living/carbon/human/H, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(H, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS)

/datum/species/arachnid/proc/damage_weakness(datum/source, list/damage_mods, damage_amount, damagetype, def_zone, sharpness, attack_direction, obj/item/attacking_item)
	SIGNAL_HANDLER

	if(istype(attacking_item, /obj/item/melee/flyswatter))
		damage_mods += 30 // Yes, a 30x damage modifier

/datum/species/arachnid/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.features["mcolor"] = "#382928"
	human.dna.features["arachnid_appendages"] = "Long"
	human.eye_color_left = COLOR_SILVER
	human.eye_color_right = COLOR_SILVER
	human.update_body(is_creating = TRUE)

/datum/species/arachnid/get_species_description()
	return "Arachnids are a species of humanoid spiders employed by Nanotrasen in recent years."

/datum/species/arachnid/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "bolt",
			SPECIES_PERK_NAME = "Agile",
			SPECIES_PERK_DESC = "Arachnids run slightly faster than other species, but are still outpaced by Goblins.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = "spider",
			SPECIES_PERK_NAME = "Big Appendages",
			SPECIES_PERK_DESC = "Arachnids have appendages that are not hidden by space suits \
			or MODsuits. This can make concealing your identity harder.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "sun",
			SPECIES_PERK_NAME = "Maybe Too Many Eyes",
			SPECIES_PERK_DESC = "Arachnids cannot equip any kind of eyewear, requiring \
			alternatives like welding helmets or implants. Their eyes have night vision however.",
		),
	)
	return to_add

/datum/reagent/mutationtoxin/arachnid
	name = "Arachnid Mutation Toxin"
	description = "A spidering toxin."
	color = "#BFB413"
	race = /datum/species/arachnid
	taste_description = "webs"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/chemical_reaction/arachnid_muttoxin
	results = list(/datum/reagent/mutationtoxin/arachnid = 1)
	required_reagents = list(/datum/reagent/mutationtoxin/lizard = 1, /datum/reagent/consumable/milk = 1)
	reaction_tags = REACTION_TAG_EASY

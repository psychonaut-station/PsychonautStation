/datum/species/arachnid
	name = "Arachnid"
	id = SPECIES_ARACHNID
	examine_limb_id = SPECIES_JELLYPERSON
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
	mutanteye = /obj/item/organ/internal/eyes/night_vision/arachnid
	mutanttongue = /obj/item/organ/internal/tongue/arachnid
	external_organs = list(
		/obj/item/organ/external/arachnid_appendages = "Long",
		/obj/item/organ/external/chelicerae = "Basic",
	)
	
	
	
/**
/obj/item/bodypart/head/arachnid
        icon_greyscale = 'icons/psychonaut/mob/human/species/arachnid/bodyparts.dmi'
        limb_id = SPECIES_ARACHNID
        is_dimorphic = FALSE
        head_flags = HEAD_EYESPRITES|HEAD_EYECOLOR

/obj/item/bodypart/chest/arachnid
        icon_greyscale = 'icons/psychonaut/mob/human/species/arachnid/bodyparts.dmi'
        limb_id = SPECIES_ARACHNID
        is_dimorphic = FALSE

/obj/item/bodypart/arm/left/arachnid
        icon_greyscale = 'icons/psychonaut/mob/human/species/arachnid/bodyparts.dmi'
        limb_id = SPECIES_ARACHNID
        unarmed_attack_verb = "slash"
        unarmed_attack_effect = ATTACK_EFFECT_CLAW
        unarmed_attack_sound = 'sound/weapons/slash.ogg'
        unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'

/obj/item/bodypart/arm/right/arachnid
        icon_greyscale = 'icons/psychonaut/mob/human/species/arachnid/bodyparts.dmi'
        limb_id = SPECIES_ARACHNID
        unarmed_attack_verb = "slash"
        unarmed_attack_effect = ATTACK_EFFECT_CLAW
        unarmed_attack_sound = 'sound/weapons/slash.ogg'
        unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'

/obj/item/bodypart/leg/left/arachnid
        icon_greyscale = 'icons/psychonaut/mob/human/species/arachnid/bodyparts.dmi'
        limb_id = SPECIES_ARACHNID

/obj/item/bodypart/leg/right/arachnid
        icon_greyscale = 'icons/psychonaut/mob/human/species/arachnid/bodyparts.dmi'
        limb_id = SPECIES_ARACHNID
**/
/datum/species/arachnid/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H, seconds_per_tick, times_fired)
	if(chem.type == /datum/reagent/toxin/pestkiller)
		H.adjustToxLoss(3 * REM * seconds_per_tick)
		H.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM * seconds_per_tick)
		return TRUE
	return ..()

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

/datum/reagent/mutationtoxin/arachnid
	name = "Arachnid Mutation Toxin"
	description = "A spidering toxin."
	color = "#BFB413"
	race = /datum/species/arachnid
	taste_description = "webs"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/chemical_reaction/arachnid_muttoxin
	results = list(/datum/reagent/mutationtoxin/arachnid = 1)
	required_reagents = list(/datum/reagent/mutationtoxin/lizard = 1, /datum/reagent/toxin = 1)
	reaction_tags = REACTION_TAG_EASY
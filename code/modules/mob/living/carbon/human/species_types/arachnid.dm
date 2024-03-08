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
	coldmod = 1.5
	heatmod = 1.5
	mutanteye = /obj/item/organ/internal/eyes/night_vision/arachnid
	mutanttongue = /obj/item/organ/internal/tongue/arachnid
	
	
	
	
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
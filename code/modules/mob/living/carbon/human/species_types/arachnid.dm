/datum/species/arachnid
	name = "Arachnid"
	id = SPECIES_ARACHNID
	examine_limb_id = SPECIES_JELLYPERSON
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	species_language_holder = /datum/language_holder/fly
	payday_modifier = 1.0
	sexes = FALSE
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
	)
	meat = /obj/item/food/meat/slab/spider
	coldmod = 3   // = 1.5x cold damage
	heatmod = 3 // = 1.5x heat damage
	
	
	
	
	
	
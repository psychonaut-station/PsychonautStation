/datum/preference/choiced/height
	savefile_key = "height"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	randomize_by_default = FALSE

/datum/preference/choiced/height/init_possible_values()
	return list("Short", "Medium", "Tall")

/datum/preference/choiced/height/apply_to_human(mob/living/carbon/human/target, value)
	var/height = HUMAN_HEIGHT_MEDIUM
	switch(value)
		if("Short")
			height = HUMAN_HEIGHT_SHORT
		if("Tall")
			height = HUMAN_HEIGHT_TALL

	target.set_mob_height(height)

/datum/preference/choiced/height/create_default_value()
	return pick("Short", "Medium", "Tall")

/datum/preference/choiced/height/is_accessible(datum/preferences/preferences)
	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = GLOB.species_prototypes[species_type]

	if(istype(species, /datum/species/monkey))
		return FALSE
	if(!(species.inherent_biotypes & MOB_ORGANIC)) // Plasmaman, IPC etc.
		return FALSE
	if(("Settler" in preferences.all_quirks) || ("Spacer" in preferences.all_quirks))
		return FALSE

	return ..()

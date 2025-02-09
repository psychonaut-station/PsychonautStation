/datum/preference/choiced/height
	savefile_key = "height"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL

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
	return "Medium"

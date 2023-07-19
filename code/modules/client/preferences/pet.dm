/// Pet Type preference
/datum/preference/choiced/pettype
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "pettype"
	body_type = "Pet"
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL

/datum/preference/choiced/pettype/init_possible_values()
	return list(PUG, BULLTERRIER, CAT, BLACK_CAT)

/datum/preference/choiced/pettype/create_default_value()
	return PUG

/datum/preference/choiced/pettype/apply_to_human(client/client, value)
	return FALSE

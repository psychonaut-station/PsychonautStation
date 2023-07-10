/// Pet Type preference
/datum/preference/choiced/pettype
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "pettype"
	priority = PREFERENCE_PRIORITY_PET_TYPE

/datum/preference/choiced/pettype/init_possible_values()
	return list(PUG, CAT)

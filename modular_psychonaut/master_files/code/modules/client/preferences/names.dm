/datum/preference/name/real_name/serialize(input, datum/preferences/preferences)
	// `is_valid` should always be run before `serialize`, so it should not
	// be possible for this to return `null`.
	var/datum/species/race = preferences?.read_preference(/datum/preference/choiced/species) || /datum/species/human
	return reject_bad_name(input, race::allow_numbers_in_name || allow_numbers)

/datum/preference/name/real_name/is_valid(value, datum/preferences/preferences)
	var/datum/species/race = preferences.read_preference(/datum/preference/choiced/species)
	return istext(value) && !isnull(reject_bad_name(value, race::allow_numbers_in_name || allow_numbers))

/datum/preference/name/backup_human/deserialize(input, datum/preferences/preferences)
	return reject_bad_name(input, allow_numbers)

/datum/preference/name/animal
	savefile_key = "animal_name"
	explanation = "Animal name"
	group = "fun"
	relevant_job = /datum/job/animal

/datum/preference/name/animal/create_default_value()
	return pick(GLOB.animal_names)

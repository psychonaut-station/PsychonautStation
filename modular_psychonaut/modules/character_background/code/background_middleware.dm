/datum/preference_middleware/background
	action_delegations = list(
		"set_background_data" = PROC_REF(set_background_data),
	)

/datum/preference_middleware/background/get_ui_data(mob/user)
	if (preferences.current_window != PREFERENCE_TAB_CHARACTER_PREFERENCES)
		return list()

	var/list/data = list()

	data["character_desc"] = preferences.read_preference(/datum/preference/background_data/character_desc)
	data["medical_records"] = preferences.read_preference(/datum/preference/background_data/medical_records)
	data["security_records"] = preferences.read_preference(/datum/preference/background_data/security_records)
	data["employment_records"] = preferences.read_preference(/datum/preference/background_data/employment_records)
	data["exploit_records"] = preferences.read_preference(/datum/preference/background_data/exploit_records)

	return data

/datum/preference_middleware/background/get_ui_static_data(mob/user)
	if (preferences.current_window != PREFERENCE_TAB_CHARACTER_PREFERENCES)
		return list()

	var/list/data = list()
	data["max_background_charlength"] = CONFIG_GET(number/maximum_background_charlength)
	return data

/datum/preference_middleware/background/proc/set_background_data(list/params, mob/user)
	var/value = params["value"]
	var/datum/preference/background_data/background_preference = GLOB.preference_entries_by_key[params["preference"]]
	if (!istype(background_preference))
		return FALSE

	return preferences.update_preference(background_preference, value)

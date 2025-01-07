/datum/preference_middleware/background
	action_delegations = list(
		"set_background_data" = PROC_REF(set_background_data),
	)

/datum/preference_middleware/background/get_ui_data(mob/user)
	if (preferences.current_window != PREFERENCE_TAB_CHARACTER_PREFERENCES)
		return list()

	var/list/data = list()

	data["background_info"] = preferences.background_info

	return data

/datum/preference_middleware/background/proc/set_background_data(list/params, mob/user)
	var/key = params["key"]
	preferences.background_info[key] = params["value"]
	return TRUE

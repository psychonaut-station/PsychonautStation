/datum/preference_middleware/background
	action_delegations = list(
		"character_desc" = PROC_REF(set_character_desc),
		"medical_records" = PROC_REF(set_medical_records),
		"security_records" = PROC_REF(set_security_records),
		"employment_records" = PROC_REF(set_employment_records),
		"exploit_records" = PROC_REF(set_exploit_records),
	)

/datum/preference_middleware/background/get_ui_data(mob/user)
	if (preferences.current_window != PREFERENCE_TAB_CHARACTER_PREFERENCES)
		return list()

	return preferences.background_info

/datum/preference_middleware/background/proc/set_character_desc(list/params, mob/user)
	var/value = params["value"]
	if(!is_valid(value))
		tgui_alert(user, "The number of characters of the value must be less than 256!")
		return FALSE
	preferences.background_info["character_desc"] = value
	return TRUE

/datum/preference_middleware/background/proc/set_medical_records(list/params, mob/user)
	var/value = params["value"]
	if(!is_valid(value))
		tgui_alert(user, "The number of characters of the value must be less than 256!")
		return FALSE
	preferences.background_info["medical_records"] = value
	return TRUE

/datum/preference_middleware/background/proc/set_security_records(list/params, mob/user)
	var/value = params["value"]
	if(!is_valid(value))
		tgui_alert(user, "The number of characters of the value must be less than 256!")
		return FALSE
	preferences.background_info["security_records"] = value
	return TRUE

/datum/preference_middleware/background/proc/set_employment_records(list/params, mob/user)
	var/value = params["value"]
	if(!is_valid(value))
		tgui_alert(user, "The number of characters of the value must be less than 256!")
		return FALSE
	preferences.background_info["employment_records"] = value
	return TRUE

/datum/preference_middleware/background/proc/set_exploit_records(list/params, mob/user)
	var/value = params["value"]
	if(!is_valid(value))
		tgui_alert(user, "The number of characters of the value must be less than 256!")
		return FALSE
	preferences.background_info["exploit_records"] = value
	return TRUE

/datum/preference_middleware/background/proc/is_valid(value)
	if(!istext(value) || length(value) > 256)
		return FALSE
	return TRUE

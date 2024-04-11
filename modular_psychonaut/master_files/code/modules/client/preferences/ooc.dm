/datum/preference/toggle/enable_looc
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "chat_looc"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/enable_looc/create_default_value()
	return TRUE

/datum/preference/toggle/enable_looc/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return TRUE

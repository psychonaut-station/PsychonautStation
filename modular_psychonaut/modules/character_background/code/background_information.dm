/datum/preference/background_data
	category = "background_info"
	abstract_type = /datum/preference/background_data
	priority = PREFERENCE_PRIORITY_BACKGROUND_INFORMATION
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/background_data/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/background_data/deserialize(input, datum/preferences/preferences)
	return STRIP_HTML_LOCALE_FULL(input, CONFIG_GET(number/maximum_background_charlength)+1)

/datum/preference/background_data/create_default_value()
	return ""

/datum/preference/background_data/is_valid(value)
	return istext(value) && length_char(value) <= CONFIG_GET(number/maximum_background_charlength)

/datum/preference/background_data/character_desc
	savefile_key = "character_desc"

/datum/preference/background_data/character_desc/apply_to_human(mob/living/carbon/human/target, value)
	target.flavor_text = value

/datum/preference/background_data/medical_records
	savefile_key = "medical_records"

/datum/preference/background_data/security_records
	savefile_key = "security_records"

/datum/preference/background_data/employment_records
	savefile_key = "employment_records"

/datum/preference/background_data/exploit_records
	savefile_key = "exploit_records"

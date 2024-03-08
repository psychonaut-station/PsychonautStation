
/datum/preference/choiced/arachnid_appendages
	savefile_key = "feature_arachnid_appendages"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Appendages"

/datum/preference/choiced/arachnid_appendages/init_possible_values()
	return assoc_to_keys_features(GLOB.arachnid_appendages_list)

/datum/preference/choiced/arachnid_appendages/create_default_value()
	return pick(assoc_to_keys_features(GLOB.arachnid_appendages_list))

/datum/preference/choiced/arachnid_appendages/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["arachnid_appendages"] = value

/datum/preference/choiced/arachnid_chelicerae
	savefile_key = "feature_arachnid_chelicerae"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Chelicerae"

/datum/preference/choiced/arachnid_chelicerae/init_possible_values()
	return assoc_to_keys_features(GLOB.arachnid_chelicerae_list)

/datum/preference/choiced/arachnid_chelicerae/create_default_value()
	return pick(assoc_to_keys_features(GLOB.arachnid_chelicerae_list))

/datum/preference/choiced/arachnid_chelicerae/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["arachnid_chelicerae"] = value

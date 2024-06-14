/datum/preference/choiced/arachnid_appendages
	savefile_key = "feature_arachnid_appendages"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	main_feature_name = "Appendages"
	relevant_external_organ = /obj/item/organ/external/arachnid_appendages

/datum/preference/choiced/arachnid_appendages/init_possible_values()
	return assoc_to_keys_features(SSaccessories.arachnid_appendages_list)

/datum/preference/choiced/arachnid_appendages/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["arachnid_appendages"] = value

/datum/preference/choiced/arachnid_appendages/create_default_value()
	return /datum/sprite_accessory/arachnid_appendages/long::name


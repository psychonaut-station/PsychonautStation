/datum/preference/choiced/species_feature/arachnid_appendages
	savefile_key = "feature_arachnid_appendages"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	main_feature_name = "Appendages"
	relevant_organ = /obj/item/organ/arachnid_appendages

/datum/preference/choiced/species_feature/arachnid_appendages/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features[FEATURE_ARACHNID_APPENDAGES] = value

/datum/preference/choiced/species_feature/arachnid_appendages/create_default_value()
	return /datum/sprite_accessory/arachnid_appendages/long::name

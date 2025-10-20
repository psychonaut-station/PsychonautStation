/datum/dna_block/feature/arachnid_appendages
	feature_key = FEATURE_ARACHNID_APPENDAGES

/datum/dna_block/feature/arachnid_appendages/create_unique_block(mob/living/carbon/human/target)
	return construct_block(SSaccessories.arachnid_appendages_list.Find(target.dna.features[feature_key]), length(SSaccessories.arachnid_appendages_list))

/datum/dna_block/feature/arachnid_appendages/apply_to_mob(mob/living/carbon/human/target, dna_hash)
	target.dna.features[feature_key] = SSaccessories.arachnid_appendages_list[deconstruct_block(get_block(dna_hash), length(SSaccessories.arachnid_appendages_list))]

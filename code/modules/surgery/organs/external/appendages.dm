/obj/item/organ/arachnid_appendages
	name = "arachnid appendages"
	desc = "Extra legs that go on your back, don't actually work for walking sadly."

	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_EXTERNAL_APPENDAGES

	dna_block = /datum/dna_block/feature/arachnid_appendages
	restyle_flags = EXTERNAL_RESTYLE_FLESH
	use_mob_sprite_as_obj_sprite = TRUE

	bodypart_overlay = /datum/bodypart_overlay/mutant/arachnid_appendages

	organ_flags = parent_type::organ_flags | ORGAN_EXTERNAL

/datum/bodypart_overlay/mutant/arachnid_appendages
	layers = EXTERNAL_FRONT | EXTERNAL_BEHIND
	feature_key = FEATURE_ARACHNID_APPENDAGES

/datum/bodypart_overlay/mutant/arachnid_appendages/get_global_feature_list()
	return SSaccessories.arachnid_appendages_list

/datum/bodypart_overlay/mutant/arachnid_appendages/can_draw_on_bodypart(mob/living/carbon/human/human)
	return TRUE

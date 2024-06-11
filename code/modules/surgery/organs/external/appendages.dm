/obj/item/organ/external/arachnid_appendages
	name = "arachnid appendages"
	desc = "Extra legs that go on your back, don't actually work for walking sadly."

	preference = "feature_arachnid_appendages"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_EXTERNAL_WINGS
	dna_block = DNA_ARACHNID_APPENDAGES_BLOCK

	use_mob_sprite_as_obj_sprite = TRUE
	bodypart_overlay = /datum/bodypart_overlay/mutant/arachnid_appendages

/datum/bodypart_overlay/mutant/arachnid_appendages
	layers = EXTERNAL_FRONT | EXTERNAL_BEHIND
	feature_key = "arachnid_appendages"

/datum/bodypart_overlay/mutant/arachnid_appendages/get_global_feature_list()
	return SSaccessories.arachnid_appendages_list

/datum/bodypart_overlay/mutant/arachnid_appendages/can_draw_on_bodypart(mob/living/carbon/human/human)
	return TRUE

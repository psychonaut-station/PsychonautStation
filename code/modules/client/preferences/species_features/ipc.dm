/datum/preference/choiced/species_feature/ipc_chassis
	savefile_key = "feature_ipc_chassis"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	feature_key = FEATURE_IPC_CHASSIS
	main_feature_name = "Chassis"
	should_generate_icons = TRUE

/datum/preference/choiced/species_feature/ipc_chassis/has_relevant_feature(datum/preferences/preferences)
	return current_species_has_savekey(preferences)

/datum/preference/choiced/species_feature/ipc_chassis/icon_for(value)
	var/list/body_parts = list(
		BODY_ZONE_HEAD,
		BODY_ZONE_CHEST,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_PRECISE_L_HAND,
		BODY_ZONE_PRECISE_R_HAND,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
	)
	var/datum/sprite_accessory/chassis = get_accessory_for_value(value)
	var/datum/universal_icon/icon = uni_icon('icons/effects/effects.dmi', "nothing")

	for(var/body_part in body_parts)
		icon.blend_icon(uni_icon('icons/psychonaut/mob/human/species/ipc/bodyparts.dmi', "[chassis.icon_state]_[body_part]", dir = SOUTH), ICON_OVERLAY)

	return icon

/datum/preference/choiced/species_feature/ipc_chassis/apply_to_human(mob/living/carbon/human/target, value)
	. = ..()
	var/datum/sprite_accessory/ipc_chassis/chassis_of_choice = get_accessory_for_value(value)
	for(var/obj/item/bodypart/bodypart as anything in target.bodyparts) //Override bodypart data as necessary
		if(isipc(target))
			bodypart.icon = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
			bodypart.change_appearance('icons/psychonaut/mob/human/species/ipc/bodyparts.dmi', chassis_of_choice.icon_state, (chassis_of_choice.color_src == MUTANT_COLOR), FALSE)
			bodypart.update_limb()

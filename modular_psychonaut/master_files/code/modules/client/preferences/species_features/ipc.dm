/datum/preference/choiced/ipc_chassis
	savefile_key = "feature_ipc_chassis"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Chassis"
	should_generate_icons = TRUE
	relevant_body_markings = /datum/bodypart_overlay/simple/body_marking/ipc

/datum/preference/choiced/ipc_chassis/has_relevant_feature(datum/preferences/preferences)
	return current_species_has_savekey(preferences)

/datum/preference/choiced/ipc_chassis/init_possible_values()
	return assoc_to_keys_features(SSaccessories.ipc_chassis_list)

/datum/preference/choiced/ipc_chassis/icon_for(value)
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
	var/datum/sprite_accessory/chassis = SSaccessories.ipc_chassis_list[value]
	var/datum/universal_icon/icon_with_chassis = uni_icon('icons/effects/effects.dmi', "nothing")

	for (var/body_part in body_parts)
		icon_with_chassis.blend_icon(uni_icon('modular_psychonaut/master_files/icons/mob/human/species/ipc/bodyparts.dmi', "[chassis.icon_state]_[body_part]", dir = SOUTH), ICON_OVERLAY)

	return icon_with_chassis

/datum/preference/choiced/ipc_chassis/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features[FEATURE_IPC_CHASSIS] = value

/datum/preference/choiced/ipc_chassis/create_default_value()
	return /datum/sprite_accessory/ipc_chassis/black::name

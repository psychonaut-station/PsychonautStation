/datum/preference/choiced/ipc_chassis
	savefile_key = "feature_ipc_chassis"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Chassis"
	should_generate_icons = TRUE
	relevant_mutant_bodypart = "ipc_chassis"

/datum/preference/choiced/ipc_chassis/init_possible_values()
	return assoc_to_keys(GLOB.ipc_chassis_list)

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
	var/datum/sprite_accessory/chassis = GLOB.ipc_chassis_list[value]
	var/icon/icon_with_chassis = icon('icons/effects/effects.dmi', "nothing")

	for (var/body_part in body_parts)
		icon_with_chassis.Blend(icon('icons/mob/human/species/ipc/bodyparts.dmi', "[chassis.limbs_id]_[body_part]", dir = SOUTH), ICON_OVERLAY)

	return icon_with_chassis

/datum/preference/choiced/ipc_chassis/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["ipc_monitor"] = value
	target.dna.features["ipc_chassis"] = value
	var/datum/sprite_accessory/ipc_chassis/chassis_of_choice = GLOB.ipc_chassis_list[value]
	for(var/obj/item/bodypart/BP as() in target.bodyparts) //Override bodypart data as necessary
		if(isipc(target))
			BP.icon = 'icons/mob/human/species/ipc/bodyparts.dmi'
			BP.change_appearance('icons/mob/human/species/ipc/bodyparts.dmi', chassis_of_choice.limbs_id, FALSE, FALSE)
			BP.name = "\improper[chassis_of_choice.name] [parse_zone(BP.body_zone)]"
			BP.update_limb()

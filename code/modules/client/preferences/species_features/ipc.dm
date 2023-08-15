/datum/preference/choiced/ipc_head
	savefile_key = "feature_ipc_monitor"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES

/datum/preference/choiced/ipc_head/init_possible_values()
	return assoc_to_keys_features(GLOB.ipc_monitor_list)

/datum/preference/choiced/ipc_head/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["ipc_monitor"] = value

/datum/preference/choiced/ipc_head/create_default_value()
	var/datum/sprite_accessory/ipc_monitor/monitor = /datum/sprite_accessory/ipc_monitor/black
	return initial(monitor.name)

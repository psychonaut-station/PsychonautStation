/datum/preference/choiced/ipc_head
	savefile_key = "feature_ipc_monitor"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Ipc Monitor"
	should_generate_icons = TRUE

/datum/preference/choiced/ipc_head/init_possible_values()
	var/list/values = list()

	var/icon/ipchead = icon('icons/mob/human/species/ipc/bodyparts.dmi', "ipcs_head")

	for (var/monitor_name in GLOB.ipc_monitor_list)
		var/datum/sprite_accessory/ipc_monitor/monitor = GLOB.ipc_monitor_list[monitor_name]
		var/icon/icon_with_monitor = new(ipchead)
		icon_with_monitor.Blend(icon(monitor.icon, "m_ipc_monitor_[monitor.icon_state]_FRONT"), ICON_OVERLAY)
		icon_with_monitor.Scale(64, 64)
		icon_with_monitor.Crop(15, 64, 15 + 31, 64 - 31)

		values[monitor.name] = icon_with_monitor

	return values

/datum/preference/choiced/ipc_head/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["ipc_monitor"] = value

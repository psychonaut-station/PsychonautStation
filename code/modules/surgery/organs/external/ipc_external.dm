//Ipc head organ
/obj/item/organ/external/ipchead
	name = "ipc monitor"
	desc = "IPC Head Monitor"

	use_mob_sprite_as_obj_sprite = TRUE
	icon = 'icons/mob/human/species/ipc/ipc_screens.dmi'
	icon_state = "m_ipc_monitor_blackhead_FRONT"

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_IPC_MONITOR

	preference = "feature_ipc_monitor"

	bodypart_overlay = /datum/bodypart_overlay/mutant/ipchead
	actions_types = list(/datum/action/innate/change_monitor)

/datum/bodypart_overlay/mutant/ipchead
	layers = EXTERNAL_FRONT
	feature_key = "ipc_monitor"
	color_source = NONE

/datum/bodypart_overlay/mutant/ipchead/get_global_feature_list()
	return GLOB.ipc_monitor_list

//Screen
/datum/bodypart_overlay/simple/ipcscreen
	icon = 'icons/mob/human/species/ipc/ipc_screens.dmi'
	layers = EXTERNAL_FRONT
	var/attached_body_zone = BODY_ZONE_HEAD

/datum/bodypart_overlay/simple/ipcscreen/ipcoff
	icon_state = "ipc-off"

/datum/bodypart_overlay/simple/ipcscreen/ipcsmile
	icon_state = "ipc-smile"

/datum/bodypart_overlay/simple/ipcscreen/ipcuwu
	icon_state = "ipc-uwu"

/datum/bodypart_overlay/simple/ipcscreen/ipcnull
	icon_state = "ipc-null"

/datum/bodypart_overlay/simple/ipcscreen/ipcalert
	icon_state = "ipc-alert"

/datum/bodypart_overlay/simple/ipcscreen/ipccool
	icon_state = "ipc-cool"

/datum/bodypart_overlay/simple/ipcscreen/ipcdead
	icon_state = "ipc-dead"

/datum/bodypart_overlay/simple/ipcscreen/ipcnt
	icon_state = "ipc-nt"

/datum/bodypart_overlay/simple/ipcscreen/ipcheartline
	icon_state = "ipc-heartline"

/datum/bodypart_overlay/simple/ipcscreen/ipcreddot
	icon_state = "ipc-reddot"

/datum/bodypart_overlay/simple/ipcscreen/ipcglitchman
	icon_state = "ipc-glitchman"

/datum/bodypart_overlay/simple/ipcscreen/ipcturk
	icon_state = "ipc-turk"

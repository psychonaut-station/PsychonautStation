// tube monitor for ipc. I wonder if it explodes like in real life?
/obj/item/organ/external/ipchead
	name = "ipc monitor"
	desc = "Tube monitor of an IPC. I wonder if it explodes like in real life?"

	use_mob_sprite_as_obj_sprite = TRUE
	icon = 'icons/psychonaut/mob/human/species/ipc/ipc_screens.dmi'
	icon_state = "m_ipc_monitor_blackipc_FRONT"

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_IPC_MONITOR
	organ_flags = ORGAN_ROBOTIC

	preference = "feature_ipc_chassis"

	bodypart_overlay = /datum/bodypart_overlay/mutant/ipchead
	actions_types = list(/datum/action/innate/change_monitor)

/obj/item/organ/external/ipchead/black
	sprite_accessory_override = /datum/sprite_accessory/ipc_monitor/black

/datum/bodypart_overlay/mutant/ipchead
	layers = EXTERNAL_ADJACENT
	feature_key = "ipc_monitor"
	color_source = NONE

/datum/bodypart_overlay/mutant/ipchead/can_draw_on_bodypart(mob/living/carbon/human/human)
	if((human.head?.flags_inv & HIDEHAIR) || (human.wear_mask?.flags_inv & HIDEHAIR))
		return FALSE

	return TRUE

/datum/bodypart_overlay/mutant/ipchead/get_global_feature_list()
	return GLOB.ipc_monitor_list

//Screen
/datum/bodypart_overlay/simple/ipcscreen
	icon = 'icons/psychonaut/mob/human/species/ipc/ipc_screens.dmi'
	layers = EXTERNAL_ADJACENT
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

/datum/bodypart_overlay/simple/ipcscreen/ipcclown
	icon_state = "ipc-clown"

/datum/bodypart_overlay/simple/ipcscreen/ipcmime
	icon_state = "ipc-mime"

/datum/bodypart_overlay/simple/ipcscreen/ipcpinball
	icon_state = "ipc-pinball"

/datum/bodypart_overlay/simple/ipcscreen/ipcnoerp
	icon_state = "ipc-noerp"

/datum/bodypart_overlay/simple/ipcscreen/ipcpaicat
	icon_state = "ipc-paicat"

/datum/bodypart_overlay/simple/ipcscreen/ipcskull
	icon_state = "ipc-skull"

/datum/bodypart_overlay/simple/ipcscreen/ipcmonkey
	icon_state = "ipc-monkey"

/datum/bodypart_overlay/simple/ipcscreen/ipcnerd
	icon_state = "ipc-nerd"

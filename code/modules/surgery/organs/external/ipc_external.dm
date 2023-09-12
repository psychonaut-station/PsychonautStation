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
	var/emagged = FALSE

/obj/item/organ/external/ipchead/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ATOM_EMAG_ACT, PROC_REF(on_emag_act))

/obj/item/organ/external/ipchead/Insert(mob/living/carbon/receiver, special, drop_if_replaced)
	. = ..()
	RegisterSignal(receiver, COMSIG_ATOM_EMAG_ACT, PROC_REF(on_emag_act))
	receiver.dna.species.update_no_equip_flags(receiver, ITEM_SLOT_MASK)

/obj/item/organ/external/ipchead/Remove(mob/living/carbon/organ_owner, special, moving)
	. = ..()
	UnregisterSignal(organ_owner, COMSIG_ATOM_EMAG_ACT)
	organ_owner.dna.species.update_no_equip_flags(organ_owner, NONE)

/obj/item/organ/external/ipchead/proc/on_emag_act(mob/user)
	SIGNAL_HANDLER
	if(emagged)
		return FALSE
	emagged = TRUE
	if(user)
		to_chat(user, span_notice("You tap [owner] on the back with your card."))
	owner.visible_message(span_danger("2 protrusions appeared on [owner]'s head"))
	owner.dna.species.update_no_equip_flags(owner, NONE)
	return TRUE

/obj/item/organ/external/ipchead/black
	sprite_accessory_override = /datum/sprite_accessory/ipc_monitor/black

/datum/bodypart_overlay/mutant/ipchead
	layers = EXTERNAL_FRONT
	feature_key = "ipc_monitor"
	color_source = NONE

/datum/bodypart_overlay/mutant/ipchead/get_global_feature_list()
	return GLOB.ipc_monitor_list

//Screen
/datum/bodypart_overlay/simple/ipcscreen
	icon = 'icons/psychonaut/mob/human/species/ipc/ipc_screens.dmi'
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

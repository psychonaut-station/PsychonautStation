/datum/computer_file/program/ai_network_base
	downloader_category = PROGRAM_CATEGORY_SCIENCE
	program_open_overlay = "generic"
	ui_header = "power_norm.gif"
	can_run_on_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	program_flags = PROGRAM_ON_NTNET_STORE
	program_icon = "network-wired"

	/// IntelliCard currently inserted into this program.
	var/obj/item/aicard/stored_card

/datum/computer_file/program/ai_network_base/on_examine(obj/item/modular_computer/source, mob/user)
	var/list/examine_text = list()
	if(!stored_card)
		examine_text += "It has a slot installed for an intelliCard."
		return examine_text

	if(computer.Adjacent(user))
		examine_text += "It has a slot installed for an intelliCard which contains: [stored_card.name]"
	else
		examine_text += "It has a slot installed for an intelliCard, which appears to be occupied."
	examine_text += span_info("Alt-click the computer or use the interface to eject the intelliCard.")
	return examine_text

/datum/computer_file/program/ai_network_base/Destroy()
	if(stored_card)
		if(computer)
			stored_card.forceMove(computer.drop_location())
		stored_card = null
	return ..()

/datum/computer_file/program/ai_network_base/kill_program(mob/user)
	try_eject(forced = TRUE)
	return ..()

/datum/computer_file/program/ai_network_base/application_item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/aicard))
		return aicard_act(user, tool)
	return NONE

/datum/computer_file/program/ai_network_base/proc/aicard_act(mob/living/user, obj/item/aicard/used_aicard)
	if(!computer)
		return NONE
	if(stored_card)
		to_chat(user, span_warning("You try to insert \the [used_aicard] into \the [computer.name], but the slot is occupied."))
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(used_aicard, computer))
		return ITEM_INTERACT_BLOCKING

	stored_card = used_aicard
	to_chat(user, span_notice("You insert \the [used_aicard] into \the [computer.name]."))
	return ITEM_INTERACT_SUCCESS

/datum/computer_file/program/ai_network_base/try_eject(mob/living/user, forced = FALSE)
	if(!stored_card)
		if(user)
			to_chat(user, span_warning("There is no card in \the [computer.name]."))
		return FALSE

	if(user && computer.Adjacent(user))
		to_chat(user, span_notice("You remove [stored_card] from [computer.name]."))
		user.put_in_hands(stored_card)
	else
		stored_card.forceMove(computer.drop_location())

	stored_card = null
	return TRUE

/datum/computer_file/program/ai_network_base/proc/get_local_ainet()
	var/turf/computer_turf = get_turf(computer?.physical || computer)
	if(!computer_turf)
		return null
	var/obj/structure/ethernet_cable/ethernet_cable = locate(/obj/structure/ethernet_cable) in computer_turf
	return ethernet_cable?.network

/datum/computer_file/program/ai_network_base/proc/get_ainet(mob/user)
	var/datum/ai_network/network = get_local_ainet()
	if(network)
		return network
	if(isAI(user))
		var/mob/living/silicon/ai/ai_user = user
		return ai_user.ai_network
	return null

/datum/computer_file/program/ai_network_base/proc/get_ai(get_card = FALSE)
	if(get_card)
		return stored_card
	return stored_card?.AI

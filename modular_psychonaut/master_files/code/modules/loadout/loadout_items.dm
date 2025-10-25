/datum/loadout_item/get_item_information()
	if(donator_only)
		group = "Patreon"
	return ..()

/datum/loadout_item
	var/donator_only = FALSE

/datum/loadout_item/on_equip_item(obj/item/equipped_item, datum/preferences/preference_source, list/preference_list, mob/living/carbon/human/equipper, visuals_only)
	if(!isnull(equipped_item) && donator_only && !equipper.client?.patron)
		qdel(equipped_item)
		return NONE
	return ..()

/datum/loadout_item/head/donator
	abstract_type = /datum/loadout_item/head/donator
	additional_displayed_text = list("Patreon")
	donator_only = TRUE

// Testing
/datum/loadout_item/head/delinquent_cap
	additional_displayed_text = list("Patreon")
	donator_only = TRUE

/datum/loadout_item/glasses/donator
	abstract_type = /datum/loadout_item/glasses/donator
	additional_displayed_text = list("Patreon")
	donator_only = TRUE

/datum/loadout_item/accessory/donator
	abstract_type = /datum/loadout_item/accessory/donator
	additional_displayed_text = list("Patreon")
	donator_only = TRUE

/datum/loadout_item/neck/donator
	abstract_type = /datum/loadout_item/neck/donator
	additional_displayed_text = list("Patreon")
	donator_only = TRUE

/datum/loadout_item/inhand/donator
	abstract_type = /datum/loadout_item/inhand/donator
	additional_displayed_text = list("Patreon")
	donator_only = TRUE

/datum/loadout_item/pocket_items/donator
	abstract_type = /datum/loadout_item/pocket_items/donator
	additional_displayed_text = list("Patreon")
	donator_only = TRUE

/datum/preference_middleware/loadout/select_item(datum/loadout_item/selected_item)
	if(selected_item.donator_only && !preferences.parent.patron)
		return
	return ..()

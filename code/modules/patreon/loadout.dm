/datum/loadout_item
	var/donator_only = FALSE

/datum/loadout_item/on_equip_item(obj/item/equipped_item, datum/preferences/preference_source, list/preference_list, mob/living/carbon/human/equipper, visuals_only)
	if(!isnull(equipped_item) && donator_only && equipper.client && !is_patron(equipper))
		qdel(equipped_item)
		return NONE
	return ..()

/datum/loadout_item/head/donator
	donator_only = TRUE
	additional_displayed_text = list("Patreon")

// Testing
/datum/loadout_item/head/delinquent_cap
	donator_only = TRUE
	additional_displayed_text = list("Patreon")

/datum/loadout_item/glasses/donator
	donator_only = TRUE
	additional_displayed_text = list("Patreon")

/datum/loadout_item/accessory/donator
	donator_only = TRUE
	additional_displayed_text = list("Patreon")

/datum/loadout_item/neck/donator
	donator_only = TRUE
	additional_displayed_text = list("Patreon")

/datum/loadout_item/inhand/donator
	donator_only = TRUE
	additional_displayed_text = list("Patreon")

/datum/loadout_item/pocket_items/donator
	donator_only = TRUE
	additional_displayed_text = list("Patreon")

/datum/preference_middleware/loadout/select_item(datum/loadout_item/selected_item)
	if(selected_item.donator_only && !is_patron(preferences.parent))
		return
	return ..()

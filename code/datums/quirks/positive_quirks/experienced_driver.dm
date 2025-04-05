/datum/quirk/item_quirk/experienced_driver
	name = "Experienced Driver"
	desc = "Driving, repairing and sustaining a car is much easier to you."
	icon = FA_ICON_CAR
	value = 2
	mob_trait = TRAIT_EXP_DRIVER
	gain_text = span_notice("You feel more experienced about cars.")
	lose_text = span_danger("You feel more clueless about cars.")
	medical_record_text = "Patient shows unusual admiration to movable vehicles and can't stop talking about 'cars.'"

/datum/quirk/item_quirk/experienced_driver/add_unique(client/client_source)
	give_item_to_holder(/obj/item/choice_beacon/car, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

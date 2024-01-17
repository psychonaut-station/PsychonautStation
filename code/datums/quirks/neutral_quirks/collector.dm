/datum/quirk/item_quirk/collector
	name = "Collector"
	desc = "You love trading cards. If you can keep your trading cards until the end of the round, you can start the next shift with them"
	icon = FA_ICON_DIAMOND
	value = 0
	medical_record_text = "Patient loves to collect trading cards."
	mail_goodies = list(/obj/item/cardpack/series_one, /obj/item/cardpack/resin)

/datum/quirk/item_quirk/collector/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.load_trading_cards(client_source)

/mob/living/carbon/human/proc/format_trading_cards()
	var/trading_cards = ""
	var/list/cards = list()
	for(var/obj/item/tcgcard/card in gather_belongings())
		if(!cards.Find(card))
			trading_cards += "[card.format_card()];"
			cards += card
	return trading_cards

/mob/living/carbon/human/proc/load_trading_card(card_line, specified_char_index, binder)
	var/list/card_data = splittext(card_line, "|")
	if(LAZYLEN(card_data) != TCG_SAVE_LENGTH)
		return
	var/version = text2num(card_data[TCG_SAVE_VERS])
	if(!version || version != TCG_CURRENT_VERSION)
		return
	var/obj/item/tcgcard/card = new (get_turf(src), card_data[TCG_SAVE_SERIES], card_data[TCG_SAVE_ID])
	card.forceMove(binder)
	return TRUE

/mob/living/carbon/human/proc/load_trading_cards(client/client_source)
	if(!client_source.ckey || !mind?.original_character_slot_index || !has_quirk(/datum/quirk/item_quirk/collector))
		return

	var/path = "data/player_saves/[client_source.ckey[1]]/[client_source.ckey]/trading_cards.sav"
	var/loaded_char_slot = client_source.prefs.default_slot

	if(!loaded_char_slot || !fexists(path))
		return FALSE
	var/savefile/F = new /savefile(path)
	if(!F)
		return

	var/char_index = mind.original_character_slot_index

	var/cards_string = F["trading_card[char_index]"]
	var/valid_cards = ""

	var/card_lines = splittext(sanitize_text(cards_string), ";")
	if(length(card_lines) > 0)
		var/obj/item/storage/card_binder/binder = new (get_turf(src))
		var/where = equip_in_one_of_slots(binder, list(LOCATION_BACKPACK = ITEM_SLOT_BACK, LOCATION_HANDS = ITEM_SLOT_HANDS), qdel_on_fail = FALSE, indirect_action = TRUE)

		if(where == LOCATION_BACKPACK && back)
			back.atom_storage.show_contents(src)

		for(var/card_line in card_lines)
			if(load_trading_card(card_line, char_index, binder))
				valid_cards += "[card_line];"

	WRITE_FILE(F["trading_card[char_index]"], sanitize_text(valid_cards))

/mob/living/carbon/human/proc/save_trading_cards(nuke = FALSE)
	if(!ckey || !mind?.original_character_slot_index || !has_quirk(/datum/quirk/item_quirk/collector))
		return

	var/path = "data/player_saves/[ckey[1]]/[ckey]/trading_cards.sav"
	var/savefile/F = new /savefile(path)
	var/char_index = mind.original_character_slot_index

	if(nuke)
		WRITE_FILE(F["trading_card[char_index]"], "")
		return

	var/trading_cards = format_trading_cards()
	WRITE_FILE(F["trading_card[char_index]"], sanitize_text(trading_cards))

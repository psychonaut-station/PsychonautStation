/datum/controller/subsystem/persistence/proc/save_trading_cards()
	for(var/ckey in GLOB.joined_player_list)
		var/mob/living/carbon/human/ending_human = get_mob_by_ckey(ckey)
		if(!istype(ending_human) || !ending_human.mind?.original_character_slot_index || !ending_human.has_quirk(/datum/quirk/item_quirk/collector))
			continue

		var/mob/living/carbon/human/original_human = ending_human.mind.original_character.resolve()

		if(!original_human)
			continue

		if(original_human.stat == DEAD || original_human != ending_human)
			original_human.save_trading_cards(TRUE)
		else
			original_human.save_trading_cards()

/datum/tgs_chat_command/tgscheck
	name = "check"
	help_text = "Check round status"

/datum/tgs_chat_command/tgscheck/Run(datum/tgs_chat_user/sender, params)
	var/message_body = ""
	if (GLOB.round_id)
		message_body += "Round #[GLOB.round_id]: "

	message_body += "[GLOB.clients.len] kişi ile [SSmapping.current_map.map_name] haritasinda \
					[SSticker.HasRoundStarted() ? (SSticker.IsRoundInProgress() ? "devam etmekte" : "bitmek üzere") : "başlıyor"]."

	return new /datum/tgs_message_content(message_body)

// Bildirim
/datum/tgs_chat_command/bildirim
	name = "bildirim"
	help_text = "Yeni bir round başladığında özel olarak bildirim alabilmeni sağlıyor"

/datum/tgs_chat_command/bildirim/Run(datum/tgs_chat_user/sender, params)
	if(!CONFIG_GET(str_list/channel_announce_new_game))
		return new /datum/tgs_message_content("Sunucu bildirimleri kapalı.")

	for(var/member in SSdiscord.notify_members) // If they are in the list, take them out
		if(member == sender.mention)
			SSdiscord.notify_members -= sender.mention
			return new /datum/tgs_message_content("Yeni round başladığında artık bildirim almayacaksın")

	// If we got here, they arent in the list. Chuck 'em in!
	SSdiscord.notify_members += sender.mention
	return new /datum/tgs_message_content("Yeni round başladığında bildirim alacaksın")

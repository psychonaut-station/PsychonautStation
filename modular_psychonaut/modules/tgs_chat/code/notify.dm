/datum/tgs_chat_command/notify
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

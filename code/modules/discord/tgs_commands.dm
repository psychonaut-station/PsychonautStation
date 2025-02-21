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

<<<<<<< HEAD
/datum/tgs_chat_command/bildirim/Run(datum/tgs_chat_user/sender, params)
	if(!CONFIG_GET(string/channel_announce_new_game))
		return new /datum/tgs_message_content("Sunucu bildirimleri kapalı.")
=======
		if(GLOB.revdata.originmastercommit)
			msg += ", from origin commit: <[CONFIG_GET(string/githuburl)]/commit/[GLOB.revdata.originmastercommit]>"

		if(GLOB.revdata.testmerge.len)
			msg += "\n"
			for(var/datum/tgs_revision_information/test_merge/PR as anything in GLOB.revdata.testmerge)
				msg += "PR #[PR.number] at [copytext_char(PR.head_commit, 1, 9)] [PR.title].\n"
				if (PR.url)
					msg += "<[PR.url]>\n"
	return new /datum/tgs_message_content(msg.Join(""))

// Notify
/datum/tgs_chat_command/notify
	name = "notify"
	help_text = "Pings the invoker when the round ends"

/datum/tgs_chat_command/notify/Run(datum/tgs_chat_user/sender, params)
	if(!CONFIG_GET(str_list/channel_announce_new_game))
		return new /datum/tgs_message_content("Notifcations are currently disabled")
>>>>>>> f4b88965991eff53ea44b26de94339706d8fb591

	for(var/member in SSdiscord.notify_members) // If they are in the list, take them out
		if(member == sender.mention)
			SSdiscord.notify_members -= sender.mention
			return new /datum/tgs_message_content("Yeni round başladığında artık bildirim almayacaksın")

	// If we got here, they arent in the list. Chuck 'em in!
	SSdiscord.notify_members += sender.mention
	return new /datum/tgs_message_content("Yeni round başladığında bildirim alacaksın")

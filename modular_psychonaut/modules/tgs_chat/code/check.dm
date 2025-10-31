/datum/tgs_chat_command/tgscheck
	help_text = "Check round status"

/datum/tgs_chat_command/tgscheck/Run(datum/tgs_chat_user/sender, params)
	var/message_body = ""
	if (GLOB.round_id)
		message_body += "Round #[GLOB.round_id]: "

	message_body += "[GLOB.clients.len] kişi ile [SSmapping.current_map.map_name] haritasinda \
					[SSticker.HasRoundStarted() ? (SSticker.IsRoundInProgress() ? "devam etmekte" : "bitmek üzere") : "başlıyor"]."

	return new /datum/tgs_message_content(message_body)

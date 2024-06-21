/datum/tgs_chat_command/tgscheck/Run(datum/tgs_chat_user/sender, params)
	return new /datum/tgs_message_content("[GLOB.round_id ? "Round #[GLOB.round_id]: " : ""][GLOB.clients.len] kişi ile [SSmapping.config.map_name] haritasında [SSticker.HasRoundStarted() ? (SSticker.IsRoundInProgress() ? "devam etmekte" : "bitiyor") : "başlıyor"].")

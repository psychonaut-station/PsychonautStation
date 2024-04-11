/// Logging for messages sent in LOOC
/proc/log_looc(text, list/data)
	logger.Log(LOG_CATEGORY_GAME_LOOC, text, data)

/// Logging for e-jukebox
/proc/log_jukebox(text, list/data)
	logger.Log(LOG_CATEGORY_GAME_JUKEBOX, text, data)

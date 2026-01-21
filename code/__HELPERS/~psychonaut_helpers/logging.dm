/// Logging for e-jukebox
/proc/log_jukebox(text, list/data)
	logger.Log(LOG_CATEGORY_GAME_JUKEBOX, text, data)

/// Logging for messages sent in LOOC
/proc/log_looc(text, list/data)
	logger.Log(LOG_CATEGORY_GAME_LOOC, text, data)

/// Logging for hallucinations
/proc/log_hallucination(text, list/data)
	logger.Log(LOG_CATEGORY_GAME_HALLUCINATION, text, data)

/// Logging for storyteller procs
/proc/log_storyteller(text, list/data)
	logger.Log(LOG_CATEGORY_STORYTELLER, text, data)

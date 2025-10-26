/datum/tgui_window
	var/communication_locked = FALSE // bu tg'de yok bizde niye var bilmiyorum amk

/**
 * public
 *
 * Blocks all communication with the server until the window is closed or reloaded by browse()
 */
/datum/tgui_window/proc/lock_communication()
	if(!client || isnull(id))
		return
	communication_locked = TRUE
	client << output("", is_browser \
		? "[id]:lock_communication" \
		: "[id].browser:lock_communication")

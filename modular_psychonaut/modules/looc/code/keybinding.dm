/datum/keybinding/client/communication/looc
	hotkey_keys = list("L")
	name = LOOC_CHANNEL
	full_name = "Local Out Of Character Say (LOOC)"
	keybind_signal = COMSIG_KB_CLIENT_LOOC_DOWN

/datum/keybinding/client/communication/looc/down(client/user)
	. = ..()
	if(.)
		return
	winset(user, null, "command=[user.tgui_say_create_open_command(LOOC_CHANNEL)]")
	return TRUE

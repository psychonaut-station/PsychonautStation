/datum/keybinding/living/face_cursor
	hotkey_keys = list("Unbound")
	name = "face_cursor"
	full_name = "Face Cursor"
	description = "Hold for face to cursor."
	keybind_signal = COMSIG_KB_LIVING_FACECURSOR_DOWN

/datum/keybinding/living/face_cursor/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/M = user.mob
	M.face_mouse = TRUE

/datum/keybinding/living/face_cursor/up(client/user)
	. = ..()
	if(.)
		return
	var/mob/M = user.mob
	M.face_mouse = FALSE

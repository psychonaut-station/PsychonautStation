#define TGUI_PANEL_MAX_EMOTES 45
#define TGUI_PANEL_MAX_EMOTE_LENGTH 128
#define TGUI_PANEL_MAX_EMOTE_NAME_LENGTH 32
#define SHORT_EMOTE_MAX_LENGTH 40
#define CUSTOM_SHORT_EMOTE_COOLDOWN 0.4 SECONDS
#define CUSTOM_EMOTE_COOLDOWN 1 SECONDS

#define DELETE_EMOTE "Delete"
#define RENAME_EMOTE "Rename"
#define CUSTOMIZE_EMOTE "Customize"
#define CHANGE_EMOTE_TEXT "Change Text"
#define CANCEL_EMOTE_ADDITION "Adding emote cancelled."

/mob/living
	var/next_sound_emote

/datum/tgui_panel
	var/static/list/all_emotes = list()
	var/list/blacklisted_emote_types = list(
		/datum/emote/help,
		/datum/emote/living/custom,
		/datum/emote/imaginary_friend,
		)


// GLOB.emote_list
/datum/tgui_panel/proc/populate_all_emotes_list()
	if(length(all_emotes))
		return
	for(var/emote_key in GLOB.emote_list)
		var/list/emote_list = GLOB.emote_list[emote_key]
		for(var/datum/emote/emote in emote_list)
			if(is_type_in_list(emote, blacklisted_emote_types))
				continue

			if(emote_key != emote.key)
				continue

			all_emotes += emote

/datum/tgui_panel/proc/get_cached_all_emotes()
	if(!length(all_emotes))
		populate_all_emotes_list()
	return all_emotes

/datum/tgui_panel/New(client/client, id)
	. = ..()
	populate_all_emotes_list()

/datum/tgui_panel/on_message(type, payload)
	. = ..()

	if(!client?.prefs)
		return

	if(. && type == "ready")
		emotes_send_list()

	if(.)
		return


	switch(type)
		if("emotes/execute")
			if(!islist(payload))
				return

			var/emote_name = payload["name"]
			if(!emote_name || !istext(emote_name) || !length(emote_name))
				return

			if(isnull(client.prefs.custom_emote_panel[emote_name]))
				to_chat(client, span_warning("Emote [emote_name] is not in your panel!"))
				return FALSE

			if(isnull(client.prefs.custom_emote_panel[emote_name]["type"]))
				to_chat(client, span_warning("Emote [emote_name] has no type!"))
				return FALSE

			var/emote_type = client.prefs.custom_emote_panel[emote_name]["type"]
			if(!isliving(client.mob))
				return TRUE

			var/mob/living/living = client.mob
			switch (emote_type)
				if(TGUI_PANEL_EMOTE_TYPE_DEFAULT)
					var/emote_key = client.prefs.custom_emote_panel[emote_name]["key"]
					living.emote(emote_key, intentional = TRUE)

				//To prevent users from spamming 128 character messages at very high speed.
				if(TGUI_PANEL_EMOTE_TYPE_CUSTOM)
					if(living.next_sound_emote >= world.time)
						to_chat(living, span_warning("Not so fast!"))
						return TRUE

					var/emote_key = client.prefs.custom_emote_panel[emote_name]["key"]
					var/message_override = client.prefs.custom_emote_panel[emote_name]["message_override"]
					living.emote(emote_key, intentional = TRUE, message_override = message_override)
					handle_panel_cooldown(living, message_override)

				if(TGUI_PANEL_EMOTE_TYPE_ME)
					if(living.next_sound_emote >= world.time)
						to_chat(living, span_warning("Not so fast!"))
						return TRUE

					var/message = client.prefs.custom_emote_panel[emote_name]["message"]
					living.emote("me", intentional = TRUE, message = message)
					handle_panel_cooldown(living, message)

			return TRUE

		if("emotes/create")
			if(length(client.prefs.custom_emote_panel) > TGUI_PANEL_MAX_EMOTES)
				to_chat(client, span_warning("Maximum number of emotes reached: [TGUI_PANEL_MAX_EMOTES]."))
				return

			var/list/emote = list()
			var/emote_type_string = tgui_alert(client.mob, "What emote would you like to add to the panel?", "Choose emote type", list("Default", "Custom text", "*me"))
			if(!emote_type_string)
				to_chat(client, span_warning(CANCEL_EMOTE_ADDITION))
				return

			var/suggested_name = ""
			switch (emote_type_string)
				if("Default")
					var/list/available_emotes = get_cached_all_emotes()
					if(!length(available_emotes))
						to_chat(client, span_warning("No emotes are currently available to add."))
						return

					var/datum/emote/picked_emote = tgui_input_list(client.mob, "What emote would you like to add to the panel?", "Choose emote", available_emotes)
					if(!picked_emote)
						to_chat(client, span_warning(CANCEL_EMOTE_ADDITION))
						return

					var/emote_key = picked_emote.key
					if(!(emote_key in GLOB.emote_list))
						to_chat(client, span_warning("Emote [emote_key] does not exist!"))
						return

					suggested_name = picked_emote.name
					emote = list(
						"type" = TGUI_PANEL_EMOTE_TYPE_DEFAULT,
						"key" = emote_key,
					)

				if("Custom text")
					var/list/available_emotes = get_cached_all_emotes()
					if(!length(available_emotes))
						to_chat(client, span_warning("No emotes are currently available to add."))
						return

					var/datum/emote/picked_emote = tgui_input_list(client.mob, "What emote would you like to add to the panel?", "Choose emote", available_emotes)
					if(!picked_emote)
						to_chat(client, span_warning(CANCEL_EMOTE_ADDITION))
						return

					var/emote_key = picked_emote.key
					if(!(emote_key in GLOB.emote_list))
						to_chat(client, span_warning("Emote [emote_key] does not exist!"))
						return

					var/message_override = tgui_input_text(client.mob, "What custom text would you like for the emote? (max [TGUI_PANEL_MAX_EMOTE_LENGTH] characters)", "Custom text", picked_emote.name, TGUI_PANEL_MAX_EMOTE_LENGTH, TRUE, TRUE)
					if(!message_override)
						to_chat(client, span_warning(CANCEL_EMOTE_ADDITION))
						return

					suggested_name = picked_emote.name
					emote = list(
						"type" = TGUI_PANEL_EMOTE_TYPE_CUSTOM,
						"key" = emote_key,
						"message_override" = message_override,
					)

				if("*me")
					var/message = tgui_input_text(client.mob, "What text would you like for the emote? (max [TGUI_PANEL_MAX_EMOTE_LENGTH] characters)", "Custom text", "", TGUI_PANEL_MAX_EMOTE_LENGTH, TRUE, TRUE)
					if(!message)
						to_chat(client, span_warning(CANCEL_EMOTE_ADDITION))
						return

					suggested_name = copytext_char(message, 1, TGUI_PANEL_MAX_EMOTE_NAME_LENGTH + 1)
					emote = list(
						"type" = TGUI_PANEL_EMOTE_TYPE_ME,
						"message" = message,
					)

			var/emote_name = tgui_input_text(client.mob, "What name would you like for the emote in the panel?", "Emote name", suggested_name, TGUI_PANEL_MAX_EMOTE_NAME_LENGTH, FALSE, TRUE)
			if(!emote_name)
				to_chat(client, span_warning(CANCEL_EMOTE_ADDITION))
				return

			if(emote_name in client.prefs.custom_emote_panel)
				to_chat(client, span_warning("Emote \"[emote_name]\" already exists!"))
				return

			client.prefs.custom_emote_panel[emote_name] = emote
			client.prefs.save_preferences()
			emotes_send_list()

			return TRUE

		if("emotes/contextAction")
			if(!islist(payload))
				return

			var/emote_name = payload["name"]
			if(!emote_name || !istext(emote_name) || !length(emote_name))
				return

			if(isnull(client.prefs.custom_emote_panel[emote_name]))
				to_chat(client, span_warning("Emote [emote_name] is not in your panel!"))
				return FALSE

			var/emote_type = client.prefs.custom_emote_panel[emote_name]["type"] ? client.prefs.custom_emote_panel[emote_name]["type"] : TGUI_PANEL_EMOTE_TYPE_UNKNOWN
			var/list/actions = list()
			switch (emote_type)
				if(TGUI_PANEL_EMOTE_TYPE_DEFAULT)
					actions.Add(list(RENAME_EMOTE, CUSTOMIZE_EMOTE, DELETE_EMOTE))

				if(TGUI_PANEL_EMOTE_TYPE_CUSTOM)
					actions.Add(list(RENAME_EMOTE, CHANGE_EMOTE_TEXT, DELETE_EMOTE))

				if(TGUI_PANEL_EMOTE_TYPE_ME)
					actions.Add(list(RENAME_EMOTE, CHANGE_EMOTE_TEXT, DELETE_EMOTE))

				if(TGUI_PANEL_EMOTE_TYPE_UNKNOWN)
					to_chat(client, span_warning("This emote has no type, so it can only be deleted."))
					actions.Add(list(DELETE_EMOTE))

			var/action = tgui_alert(client.mob, "What would you like to do with emote \"[emote_name]\"?", "Choose action", actions)

			switch (action)
				if(DELETE_EMOTE)
					if(emotes_remove(emote_name))
						client.prefs.save_preferences()
						emotes_send_list()
				if(RENAME_EMOTE)
					if(emotes_rename(emote_name))
						client.prefs.save_preferences()
						emotes_send_list()
				if(CUSTOMIZE_EMOTE)
					if(emotes_add_custom_text(emote_name))
						client.prefs.save_preferences()
						emotes_send_list()
				if(CHANGE_EMOTE_TEXT)
					if(emotes_change_custom_text(emote_name))
						client.prefs.save_preferences()
						emotes_send_list()

			return TRUE

/datum/tgui_panel/proc/handle_panel_cooldown(mob/living/living, message)
	if(length_char(message) > SHORT_EMOTE_MAX_LENGTH)
		living.next_sound_emote = max(living.next_sound_emote, world.time + CUSTOM_EMOTE_COOLDOWN)
	else
		living.next_sound_emote = max(living.next_sound_emote, world.time + CUSTOM_SHORT_EMOTE_COOLDOWN)

/datum/tgui_panel/proc/emotes_rename(emote_name)
	var/new_emote_name = tgui_input_text(client.mob, "What new name would you like for emote [emote_name]?", "Emote name", emote_name, TGUI_PANEL_MAX_EMOTE_NAME_LENGTH, FALSE, TRUE)
	if(!new_emote_name)
		return FALSE
	if(new_emote_name == emote_name)
		to_chat(client, span_notice("Rename cancelled"))
		return FALSE
	if(new_emote_name in client.prefs.custom_emote_panel)
		to_chat(client, span_warning("Emote \"[new_emote_name]\" already exists!"))
		return FALSE

	var/list/emote = client.prefs.custom_emote_panel[emote_name]
	client.prefs.custom_emote_panel[new_emote_name] = emote
	client.prefs.custom_emote_panel.Remove(emote_name)

	return TRUE

/datum/tgui_panel/proc/emotes_remove(emote_name)
	client.prefs.custom_emote_panel.Remove(emote_name)
	return TRUE

/datum/tgui_panel/proc/emotes_add_custom_text(emote_name)
	if(isnull(client.prefs.custom_emote_panel[emote_name]))
		to_chat(client, span_warning("Emote [emote_name] is not in your panel!"))
		return FALSE

	var/emote_type = client.prefs.custom_emote_panel[emote_name]["type"]
	if(emote_type != TGUI_PANEL_EMOTE_TYPE_DEFAULT)
		to_chat(client, span_warning("You can only add text to default emotes!"))
		return FALSE

	var/message_override = tgui_input_text(client.mob, "What new custom text would you like for emote [emote_name]?", "Custom text", "", TGUI_PANEL_MAX_EMOTE_LENGTH, TRUE, TRUE)
	if(!message_override)
		return FALSE

	client.prefs.custom_emote_panel[emote_name]["type"] = TGUI_PANEL_EMOTE_TYPE_CUSTOM
	client.prefs.custom_emote_panel[emote_name]["message_override"] = message_override
	return TRUE

/datum/tgui_panel/proc/emotes_change_custom_text(emote_name)
	if(isnull(client.prefs.custom_emote_panel[emote_name]))
		to_chat(client, span_warning("Emote [emote_name] is not in your panel!"))
		return FALSE

	var/emote_type = client.prefs.custom_emote_panel[emote_name]["type"]
	var/old_message = "???"
	if(emote_type == TGUI_PANEL_EMOTE_TYPE_CUSTOM)
		old_message = client.prefs.custom_emote_panel[emote_name]["message_override"]
	else if(emote_type == TGUI_PANEL_EMOTE_TYPE_ME)
		old_message = client.prefs.custom_emote_panel[emote_name]["message"]
	else
		to_chat(client, span_warning("This emote doesn't have custom text yet!"))
		return FALSE

	var/message_override = tgui_input_text(client.mob, "What new custom text would you like for emote [emote_name]?", "Custom text", old_message, TGUI_PANEL_MAX_EMOTE_LENGTH, TRUE, TRUE)
	if(!message_override)
		return FALSE

	if(emote_type == TGUI_PANEL_EMOTE_TYPE_CUSTOM)
		client.prefs.custom_emote_panel[emote_name]["message_override"] = message_override
	else
		client.prefs.custom_emote_panel[emote_name]["message"] = message_override

	return TRUE

/datum/tgui_panel/proc/check_emote_usability(emote_key)
	if(!client?.mob)
		return FALSE

	if(!(emote_key in GLOB.emote_list))
		return FALSE

	var/list/emote_list = GLOB.emote_list[emote_key]

	for(var/datum/emote/emote in emote_list)
		if(emote.key != emote_key)
			continue
		if(emote.can_run_emote(client.mob, status_check = TRUE, intentional = TRUE))
			return TRUE

	return FALSE

/datum/tgui_panel/proc/emotes_send_list()
	var/list/payload = list()
	var/has_mob = isliving(client.mob)

	for(var/emote_name in client.prefs.custom_emote_panel)
		var/list/emote_data = client.prefs.custom_emote_panel[emote_name]

		var/emote_type = emote_data["type"]
		var/usable = FALSE

		if(has_mob)
			switch(emote_type)
				if(TGUI_PANEL_EMOTE_TYPE_DEFAULT, TGUI_PANEL_EMOTE_TYPE_CUSTOM)
					usable = check_emote_usability(emote_data["key"])
				if(TGUI_PANEL_EMOTE_TYPE_ME)
					usable = TRUE

		emote_data["usable"] = usable

		payload[emote_name] = emote_data

	window.send_message("emotes/setList", payload)

#undef TGUI_PANEL_MAX_EMOTES
#undef TGUI_PANEL_MAX_EMOTE_LENGTH
#undef TGUI_PANEL_MAX_EMOTE_NAME_LENGTH
#undef SHORT_EMOTE_MAX_LENGTH
#undef CUSTOM_SHORT_EMOTE_COOLDOWN
#undef CUSTOM_EMOTE_COOLDOWN

#undef DELETE_EMOTE
#undef RENAME_EMOTE
#undef CUSTOMIZE_EMOTE
#undef CHANGE_EMOTE_TEXT
#undef CANCEL_EMOTE_ADDITION

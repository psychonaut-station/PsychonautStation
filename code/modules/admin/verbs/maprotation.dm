ADMIN_VERB(admin_change_map, R_SERVER, "Change Map", "Set the next map.", ADMIN_CATEGORY_SERVER)
	var/list/maprotatechoices = list()
	for (var/map in config.maplist)
		var/datum/map_config/virtual_map = config.maplist[map]
		var/mapname = virtual_map.map_name
		if (virtual_map == config.defaultmap)
			mapname += " (Default)"

		if (virtual_map.config_min_users > 0 || virtual_map.config_max_users > 0)
			mapname += " \["
			if (virtual_map.config_min_users > 0)
				mapname += "[virtual_map.config_min_users]"
			else
				mapname += "0"
			mapname += "-"
			if (virtual_map.config_max_users > 0)
				mapname += "[virtual_map.config_max_users]"
			else
				mapname += "inf"
			mapname += "\]"

		maprotatechoices[mapname] = virtual_map
	var/chosenmap = tgui_input_list(user, "Choose a map to change to", "Change Map", sort_list(maprotatechoices)|"Custom")
	if (isnull(chosenmap))
		return

	if(chosenmap == "Custom")
		message_admins("[key_name_admin(user)] is changing the map to a custom map")
		log_admin("[key_name(user)] is changing the map to a custom map")
		var/datum/map_config/virtual_map = new

		var/map_file = input(user, "Pick file:", "Map File") as null|file
		if(isnull(map_file))
			return

		if(copytext("[map_file]", -4) != ".dmm")//4 == length(".dmm")
			to_chat(user, span_warning("Filename must end in '.dmm': [map_file]"))
			return

		if(fexists("_maps/custom/[map_file]"))
			fdel("_maps/custom/[map_file]")
		if(!fcopy(map_file, "_maps/custom/[map_file]"))
			return
		// This is to make sure the map works so the server does not start without a map.
		var/datum/parsed_map/M = new (map_file)
		if(!M)
			to_chat(user, span_warning("Map '[map_file]' failed to parse properly."))
			return

		if(!M.bounds)
			to_chat(user, span_warning("Map '[map_file]' has non-existant bounds."))
			qdel(M)
			return

		qdel(M)
		var/config_file = null
		var/list/json_value = list()
		var/config = tgui_alert(user,"Would you like to upload an additional config for this map?", "Map Config", list("Yes", "No"))
		if(config == "Yes")
			config_file = input(user, "Pick file:", "Config JSON File") as null|file
			if(isnull(config_file))
				return
			if(copytext("[config_file]", -5) != ".json")
				to_chat(src, span_warning("Filename must end in '.json': [config_file]"))
				return
			if(fexists("data/custom_map_json/[config_file]"))
				fdel("data/custom_map_json/[config_file]")
			if(!fcopy(config_file, "data/custom_map_json/[config_file]"))
				return

			json_value = virtual_map.LoadConfig("data/custom_map_json/[config_file]", TRUE)

			if(!json_value)
				to_chat(src, span_warning("Failed to load config: [config_file]. Check that the fields are filled out correctly. \"map_path\": \"custom\" and \"map_file\": \"your_map_name.dmm\""))
				return

		else
			virtual_map = load_map_config()
			virtual_map.map_name = input(user, "Choose the name for the map", "Map Name") as null|text
			if(isnull(virtual_map.map_name))
				virtual_map.map_name = "Custom"

			var/shuttles = tgui_alert(user,"Do you want to modify the shuttles?", "Map Shuttles", list("Yes", "No"))
			if(shuttles == "Yes")
				for(var/s in virtual_map.shuttles)
					var/shuttle = input(user, s, "Map Shuttles") as null|text
					if(!shuttle)
						continue
					if(!SSmapping.shuttle_templates[shuttle])
						to_chat(user, span_warning("No such shuttle as '[shuttle]' exists, using default."))
						continue
					virtual_map.shuttles[s] = shuttle

			json_value = list(
				"version" = MAP_CURRENT_VERSION,
				"map_name" = virtual_map.map_name,
				"map_path" = CUSTOM_MAP_PATH,
				"map_file" = "[map_file]",
				"shuttles" = virtual_map.shuttles,
			)

		// If the file isn't removed text2file will just append.
		if(fexists(PATH_TO_NEXT_MAP_JSON))
			fdel(PATH_TO_NEXT_MAP_JSON)
		text2file(json_encode(json_value), PATH_TO_NEXT_MAP_JSON)

		if(SSmap_vote.set_next_map(virtual_map))
			message_admins("[key_name_admin(user)] has changed the map to [virtual_map.map_name]")
			SSmap_vote.admin_override = TRUE
		fdel("data/custom_map_json/[config_file]")
	else
		var/datum/map_config/virtual_map = maprotatechoices[chosenmap]
		message_admins("[key_name_admin(user)] is changing the map to [virtual_map.map_name]")
		log_admin("[key_name(user)] is changing the map to [virtual_map.map_name]")
		if (SSmap_vote.set_next_map(virtual_map))
			message_admins("[key_name_admin(user)] has changed the map to [virtual_map.map_name]")
			SSmap_vote.admin_override = TRUE

ADMIN_VERB(admin_change_map_templates, R_SERVER, "Change Map Templates", "Set the next map's map templates.", ADMIN_CATEGORY_SERVER)
	if(!SSmap_vote.next_map_config)
		to_chat(user, span_warning("Next map has not selected"))
		return
	var/datum/map_config/next_map = SSmap_vote.next_map_config
	var/list/json_value = safe_json_decode(file2text(PATH_TO_NEXT_MAP_JSON))
	var/changed_something = FALSE
	var/change_engine = tgui_alert(user,"Do you want to modify the engine?", "Map Engine", list("Yes", "No"))
	if(change_engine == "Yes")
		var/list/engine_list = list()
		for(var/datum/map_template/random_room/random_engine/engine_template as anything in subtypesof(/datum/map_template/random_room/random_engine))
			if(engine_template.station_name != next_map.map_name)
				continue
			engine_list[engine_template.name] = engine_template.room_id
		if(engine_list.len < 2)
			to_chat(user, span_warning("Next map doesnt have engine options."))
			return
		var/engine = tgui_input_list(user, "Change Map Engine", "Select the engine for next map", sort_list(engine_list)|"Random")
		if(engine != "Random")
			next_map.picked_rooms["engine"] = engine_list[engine]
		else
			next_map.picked_rooms["engine"] = null
		changed_something = TRUE
		message_admins("[key_name_admin(user)] has changed the next map's engine to [engine]")
		log_admin("[key_name(user)] has changed the next map's engine to [engine]")
	if(!changed_something)
		return
	json_value["room_templates"] = next_map.picked_rooms
	if(fexists(PATH_TO_NEXT_MAP_JSON))
		fdel(PATH_TO_NEXT_MAP_JSON)
	text2file(json_encode(json_value), PATH_TO_NEXT_MAP_JSON)

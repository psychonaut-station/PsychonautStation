ADMIN_VERB(admin_change_map_templates, R_SERVER, "Change Map Templates", "Set the next map's map templates.", ADMIN_CATEGORY_SERVER)
	if(!SSmap_vote.next_map_config)
		to_chat(user, span_warning("Next map has not selected"))
		return
	var/datum/map_config/next_map = SSmap_vote.next_map_config
	var/list/json_value = safe_json_decode(file2text(PATH_TO_NEXT_MAP_JSON))
	var/changed_something = FALSE
	var/list/next_map_room_templates = list()
	for(var/datum/map_template/modular_room/item as anything in subtypesof(/datum/map_template/modular_room))
		if(item.station_name != next_map.map_name || isnull(item.room_type))
			continue
		next_map_room_templates[item.room_type] += list("[item.room_id]" = item)
	for(var/roomtype in next_map_room_templates)
		if(length(next_map_room_templates[roomtype]) < 2)
			continue
		var/change_room = tgui_alert(user,"Do you want to modify the [roomtype]?", "Map Rooms", list("Yes", "No"))
		if(change_room != "Yes")
			continue
		var/list/template_list = next_map_room_templates[roomtype]
		var/selected_room = tgui_input_list(user, "Change Room Template", "Select", sort_list(template_list)|"Random")
		if(selected_room != "Random")
			next_map.picked_rooms[roomtype] = template_list[selected_room]
		else
			next_map.picked_rooms[roomtype] = null
		changed_something = TRUE
		message_admins("[key_name_admin(user)] has changed the next map's [roomtype] to [selected_room]")
		log_admin("[key_name(user)] has changed the next map's [roomtype] to [selected_room]")
	if(!changed_something)
		return
	json_value["room_templates"] = next_map.picked_rooms
	if(fexists(PATH_TO_NEXT_MAP_JSON))
		fdel(PATH_TO_NEXT_MAP_JSON)
	text2file(json_encode(json_value), PATH_TO_NEXT_MAP_JSON)

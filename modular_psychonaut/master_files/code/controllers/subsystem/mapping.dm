/datum/controller/subsystem/mapping
	/// List of bounds of the current station map by groups
	var/list/all_offsets = list()

	var/list/machines_delete_after = list()

	var/list/modular_room_templates = list()

	var/list/obj/effect/landmark/random_room/modular_room_spawners = list()
	var/list/datum/map_template/modular_room/picked_rooms = list()

/datum/controller/subsystem/mapping/Recover()
	. = ..()
	modular_room_templates = SSmapping.modular_room_templates

/datum/controller/subsystem/mapping/proc/machiness_post_init()
	var/list/prioritys = typecacheof(list(/obj/machinery/meter, /obj/machinery/power/apc))
	for(var/atom/prior_item in typecache_filter_list(machines_delete_after, prioritys))
		if(istype(prior_item, /obj/machinery/power/apc))
			var/obj/machinery/power/apc/apc = prior_item
			QDEL_NULL(apc.terminal)
		qdel(prior_item)
		machines_delete_after -= prior_item
	QDEL_LIST(machines_delete_after)

/datum/controller/subsystem/mapping/proc/locate_spawner_turf(datum/map_template/modular_room/room)
	var/list/offsets = all_offsets[room.group]
	var/coordinate_x = (offsets["x"] - 1) + room.coordinates["x"]
	var/coordinate_y = (offsets["y"] - 1) + room.coordinates["y"]
	var/turf/target = locate(coordinate_x, coordinate_y, room.coordinates["z"])
	return target

/datum/controller/subsystem/mapping/proc/load_room_templates()
	for(var/item in subtypesof(/datum/map_template/modular_room))
		var/datum/map_template/modular_room/room_type = item
		var/datum/map_template/modular_room/R = new room_type()
		map_templates[R.room_id] = R
		if(current_map.map_name == R.station_name)
			modular_room_templates[R.room_type] += list("[R.room_id]" = R)
			if(R.coordinates.len && R.template_width && R.template_height && !modular_room_spawners[R.room_type])
				create_room_spawner(R, R.room_type)

/datum/controller/subsystem/mapping/proc/create_room_spawner(datum/map_template/modular_room/room, roomtype)
	var/turf/target = locate_spawner_turf(room)
	var/obj/effect/landmark/random_room/room_spawner = new(target)
	room_spawner.room_width = room.template_width
	room_spawner.room_height = room.template_height
	modular_room_spawners[roomtype] = room_spawner
	return TRUE

/datum/controller/subsystem/mapping/proc/pick_room_types()
	for(var/roomtype in modular_room_templates)
		pick_room(roomtype, !isnull(current_map.picked_rooms[roomtype]))

/datum/controller/subsystem/mapping/proc/pick_room(roomtype, force = FALSE)
	if(force)
		picked_rooms[roomtype] = modular_room_templates[roomtype][current_map.picked_rooms[roomtype]]
		return TRUE
	var/list/room_weights = CONFIG_GET(keyed_list/modular_room_weight)
	var/list/possible_room_templates = list()
	var/datum/map_template/modular_room/room_candidate
	shuffle_inplace(modular_room_templates[roomtype])
	for(var/ID in modular_room_templates[roomtype])
		room_candidate = modular_room_templates[roomtype][ID]
		if(room_candidate.weight == 0 || (room_candidate.mappath && (modular_room_spawners[roomtype].room_height != room_candidate.template_height || modular_room_spawners[roomtype].room_width != room_candidate.template_width)))
			room_candidate = null
			continue
		possible_room_templates[room_candidate] = room_weights[room_candidate.room_id] || room_candidate.weight
	if(!possible_room_templates.len)
		return FALSE
	picked_rooms[roomtype] = pick_weight(possible_room_templates)
	return TRUE

/datum/controller/subsystem/mapping/proc/load_random_rooms()
	for(var/roomtype in picked_rooms)
		load_random_room(roomtype)

/datum/controller/subsystem/mapping/proc/load_random_room(roomtype)
	var/start_time = REALTIMEOFDAY
	if(modular_room_spawners[roomtype] && picked_rooms[roomtype])
		log_world("Loading [roomtype] template [picked_rooms[roomtype].name] ([picked_rooms[roomtype].type]) at [AREACOORD(modular_room_spawners[roomtype])]")
		if(picked_rooms[roomtype].mappath)
			var/datum/map_template/modular_room/template = picked_rooms[roomtype]
			template.stationinitload(get_turf(modular_room_spawners[roomtype]), centered = template.centerspawner)
	QDEL_NULL(modular_room_spawners[roomtype])
	log_world("Loaded [roomtype] in [(REALTIMEOFDAY - start_time)/10]s!")
	return TRUE

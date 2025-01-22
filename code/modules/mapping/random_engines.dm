/datum/map_template/random_room
	var/room_id //The SSmapping random_room_template list is ordered by this var
	var/spawned //Whether this template (on the random_room template list) has been spawned
	var/station_name //Matches this template with that right station
	var/centerspawner = TRUE
	var/template_height = 0
	var/template_width = 0
	var/weight = 10 //weight a room has to appear
	var/list/coordinates = list()
	var/room_type = null

/datum/map_template/random_room/random_engine
	room_type = "engine"
	var/engine_type = null

/datum/map_template/random_room/random_engine/meta_supermatter
	name = "Meta Supermatter"
	room_id = "meta_supermatter"
	centerspawner = FALSE
	weight = 8
	station_name = "MetaStation"
	should_place_on_top = FALSE
	coordinates = list(
		"x" = 162,
		"y" = 141,
		"z" = 2,
	)
	engine_type = "supermatter"

/datum/map_template/random_room/random_engine/meta_singularity
	name = "Meta Singularity"
	room_id = "meta_singularity"
	mappath = "_maps/RandomRooms/MetaStation/singularity.dmm"
	centerspawner = FALSE
	template_height = 25
	template_width = 33
	weight = 8
	station_name = "MetaStation"
	should_place_on_top = FALSE
	coordinates = list(
		"x" = 162,
		"y" = 141,
		"z" = 2,
	)
	engine_type = "singularity"

/datum/map_template/random_room/random_engine/delta_supermatter
	name = "Delta Supermatter"
	room_id = "delta_supermatter"
	centerspawner = FALSE
	weight = 8
	station_name = "Delta Station"
	should_place_on_top = FALSE
	coordinates = list(
		"x" = 61,
		"y" = 106,
		"z" = 2,
	)
	engine_type = "supermatter"

/datum/map_template/random_room/random_engine/delta_singularity
	name = "Delta Singularity"
	room_id = "delta_singularity"
	mappath = "_maps/RandomRooms/Deltastation/singularity.dmm"
	centerspawner = FALSE
	template_height = 31
	template_width = 23
	weight = 8
	station_name = "Delta Station"
	should_place_on_top = FALSE
	coordinates = list(
		"x" = 61,
		"y" = 106,
		"z" = 2,
	)
	engine_type = "singularity"

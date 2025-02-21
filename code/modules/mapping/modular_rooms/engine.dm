/datum/map_template/modular_room/random_engine
	room_type = "engine"
	var/engine_type = null

/datum/map_template/modular_room/random_engine/meta_supermatter
	name = "Meta Supermatter"
	room_id = "meta_supermatter"
	centerspawner = FALSE
	station_name = "MetaStation"
	should_place_on_top = FALSE
	coordinates = list(
		"x" = 162,
		"y" = 141,
		"z" = 2,
	)
	engine_type = "supermatter"

/datum/map_template/modular_room/random_engine/meta_singularity
	name = "Meta Singularity"
	room_id = "meta_singularity"
	mappath = "_maps/ModularRooms/MetaStation/singularity.dmm"
	centerspawner = FALSE
	template_height = 25
	template_width = 33
	station_name = "MetaStation"
	should_place_on_top = FALSE
	coordinates = list(
		"x" = 162,
		"y" = 141,
		"z" = 2,
	)
	engine_type = "singularity"

/datum/map_template/modular_room/random_engine/delta_supermatter
	name = "Delta Supermatter"
	room_id = "delta_supermatter"
	centerspawner = FALSE
	station_name = "Delta Station"
	should_place_on_top = FALSE
	coordinates = list(
		"x" = 61,
		"y" = 106,
		"z" = 2,
	)
	engine_type = "supermatter"

/datum/map_template/modular_room/random_engine/delta_singularity
	name = "Delta Singularity"
	room_id = "delta_singularity"
	mappath = "_maps/ModularRooms/Deltastation/singularity.dmm"
	centerspawner = FALSE
	template_height = 31
	template_width = 23
	station_name = "Delta Station"
	should_place_on_top = FALSE
	coordinates = list(
		"x" = 61,
		"y" = 106,
		"z" = 2,
	)
	engine_type = "singularity"

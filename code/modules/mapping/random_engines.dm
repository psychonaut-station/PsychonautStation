/datum/map_template/random_room
	var/room_id //The SSmapping random_room_template list is ordered by this var
	var/spawned //Whether this template (on the random_room template list) has been spawned
	var/station_name //Matches this template with that right station
	var/centerspawner = TRUE
	var/template_height = 0
	var/template_width = 0
	var/weight = 10 //weight a room has to appear
	var/stock = 1 //how many times this room can appear in a round
	var/datum/map_template/empty/empty_map = null
	var/list/coordinates = list()

/datum/map_template/empty/meta
	name = "Meta Emptyer"
	mappath = "_maps/RandomEngines/MetaStation/empty.dmm"
	should_place_on_top = FALSE

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

/datum/map_template/random_room/random_engine/meta_singularity
	name = "Meta Singularity"
	room_id = "meta_singularity"
	mappath = "_maps/RandomEngines/MetaStation/singularity.dmm"
	centerspawner = FALSE
	template_height = 25
	template_width = 33
	weight = 8
	station_name = "MetaStation"
	should_place_on_top = FALSE
	empty_map = /datum/map_template/empty/meta
	coordinates = list(
		"x" = 162,
		"y" = 141,
		"z" = 2,
	)

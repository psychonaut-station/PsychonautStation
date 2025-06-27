/datum/map_template/modular_room
	var/room_id //The SSmapping random_room_template list is ordered by this var
	var/spawned //Whether this template (on the random_room template list) has been spawned
	var/station_name //Matches this template with that right station
	var/centerspawner = TRUE
	var/template_height = 0
	var/template_width = 0
	var/weight = 10 //weight a room has to appear
	var/list/coordinates = list() // x and y coordinates from strongdmm (NOT INGAME COORDINATES)
	var/room_type = null
	var/group = "Station"

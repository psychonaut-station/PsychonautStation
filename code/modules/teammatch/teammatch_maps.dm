/datum/lazy_template/teammatch
	map_dir = "_maps/minigame/teammatch"
	place_on_top = TRUE
	turf_reservation_type = /datum/turf_reservation/turf_not_baseturf
	/// Map UI Name
	var/name
	/// Map Description
	var/desc = ""

	/// whether we are currently being loaded by a lobby
	var/template_in_use = FALSE

/datum/lazy_template/teammatch/lv624_1
	name = "LV624-1"
	desc = "A planet full of xenos. First half of lv624"
	map_name = "LV624-1"
	key = "LV624-1"

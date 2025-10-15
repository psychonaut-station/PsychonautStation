/datum/map_template/proc/stationinitload(turf/T, centered = FALSE)
	if(centered)
		T = locate(T.x - round(width/2) , T.y - round(height/2) , T.z)
	if(!T || T.x+width > world.maxx || T.y+height > world.maxy)
		return
	var/datum/parsed_map/parsed = new(file(mappath))
	parsed.load(T.x, T.y, T.z, crop_map=TRUE, no_changeturf=TRUE, place_on_top=should_place_on_top, clear_area = TRUE)

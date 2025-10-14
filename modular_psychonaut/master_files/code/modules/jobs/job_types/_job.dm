/datum/job
	/// Which landmarks should this job spawn at if the job doesn't have its own spawn point?
	var/obj/effect/landmark/start/roundstart_spawn_point

/datum/job/get_default_roundstart_spawn_point()
	if(roundstart_spawn_point)
		for(var/obj/effect/landmark/start/spawn_point as anything in GLOB.start_landmarks_list)
			if(!ispath(spawn_point, roundstart_spawn_point))
				continue
			. = spawn_point
			if(spawn_point.used)
				continue
			spawn_point.used = TRUE
			break
	if(!.)
		return ..()

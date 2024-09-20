#define MAP_EDGE_PAD 5

/proc/spawn_meteors(number = 10, list/meteor_types, direction)
	for(var/i in 1 to number)
		spawn_meteor(meteor_types, direction)

/proc/spawn_meteor(list/meteor_types, direction, atom/target)
	if (SSmapping.is_planetary())
		stack_trace("Tried to spawn meteors in a map which isn't in space.")
		return // We're not going to find any space turfs here
	var/turf/picked_start
	var/turf/picked_goal
	var/max_i = 10//number of tries to spawn meteor.
	while(!isspaceturf(picked_start))
		var/start_side
		if(direction) //If a direction has been specified, we set start_side to it. Otherwise, pick randomly
			start_side = direction
		else
			start_side = pick(GLOB.cardinals)
		var/start_Z = pick(SSmapping.levels_by_trait(ZTRAIT_STATION))
		picked_start = spaceDebrisStartLoc(start_side, start_Z)
		if(target)
			if(!isturf(target))
				target = get_turf(target)
			picked_goal = target
		else
			picked_goal = spaceDebrisFinishLoc(start_side, start_Z)
		max_i--
		if(max_i <= 0)
			return
	var/new_meteor = pick_weight(meteor_types)
	new new_meteor(picked_start, picked_goal)

/proc/spaceDebrisStartLoc(start_side, Z)
	var/starty
	var/startx
	switch(start_side)
		if(NORTH)
			starty = world.maxy-(TRANSITIONEDGE + MAP_EDGE_PAD)
			startx = rand((TRANSITIONEDGE + MAP_EDGE_PAD), world.maxx-(TRANSITIONEDGE + MAP_EDGE_PAD))
		if(EAST)
			starty = rand((TRANSITIONEDGE + MAP_EDGE_PAD),world.maxy-(TRANSITIONEDGE + MAP_EDGE_PAD))
			startx = world.maxx-(TRANSITIONEDGE + MAP_EDGE_PAD)
		if(SOUTH)
			starty = (TRANSITIONEDGE + MAP_EDGE_PAD)
			startx = rand((TRANSITIONEDGE + MAP_EDGE_PAD), world.maxx-(TRANSITIONEDGE + MAP_EDGE_PAD))
		if(WEST)
			starty = rand((TRANSITIONEDGE + MAP_EDGE_PAD), world.maxy-(TRANSITIONEDGE + MAP_EDGE_PAD))
			startx = (TRANSITIONEDGE + MAP_EDGE_PAD)
	. = locate(startx, starty, Z)

/proc/spaceDebrisFinishLoc(startSide, Z)
	var/endy
	var/endx
	switch(startSide)
		if(NORTH)
			endy = (TRANSITIONEDGE + MAP_EDGE_PAD)
			endx = rand((TRANSITIONEDGE + MAP_EDGE_PAD), world.maxx-(TRANSITIONEDGE + MAP_EDGE_PAD))
		if(EAST)
			endy = rand((TRANSITIONEDGE + MAP_EDGE_PAD), world.maxy-(TRANSITIONEDGE + MAP_EDGE_PAD))
			endx = (TRANSITIONEDGE + MAP_EDGE_PAD)
		if(SOUTH)
			endy = world.maxy-(TRANSITIONEDGE + MAP_EDGE_PAD)
			endx = rand((TRANSITIONEDGE + MAP_EDGE_PAD), world.maxx-(TRANSITIONEDGE + MAP_EDGE_PAD))
		if(WEST)
			endy = rand((TRANSITIONEDGE + MAP_EDGE_PAD),world.maxy-(TRANSITIONEDGE + MAP_EDGE_PAD))
			endx = world.maxx-(TRANSITIONEDGE + MAP_EDGE_PAD)
	. = locate(endx, endy, Z)

#undef MAP_EDGE_PAD

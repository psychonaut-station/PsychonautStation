/obj/machinery/computer/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	for(var/obj/machinery/computer/computer in range(1, src))
		if(computer.icon_state == "computer")
			computer.update_appearance()

/obj/machinery/computer/Destroy()
	for(var/obj/machinery/computer/computer in range(1, src))
		if(computer.icon_state == "computer")
			computer.update_appearance()
	return ..()

/obj/machinery/computer/update_overlays()
	. = ..()

	if(icon_state == "computer")
		var/obj/machinery/computer/left_comp = null
		var/obj/machinery/computer/right_comp = null
		var/turf/left_turf = null
		var/turf/right_turf = null
		switch(dir)
			if(NORTH)
				left_turf = get_step(src, WEST)
				right_turf = get_step(src, EAST)
			if(EAST)
				left_turf = get_step(src, NORTH)
				right_turf = get_step(src, SOUTH)
			if(SOUTH)
				left_turf = get_step(src, EAST)
				right_turf = get_step(src, WEST)
			if(WEST)
				left_turf = get_step(src, SOUTH)
				right_turf = get_step(src, NORTH)
		for(var/obj/machinery/computer/computer in left_turf.contents)
			if(QDELETED(computer))
				continue
			if(computer.dir != dir)
				continue
			if(computer.icon_state != "computer")
				continue
			left_comp = computer
			break
		for(var/obj/machinery/computer/computer in right_turf.contents)
			if(QDELETED(computer))
				continue
			if(computer.dir != dir)
				continue
			if(computer.icon_state != "computer")
				continue
			right_comp = computer
			break
		if(!isnull(left_comp))
			. += mutable_appearance('modular_psychonaut/master_files/icons/obj/machines/connectors.dmi', "left")
		if(!isnull(right_comp))
			. += mutable_appearance('modular_psychonaut/master_files/icons/obj/machines/connectors.dmi', "right")

/obj/machinery/computer/on_construction(mob/user, from_flatpack = FALSE)
	..()
	for(var/obj/machinery/computer/computer in range(1, src))
		if(computer.icon_state == "computer")
			computer.update_appearance()

/obj/machinery/computer/setDir(newdir)
	. = ..()
	for(var/obj/machinery/computer/computer in range(1, src))
		if(computer.icon_state == "computer")
			computer.update_appearance()

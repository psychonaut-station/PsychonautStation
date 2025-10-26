/datum/controller/subsystem/minor_mapping/Initialize()
	. = ..()
	if(. != SS_INIT_SUCCESS)
		return .
	place_crewrecords()

/datum/controller/subsystem/minor_mapping/proc/place_crewrecords()
	var/area/hoproom = GLOB.areas_by_type[/area/station/command/heads_quarters/hop]
	if(isnull(hoproom)) //no hop room, what will he assist?
		return
	var/list/tables = list()
	var/obj/machinery/modular_computer/preset/id/idconsole
	for(var/turf/area_turf as anything in hoproom.get_turfs_from_all_zlevels())
		var/obj/structure/table/table = locate() in area_turf
		var/obj/machinery/modular_computer/preset/id/console = locate() in area_turf
		var/obj/machinery/door/window/window = locate() in area_turf
		if(!isnull(console))
			idconsole = console
			continue
		if(!isnull(window))
			continue
		if(isnull(table))
			continue
		if(area_turf.is_blocked_turf(ignore_atoms = list(table))) //don't spawn a coffeemaker on a fax machine or smth
			continue
		tables += table
	if(!length(tables))
		return
	if(isnull(idconsole))
		return
	var/picked_table = get_closest_atom(/obj/structure/table, tables, idconsole)
	var/picked_turf = get_turf(picked_table)
	if(length(tables))
		var/another_table = pick(tables)
		for(var/obj/thing_on_table in picked_turf) //if there's paper bins or other shit on the table, get that off
			if(thing_on_table == picked_table)
				continue
			if(HAS_TRAIT(thing_on_table, TRAIT_WALLMOUNTED) || (thing_on_table.flags_1 & ON_BORDER_1) || thing_on_table.layer < TABLE_LAYER)
				continue
			if(thing_on_table.invisibility || !thing_on_table.alpha || !thing_on_table.mouse_opacity)
				continue
			thing_on_table.forceMove(get_turf(another_table))
	var/obj/machinery/computer/records/crew/laptop/laptop = new (picked_turf)
	var/laptopdir
	var/list/possible_dirs = GLOB.cardinals.Copy()
	var/static/list/passList = list(
		/obj/item,
		/obj/machinery/holopad,
		/obj/machinery/atmospherics/components,
		/obj/structure/chair,
	)
	for(var/i in GLOB.cardinals)
		var/turf/steppedTurf = get_step(laptop, i)
		if(isclosedturf(steppedTurf))
			possible_dirs -= i
			continue
		var/skip_turf = FALSE
		for(var/obj/thing_on_turf in steppedTurf)
			if(HAS_TRAIT(thing_on_turf, TRAIT_WALLMOUNTED) || (thing_on_turf.flags_1 & ON_BORDER_1))
				continue
			if(thing_on_turf.invisibility || !thing_on_turf.alpha || !thing_on_turf.mouse_opacity)
				continue
			if(is_type_in_list(thing_on_turf, passList))
				continue
			skip_turf = TRUE
		if(skip_turf)
			possible_dirs -= i
			continue
	if(length(possible_dirs))
		laptopdir = pick(possible_dirs)
	else
		laptopdir = pick(GLOB.cardinals)
	laptop.setDir(laptopdir)

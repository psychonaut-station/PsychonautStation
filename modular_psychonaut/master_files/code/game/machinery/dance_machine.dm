/obj/machinery/jukebox/no_access/Initialize(mapload)
	. = ..()
	if(mapload)
		new /obj/machinery/electrical_jukebox/public(loc)
		return INITIALIZE_HINT_QDEL

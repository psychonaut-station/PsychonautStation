/obj/machinery/jukebox/Initialize(mapload)
	. = ..()

	if(mapload)
		new /obj/machinery/electrical_jukebox/public(get_turf(src))
		return INITIALIZE_HINT_QDEL

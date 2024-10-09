/obj/machinery/particle_accelerator/control_box
	name = "Particle Accelerator Control Console"
	desc = "This controls the density of the particles."
	icon_state = "control_box"
	var/list/obj/machinery/particle_accelerator/connected_parts = list()

/obj/machinery/particle_accelerator/control_box/proc/assemble()
	if(!can_assemble())
		return FALSE

	var/turf/assemble_loc = get_turf(connected_parts["end_cap"])

	var/obj/machinery/particle_accelerator/full/fpa = new(assemble_loc)
	fpa.setDir(dir)
	for(var/pa_ref as anything in connected_parts)
		if(pa_ref != "end_cap")
			var/turf/T = get_turf(connected_parts[pa_ref])
			var/obj/structure/filler/F = new(T)
			F.parent = src
			fpa.fillers[pa_ref] = F
		qdel(connected_parts[pa_ref])
	return TRUE

/obj/machinery/particle_accelerator/control_box/proc/can_assemble()
	var/ldir = turn(dir,-90)
	var/rdir = turn(dir,90)
	var/odir = turn(dir,180)
	var/turf/T = loc

	var/obj/machinery/particle_accelerator/fuel_chamber/F = locate() in orange(1,src)
	if(!F)
		return FALSE

	setDir(F.dir)
	connected_parts.Cut()

	T = get_step(T,rdir)
	if(!check_part(T, /obj/machinery/particle_accelerator/fuel_chamber))
		return FALSE
	T = get_step(T,odir)
	if(!check_part(T, /obj/machinery/particle_accelerator/end_cap))
		return FALSE
	T = get_step(T,dir)
	T = get_step(T,dir)
	if(!check_part(T, /obj/machinery/particle_accelerator/power_box))
		return FALSE
	T = get_step(T,dir)
	if(!check_part(T, /obj/machinery/particle_accelerator/particle_emitter/center))
		return FALSE
	T = get_step(T,ldir)
	if(!check_part(T, /obj/machinery/particle_accelerator/particle_emitter/left))
		return FALSE
	T = get_step(T,rdir)
	T = get_step(T,rdir)
	if(!check_part(T, /obj/machinery/particle_accelerator/particle_emitter/right))
		return FALSE

	return TRUE

/obj/machinery/particle_accelerator/control_box/proc/check_part(turf/T, type)
	var/obj/machinery/particle_accelerator/PA = locate(/obj/machinery/particle_accelerator) in T
	if(istype(PA, type) && PA.anchored)
		if(PA.connect_master(src))
			connected_parts[PA.reference] = PA
			return TRUE
	return FALSE

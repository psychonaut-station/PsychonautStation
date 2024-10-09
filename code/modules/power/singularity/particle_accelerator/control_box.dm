/obj/machinery/particle_accelerator/control_box
	name = "Particle Accelerator Control Console"
	desc = "This controls the density of the particles."
	icon_state = "control_box"
	use_power = NO_POWER_USE
	var/interface_control = TRUE
	var/active = FALSE
	var/strength = 0
	var/strength_upper_limit = 2
	var/obj/machinery/particle_accelerator/full/particle_accelerator

/obj/machinery/particle_accelerator/control_box/Initialize(mapload)
	. = ..()
	set_wires(new /datum/wires/particle_accelerator/control_box(src))

/obj/machinery/particle_accelerator/control_box/Destroy()
	if(particle_accelerator)
		QDEL_NULL(particle_accelerator)
	QDEL_NULL(wires)
	return ..()

/obj/machinery/particle_accelerator/control_box/screwdriver_act(mob/living/user, obj/item/I)
	if(active)
		return ITEM_INTERACT_BLOCKING
	if(default_deconstruction_screwdriver(user, "control_boxw", "control_boxp", I))
		update_appearance()
		return ITEM_INTERACT_SUCCESS
	return NONE

/obj/machinery/particle_accelerator/control_box/multitool_act(mob/living/user, obj/item/I)
	. = ..()
	if(panel_open)
		wires.interact(user)
		return TRUE

/obj/machinery/particle_accelerator/control_box/update_icon_state()
	. = ..()
	if(active && particle_accelerator)
		icon_state = "control_boxp[strength]"
	else
		icon_state = "control_boxp"

/obj/machinery/particle_accelerator/control_box/process()
	if(active && particle_accelerator)
		particle_accelerator.emit_particle(strength)

/obj/machinery/particle_accelerator/control_box/proc/is_interactive(mob/user)
	if(!interface_control)
		to_chat(user, "<span class='alert'>ERROR: Request timed out. Check wire contacts.</span>")
		return FALSE
	if(!anchored && panel_open)
		return FALSE
	return TRUE

/obj/machinery/particle_accelerator/control_box/proc/add_strength(s)
	if(anchored && (strength < strength_upper_limit) && particle_accelerator)
		strength++
		particle_accelerator.update_icon()
		message_admins("PA Control Computer increased to [strength] by [ADMIN_LOOKUPFLW(usr)] in [ADMIN_VERBOSEJMP(src)]")
		log_game("PA Control Computer increased to [strength] by [key_name(usr)] in [AREACOORD(src)]")
		investigate_log("increased to <font color='red'>[strength]</font> by [key_name(usr)] at [AREACOORD(src)]", INVESTIGATE_ENGINE)

/obj/machinery/particle_accelerator/control_box/proc/remove_strength(s)
	if(anchored && (strength > 0) && particle_accelerator)
		strength--
		particle_accelerator.update_icon()
		message_admins("PA Control Computer decreased to [strength] by [ADMIN_LOOKUPFLW(usr)] in [ADMIN_VERBOSEJMP(src)]")
		log_game("PA Control Computer decreased to [strength] by [key_name(usr)] in [AREACOORD(src)]")
		investigate_log("decreased to <font color='green'>[strength]</font> by [key_name(usr)] at [AREACOORD(src)]", INVESTIGATE_ENGINE)

/obj/machinery/particle_accelerator/control_box/proc/toggle_power()
	if(!particle_accelerator)
		return
	active = !active
	investigate_log("turned [active?"<font color='green'>ON</font>":"<font color='red'>OFF</font>"] by [usr ? key_name(usr) : "outside forces"] at [AREACOORD(src)]", INVESTIGATE_ENGINE)
	message_admins("PA Control Computer turned [active ?"ON":"OFF"] by [usr ? ADMIN_LOOKUPFLW(usr) : "outside forces"] in [ADMIN_VERBOSEJMP(src)]")
	log_game("PA Control Computer turned [active ?"ON":"OFF"] by [usr ? "[key_name(usr)]" : "outside forces"] at [AREACOORD(src)]")
	if(active)
		use_power = ACTIVE_POWER_USE
		particle_accelerator.update_icon()
	else
		use_power = IDLE_POWER_USE
		particle_accelerator.update_icon()
	return TRUE

/obj/machinery/particle_accelerator/control_box/can_be_unfasten_wrench(mob/user, silent)
	. = ..()
	if(particle_accelerator)
		return CANT_UNFASTEN

/obj/machinery/particle_accelerator/control_box/proc/assemble()
	var/ldir = turn(dir,-90)
	var/rdir = turn(dir,90)
	var/odir = turn(dir,180)
	var/turf/T = loc

	var/obj/machinery/particle_accelerator/fuel_chamber/F = locate() in orange(1,src)
	if(!F)
		return FALSE

	setDir(F.dir)
	var/list/obj/machinery/particle_accelerator/connected_parts = list()

	T = get_step(T,rdir)
	if(!check_part(T, /obj/machinery/particle_accelerator/fuel_chamber, connected_parts))
		return FALSE
	T = get_step(T,odir)
	if(!check_part(T, /obj/machinery/particle_accelerator/end_cap, connected_parts))
		return FALSE
	T = get_step(T,dir)
	T = get_step(T,dir)
	if(!check_part(T, /obj/machinery/particle_accelerator/power_box, connected_parts))
		return FALSE
	T = get_step(T,dir)
	if(!check_part(T, /obj/machinery/particle_accelerator/particle_emitter/center, connected_parts))
		return FALSE
	T = get_step(T,ldir)
	if(!check_part(T, /obj/machinery/particle_accelerator/particle_emitter/left, connected_parts))
		return FALSE
	T = get_step(T,rdir)
	T = get_step(T,rdir)
	if(!check_part(T, /obj/machinery/particle_accelerator/particle_emitter/right, connected_parts))
		return FALSE

	var/turf/assemble_loc = get_turf(connected_parts["end_cap"])
	var/obj/machinery/particle_accelerator/full/fpa = new(assemble_loc)
	fpa.setDir(dir)
	for(var/pa_ref as anything in connected_parts)
		if(pa_ref != "end_cap")
			var/turf/pa_turf = get_turf(connected_parts[pa_ref])
			var/obj/structure/filler/filler = new(pa_turf)
			filler.parent = src
			fpa.fillers[pa_ref] = filler
		qdel(connected_parts[pa_ref])
	QDEL_LIST_ASSOC(connected_parts)
	particle_accelerator = fpa
	return TRUE

/obj/machinery/particle_accelerator/control_box/proc/disassemble()
	if(!particle_accelerator)
		return
	var/static/list/pa_typepaths = list(
		"fuel_chamber" = /obj/machinery/particle_accelerator/fuel_chamber,
		"end_cap" = /obj/machinery/particle_accelerator/end_cap,
		"power_box" = /obj/machinery/particle_accelerator/power_box,
		"emitter_center" = /obj/machinery/particle_accelerator/particle_emitter/center,
		"emitter_left" = /obj/machinery/particle_accelerator/particle_emitter/left,
		"emitter_right" = /obj/machinery/particle_accelerator/particle_emitter/right,
	)
	var/turf/c_turf = get_turf(particle_accelerator)
	var/obj/machinery/particle_accelerator/end_cap/end_cap = new(c_turf)
	end_cap.setDir(dir)
	end_cap.anchored = TRUE
	for(var/filler_ref as anything in particle_accelerator.fillers)
		var/turf/pa_turf = get_turf(particle_accelerator.fillers[filler_ref])
		var/obj/machinery/particle_accelerator/pa_type = pa_typepaths[filler_ref]
		var/obj/machinery/particle_accelerator/pa = new pa_type(pa_turf)
		pa.setDir(dir)
		pa.anchored = TRUE
	particle_accelerator.master = null
	QDEL_NULL(particle_accelerator)

/obj/machinery/particle_accelerator/control_box/proc/check_part(turf/T, type, list/connected_parts)
	var/obj/machinery/particle_accelerator/PA = locate(/obj/machinery/particle_accelerator) in T
	if(istype(PA, type) && PA.anchored)
		if(PA.dir == dir)
			connected_parts[PA.reference] = PA
			return TRUE
	return FALSE

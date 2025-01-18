#define PA_CONSTRUCTION_UNSECURED  0
#define PA_CONSTRUCTION_UNWIRED    1
#define PA_CONSTRUCTION_PANEL_OPEN 2
#define PA_CONSTRUCTION_COMPLETE   3

/obj/machinery/particle_accelerator/control_box
	name = "particle accelerator control box"
	desc = "This controls the density of the particles."
	icon_state = "control_box"
	use_power = NO_POWER_USE
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 2
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 2.5
	circuit = /obj/item/circuitboard/machine/pa/control_box
	reference = "control_box"
	var/interface_control = TRUE
	var/active = FALSE
	var/strength = 0
	var/strength_upper_limit = 2
	var/assembled = FALSE
	var/obj/machinery/particle_accelerator/full/particle_accelerator

/obj/machinery/particle_accelerator/control_box/Initialize(mapload)
	. = ..()
	set_wires(new /datum/wires/particle_accelerator/control_box(src))

/obj/machinery/particle_accelerator/control_box/Destroy()
	if(particle_accelerator)
		disassemble()
	QDEL_NULL(wires)
	return ..()

/obj/machinery/particle_accelerator/control_box/examine(mob/user)
	. = ..()

	switch(construction_state)
		if(PA_CONSTRUCTION_UNSECURED)
			. += "Looks like it's not attached to the flooring."
		if(PA_CONSTRUCTION_UNWIRED)
			. += "It is missing some cables."
		if(PA_CONSTRUCTION_PANEL_OPEN)
			. += "The panel is open."

/obj/machinery/particle_accelerator/control_box/update_state()
	if(construction_state < PA_CONSTRUCTION_COMPLETE && particle_accelerator)
		use_power = NO_POWER_USE
		strength = 0
		active = FALSE
		particle_accelerator.update_appearance()
	active_power_usage = (strength * BASE_MACHINE_ACTIVE_CONSUMPTION * 1.5)+initial(active_power_usage)
	return

/obj/machinery/particle_accelerator/control_box/multitool_act(mob/living/user, obj/item/I)
	. = ..()
	if((construction_state == PA_CONSTRUCTION_PANEL_OPEN))
		wires.interact(user)
		return TRUE

/obj/machinery/particle_accelerator/control_box/wirecutter_act(mob/living/user, obj/item/tool)
	. = ..()
	if((construction_state == PA_CONSTRUCTION_PANEL_OPEN))
		wires.interact(user)
		return TRUE

/obj/machinery/particle_accelerator/control_box/update_icon_state()
	. = ..()
	switch(construction_state)
		if(PA_CONSTRUCTION_UNSECURED,PA_CONSTRUCTION_UNWIRED)
			icon_state="[reference]"
		if(PA_CONSTRUCTION_PANEL_OPEN)
			icon_state="[reference]w"
		if(PA_CONSTRUCTION_COMPLETE)
			if(active)
				icon_state="[reference]p[strength]"
			else
				icon_state="[reference]c"

/obj/machinery/particle_accelerator/control_box/blob_act(obj/structure/blob/B)
	if(prob(50))
		qdel(src)

/obj/machinery/particle_accelerator/control_box/interact(mob/user)
	if(construction_state == PA_CONSTRUCTION_PANEL_OPEN)
		wires.interact(user)
	else
		..()

/obj/machinery/particle_accelerator/control_box/proc/is_interactive(mob/user)
	if(!interface_control)
		to_chat(user, span_alert("ERROR: Request timed out. Check wire contacts."))
		return FALSE
	if(construction_state != PA_CONSTRUCTION_COMPLETE)
		return FALSE
	return TRUE

/obj/machinery/particle_accelerator/control_box/ui_status(mob/user)
	if(is_interactive(user))
		return ..()
	return UI_CLOSE

/obj/machinery/particle_accelerator/control_box/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ParticleAccelerator", name)
		ui.open()

/obj/machinery/particle_accelerator/control_box/ui_data(mob/user)
	. = list()
	.["assembled"] = !isnull(particle_accelerator)
	.["power"] = active
	.["strength_limit"] = strength_upper_limit
	.["strength"] = strength

/obj/machinery/particle_accelerator/control_box/ui_act(action, params)
	if(..())
		return

	switch(action)
		if("power")
			if(wires.is_cut(WIRE_POWER))
				return
			toggle_power()
			. = TRUE
		if("assemble")
			assemble()
			. = TRUE
		if("disassemble")
			disassemble()
			. = TRUE
		if("add_strength")
			if(wires.is_cut(WIRE_STRENGTH))
				return
			add_strength()
			. = TRUE
		if("remove_strength")
			if(wires.is_cut(WIRE_STRENGTH))
				return
			remove_strength()
			. = TRUE

	update_icon()

/obj/machinery/particle_accelerator/control_box/power_change()
	. = ..()
	if(machine_stat & NOPOWER)
		active = FALSE
		use_power = NO_POWER_USE
	else if(!machine_stat && (construction_state == PA_CONSTRUCTION_COMPLETE))
		use_power = IDLE_POWER_USE

/obj/machinery/particle_accelerator/control_box/proc/add_strength()
	if((construction_state == PA_CONSTRUCTION_COMPLETE) && (strength < strength_upper_limit) && particle_accelerator)
		strength++
		particle_accelerator.update_icon()
		message_admins("PA Control Computer increased to [strength] by [ADMIN_LOOKUPFLW(usr)] in [ADMIN_VERBOSEJMP(src)]")
		log_game("PA Control Computer increased to [strength] by [key_name(usr)] in [AREACOORD(src)]")
		investigate_log("increased to <font color='red'>[strength]</font> by [key_name(usr)] at [AREACOORD(src)]", INVESTIGATE_ENGINE)
		update_state()

/obj/machinery/particle_accelerator/control_box/proc/remove_strength()
	if((construction_state == PA_CONSTRUCTION_COMPLETE) && (strength > 0) && particle_accelerator)
		strength--
		particle_accelerator.update_icon()
		message_admins("PA Control Computer decreased to [strength] by [ADMIN_LOOKUPFLW(usr)] in [ADMIN_VERBOSEJMP(src)]")
		log_game("PA Control Computer decreased to [strength] by [key_name(usr)] in [AREACOORD(src)]")
		investigate_log("decreased to <font color='green'>[strength]</font> by [key_name(usr)] at [AREACOORD(src)]", INVESTIGATE_ENGINE)
		update_state()

/obj/machinery/particle_accelerator/control_box/proc/set_strength(str = 0)
	if((construction_state == PA_CONSTRUCTION_COMPLETE) && (str <= strength_upper_limit) && (str >= 0) && particle_accelerator)
		strength = str
		particle_accelerator.update_icon()
		message_admins("PA Control Computer set to [strength] by [ADMIN_LOOKUPFLW(usr)] in [ADMIN_VERBOSEJMP(src)]")
		log_game("PA Control Computer set to [strength] by [key_name(usr)] in [AREACOORD(src)]")
		investigate_log("set to <font color='green'>[strength]</font> by [key_name(usr)] at [AREACOORD(src)]", INVESTIGATE_ENGINE)
		update_state()

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
	var/obj/machinery/particle_accelerator/particle_emitter/temporary_emitter

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
	if(!check_part(T, /obj/machinery/particle_accelerator/particle_emitter, connected_parts))
		return FALSE
	temporary_emitter = locate(/obj/machinery/particle_accelerator/particle_emitter) in T
	if(temporary_emitter.emitter_type != "center")
		return FALSE
	T = get_step(T,ldir)
	if(!check_part(T, /obj/machinery/particle_accelerator/particle_emitter, connected_parts))
		return FALSE
	temporary_emitter = locate(/obj/machinery/particle_accelerator/particle_emitter) in T
	if(temporary_emitter.emitter_type != "left")
		return FALSE
	T = get_step(T,rdir)
	T = get_step(T,rdir)
	if(!check_part(T, /obj/machinery/particle_accelerator/particle_emitter, connected_parts))
		return FALSE
	temporary_emitter = locate(/obj/machinery/particle_accelerator/particle_emitter) in T
	if(temporary_emitter.emitter_type != "right")
		return FALSE
	var/turf/assemble_loc = get_turf(connected_parts["end_cap"])
	var/obj/machinery/particle_accelerator/full/fpa = new(assemble_loc)
	fpa.master = src
	fpa.setDir(dir)
	for(var/pa_ref as anything in connected_parts)
		if(pa_ref != "end_cap")
			var/turf/pa_turf = get_turf(connected_parts[pa_ref])
			var/obj/structure/filler/filler = new(pa_turf)
			filler.parent = src
			fpa.fillers[pa_ref] = filler
		qdel(connected_parts[pa_ref])
	particle_accelerator = fpa
	if(!assembled)
		new /obj/item/paper/guides/jobs/engineering/singularity(get_turf(src))
		assembled = TRUE
	return TRUE

/obj/machinery/particle_accelerator/control_box/proc/disassemble()
	if(!particle_accelerator)
		return FALSE
	if(active)
		toggle_power()
	var/static/list/pa_typepaths = list(
		"fuel_chamber" = /obj/machinery/particle_accelerator/fuel_chamber,
		"power_box" = /obj/machinery/particle_accelerator/power_box,
		"emitter_center" = /obj/machinery/particle_accelerator/particle_emitter,
		"emitter_left" = /obj/machinery/particle_accelerator/particle_emitter/left,
		"emitter_right" = /obj/machinery/particle_accelerator/particle_emitter/right,
	)
	var/turf/c_turf = get_turf(particle_accelerator)
	var/obj/machinery/particle_accelerator/end_cap/end_cap = new(c_turf)
	end_cap.setDir(dir)
	end_cap.anchored = TRUE
	end_cap.construction_state = PA_CONSTRUCTION_COMPLETE
	for(var/filler_ref as anything in particle_accelerator.fillers)
		var/turf/pa_turf = get_turf(particle_accelerator.fillers[filler_ref])
		var/obj/machinery/particle_accelerator/pa_type = pa_typepaths[filler_ref]
		var/obj/machinery/particle_accelerator/fuel_chamber/pa = new pa_type(pa_turf)
		pa.setDir(dir)
		pa.anchored = TRUE
		pa.construction_state = PA_CONSTRUCTION_COMPLETE
	QDEL_LIST_ASSOC_VAL(particle_accelerator.fillers)
	if(!QDELETED(particle_accelerator))
		QDEL_NULL(particle_accelerator)
	else
		particle_accelerator = null
	return TRUE

/obj/machinery/particle_accelerator/control_box/proc/check_part(turf/T, type, list/connected_parts)
	var/obj/machinery/particle_accelerator/PA = locate(/obj/machinery/particle_accelerator) in T
	if(istype(PA, type) && (PA.construction_state == PA_CONSTRUCTION_COMPLETE))
		if(PA.dir == dir)
			connected_parts[PA.reference] = PA
			return TRUE
	return FALSE

#undef PA_CONSTRUCTION_UNSECURED
#undef PA_CONSTRUCTION_UNWIRED
#undef PA_CONSTRUCTION_PANEL_OPEN
#undef PA_CONSTRUCTION_COMPLETE

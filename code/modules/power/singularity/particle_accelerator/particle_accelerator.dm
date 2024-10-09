/obj/machinery/particle_accelerator
	name = "Particle Accelerator"
	desc = "If you see this, please tell this to developers."
	icon = 'icons/psychonaut/obj/machines/engine/particle_accelerator.dmi'
	icon_state = "none"
	density = TRUE
	anchored = FALSE
	var/reference = null

/obj/machinery/particle_accelerator/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/particle_accelerator/end_cap
	name = "Alpha Particle Generation Array"
	desc = "This is where Alpha particles are generated from \[REDACTED\]."
	icon_state = "end_cap"
	reference = "end_cap"

/obj/machinery/particle_accelerator/end_cap/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/machinery/particle_accelerator/power_box
	name = "Particle Focusing EM Lens"
	desc = "This uses electromagnetic waves to focus the Alpha particles."
	icon_state = "power_box"
	reference = "power_box"

/obj/machinery/particle_accelerator/power_box/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/machinery/particle_accelerator/fuel_chamber
	name = "EM Acceleration Chamber"
	desc = "This is where the Alpha particles are accelerated to <b><i>radical speeds</i></b>."
	icon_state = "fuel_chamber"
	reference = "fuel_chamber"

/obj/machinery/particle_accelerator/fuel_chamber/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/machinery/particle_accelerator/particle_emitter
	name = "EM Containment Grid"
	desc = "This launches the Alpha particles, might not want to stand near this end."
	icon_state = "emitter_center"

/obj/machinery/particle_accelerator/particle_emitter/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/machinery/particle_accelerator/particle_emitter/center
	icon_state = "emitter_center"
	reference = "emitter_center"

/obj/machinery/particle_accelerator/particle_emitter/left
	icon_state = "emitter_left"
	reference = "emitter_left"

/obj/machinery/particle_accelerator/particle_emitter/right
	icon_state = "emitter_right"
	reference = "emitter_right"

/obj/machinery/particle_accelerator/full
	name = "Particle Accelerator"
	desc = "particle accelerator."
	icon = 'icons/psychonaut/obj/machines/engine/128x128.dmi'
	icon_state = "pac"
	anchored = TRUE
	appearance_flags = LONG_GLIDE
	var/list/obj/structure/fillers = list()
	var/obj/machinery/particle_accelerator/control_box/master = null
	var/fire_delay = 50
	var/last_shot = 0

/obj/machinery/particle_accelerator/full/setDir(newdir)
	. = ..()
	update_appearance()

/obj/machinery/particle_accelerator/full/Destroy()
	if(master)
		QDEL_NULL(master)
	return ..()

/obj/machinery/particle_accelerator/full/update_appearance(updates)
	. = ..()
	pixel_z = 0
	pixel_x = 0
	switch(dir)
		if(NORTH)
			pixel_x = -48
		if(SOUTH)
			pixel_x = -48
			pixel_z = -96
		if(EAST)
			pixel_z = -48
		if(WEST)
			pixel_x = -96
			pixel_z = -48

/obj/machinery/particle_accelerator/full/wrench_act(mob/living/user, obj/item/I)
	return FALSE

/obj/machinery/particle_accelerator/full/proc/set_delay(delay)
	if(delay >= 0)
		fire_delay = delay
		return 1
	return 0

/obj/machinery/particle_accelerator/full/proc/emit_particle(strength = 0)
	if((last_shot + fire_delay) <= world.time)
		last_shot = world.time
		for(var/filler as anything in fillers)
			if(filler != "emitter_center" && filler != "emitter_left" && filler != "emitter_right")
				continue
			var/turf/T = get_turf(fillers[filler])
			var/obj/effect/accelerated_particle/P
			switch(strength)
				if(0)
					P = new/obj/effect/accelerated_particle/weak(T)
				if(1)
					P = new/obj/effect/accelerated_particle(T)
				if(2)
					P = new/obj/effect/accelerated_particle/strong(T)
				if(3)
					P = new/obj/effect/accelerated_particle/powerful(T)
			P.setDir(dir)
		return 1
	return 0


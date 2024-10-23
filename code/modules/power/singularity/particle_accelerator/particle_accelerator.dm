/* Composed of 7 parts :
 * 3 Particle Emitters: Left - Center - Right
 * 1 Power Box
 * 1 Fuel Chamber
 * 1 End Cap
 * 1 Control computer
 * Setup map
 *   |EC|
 * CC|FC|
 *   |PB|
 * PE|PE|PE
 */

#define PA_CONSTRUCTION_UNSECURED  0
#define PA_CONSTRUCTION_UNWIRED    1
#define PA_CONSTRUCTION_PANEL_OPEN 2
#define PA_CONSTRUCTION_COMPLETE   3

/obj/machinery/particle_accelerator
	name = "Particle Accelerator"
	desc = "If you see this, please tell this to developers."
	icon = 'icons/psychonaut/obj/machines/engine/particle_accelerator.dmi'
	icon_state = "none"
	density = TRUE
	anchored = FALSE
	var/reference = null
	var/construction_state = PA_CONSTRUCTION_UNSECURED

/obj/machinery/particle_accelerator/examine(mob/user)
	. = ..()

	switch(construction_state)
		if(PA_CONSTRUCTION_UNSECURED)
			. += "Looks like it's not attached to the flooring."
		if(PA_CONSTRUCTION_UNWIRED)
			. += "It is missing some cables."
		if(PA_CONSTRUCTION_PANEL_OPEN)
			. += "The panel is open."

/obj/machinery/particle_accelerator/set_anchored(anchorvalue)
	. = ..()
	if(isnull(.))
		return
	construction_state = anchorvalue ? PA_CONSTRUCTION_UNWIRED : PA_CONSTRUCTION_UNSECURED
	update_state()
	update_icon()

/obj/machinery/particle_accelerator/wrench_act(mob/living/user, obj/item/item)
	switch(construction_state)
		if(PA_CONSTRUCTION_UNSECURED)
			default_unfasten_wrench(user, item, 20)
			user.visible_message("<span class='notice'>[user.name] secures the [name] to the floor.</span>", \
				"<span class='notice'>You secure the external bolts.</span>")
		if(PA_CONSTRUCTION_UNWIRED)
			default_unfasten_wrench(user, item, 20)
			user.visible_message("<span class='notice'>[user.name] detaches the [name] from the floor.</span>", \
				"<span class='notice'>You remove the external bolts.</span>")
		else
			return FALSE
	update_icon()
	update_state()
	return TRUE

/obj/machinery/particle_accelerator/screwdriver_act(mob/living/user, obj/item/tool)
	switch(construction_state)
		if(PA_CONSTRUCTION_COMPLETE)
			if(tool.use_tool(src, user, 10))
				user.visible_message("<span class='notice'>[user.name] opens the [name]'s access panel.</span>", \
					"<span class='notice'>You open the access panel.</span>")
				construction_state = PA_CONSTRUCTION_PANEL_OPEN
		if(PA_CONSTRUCTION_PANEL_OPEN)
			if(tool.use_tool(src, user, 10))
				user.visible_message("<span class='notice'>[user.name] closes the [name]'s access panel.</span>", \
					"<span class='notice'>You close the access panel.</span>")
				construction_state = PA_CONSTRUCTION_COMPLETE
		else
			return FALSE
	update_icon()
	update_state()
	return TRUE

/obj/machinery/particle_accelerator/wirecutter_act(mob/living/user, obj/item/tool)
	if(construction_state == PA_CONSTRUCTION_PANEL_OPEN && tool.use_tool(src, user, 5))
		user.visible_message("<span class='notice'>[user.name] removes some wires from the [name].</span>", \
			"<span class='notice'>You remove some wires.</span>")
		construction_state = PA_CONSTRUCTION_UNWIRED
		update_icon()
		update_state()
		return TRUE
	else
		return FALSE

/obj/machinery/particle_accelerator/attackby(obj/item/W, mob/user, params)
	if(isnull(reference))
		return ..()

	if(construction_state == PA_CONSTRUCTION_UNWIRED && istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if(CC.use_tool(src, user, 5, 1))
			user.visible_message("<span class='notice'>[user.name] adds wires to the [name].</span>", \
				"<span class='notice'>You add some wires.</span>")
			construction_state = PA_CONSTRUCTION_PANEL_OPEN
			update_icon()
			update_state()
	return ..()

/obj/machinery/particle_accelerator/proc/update_state()
	return

/obj/machinery/particle_accelerator/update_icon_state()
	if(isnull(reference))
		return ..()
	switch(construction_state)
		if(PA_CONSTRUCTION_UNSECURED,PA_CONSTRUCTION_UNWIRED)
			icon_state="[reference]"
		if(PA_CONSTRUCTION_PANEL_OPEN)
			icon_state="[reference]w"
		if(PA_CONSTRUCTION_COMPLETE)
			icon_state="[reference]c"
	return ..()

/obj/machinery/particle_accelerator/end_cap
	name = "Alpha Particle Generation Array"
	desc = "This is where Alpha particles are generated from \[REDACTED\]."
	circuit = /obj/item/circuitboard/machine/pa/end_cap
	icon_state = "end_cap"
	reference = "end_cap"

/obj/machinery/particle_accelerator/end_cap/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/machinery/particle_accelerator/power_box
	name = "Particle Focusing EM Lens"
	desc = "This uses electromagnetic waves to focus the Alpha particles."
	circuit = /obj/item/circuitboard/machine/pa/power_box
	icon_state = "power_box"
	reference = "power_box"

/obj/machinery/particle_accelerator/power_box/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/machinery/particle_accelerator/fuel_chamber
	name = "EM Acceleration Chamber"
	desc = "This is where the Alpha particles are accelerated to <b><i>radical speeds</i></b>."
	circuit = /obj/item/circuitboard/machine/pa/fuel_chamber
	icon_state = "fuel_chamber"
	reference = "fuel_chamber"
	var/filled_with = NONE

/obj/machinery/particle_accelerator/fuel_chamber/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/machinery/particle_accelerator/particle_emitter
	name = "EM Containment Grid"
	desc = "This launches the Alpha particles, might not want to stand near this end."
	circuit = /obj/item/circuitboard/machine/pa/particle_emitter
	icon_state = "emitter_center"

/obj/machinery/particle_accelerator/particle_emitter/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/machinery/particle_accelerator/particle_emitter/click_ctrl(mob/living/user)
	if(construction_state != PA_CONSTRUCTION_UNSECURED)
		return CLICK_ACTION_BLOCKING
	var/emitter_direction
	switch(reference)
		if("emitter_center")
			reference = "emitter_left"
			emitter_direction = "left"
		if("emitter_left")
			reference = "emitter_right"
			emitter_direction = "right"
		if("emitter_right")
			reference = "emitter_center"
			emitter_direction = "center"
	user.visible_message("<span class='notice'>[user.name] changes the emitter's direction to [emitter_direction].</span>", \
		"<span class='notice'>You changed the emitter's rotation to [emitter_direction].</span>")
	icon_state = reference
	return CLICK_ACTION_SUCCESS

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
	construction_state = PA_CONSTRUCTION_COMPLETE
	var/list/obj/structure/fillers = list()
	var/obj/machinery/particle_accelerator/control_box/master = null
	var/fire_delay = 50
	var/last_shot = 0
	var/filled_with = NONE
	COOLDOWN_DECLARE(next_fire)

/obj/machinery/particle_accelerator/full/setDir(newdir)
	. = ..()
	update_appearance()

/obj/machinery/particle_accelerator/full/Destroy()
	if(master)
		master.active = FALSE
		master.strength = 0
		master.disassemble()
	return ..()

/obj/machinery/particle_accelerator/full/process()
	if(master && master.active && (last_shot + fire_delay) <= world.time)
		emit_particle(master.strength)

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

/obj/machinery/particle_accelerator/full/update_icon_state()
	. = ..()
	if(master && master.active)
		icon_state = "pa[master.strength]"
	else
		icon_state = "pac"

/obj/machinery/particle_accelerator/full/wrench_act(mob/living/user, obj/item/I)
	return FALSE

/obj/machinery/particle_accelerator/full/screwdriver_act(mob/living/user, obj/item/I)
	return FALSE

/obj/machinery/particle_accelerator/full/wirecutter_act(mob/living/user, obj/item/tool)
	return FALSE

/obj/machinery/particle_accelerator/full/proc/set_delay(delay)
	if(delay >= 0)
		fire_delay = delay
		return 1
	return 0

/obj/machinery/particle_accelerator/full/proc/emit_particle(strength = 0)
	last_shot = world.time
	for(var/filler as anything in fillers)
		if(filler != "emitter_center" && filler != "emitter_left" && filler != "emitter_right")
			continue
		var/turf/T = get_turf(fillers[filler])
		var/obj/projectile/accelerated_particle/P
		switch(strength)
			if(0)
				P = new/obj/projectile/accelerated_particle/weak(T)
			if(1)
				P = new/obj/projectile/accelerated_particle(T)
			if(2)
				P = new/obj/projectile/accelerated_particle/strong(T)
			if(3)
				P = new/obj/projectile/accelerated_particle/powerful(T)
		P.firer = src
		P.fired_from = src
		P.fire(dir2angle(dir))
		P.filled_with = filled_with
	return 1

#undef PA_CONSTRUCTION_UNSECURED
#undef PA_CONSTRUCTION_UNWIRED
#undef PA_CONSTRUCTION_PANEL_OPEN
#undef PA_CONSTRUCTION_COMPLETE

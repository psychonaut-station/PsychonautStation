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

/obj/machinery/particle_accelerator/Initialize(mapload)
	. = ..()
	register_context()

/obj/machinery/particle_accelerator/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = NONE
	if(isnull(held_item))
		return

	if(held_item.tool_behaviour == TOOL_WRENCH)
		switch(construction_state)
			if(PA_CONSTRUCTION_UNSECURED)
				context[SCREENTIP_CONTEXT_LMB] = "Secure"
				return CONTEXTUAL_SCREENTIP_SET
			if(PA_CONSTRUCTION_UNWIRED)
				context[SCREENTIP_CONTEXT_LMB] = "Unsecure"
				return CONTEXTUAL_SCREENTIP_SET
	else if(held_item.tool_behaviour == TOOL_SCREWDRIVER)
		switch(construction_state)
			if(PA_CONSTRUCTION_COMPLETE)
				context[SCREENTIP_CONTEXT_LMB] = "Open wire panel"
				return CONTEXTUAL_SCREENTIP_SET
			if(PA_CONSTRUCTION_PANEL_OPEN)
				context[SCREENTIP_CONTEXT_LMB] = "Close wire panel"
				return CONTEXTUAL_SCREENTIP_SET
	else if(held_item.tool_behaviour == TOOL_WIRECUTTER && construction_state == PA_CONSTRUCTION_PANEL_OPEN)
		context[SCREENTIP_CONTEXT_LMB] = "Cut wires"
		return CONTEXTUAL_SCREENTIP_SET
	else if(istype(held_item, /obj/item/stack/cable_coil) && construction_state == PA_CONSTRUCTION_UNWIRED)
		context[SCREENTIP_CONTEXT_LMB] = "Add wires"
		return CONTEXTUAL_SCREENTIP_SET

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
	if(panel_open)
		to_chat(user, span_warning("The access panel is open!"))
		return FALSE
	switch(construction_state)
		if(PA_CONSTRUCTION_UNSECURED)
			default_unfasten_wrench(user, item, 20)
			user.visible_message(span_notice("[user.name] secures the [name] to the floor."), \
				span_notice("You secure the external bolts."))
		if(PA_CONSTRUCTION_UNWIRED)
			default_unfasten_wrench(user, item, 20)
			user.visible_message(span_notice("[user.name] detaches the [name] from the floor."), \
				span_notice("You remove the external bolts."))
		else
			return FALSE
	update_icon()
	update_state()
	return TRUE

/obj/machinery/particle_accelerator/screwdriver_act(mob/living/user, obj/item/tool)
	switch(construction_state)
		if(PA_CONSTRUCTION_COMPLETE)
			if(tool.use_tool(src, user, 10))
				user.visible_message(span_notice("[user.name] opens the [name]'s wire panel."), \
					span_notice("You open the access panel."))
				construction_state = PA_CONSTRUCTION_PANEL_OPEN
		if(PA_CONSTRUCTION_PANEL_OPEN)
			if(tool.use_tool(src, user, 10))
				user.visible_message(span_notice("[user.name] closes the [name]'s wire panel."), \
					span_notice("You close the wire panel."))
				construction_state = PA_CONSTRUCTION_COMPLETE
		if(PA_CONSTRUCTION_UNSECURED)
			return default_deconstruction_screwdriver(user, icon_state, icon_state, tool)
		else
			return FALSE
	update_icon()
	update_state()
	return TRUE

/obj/machinery/particle_accelerator/wirecutter_act(mob/living/user, obj/item/tool)
	if(construction_state == PA_CONSTRUCTION_PANEL_OPEN && tool.use_tool(src, user, 5))
		user.visible_message(span_notice("[user.name] removes some wires from the [name]."), \
			span_notice("You remove some wires."))
		construction_state = PA_CONSTRUCTION_UNWIRED
		new /obj/item/stack/cable_coil(get_turf(src), 1)
		update_icon()
		update_state()
		return TRUE
	else
		return FALSE

/obj/machinery/particle_accelerator/crowbar_act(mob/living/user, obj/item/tool)
	if(construction_state == PA_CONSTRUCTION_UNSECURED)
		return default_deconstruction_crowbar(tool)
	else
		return FALSE

/obj/machinery/particle_accelerator/attackby(obj/item/W, mob/user, params)
	if(isnull(reference))
		return ..()

	if(construction_state == PA_CONSTRUCTION_UNWIRED && istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if(CC.use_tool(src, user, 5, 1))
			user.visible_message(span_notice("[user.name] adds wires to the [name]."), \
				span_notice("You add some wires."))
			construction_state = PA_CONSTRUCTION_PANEL_OPEN
			update_icon()
			update_state()
	else
		return ..()

/obj/machinery/particle_accelerator/proc/update_state()
	return

/obj/machinery/particle_accelerator/update_icon_state()
	if(isnull(reference) || reference == "control_box")
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

/obj/machinery/particle_accelerator/fuel_chamber/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

#define CENTER "center"
#define RIGHT "right"
#define LEFT "left"

/obj/machinery/particle_accelerator/particle_emitter
	name = "EM Containment Grid"
	desc = "This launches the Alpha particles, might not want to stand near this end."
	circuit = /obj/item/circuitboard/machine/pa/particle_emitter
	icon_state = "emitter_center"
	reference = "emitter_center"
	var/emitter_type = CENTER

/obj/machinery/particle_accelerator/particle_emitter/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/machinery/particle_accelerator/particle_emitter/multitool_act(mob/living/user, obj/item/tool)
	if(construction_state != PA_CONSTRUCTION_UNSECURED)
		return FALSE
	switch(emitter_type)
		if(CENTER)
			emitter_type = LEFT
		if(LEFT)
			emitter_type = RIGHT
		if(RIGHT)
			emitter_type = CENTER
	reference = "emitter_[emitter_type]"
	icon_state = reference
	user.visible_message(span_notice("[user.name] changes the emitter's type to [emitter_type]."), \
		span_notice("You changed the emitter's type to [emitter_type]."))
	return TRUE

/obj/machinery/particle_accelerator/particle_emitter/left
	icon_state = "emitter_left"
	reference = "emitter_left"
	emitter_type = LEFT

/obj/machinery/particle_accelerator/particle_emitter/right
	icon_state = "emitter_right"
	reference = "emitter_right"
	emitter_type = RIGHT

#undef LEFT
#undef RIGHT
#undef CENTER
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
	COOLDOWN_DECLARE(next_fire)

/obj/machinery/particle_accelerator/full/Destroy()
	if(master)
		master.active = FALSE
		master.strength = 0
		master.disassemble()
	return ..()

/obj/machinery/particle_accelerator/full/setDir(newdir)
	. = ..()
	update_appearance()

/obj/machinery/particle_accelerator/full/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	return NONE

/obj/machinery/particle_accelerator/full/process()
	if(master && master.active && (last_shot + fire_delay) <= world.time)
		emit_particle(master.strength)

/obj/machinery/particle_accelerator/full/update_appearance(updates)
	. = ..()
	pixel_y = 0
	pixel_x = 0
	switch(dir)
		if(NORTH)
			pixel_x = -48
		if(SOUTH)
			pixel_x = -48
			pixel_y = -96
		if(EAST)
			pixel_y = -48
		if(WEST)
			pixel_x = -96
			pixel_y = -48

/obj/machinery/particle_accelerator/full/update_icon_state()
	. = ..()
	if(master && master.active)
		icon_state = "pa[master.strength]"
	else
		icon_state = "pac"

/obj/machinery/particle_accelerator/full/wrench_act(mob/living/user, obj/item/I)
	return

/obj/machinery/particle_accelerator/full/screwdriver_act(mob/living/user, obj/item/I)
	return

/obj/machinery/particle_accelerator/full/wirecutter_act(mob/living/user, obj/item/tool)
	return

/obj/machinery/particle_accelerator/full/crowbar_act(mob/living/user, obj/item/I)
	return

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
	return 1

#undef PA_CONSTRUCTION_UNSECURED
#undef PA_CONSTRUCTION_UNWIRED
#undef PA_CONSTRUCTION_PANEL_OPEN
#undef PA_CONSTRUCTION_COMPLETE

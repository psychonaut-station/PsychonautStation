/obj/structure/foldable_barricade
	name = "foldable barricade"
	desc = "A folding barricade made out of metal, making it slightly stronger than a normal metal barricade. Use a blowtorch to repair. Can be flipped down to create a path."
	icon = 'icons/psychonaut/obj/barricade.dmi'
	icon_state = "folding_metal_0"
	base_icon_state = "folding"
	anchored = TRUE
	density = FALSE
	layer = BELOW_OBJ_LAYER
	flags_1 = ON_BORDER_1
	obj_flags = CAN_BE_HIT | IGNORE_DENSITY | BLOCKS_CONSTRUCTION_DIR
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 11)

	pass_flags_self = LETPASSTHROW
	max_integrity = 200
	///Whether this is open
	var/is_open = TRUE
	///Is this barricade wired?
	var/is_wired = FALSE

/obj/structure/foldable_barricade/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/climbable)
	AddElement(/datum/element/simple_rotation)
	register_context()

	var/static/list/loc_connections = list(
		COMSIG_ATOM_EXIT = PROC_REF(on_exit),
	)

	AddElement(/datum/element/connect_loc, loc_connections)
	update_appearance()

/obj/structure/foldable_barricade/proc/on_exit(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER
	if(is_open)
		return

	if(leaving.movement_type & PHASING)
		return

	if(leaving == src)
		return

	if(istype(leaving, /obj/projectile))
		return

	if(direction == dir)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/foldable_barricade/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(.)
		return

	if(is_open)
		return FALSE

	if(isprojectile(mover))
		var/obj/projectile/proj = mover
		//Lets through bullets shot from behind the cover of the table
		if(proj.movement_vector && angle2dir_cardinal(proj.movement_vector.angle) == dir)
			return TRUE
		return FALSE
	if(border_dir == dir)
		return FALSE

	return TRUE

/obj/structure/foldable_barricade/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	context[SCREENTIP_CONTEXT_LMB] = is_open ? "Close" : "Open"

	if(!isnull(held_item))
		if(!is_wired && istype(held_item, /obj/item/stack/rods))
			context[SCREENTIP_CONTEXT_LMB] = "Wire"
		else if(is_wired && held_item.tool_behaviour == TOOL_WIRECUTTER)
			context[SCREENTIP_CONTEXT_LMB] = "Remove wires"
		else if(held_item.tool_behaviour == TOOL_WELDER)
			context[SCREENTIP_CONTEXT_LMB] = "Repair"
		else if(held_item.tool_behaviour == TOOL_WRENCH)
			context[SCREENTIP_CONTEXT_LMB] = anchored ? "Unanchor" : "Anchor"

	return CONTEXTUAL_SCREENTIP_SET

/obj/structure/foldable_barricade/attack_hand(mob/living/user)
	. = ..()
	if(!.)
		toggle_open(user)

/obj/structure/foldable_barricade/proc/toggle_open(mob/living/user)
	playsound(loc, 'sound/items/tools/ratchet.ogg', 25, 1)
	is_open = !is_open
	density = !density

	user.visible_message(span_notice("[user] flips [src] [is_open ? "open" :"closed"]."),
		span_notice("You flip [src] [is_open ? "open" :"closed"]."))

	update_appearance()

/obj/structure/foldable_barricade/update_icon_state()
	. = ..()
	var/damage_state
	var/percentage = get_integrity_percentage()
	switch(percentage)
		if(0 to 0.25)
			damage_state = 3
		if(0.25 to 0.5)
			damage_state = 2
		if(0.5 to 0.75)
			damage_state = 1
		if(0.75 to 1)
			damage_state = 0

	icon_state = "[base_icon_state]_metal"
	if(is_open)
		icon_state += "_open"

	icon_state += "_[damage_state]"

	if(is_open)
		layer = OBJ_LAYER
	else
		switch(dir)
			if(SOUTH)
				layer = ABOVE_MOB_LAYER
			if(NORTH)
				layer = initial(layer) - 0.01
			else
				layer = initial(layer)

/obj/structure/foldable_barricade/update_overlays()
	. = ..()
	if(is_wired)
		. += mutable_appearance(icon, "[base_icon_state]_metal[is_open ? "_open" : ""]_wire", layer = dir == NORTH ? layer : ABOVE_MOB_LAYER)

/obj/structure/foldable_barricade/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/stack/rods))
		return wire(user, tool)
	return ..()

/obj/structure/foldable_barricade/welder_act(mob/living/user, obj/item/tool)
	if(atom_integrity >= max_integrity)
		to_chat(user, span_warning("[src] is already in good condition!"))
		return ITEM_INTERACT_SUCCESS
	if(!tool.tool_start_check(user, amount = 0))
		return FALSE
	to_chat(user, span_notice("You begin repairing [src]..."))
	if(tool.use_tool(src, user, 4 SECONDS, volume = 50))
		repair_damage(max_integrity)
		to_chat(user, span_notice("You repair [src]."))
	return ITEM_INTERACT_SUCCESS

/obj/structure/foldable_barricade/wirecutter_act(mob/living/user, obj/item/I)
	if(!is_wired)
		return FALSE

	balloon_alert_to_viewers("removing wire...")

	if(!do_after(user, 2 SECONDS, src, NONE) || !is_wired)
		return TRUE

	is_wired = FALSE
	playsound(loc, 'sound/items/tools/wirecutter.ogg', 25, TRUE)
	balloon_alert_to_viewers("removed")
	modify_max_integrity(initial(max_integrity) - 50)
	AddElement(/datum/element/climbable)
	update_appearance()
	new /obj/item/stack/rods(loc)

/obj/structure/foldable_barricade/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/structure/foldable_barricade/proc/wire(atom/user, obj/item/stack/rods/rod)
	if(is_wired)
		balloon_alert(user, "already wired!")
		return ITEM_INTERACT_BLOCKING
	if(!rod.use(1))
		balloon_alert(user, "not enough iron rod!")
		return ITEM_INTERACT_BLOCKING

	balloon_alert_to_viewers("setting up wire...")
	if(!do_after(user, 2 SECONDS, src) || is_wired)
		return

	is_wired = TRUE
	playsound(loc, 'sound/_psychonaut/grate.ogg', 25)
	RemoveElement(/datum/element/climbable)
	modify_max_integrity(initial(max_integrity) + 50)
	update_appearance()

/obj/structure/foldable_barricade/setDir(newdir)
	. = ..()
	update_appearance()

/obj/structure/foldable_barricade/ex_act(severity)
	switch(severity)
		if(EXPLODE_DEVASTATE)
			deconstruct(FALSE)
			return
		if(EXPLODE_HEAVY)
			take_damage(rand(33, 66), BRUTE, BOMB)
		if(EXPLODE_LIGHT)
			take_damage(rand(10, 33), BRUTE, BOMB)

	update_appearance()

/obj/structure/foldable_barricade/attack_alien(mob/living/carbon/alien/attacker, list/modifiers)
	if(is_wired)
		balloon_alert(attacker, "barbed wire slicing into you!")
		attacker.apply_damage(20, blocked = MELEE , sharpness = SHARP_EDGED)

	return ..()

/obj/structure/foldable_barricade/examine(mob/user)
	. = ..()
	if(is_wired)
		. += span_info("There is a length of wire strewn across the top of this barricade.")
	switch(get_integrity_percentage())
		if(0.75 to 1)
			. += span_info("It appears to be in good shape.")
		if(0.5 to 0.75)
			. += span_warning("It's slightly damaged, but still very functional.")
		if(0.25 to 0.5)
			. += span_warning("It's quite beat up, but it's holding together.")
		if(0 to 0.25)
			. += span_warning("It's crumbling apart, just a few more blows will tear it apart.")

/obj/structure/foldable_barricade/atom_deconstruct(disassembled = TRUE)
	if(disassembled && is_wired)
		new /obj/item/stack/rods(loc)
	drop_custom_materials(max(atom_integrity / max_integrity, 1))
	return ..()

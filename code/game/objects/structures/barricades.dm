/obj/structure/foldable_barricade
	name = "Foldable barricade"
	desc = "A folding barricade made out of metal, making it slightly stronger than a normal metal barricade. Use a blowtorch to repair. Can be flipped down to create a path."
	icon = 'icons/psychonaut/obj/barricade.dmi'
	icon_state = "folding_metal_0"
	base_icon_state = "folding"
	anchored = FALSE
	density = FALSE
	layer = BELOW_OBJ_LAYER
	flags_1 = ON_BORDER_1
	obj_flags = CAN_BE_HIT | IGNORE_DENSITY | BLOCKS_CONSTRUCTION_DIR
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 11)

	pass_flags_self = LETPASSTHROW
	max_integrity = 200
	///The type of stack the barricade dropped when disassembled if any.
	var/stack_type = /obj/item/stack/sheet/iron
	///The amount of stack dropped when disassembled at full health
	var/stack_amount = 5
	///to specify a non-zero amount of stack to drop when destroyed
	var/destroyed_stack_amount = 1
	var/barricade_type = "metal"
	///Whether this is open
	var/is_open = TRUE
	///Can this barricade type be wired
	var/can_wire = TRUE
	///Is this barricade wired?
	var/is_wired = FALSE

/obj/structure/foldable_barricade/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/climbable)

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

/obj/structure/foldable_barricade/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return

	toggle_open(null, user)

/obj/structure/foldable_barricade/proc/toggle_open(state, atom/user)
	if(state == is_open)
		return
	playsound(loc, 'sound/items/tools/ratchet.ogg', 25, 1)
	is_open = !is_open
	density = !density

	user?.visible_message(span_notice("[user] flips [src] [is_open ? "open" :"closed"]."),
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

	icon_state = "[base_icon_state]_[barricade_type]"
	if(is_open)
		icon_state += "_open"

	icon_state += "_[damage_state]"

	if(is_open)
		layer = OBJ_LAYER
	else if(!anchored)
		layer = initial(layer)
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
		. += mutable_appearance(icon, "[base_icon_state]_[barricade_type][is_open ? "_open" : ""]_wire", layer = dir == NORTH ? layer : ABOVE_MOB_LAYER)

/obj/structure/foldable_barricade/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/stack/cable_coil))
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

	if(!do_after(user, 2 SECONDS, src, NONE))
		return TRUE

	playsound(loc, 'sound/items/tools/wirecutter.ogg', 25, TRUE)
	balloon_alert_to_viewers("removed")
	modify_max_integrity(max_integrity - 50)
	is_wired = FALSE
	AddElement(/datum/element/climbable)
	update_appearance()
	new /obj/item/stack/cable_coil(loc)

/obj/structure/foldable_barricade/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/structure/foldable_barricade/proc/wire(atom/user, obj/item/stack/cable_coil/coil)
	if(!can_wire)
		balloon_alert(user, "cannot wire barrier!")
		return ITEM_INTERACT_BLOCKING
	if(is_wired)
		balloon_alert(user, "already wired!")
		return ITEM_INTERACT_BLOCKING
	if(!coil.use(1))
		balloon_alert(user, "not enough cable!")
		return ITEM_INTERACT_BLOCKING

	balloon_alert_to_viewers("setting up wire...")
	if(!do_after(user, 2 SECONDS, src))
		return

	is_wired = TRUE
	playsound(loc, 'sound/_psychonaut/grate.ogg', 25)
	RemoveElement(/datum/element/climbable)
	modify_max_integrity(max_integrity + 50)
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

/obj/structure/foldable_barricade/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(anchored)
		balloon_alert(usr, "fastened to the floor")
		return FALSE

	setDir(turn(dir, 270))

/obj/structure/foldable_barricade/attack_alien(mob/living/carbon/alien/attacker, list/modifiers)
	if(is_wired)
		balloon_alert(attacker, "barbed wire slicing into you!")
		attacker.apply_damage(20, blocked = MELEE , sharpness = SHARP_EDGED)

	return ..()

/obj/structure/foldable_barricade/CanAllowThrough(atom/movable/mover, turf/target)
	if(get_dir(loc, target) & dir)
		if(is_wired && density && ismob(mover))
			return FALSE

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

/obj/structure/foldable_barricade/handle_deconstruct(disassembled = TRUE, mob/living/blame_mob)
	if(disassembled && is_wired)
		new /obj/item/stack/cable_coil(loc)
	if(stack_type)
		var/stack_amt = destroyed_stack_amount
		if(disassembled)
			stack_amt = round(stack_amount * (atom_integrity/max_integrity)) //Get an amount of sheets back equivalent to remaining health. Obviously, fully destroyed means 0
		if(stack_amt)
			new stack_type (loc, stack_amt)
	return ..()

/obj/vehicle/ridden/golfcart
	///A ttv or chem grenade can be installed under the hood
	var/obj/item/carbomb = null

/obj/vehicle/ridden/golfcart/item_interaction(mob/living/user, obj/item/attacking_item, list/modifiers)
	if (!hood_open)
		return ..()
	// Allow installing a ttv or chem grenade under the hood
	if (istype(attacking_item, /obj/item/grenade/chem_grenade) || istype(attacking_item, /obj/item/transfer_valve))
		if (carbomb)
			balloon_alert(user, "there's already something installed under the hood!")
			return ITEM_INTERACT_BLOCKING
		user.transferItemToLoc(attacking_item, src)
		carbomb = attacking_item
		balloon_alert(user, "installed explosive device under the hood.")
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/vehicle/ridden/golfcart/examine(mob/user)
	. = ..()
	if (hood_open && carbomb)
		. += span_info("You can see \the [carbomb] inside.")
		. += span_smallnotice("You can remove the [carbomb] with a wirecutter.")

// Grenades and transfer valves must be removed with a wirecutter, not by hand.
/obj/vehicle/ridden/golfcart/wirecutter_act(mob/living/user, obj/item/tool)
	// Requires hood open
	if (!hood_open)
		return ..()
	if (tool.tool_behaviour != TOOL_WIRECUTTER)
		return ..()
	tool.play_tool_sound(src)
	// Remove ttv or grenade (if present)
	if (carbomb)
		var/obj/item/carbomb_to_take = carbomb
		carbomb = null
		to_chat(user, span_notice("You remove the [carbomb] from under the hood."))
		if(!user.put_in_hands(carbomb_to_take))
			carbomb_to_take.forceMove(drop_location())
		return ITEM_INTERACT_SUCCESS
	return ..()

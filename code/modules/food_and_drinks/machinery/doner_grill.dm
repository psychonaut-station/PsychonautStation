/obj/machinery/doner_grill
	name = "doner grill"
	desc = "A doner grill."
	icon = 'icons/psychonaut/obj/machines/kitchen.dmi'
	icon_state = "doner_grill"
	base_icon_state = "doner_grill"
	density = TRUE
	processing_flags = START_PROCESSING_MANUALLY
	anchored_tabletop_offset = 11
	anchored = FALSE
	pass_flags = PASSTABLE
	var/is_on = FALSE
	var/obj/item/doner_stick/doner_stick
	var/required_bake_time = 1 MINUTES
	///Sound loop for the sizzling sound
	var/datum/looping_sound/grill/grillsound

/obj/machinery/doner_grill/Initialize(mapload)
	. = ..()
	grillsound = new(src, FALSE)
	register_context()

/obj/machinery/doner_grill/Destroy()
	QDEL_NULL(grillsound)
	QDEL_NULL(particles)
	return ..()

/obj/machinery/doner_grill/update_icon_state()
	if(is_on)
		icon_state = "[base_icon_state]-on"
	else
		icon_state = base_icon_state
	return ..()

/obj/machinery/doner_grill/update_overlays()
	. = ..()
	if(doner_stick)
		. += mutable_appearance(doner_stick.icon, doner_stick.icon_state)

/obj/machinery/doner_grill/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(isnull(held_item))
		if(doner_stick)
			context[SCREENTIP_CONTEXT_LMB] = "Take stick"
		if(!is_on)
			context[SCREENTIP_CONTEXT_RMB] = "Turn on"
		else
			context[SCREENTIP_CONTEXT_RMB] = "Turn off"
		return CONTEXTUAL_SCREENTIP_SET
	if(isnull(doner_stick) && istype(held_item, /obj/item/doner_stick))
		context[SCREENTIP_CONTEXT_LMB] = "Attach stick"
		return CONTEXTUAL_SCREENTIP_SET
	else if(!isnull(doner_stick) && !doner_stick.raw && held_item.tool_behaviour == TOOL_KNIFE)
		context[SCREENTIP_CONTEXT_LMB] = "Slice meat"
		return CONTEXTUAL_SCREENTIP_SET
	return NONE

/obj/machinery/doner_grill/can_be_unfasten_wrench(mob/user, silent)
	. = ..()
	if(anchored && doner_stick)
		to_chat(user, span_warning("You cannot unsecure [src] while there is a doner stick attached!"))
		return CANT_UNFASTEN
	if(anchored && is_on)
		to_chat(user, span_warning("You cannot unsecure [src] while its on!"))
		return CANT_UNFASTEN

/obj/machinery/doner_grill/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/doner_grill/attackby(obj/item/item, mob/user, params)
	if(isnull(doner_stick) && istype(item, /obj/item/doner_stick))
		var/obj/item/doner_stick/stick = item
		if(!anchored)
			to_chat(usr, span_warning("[src] needs to be secured first!"))
			balloon_alert(usr, "secure first!")
			return TRUE
		doner_stick = stick
		doner_stick.forceMove(src)
		required_bake_time = stick.meat_level * 12.5 SECONDS
		if(is_on)
			begin_processing()
			grillsound.start()
		update_appearance()
		return TRUE
	else if(item.tool_behaviour == TOOL_KNIFE)
		if(!isnull(doner_stick))
			. = doner_stick.attackby(item, user, params)
			update_appearance()
		else
			return ..()
	else
		return ..()

/obj/machinery/doner_grill/AllowDrop()
	return FALSE

/obj/machinery/doner_grill/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(doner_stick)
		user.put_in_hands(doner_stick)
		doner_stick = null
		grillsound.stop()
		QDEL_NULL(particles)
		update_appearance()

/obj/machinery/doner_grill/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(!anchored)
		to_chat(usr, span_warning("[src] needs to be secured first!"))
		balloon_alert(usr, "secure first!")
		return
	is_on = !is_on
	if(is_on)
		if(doner_stick)
			begin_processing()
			grillsound.start()
	else
		end_processing()
		grillsound.stop()
		QDEL_NULL(particles)
	update_appearance()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/doner_grill/process(seconds_per_tick)
	if(!is_on || !doner_stick)
		return PROCESS_KILL
	if(!doner_stick.raw || !doner_stick.meat_level)
		return
	if(!particles)
		particles = new /particles/smoke/steam/mild/center(src)
	doner_stick.current_bake_time += seconds_per_tick * 10
	if(doner_stick.current_bake_time >= required_bake_time)
		doner_stick.raw = FALSE
		doner_stick.current_bake_time = 0
		doner_stick.meat_left = doner_stick.meat_level
		grillsound.stop()
		QDEL_NULL(particles)
		doner_stick.update_appearance()
		update_appearance()
		return PROCESS_KILL

/obj/item/doner_stick
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	name = "doner stick"
	icon_state = "doner_stick"
	desc = "A tool for stringing meat on a stick and cooking it."
	w_class = WEIGHT_CLASS_BULKY
	item_flags = NO_BLOOD_ON_ITEM
	var/static/list/meat_types = list("birdmeat" = "chicken", "meat" = "meat")
	var/meat_type
	var/meat_level = 0
	var/meat_left = 0
	var/raw = TRUE
	var/list/tastes = list()
	///Time spent baking so far
	var/current_bake_time = 0

/obj/item/doner_stick/Initialize(mapload)
	. = ..()
	register_context()

/obj/item/doner_stick/update_icon_state()
	if(meat_level)
		if(raw)
			icon_state = "raw_[meat_type]_doner[meat_level]"
		else
			icon_state = "[meat_type]_doner[meat_level]_[meat_left]"
	else
		icon_state = src::icon_state
	return ..()

/obj/item/doner_stick/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(raw && meat_level < 5 && held_item && meat_types[held_item.icon_state] && istype(held_item, /obj/item/food/meat/slab))
		context[SCREENTIP_CONTEXT_LMB] = "Add meat"
		return CONTEXTUAL_SCREENTIP_SET
	else if(!raw && held_item && held_item.tool_behaviour == TOOL_KNIFE)
		context[SCREENTIP_CONTEXT_LMB] = "Slice meat"
		return CONTEXTUAL_SCREENTIP_SET
	return NONE

/obj/item/doner_stick/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/food/meat/slab))
		var/obj/item/food/meat/slab/slab = item
		if(!raw)
			to_chat(user, span_warning("You cannot add more meat after [src] is cooked!"))
			return
		if(meat_level == 5)
			to_chat(user, span_warning("You cannot add more meat to it."))
			return
		if(!isnull(meat_type) && meat_type != meat_types[slab.icon_state])
			to_chat(user, span_warning("You cannot mix [slab] with [meat_type] doner!"))
			return
		if(!meat_types[slab.icon_state])
			to_chat(user, span_warning("You cannot use this meat!"))
			return
		if(!reagents)
			create_reagents(250, INJECTABLE)
		slab.reagents.trans_to(src, slab.reagents.total_volume)
		if(!meat_type)
			meat_type = meat_types[slab.icon_state]
		for(var/taste in slab.tastes)
			var/taste_stick = tastes[taste]
			var/taste_slab = slab.tastes[taste]
			if(isnull(taste_stick) || taste_stick < taste_slab)
				tastes[taste] = taste_slab
		meat_level++
		qdel(slab)
		update_appearance()
	else if(item.tool_behaviour == TOOL_KNIFE)
		if(!meat_left)
			to_chat(user, span_warning("You cannot cut steel!"))
			return
		if(raw)
			to_chat(user, span_warning("[src] is raw!"))
			return
		if(!do_after(user, 5 SECONDS, target = istype(loc, /obj/machinery/doner_grill) ? loc : src))
			balloon_alert(user, "interrupted!")
			return
		var/doner_type = (meat_type == "meat") ? /obj/item/food/doner/yaprak/et : /obj/item/food/doner/yaprak/tavuk
		var/volume = (reagents.total_volume / (meat_left * 2))
		var/turf/drop_location = drop_location()
		for(var/i in 1 to 2)
			var/obj/item/food/doner/doner = new doner_type(drop_location)
			reagents.trans_to(doner, volume)
			doner.tastes = tastes.Copy()
		meat_left--
		if(!meat_left)
			reset_stick()
		update_appearance()
	else
		return ..()

/obj/item/doner_stick/proc/reset_stick()
	meat_type = null
	meat_level = 0
	meat_left = 0
	raw = TRUE
	tastes = list()
	current_bake_time = 0
	QDEL_NULL(reagents)

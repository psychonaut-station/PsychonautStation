/obj/machinery/doner_machine
	name = "Doner Macjine"
	desc = "A doner machine."
	icon = 'icons/psychonaut/obj/machines/kitchen.dmi'
	icon_state = "doner_machine"
	base_icon_state = "doner_machine"
	density = TRUE
	processing_flags = START_PROCESSING_MANUALLY
	anchored_tabletop_offset = 11
	anchored = FALSE
	pass_flags = PASSTABLE
	var/isOn = FALSE
	var/obj/item/doner_stick/doner_stick
	var/required_bake_time = 1 MINUTES

/obj/machinery/doner_machine/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/machinery/doner_machine/update_icon_state()
	if(isOn)
		icon_state = "doner_machine_on"
	else
		icon_state = src::icon_state
	return ..()

/obj/machinery/doner_machine/update_overlays()
	. = ..()
	if(doner_stick)
		var/iconst = "doner_machine"
		if(doner_stick.raw)
			iconst += "_raw"
		iconst += "_[doner_stick.donericon]"
		var/mutable_appearance/theoverlay = mutable_appearance(icon, iconst)
		. += theoverlay

/obj/machinery/doner_machine/can_be_unfasten_wrench(mob/user, silent)
	. = ..()
	if(doner_stick)
		to_chat(user, span_warning("You cannot unsecure [src] while its have a doner_stick!"))
		return CANT_UNFASTEN
	if(isOn)
		to_chat(user, span_warning("You cannot unsecure [src] while its on!"))
		return CANT_UNFASTEN

/obj/machinery/doner_machine/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/doner_machine/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/doner_stick) && !doner_stick)
		var/obj/item/doner_stick/newdonerstick = item
		if(newdonerstick.meatnum != 5)
			to_chat(user, span_warning("This stick isnt full!"))
			return
		if(!newdonerstick.raw)
			to_chat(user, span_warning("That doner isnt raw!"))
			return
		doner_stick = newdonerstick
		doner_stick.forceMove(src)
		update_appearance()
	else if(item.tool_behaviour == TOOL_KNIFE)
		if(doner_stick)
			doner_stick.attackby(item, user, params)
			update_appearance()
		else
			return ..()
	else
		return ..()

/obj/machinery/doner_machine/AllowDrop()
	return FALSE

/obj/machinery/doner_machine/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(doner_stick)
		user.put_in_hands(doner_stick)
		doner_stick = null
		update_appearance()

/obj/machinery/doner_machine/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(!anchored)
		to_chat(usr, span_warning("[src] needs to be secured first!"))
		balloon_alert(usr, "secure first!")
		return
	isOn = !isOn
	if(isOn)
		begin_processing()
	else
		end_processing()
	update_appearance()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/doner_machine/process(seconds_per_tick)
	if(!doner_stick || !isOn)
		return

	doner_stick.current_bake_time += seconds_per_tick * 10 //turn it into ds
	if(doner_stick.current_bake_time >= required_bake_time)
		finish_baking()

/obj/machinery/doner_machine/proc/finish_baking()
	doner_stick.raw = FALSE
	doner_stick.update_appearance()
	update_appearance()

/obj/item/doner_stick
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	name = "Doner Stick"
	icon_state = "doner_stick"
	desc = "A tool for stringing meat on a stick and cooking it."
	w_class = WEIGHT_CLASS_BULKY
	item_flags = NO_BLOOD_ON_ITEM

	var/static/list/meat_types = list("birdmeat" = "chicken", "meat" = "meat")
	var/donericon = null
	var/raw = TRUE
	var/meatnum = 0

	var/list/tastes = list()

	///Time spent baking so far
	var/current_bake_time = 0

/obj/item/doner_stick/update_icon_state()
	if(meatnum)
		var/iconst = ""
		if(raw)
			iconst += "raw_"
		iconst += "[donericon]_"
		iconst += "doner[meatnum]"
		icon_state = iconst
	else
		icon_state = src::icon_state
	return ..()

/obj/item/doner_stick/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/food/meat/slab))
		var/obj/item/food/meat/slab/meatslab = item
		if(!meat_types[meatslab.icon_state])
			to_chat(user, span_warning("You cant put this meat!"))
			return
		if(!raw)
			to_chat(user, span_warning("You cant put a raw meat to cooked doner!"))
			return
		if(donericon && donericon != meat_types[meatslab.icon_state])
			to_chat(user, span_warning("You cant put this type of meat to [donericon] doner!"))
			return
		if(meatnum == 5)
			to_chat(user, span_warning("You cant add more meat to it."))
			return
		if(!reagents)
			create_reagents(250, INJECTABLE)
		meatslab.reagents.trans_to(src, meatslab.reagents.total_volume)
		for(var/taste in meatslab.tastes)
			tastes += list(taste = meatslab.tastes[taste])
		donericon = meat_types[meatslab.icon_state]
		meatnum++
		qdel(meatslab)
		update_appearance()
	else if(item.tool_behaviour == TOOL_KNIFE)
		if(!meatnum)
			to_chat(user, span_warning("There is no meat to cut!"))
			return
		if(raw)
			to_chat(user, span_warning("This doner is raw!"))
			return
		var/donertype = (donericon == "meat") ? /obj/item/food/doner/yaprak/et : /obj/item/food/doner/yaprak/tavuk
		var/volume = (reagents.total_volume / (meatnum * 2))
		var/turf/drop_loc = drop_location()
		for(var/i in 1 to 2)
			var/obj/item/food/doner/doner = new donertype(drop_loc)
			reagents.trans_to(doner, volume)
			for(var/taste in tastes)
				doner.tastes += list(taste = tastes[taste])
		meatnum--
		if(!meatnum)
			raw = TRUE
			donericon = null
			tastes = list()
			qdel(reagents)
			current_bake_time = 0
		update_appearance()
	else
		return ..()

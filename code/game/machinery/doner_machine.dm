/obj/item/doner_stick
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	name = "Doner Stick"
	icon_state = "doner_stick"
	desc = "A tool for stringing meat on a stick and cooking it."
	w_class = WEIGHT_CLASS_BULKY
	item_flags = NO_BLOOD_ON_ITEM

	var/static/list/meat_types = list("birdmeat" = "chicken", "meat" = "meat")
	var/donertype = null
	var/raw = TRUE
	var/meatnum = 0

	var/list/tastes = list()

/obj/item/doner_stick/update_icon_state()
	if(meatnum)
		var/iconst = ""
		if(raw)
			iconst += "raw_"
		iconst += "[donertype]_"
		iconst += "doner[meatnum]"
		icon_state = iconst
	else
		icon_state = src::icon_state
	return ..()

/obj/item/doner_stick/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/food/meat/slab))
		var/obj/item/food/meat/slab/meatslab = item
		if(!meat_types[meatslab.icon_state])
			return
		if(!raw)
			return
		if(donertype && donertype != meat_types[meatslab.icon_state])
			return
		if(meatnum == 5)
			to_chat(user, span_notice("You cant add more meat to it."))
			return
		if(!reagents)
			create_reagents(250, INJECTABLE)
		meatslab.reagents.trans_to(src, meatslab.reagents.total_volume)
		for(var/taste in meatslab.tastes)
			tastes += list(taste = meatslab.tastes[taste])
		donertype = meat_types[meatslab.icon_state]
		meatnum++
		qdel(meatslab)
		update_appearance()
	else if(item.tool_behaviour == TOOL_KNIFE)
		if(!meatnum)
			return
		if(raw)
			return
		var/volume = (reagents.total_volume / (meatnum * 2))
		for(var/i in 1 to 2)
			var/turf/drop_loc = drop_location()
			var/obj/item/food/yaprakdoner/doner = new(drop_loc)
			reagents.trans_to(doner, volume)
			for(var/taste in tastes)
				doner.tastes += list(taste = tastes[taste])
		meatnum--
		if(!meatnum)
			raw = TRUE
			donertype = null
			tastes = list()
			qdel(reagents)
		update_appearance()
	else
		return ..()

/obj/item/doner_stick/proc/bake()
	if(meatnum != 5)
		return
	if(!raw)
		return
	raw = FALSE
	update_appearance()

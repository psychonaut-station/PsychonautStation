/obj/item/storage/belt/sheath/sabre
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/belts.dmi'
	lefthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/clothing/belts_lefthand.dmi'
	righthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/clothing/belts_righthand.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/belts.dmi'
	w_class = WEIGHT_CLASS_BULKY
	interaction_flags_click = parent_type::interaction_flags_click | NEED_DEXTERITY | NEED_HANDS
	unique_reskin = list(
		"Red" = "sheath_red",
		"Black" = "sheath_black"
	)

/obj/item/storage/belt/sheath/sabre/click_alt(mob/user)
	if(length(contents))
		var/obj/item/I = contents[1]
		user.visible_message(span_notice("[user] takes [I] out of [src]."), span_notice("You take [I] out of [src]."))
		user.put_in_hands(I)
		update_appearance()
	else
		balloon_alert(user, "it's empty!")
	return CLICK_ACTION_SUCCESS

/obj/item/storage/belt/sheath/sabre/update_icon_state()
	. = ..()
	icon_state = current_skin ? unique_reskin[current_skin] : initial(icon_state)
	inhand_icon_state = current_skin ? unique_reskin[current_skin] : initial(inhand_icon_state)
	worn_icon_state = current_skin ? unique_reskin[current_skin] : initial(worn_icon_state)
	if(contents.len)
		var/obj/item/I = contents[1]
		icon_state += "-[I.icon_state]"
		inhand_icon_state += "-[I.icon_state]"
		worn_icon_state += "-[I.icon_state]"

/obj/item/storage/belt/sheath/sabre/on_click_alt_reskin(datum/source, mob/user)
	if(!contents.len)
		return NONE

	return ..()

/obj/item/storage/belt/sheath/sabre/reskin_obj(mob/user)
	. = ..()
	if(current_skin)
		var/obj/item/I = contents[1]
		if(isnull(I))
			current_skin = null
			icon_state = initial(icon_state)
			update_appearance()
			return
		switch(current_skin)
			if("Red")
				I.icon_state = "sabre_red"
				I.inhand_icon_state = "sabre_red"
			if("Black")
				I.icon_state = "sabre_black"
				I.inhand_icon_state = "sabre_black"
		I.update_appearance()
		update_appearance()

/obj/item/storage/belt/sabre
	icon = 'modular_psychonaut/modules/officers_sabre/icons/sheath.dmi'
	icon_state = "sheath_red"
	inhand_icon_state = "sheath_red"
	lefthand_file = 'modular_psychonaut/modules/officers_sabre/icons/sheath_lefthand.dmi'
	righthand_file = 'modular_psychonaut/modules/officers_sabre/icons/sheath_righthand.dmi'
	worn_icon = 'modular_psychonaut/modules/officers_sabre/icons/sheath_worn.dmi'
	worn_icon_state = "sheath_red"
	unique_reskin = list(
		"Red" = "sheath_red",
		"Black" = "sheath_black"
	)

/obj/item/storage/belt/sabre/on_click_alt_reskin(datum/source, mob/user)
	if(!length(contents))
		return NONE

	return ..()

/obj/item/storage/belt/sabre/reskin_obj(mob/user)
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

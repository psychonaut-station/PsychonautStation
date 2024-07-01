/obj/item/construction
	var/secondary_matter = 0
	var/max_secondary_matter = 100
	var/list/secondary_matter_types

/obj/item/construction/loadwithsheets(obj/item/stack/the_stack, mob/user)
	if(is_type_in_list(the_stack, secondary_matter_types, TRUE))
		var/max_sheets = round((max_secondary_matter - secondary_matter) / secondary_matter_types[the_stack.type])
		if(max_sheets > 0)
			var/amount_to_use = min(the_stack.amount, max_sheets)
			the_stack.use(amount_to_use)
			secondary_matter += amount_to_use * secondary_matter_types[the_stack.type]
			playsound(loc, 'sound/machines/click.ogg', 50, TRUE)
			return TRUE
	return ..()

/obj/item/construction/useResource(amount, mob/user, secondary = FALSE)
	if(secondary)
		if(secondary_matter < amount)
			if(user)
				balloon_alert(user, "not enough matter!")
			return FALSE
		secondary_matter -= amount
		update_appearance()
		return TRUE
	return..()

/obj/item/construction/checkResource(amount, mob/user, secondary = FALSE)
	if(secondary)
		. = secondary_matter >= amount
		if(!. && user)
			balloon_alert(user, "low ammo!")
			if(has_ammobar)
				flick("[icon_state]_empty", src)
		return .
	return ..()

/obj/item/construction/ui_data(mob/user)
	. = ..()
	if(LAZYLEN(secondary_matter_types))
		.["secondaryMatterLeft"] = secondary_matter
		.["hasSecondaryMatter"] = TRUE

/mob/living/silicon/examine(mob/user) //Displays a silicon's laws to ghosts
	. = ..()
	if(laws && isobserver(user))
		// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
		// . += "<b>[src] has the following laws:</b>"
		. += "<b>[src] aşağıdaki yasalara sahiptir:</b>"
		// PSYCHONAUT EDIT ADDITION END - LOCALIZATION
		for(var/law in laws.get_law_list(include_zeroth = TRUE))
			. += law

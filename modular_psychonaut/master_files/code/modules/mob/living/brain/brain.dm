/mob/living/brain/get_mob_appearance()
	if(!isnull(container))
		return container.appearance
	return ..()

/mob/eye/camera/ai/get_mob_appearance()
	if(!isnull(ai))
		return ai.appearance
	return ..()

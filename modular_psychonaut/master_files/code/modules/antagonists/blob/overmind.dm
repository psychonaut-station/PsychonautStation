/mob/eye/blob/get_mob_appearance()
	if(!isnull(blob_core))
		return blob_core.appearance
	return ..()

/datum/outfit/job/clown/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	..()
	if(visuals_only)
		return
	ADD_TRAIT(H, TRAIT_CAN_USE_JUKEBOX, JOB_TRAIT)

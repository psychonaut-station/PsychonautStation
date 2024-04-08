/datum/outfit/job/clown/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return

	ADD_TRAIT(H, TRAIT_CLOWNING, JOB_TRAIT)

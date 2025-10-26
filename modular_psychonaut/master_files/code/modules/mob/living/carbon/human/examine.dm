/mob/living/carbon/human/examine_more(mob/user)
	. = ..()
	if(mind?.assigned_role.job_flags & JOB_CREW_MANIFEST)
		if(flavor_text)
			. += "<span class='info'>OOC Information:</span> [flavor_text]"

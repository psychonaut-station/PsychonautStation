/datum/job
	/// Which landmarks should this job spawn at if the job doesn't have its own spawn point?
	var/obj/effect/landmark/start/roundstart_spawn_point
	/// The list of alternative job titles people can pick from
	var/list/alt_titles

/datum/job/New()
	. = ..()
	for(var/alt_title in alt_titles)
		if(!SSjob.all_alt_titles[alt_title])
			SSjob.all_alt_titles[alt_title] = title

/datum/job/get_default_roundstart_spawn_point()
	if(roundstart_spawn_point)
		for(var/obj/effect/landmark/start/spawn_point as anything in GLOB.start_landmarks_list)
			if(!ispath(spawn_point, roundstart_spawn_point))
				continue
			. = spawn_point
			if(spawn_point.used)
				continue
			spawn_point.used = TRUE
			break
	if(!.)
		return ..()

/datum/job/proc/set_alt_title(mob/living/carbon/human/H, client/player_client)
	var/chosen_title = player_client?.prefs.alt_job_titles[title] || title
	if(chosen_title == title)
		return
	var/obj/item/card/id/card = H.wear_id
	if(istype(card))
		card.assignment = chosen_title
		card.update_label()
	var/list/all_contents = H.get_all_contents()
	var/obj/item/modular_computer/pda/pda = locate() in all_contents
	if(!isnull(pda))
		pda.imprint_id(job_name = chosen_title)

/mob/living/carbon/human/dress_up_as_job(datum/job/equipping, visual_only = FALSE, client/player_client, consistent = FALSE)
	. = ..()
	if(visual_only || istype(equipping, /datum/job/security_officer))
		return
	equipping.set_alt_title(src, player_client)

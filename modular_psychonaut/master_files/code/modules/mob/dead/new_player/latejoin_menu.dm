/datum/latejoin_menu/ui_data(mob/user)
	if(isnull(user.client.prefs.alt_job_titles))
		user.client.prefs?.alt_job_titles = list()
	. = ..()
	.["job_alt_titles"] = user.client.prefs?.alt_job_titles

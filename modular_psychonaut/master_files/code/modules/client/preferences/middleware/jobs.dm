/datum/preference_middleware/jobs/proc/set_job_title(list/params, mob/user)
	var/default_job_title = params["job"]
	var/new_job_title = params["new_title"]
	var/datum/job/job = SSjob.get_job(default_job_title)

	if(isnull(job) || !job.alt_titles.Find(new_job_title))
		return FALSE

	preferences.alt_job_titles[default_job_title] = new_job_title
	return TRUE

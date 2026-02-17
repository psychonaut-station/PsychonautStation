/datum/preference_middleware/job_slots
	action_delegations = list(
			"set_job_slot" = PROC_REF(set_job_slot),
			"reset_job_slots" = PROC_REF(reset_job_slots),
		)

/datum/preference_middleware/job_slots/get_ui_data(mob/user)
	var/list/data = list()

	data["pref_job_slots"] = preferences.job_slots
	data["profile_index"] = preferences.get_slot_options()

	return data

/datum/preference_middleware/job_slots/proc/set_job_slot(list/params, mob/user)
	if(isnull(params["slot"]))
		return

	var/job_title = params["job"]
	var/slot_index = params["slot"]

	if(slot_index < JOB_SLOT_RANDOMISED_SLOT || slot_index > preferences.max_save_slots)
		return

	if(!SSjob.get_job(job_title))
		return

	if(slot_index == JOB_SLOT_CURRENT_SLOT)
		preferences.job_slots.Remove(job_title)
	else
		preferences.job_slots[job_title] = slot_index

	preferences.save_preferences()
	return TRUE

/datum/preference_middleware/job_slots/proc/reset_job_slots(list/params, mob/user)
	preferences.reset_job_slots()
	return TRUE

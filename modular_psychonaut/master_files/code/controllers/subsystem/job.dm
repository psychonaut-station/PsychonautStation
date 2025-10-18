/// Returns a list of minds of given department members
/datum/controller/subsystem/job/proc/get_department_crew(bitflag)
	. = list()
	for(var/datum/mind/mind as anything in get_crewmember_minds())
		if(mind.assigned_role.departments_bitflags & bitflag)
			. += mind

/datum/controller/subsystem/job/proc/is_occupation_of(job_name, bitflags)
	for (var/datum/job/job as anything in all_occupations)
		if (job.title != job_name)
			continue

		return job.departments_bitflags & bitflags

	return FALSE

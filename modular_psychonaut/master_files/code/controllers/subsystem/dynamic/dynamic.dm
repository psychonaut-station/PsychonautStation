/datum/controller/subsystem/dynamic/configure_ruleset(datum/dynamic_ruleset/ruleset)
	. = ..()

	for(var/datum/job/J as anything in subtypesof(/datum/job))
		if(initial(J.antagonist_restricted))
			if(initial(J.restricted_antagonists))
				var/list/restricted_antagonists = initial(J.restricted_antagonists)
				if(ruleset.antag_flag in restricted_antagonists)
					ruleset.restricted_roles |= initial(J.title)
			else
				ruleset.restricted_roles |= initial(J.title)
		if(initial(J.antagonist_protected))
			if(initial(J.protected_antagonists))
				var/list/protected_antagonists = initial(J.protected_antagonists)
				if(ruleset.antag_flag in protected_antagonists)
					ruleset.protected_roles |= initial(J.title)
			else
				ruleset.protected_roles |= initial(J.title)

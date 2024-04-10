/datum/job
	/// If this job *should not* be an antagonist.
	var/antagonist_protected = FALSE
	/// If this job *cannot* be an antagonist.
	var/antagonist_restricted = FALSE
	/// If we protect this job from antagonists, what antags? Leave blank for all antags.
	var/list/protected_antagonists
	/// If we restrict this job from antagonists, what antags? Leave blank for all antags.
	var/list/restricted_antagonists

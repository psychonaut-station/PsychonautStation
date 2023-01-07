// ROUNDSTART
/datum/dynamic_ruleset/roundstart/traitor
	protected_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_SECURITY,
		JOB_PRISONER,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_BRIG_PHYSICIAN,
	)
	restricted_roles = list(
		JOB_AI,
		JOB_CYBORG,
		JOB_PUG,
	)

/datum/dynamic_ruleset/roundstart/ntagent
	protected_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_SECURITY,
		JOB_PRISONER,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_BRIG_PHYSICIAN,
	)
	restricted_roles = list(
		JOB_PUG,
		JOB_AI,
		JOB_CYBORG,
	)

/datum/dynamic_ruleset/roundstart/traitorbro
	protected_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_SECURITY,
		JOB_PRISONER,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_BRIG_PHYSICIAN,
	)
	restricted_roles = list(
		JOB_AI,
		JOB_CYBORG,
		JOB_PUG,
	)

/datum/dynamic_ruleset/roundstart/changeling
	protected_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_SECURITY,
		JOB_PRISONER,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_BRIG_PHYSICIAN,
	)
	restricted_roles = list(
		JOB_AI,
		JOB_CYBORG,
		JOB_PUG,
	)

/datum/dynamic_ruleset/roundstart/heretics
	protected_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_SECURITY,
		JOB_PRISONER,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_BRIG_PHYSICIAN,
	)
	restricted_roles = list(
		JOB_AI,
		JOB_CYBORG,
		JOB_PUG,
	)

/datum/dynamic_ruleset/roundstart/bloodcult
	restricted_roles = list(
		JOB_AI,
		JOB_CAPTAIN,
		JOB_CHAPLAIN,
		JOB_CYBORG,
		JOB_DETECTIVE,
		JOB_HEAD_OF_PERSONNEL,
		JOB_HEAD_OF_SECURITY,
		JOB_PRISONER,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_BRIG_PHYSICIAN,
		JOB_PUG,
	)

/datum/dynamic_ruleset/roundstart/revs
	restricted_roles = list(
		JOB_AI,
		JOB_CAPTAIN,
		JOB_CHIEF_ENGINEER,
		JOB_CHIEF_MEDICAL_OFFICER,
		JOB_CYBORG,
		JOB_DETECTIVE,
		JOB_HEAD_OF_PERSONNEL,
		JOB_HEAD_OF_SECURITY,
		JOB_PRISONER,
		JOB_QUARTERMASTER,
		JOB_RESEARCH_DIRECTOR,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_BRIG_PHYSICIAN,
		JOB_PUG,
	)


// MIDROUND
/datum/dynamic_ruleset/midround/from_living/autotraitor
	protected_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_PERSONNEL,
		JOB_HEAD_OF_SECURITY,
		JOB_PRISONER,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_BRIG_PHYSICIAN,
	)
	restricted_roles = list(
		JOB_AI,
		JOB_CYBORG,
		ROLE_POSITRONIC_BRAIN,
		JOB_PUG,
	)

/datum/dynamic_ruleset/midround/malf
	enemy_roles = list(
		JOB_CHEMIST,
		JOB_CHIEF_ENGINEER,
		JOB_HEAD_OF_SECURITY,
		JOB_RESEARCH_DIRECTOR,
		JOB_SCIENTIST,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_BRIG_PHYSICIAN,
	)

/datum/dynamic_ruleset/midround/from_ghosts/nuclear
	enemy_roles = list(
		JOB_AI,
		JOB_CYBORG,
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_SECURITY,
		JOB_SECURITY_OFFICER,
		JOB_BRIG_PHYSICIAN,
	)

/datum/dynamic_ruleset/midround/from_living/blob_infection
	protected_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_SECURITY,
		JOB_PRISONER,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_BRIG_PHYSICIAN,
	)
	restricted_roles = list(
		JOB_AI,
		JOB_CYBORG,
		JOB_PUG,
		ROLE_POSITRONIC_BRAIN,
	)

/datum/dynamic_ruleset/midround/from_living/obsessed
	restricted_roles = list(
		JOB_AI,
		JOB_CYBORG,
		ROLE_POSITRONIC_BRAIN,
		JOB_PUG,
	)



// LATEJOIN
/datum/dynamic_ruleset/latejoin/infiltrator
	protected_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_PERSONNEL,
		JOB_HEAD_OF_SECURITY,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_BRIG_PHYSICIAN,
	)
	restricted_roles = list(
		JOB_PUG,
		JOB_AI,
		JOB_CYBORG,
	)

/datum/dynamic_ruleset/latejoin/provocateur
	restricted_roles = list(
		JOB_PUG,
		JOB_AI,
		JOB_CAPTAIN,
		JOB_CHIEF_ENGINEER,
		JOB_CHIEF_MEDICAL_OFFICER,
		JOB_CYBORG,
		JOB_DETECTIVE,
		JOB_HEAD_OF_PERSONNEL,
		JOB_HEAD_OF_SECURITY,
		JOB_PRISONER,
		JOB_QUARTERMASTER,
		JOB_RESEARCH_DIRECTOR,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_BRIG_PHYSICIAN,
	)
	enemy_roles = list(
		JOB_AI,
		JOB_CYBORG,
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_SECURITY,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_BRIG_PHYSICIAN,
	)

/datum/dynamic_ruleset/latejoin/heretic_smuggler
	protected_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_PERSONNEL,
		JOB_HEAD_OF_SECURITY,
		JOB_PRISONER,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_BRIG_PHYSICIAN,
	)
	restricted_roles = list(
		JOB_PUG,
		JOB_AI,
		JOB_CYBORG,
	)

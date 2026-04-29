/datum/ai_project/visual_archive
	name = "Nanoweave Visual Archive"
	description = "Uses nanotechnological screen reconstruction to unlock archived AI avatars and their matching station display projections."
	research_cost = 75
	ram_required = 0
	category = AI_PROJECT_MISC
	can_be_run = FALSE

/datum/ai_project/visual_archive/finish()
	to_chat(ai, span_notice("Archived avatar matrices integrated. Additional AI screens are now available."))

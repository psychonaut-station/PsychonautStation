/datum/ai_project/goon_core_refit
	name = "Nanoweave Core Refit"
	description = "A nanotechnological refit cracks across your linked data cores, rebuilding them into configurable Goon-style casings with independent face matrices."
	research_cost = 75
	ram_required = 0
	research_requirements_text = "Nanoweave Visual Archive"
	research_requirements = list(/datum/ai_project/visual_archive)
	category = AI_PROJECT_MISC
	can_be_run = TRUE

/datum/ai_project/goon_core_refit/finish()
	if(!(/mob/living/silicon/ai/verb/open_goon_core_customizer in ai.verbs))
		add_verb(ai, /mob/living/silicon/ai/verb/open_goon_core_customizer)
	ai.goon_core_skin = "default"
	ai.goon_core_background = "ai_blue"
	ai.goon_core_light_mode = "auto"
	ai.goon_core_face = "ai_happy-dol"
	ai.set_goon_core_visuals("default", "ai_happy-dol", TRUE, "ai_blue", TRUE)
	to_chat(ai, span_notice("Nanoweave refit complete. Use 'Configure Goon Core' under AI Commands to tune the new casing."))

/datum/ai_project/goon_core_refit/run_project(force_run = FALSE)
	. = ..(force_run)
	if(!.)
		return FALSE
	if(!ai?.has_goon_core_refit())
		stop()
		return FALSE
	ai.open_goon_core_customizer()
	stop()
	return TRUE

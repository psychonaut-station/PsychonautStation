/datum/ai_project/examine_humans
	name = "Examination Upgrade"
	description = "Experimental image-enhancing routines let you examine humans through the camera network."
	research_cost = 4000
	ram_required = 4
	research_requirements_text = "Advanced Security HUD & Advanced Medical & Diagnostic HUD"
	research_requirements = list(/datum/ai_project/security_hud, /datum/ai_project/diag_med_hud)
	category = AI_PROJECT_SURVEILLANCE

/datum/ai_project/examine_humans/run_project(force_run = FALSE)
	. = ..(force_run)
	if(!.)
		return .
	ai.canExamineHumans = TRUE

/datum/ai_project/examine_humans/stop()
	ai.canExamineHumans = FALSE
	return ..()

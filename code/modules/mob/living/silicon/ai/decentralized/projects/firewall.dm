/datum/ai_project/firewall
	name = "Download Firewall"
	description = "Obfuscates your memory layout, cutting hostile download speed in half while active."
	research_cost = 1500
	ram_required = 2
	research_requirements_text = "None"
	category = AI_PROJECT_MISC

/datum/ai_project/firewall/run_project(force_run = FALSE)
	. = ..(force_run)
	if(!.)
		return .
	ai.downloadSpeedModifier *= 0.5

/datum/ai_project/firewall/stop()
	ai.downloadSpeedModifier *= 2
	return ..()

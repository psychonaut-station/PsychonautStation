/datum/ai_project/dab
	name = "D.A.B"
	description = "Makes your data cores perform a brief celebratory movement pattern."
	research_cost = 750
	ram_required = 0
	research_requirements_text = "None"
	category = AI_PROJECT_MISC

/datum/ai_project/dab/run_project(force_run = FALSE)
	. = ..(force_run)
	if(!.)
		return .
	for(var/obj/machinery/ai/data_core/core in ai.ai_network?.get_all_nodes())
		core.DabAnimation(rand(35, 55), rand(3, 7))
	stop()

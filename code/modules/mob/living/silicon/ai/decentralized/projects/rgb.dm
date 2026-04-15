/datum/ai_project/rgb
	name = "RGB Lighting"
	description = "Varying lighting subsystem current creates a harmless but stylish color cycle for your data cores."
	research_cost = 500
	ram_required = 0
	research_requirements_text = "None"
	category = AI_PROJECT_MISC

/datum/ai_project/rgb/run_project(force_run = FALSE)
	. = ..(force_run)
	if(!.)
		return .
	for(var/obj/machinery/ai/data_core/core in ai.ai_network?.get_all_nodes())
		core.partytime()

/datum/ai_project/rgb/stop()
	for(var/obj/machinery/ai/data_core/core in ai.ai_network?.get_all_nodes())
		core.stoptheparty()
	return ..()

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
	var/list/network_nodes = ai.ai_network?.get_all_nodes()
	for(var/obj/machinery/ai/data_core/core in network_nodes)
		core.partytime()

/datum/ai_project/rgb/stop()
	var/list/network_nodes = ai.ai_network?.get_all_nodes()
	for(var/obj/machinery/ai/data_core/core in network_nodes)
		core.stoptheparty()
	return ..()

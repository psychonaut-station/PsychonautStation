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

	var/list/obj/machinery/ai/data_core/data_cores = list()
	if(ai.ai_network)
		for(var/obj/machinery/ai/data_core/core in ai.ai_network.get_all_nodes())
			if(!QDELETED(core))
				data_cores |= core

	if(istype(ai.loc, /obj/machinery/ai/data_core))
		data_cores |= ai.loc

	if(!length(data_cores))
		to_chat(ai, span_warning("No linked data cores are available to execute D.A.B."))
		stop()
		return FALSE

	for(var/obj/machinery/ai/data_core/core as anything in data_cores)
		core.DabAnimation(angle = rand(35, 55), speed = rand(3, 7))
		core.visible_message(span_notice("[core] executes a celebratory D.A.B."))
	stop()

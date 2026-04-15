/datum/ai_project/memory_compressor
	name = "Memory Compressor"
	description = "Compresses kernel memory to free 3 TB of RAM while active. Requires 15% free CPU."
	category = AI_PROJECT_EFFICIENCY
	research_cost = 2250

/datum/ai_project/memory_compressor/run_project(force_run = FALSE)
	. = ..(force_run)
	if(!.)
		return .
	dashboard.free_ram += 3
	dashboard.cpu_usage[name] = 0.15

/datum/ai_project/memory_compressor/stop()
	dashboard.free_ram -= 3
	dashboard.cpu_usage[name] = 0
	return ..()

/datum/ai_project/memory_compressor/canRun()
	. = ..()
	if(!.)
		return FALSE

	var/total_cpu_used = 0
	for(var/project_name in dashboard.cpu_usage)
		total_cpu_used += dashboard.cpu_usage[project_name]

	if(total_cpu_used < 0.85)
		return TRUE

	to_chat(ai, span_warning("Unable to run this program. You require 15% free CPU."))
	return FALSE

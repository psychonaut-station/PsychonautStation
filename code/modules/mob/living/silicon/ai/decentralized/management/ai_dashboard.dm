/mob/living/silicon/ai
	/// Yog-style project dashboard for decentralized AI progression.
	var/datum/ai_dashboard/dashboard

/datum/ai_dashboard
	/// AI that owns this dashboard.
	var/mob/living/silicon/ai/owner
	/// Projects that have not been completed yet.
	var/list/available_projects
	/// CPU allocations keyed by project name.
	var/list/cpu_usage
	/// RAM allocations keyed by project name.
	var/list/ram_usage
	/// Free RAM granted by passive effects.
	var/free_ram = 0
	/// Completed projects.
	var/list/completed_projects
	/// Currently running projects.
	var/list/running_projects

/datum/ai_dashboard/New(mob/living/silicon/ai/new_owner)
	if(!isAI(new_owner))
		qdel(src)
		return

	owner = new_owner
	available_projects = list()
	completed_projects = list()
	running_projects = list()
	cpu_usage = list()
	ram_usage = list()
	rebuild_projects(TRUE)

/datum/ai_dashboard/proc/rebuild_projects(force = FALSE)
	if(!owner || QDELETED(owner))
		return

	available_projects = islist(available_projects) ? available_projects : list()
	completed_projects = islist(completed_projects) ? completed_projects : list()
	running_projects = islist(running_projects) ? running_projects : list()
	cpu_usage = islist(cpu_usage) ? cpu_usage : list()
	ram_usage = islist(ram_usage) ? ram_usage : list()

	var/list/seen_project_types = list()
	var/list/sanitized_completed = list()
	for(var/datum/ai_project/project as anything in completed_projects)
		if(!project || QDELETED(project))
			continue
		if(project.dashboard != src || project.ai != owner)
			continue
		if(project.type in seen_project_types)
			continue
		seen_project_types += project.type
		sanitized_completed += project

	var/list/sanitized_available = list()
	for(var/datum/ai_project/project as anything in available_projects)
		if(!project || QDELETED(project))
			continue
		if(project.dashboard != src || project.ai != owner)
			continue
		if(project.type in seen_project_types)
			continue
		seen_project_types += project.type
		sanitized_available += project

	completed_projects = sanitized_completed
	available_projects = sanitized_available

	for(var/project_name in cpu_usage.Copy())
		if(!get_project_by_name(project_name))
			cpu_usage -= project_name
	for(var/project_name in ram_usage.Copy())
		if(!get_project_by_name(project_name))
			ram_usage -= project_name

	for(var/path in subtypesof(/datum/ai_project))
		if(path == /datum/ai_project)
			continue
		if(path in seen_project_types)
			continue
		var/datum/ai_project/new_project = new path(owner, src)
		if(!new_project || QDELETED(new_project))
			continue
		available_projects += new_project
		seen_project_types += path

/datum/ai_dashboard/proc/is_interactable(mob/user)
	if(user?.client?.holder)
		return TRUE
	if(user != owner || owner.incapacitated)
		return FALSE
	if(owner.control_disabled)
		to_chat(user, span_warning("Wireless control is disabled."))
		return FALSE
	return TRUE

/datum/ai_dashboard/ui_status(mob/user)
	if(is_interactable(user))
		return ..()
	return UI_CLOSE

/datum/ai_dashboard/ui_state(mob/user)
	return GLOB.always_state

/datum/ai_dashboard/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AiDashboard", "Dashboard")
		ui.open()

/datum/ai_dashboard/ui_data(mob/user)
	if(owner && !QDELETED(owner) && !owner.ai_network)
		var/obj/machinery/ai/data_core/linked_core = istype(owner.loc, /obj/machinery/ai/data_core) ? owner.loc : null
		if(!linked_core)
			for(var/obj/machinery/ai/data_core/core as anything in GLOB.data_cores)
				if(owner in core.contents)
					linked_core = core
					break
		if(!linked_core)
			linked_core = GLOB.primary_data_core
		if(linked_core?.network)
			owner.ai_network = linked_core.network
			if(!(owner in owner.ai_network.ai_list))
				owner.ai_network.ai_list += owner

	if(owner?.ai_network && !(owner in owner.ai_network.ai_list))
		owner.ai_network.ai_list += owner

	if(owner && !QDELETED(owner) && !istype(owner.loc, /obj/item/aicard))
		// Prefer a fully operational core when possible so dashboard data reflects
		// active network hardware instead of a stale/non-transfer-ready host.
		owner.ensure_data_core_residency(TRUE, FALSE)
	owner.ai_network?.update_resources()
	rebuild_projects()

	var/list/data = list()
	var/datum/ai_shared_resources/resources = owner.ai_network?.resources
	if(resources)
		var/current_cpu_assigned = resources.cpu_assigned[owner] || 0
		var/current_ram_assigned = resources.ram_assigned[owner] || 0
		if((current_cpu_assigned <= 0 && resources.total_cpu() > 0) || (current_ram_assigned <= 0 && resources.total_ram() > 0))
			owner.claim_default_network_resources()
			resources = owner.ai_network?.resources
	else
		owner.ensure_data_core_residency(FALSE, TRUE)
		owner.ai_network?.update_resources()
		resources = owner.ai_network?.resources

	if(resources && (resources.cpu_assigned[owner] || 0) <= 0 && resources.total_cpu() > 0)
		owner.claim_default_network_resources()
		resources = owner.ai_network?.resources

	var/assigned_cpu_share = resources?.cpu_assigned[owner] || 0
	var/assigned_ram = resources?.ram_assigned[owner] || 0
	var/total_cpu_used = 0
	var/total_ram_used = 0
	var/turf/current_turf = get_turf(owner)
	var/temperature = 0

	var/obj/machinery/ai/current_machine = istype(owner.loc, /obj/machinery/ai) ? owner.loc : null
	if(!current_machine && owner.ai_network)
		for(var/obj/machinery/ai/data_core/core as anything in owner.ai_network.get_all_nodes())
			if(owner in core.contents)
				current_machine = core
				break
	if(!current_machine)
		current_machine = owner.ai_network?.find_data_core()
	temperature = current_machine?.core_temp || 0

	for(var/project_name in cpu_usage)
		total_cpu_used += cpu_usage[project_name]

	for(var/project_name in ram_usage)
		total_ram_used += ram_usage[project_name]

	data["current_cpu"] = assigned_cpu_share
	data["current_ram"] = assigned_ram + free_ram
	data["used_cpu"] = total_cpu_used
	data["used_ram"] = total_ram_used
	data["total_cpu_used"] = resources?.total_cpu_assigned() || 0
	data["max_cpu"] = resources?.total_cpu() || owner.ai_network?.total_cpu() || 0
	data["max_ram"] = resources?.total_ram() || owner.ai_network?.total_ram() || 0
	data["human_lock"] = resources?.human_lock || FALSE
	data["human_only"] = data["human_lock"]
	data["is_ai"] = TRUE
	var/list/dashboard_categories = islist(GLOB.ai_project_categories) ? GLOB.ai_project_categories.Copy() : list()
	if(!length(dashboard_categories))
		for(var/datum/ai_project/project as anything in available_projects)
			if(!project?.category || (project.category in dashboard_categories))
				continue
			dashboard_categories += project.category
		for(var/datum/ai_project/project as anything in completed_projects)
			if(!project?.category || (project.category in dashboard_categories))
				continue
			dashboard_categories += project.category
	if(!length(dashboard_categories))
		dashboard_categories += AI_PROJECT_MISC
	data["categories"] = dashboard_categories
	data["integrity"] = owner.health
	data["location_name"] = current_turf ? "[get_area(current_turf)]" : "Unknown"
	data["location_coords"] = current_turf ? "[current_turf.x], [current_turf.y], [current_turf.z]" : "N/A"
	data["temperature"] = temperature

	data["available_projects"] = list()
	for(var/datum/ai_project/project as anything in available_projects)
		data["available_projects"] += list(list(
			"name" = project.name,
			"description" = project.description,
			"ram_required" = project.ram_required,
			"available" = project.canResearch(),
			"research_cost" = project.research_cost,
			"research_progress" = project.research_progress,
			"assigned_cpu" = cpu_usage[project.name] || 0,
			"research_requirements" = project.research_requirements_text,
			"category" = project.category,
		))

	var/list/ability_paths = list()
	data["completed_projects"] = list()
	data["chargeable_abilities"] = list()
	for(var/datum/ai_project/project as anything in completed_projects)
		data["completed_projects"] += list(list(
			"name" = project.name,
			"description" = project.description,
			"ram_required" = project.ram_required,
			"running" = project.running,
			"category" = project.category,
			"can_be_run" = project.can_be_run,
		))
		if(!project.ability_path || project.ability_recharge_cost <= 0 || (project.ability_path in ability_paths))
			continue
		var/datum/action/innate/ai/ability = locate(project.ability_path) in owner.actions
		if(!ability)
			continue
		ability_paths += project.ability_path
		data["chargeable_abilities"] += list(list(
			"assigned_cpu" = cpu_usage[project.name] || 0,
			"cost" = project.ability_recharge_cost,
			"progress" = project.ability_recharge_invested,
			"name" = ability.name,
			"project_name" = project.name,
			"uses" = ability.uses,
				"max_uses" = ability.max_uses,
			))

	data["available_project_count"] = length(data["available_projects"])
	data["completed_project_count"] = length(data["completed_projects"])
	data["project_type_count"] = length(subtypesof(/datum/ai_project))
	data["loaded_project_count"] = length(available_projects) + length(completed_projects)

	return data

/datum/ai_dashboard/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(!is_interactable(usr))
		return

	switch(action)
		if("run_project")
			var/datum/ai_project/project = get_project_by_name(params["project_name"])
			if(!project || !run_project(project))
				to_chat(owner, span_warning("Unable to run the program '[params["project_name"]].'"))
			else
				to_chat(owner, span_notice("Spinning up instance of [params["project_name"]]..."))
			return TRUE

		if("stop_project")
			var/datum/ai_project/project = get_project_by_name(params["project_name"])
			if(project)
				stop_project(project)
				to_chat(owner, span_notice("Instance of [params["project_name"]] succesfully ended."))
			return TRUE

		if("allocate_cpu")
			var/datum/ai_project/project = get_project_by_name(params["project_name"], TRUE)
			if(!project || !set_project_cpu(project, text2num(params["amount"])))
				to_chat(owner, span_warning("Unable to add CPU to [params["project_name"]]. Either not enough free CPU or project is unavailable."))
			return TRUE

		if("allocate_recharge_cpu")
			var/datum/ai_project/project = get_project_by_name(params["project_name"])
			if(!project || !has_completed_project(project.type))
				return TRUE
			var/datum/action/innate/ai/ability = locate(project.ability_path) in owner.actions
			if(!ability)
				return TRUE
			if(ability.uses >= ability.max_uses)
				to_chat(owner, span_warning("This action already has the maximum amount of charges!"))
				return TRUE
			if(!set_project_cpu(project, text2num(params["amount"])))
				to_chat(owner, span_warning("Unable to add CPU to [params["project_name"]]. Either not enough free CPU or ability recharge is unavailable."))
			return TRUE

		if("max_cpu")
			var/datum/ai_project/project = get_project_by_name(params["project_name"], TRUE)
			if(!project)
				to_chat(owner, span_warning("Unable to add CPU to [params["project_name"]]. Either not enough free CPU or project is unavailable."))
				return TRUE

			var/total_cpu_allocated = 0
			for(var/project_name in cpu_usage)
				if(project_name == project.name)
					continue
				total_cpu_allocated += cpu_usage[project_name]

			if(!set_project_cpu(project, max(0, 1 - total_cpu_allocated)))
				to_chat(owner, span_warning("Unable to add CPU to [params["project_name"]]. Either not enough free CPU or project is unavailable."))
			return TRUE

		if("clear_ai_resources")
			var/datum/ai_shared_resources/resources = owner.ai_network?.resources
			if(!resources || resources.human_lock)
				return TRUE
			resources.clear_ai_resources(owner)
			return TRUE

		if("set_cpu")
			var/datum/ai_shared_resources/resources = owner.ai_network?.resources
			if(!resources || resources.human_lock)
				return TRUE
			var/amount = text2num(params["amount_cpu"])
			if(amount > 1 || amount < 0)
				return TRUE

			var/used_cpu = resources.total_cpu_assigned() - (resources.cpu_assigned[owner] || 0)
			if(amount > (1 - used_cpu))
				amount = 1 - used_cpu

			resources.set_cpu(owner, amount)
			return TRUE

		if("max_cpu_assign")
			var/datum/ai_shared_resources/resources = owner.ai_network?.resources
			if(!resources || resources.human_lock)
				return TRUE
			var/amount = (1 - resources.total_cpu_assigned()) + (resources.cpu_assigned[owner] || 0)
			resources.set_cpu(owner, amount)
			return TRUE

		if("add_ram")
			var/datum/ai_shared_resources/resources = owner.ai_network?.resources
			if(!resources || resources.human_lock)
				return TRUE
			if(resources.total_ram_assigned() >= resources.total_ram())
				return TRUE
			resources.add_ram(owner, 1)
			return TRUE

		if("remove_ram")
			var/datum/ai_shared_resources/resources = owner.ai_network?.resources
			if(!resources || resources.human_lock)
				return TRUE
			if((resources.ram_assigned[owner] || 0) <= 0)
				return TRUE
			resources.remove_ram(owner, 1)
			return TRUE

	return FALSE

/datum/ai_dashboard/proc/get_project_by_name(project_name, only_available = FALSE)
	for(var/datum/ai_project/project as anything in available_projects)
		if(project.name == project_name)
			return project
	if(!only_available)
		for(var/datum/ai_project/project as anything in completed_projects)
			if(project.name == project_name)
				return project
	return FALSE

/datum/ai_dashboard/proc/set_project_cpu(datum/ai_project/project, amount)
	if(!project || amount < 0)
		return FALSE

	if(has_completed_project(project.type))
		if(!project.ability_recharge_cost)
			return FALSE
		var/datum/action/innate/ai/ability = locate(project.ability_path) in owner.actions
		if(!ability || ability.uses >= ability.max_uses)
			return FALSE
	else if(!project.canResearch())
		return FALSE

	var/total_cpu_used = 0
	for(var/project_name in cpu_usage)
		if(project_name == project.name)
			continue
		total_cpu_used += cpu_usage[project_name]

	if((1 - total_cpu_used) < amount)
		return FALSE

	cpu_usage[project.name] = amount
	return TRUE

/datum/ai_dashboard/proc/run_project(datum/ai_project/project)
	var/datum/ai_shared_resources/resources = owner.ai_network?.resources
	if(!project || !resources)
		return FALSE

	var/current_ram = (resources.ram_assigned[owner] || 0) + free_ram
	var/total_ram_used = 0

	for(var/project_name in ram_usage)
		total_ram_used += ram_usage[project_name]

	if(current_ram - total_ram_used < project.ram_required || !project.canRun())
		return FALSE

	if(!project.run_project())
		return FALSE
	ram_usage[project.name] += project.ram_required
	return TRUE

/datum/ai_dashboard/proc/stop_project(datum/ai_project/project)
	if(!project)
		return FALSE

	project.stop()
	if(!project.ram_required || !ram_usage[project.name])
		return FALSE

	ram_usage[project.name] = max(0, ram_usage[project.name] - project.ram_required)
	return project.ram_required

/datum/ai_dashboard/proc/has_completed_project(project_type)
	for(var/datum/ai_project/project as anything in completed_projects)
		if(project.type == project_type)
			return TRUE
	return FALSE

/datum/ai_dashboard/proc/finish_project(datum/ai_project/project, notify_user = TRUE)
	available_projects -= project
	completed_projects += project
	cpu_usage[project.name] = 0
	project.finish()
	if(notify_user)
		to_chat(owner, span_notice("[project] has been completed. User input required."))

/datum/ai_dashboard/proc/recharge_ability(datum/ai_project/project, notify_user = TRUE)
	if(!project?.ability_path)
		return

	var/datum/action/innate/ai/ability = locate(project.ability_path) in owner.actions
	if(!ability)
		return

	ability.uses = min(ability.max_uses, ability.uses + 1)
	project.ability_recharge_invested = 0
	if(ability.uses >= ability.max_uses)
		cpu_usage[project.name] = 0
	ability.build_all_button_icons()

	if(notify_user)
		to_chat(owner, span_notice("'[ability.name]' has been recharged."))

/datum/ai_dashboard/proc/is_project_running(datum/ai_project/project)
	var/datum/ai_project/found_project = locate(project) in running_projects
	return found_project?.running

/datum/ai_dashboard/proc/tick(seconds)
	var/datum/ai_shared_resources/resources = owner.ai_network?.resources
	if(!resources)
		return

	var/current_cpu = resources.cpu_assigned[owner] ? resources.total_cpu() * resources.cpu_assigned[owner] : 0
	var/current_ram = (resources.ram_assigned[owner] || 0) + free_ram
	var/total_ram_used = 0

	for(var/project_name in ram_usage)
		total_ram_used += ram_usage[project_name]

	if(total_ram_used > current_ram)
		for(var/project_name in ram_usage)
			if(!ram_usage[project_name])
				continue
			var/datum/ai_project/project = get_project_by_name(project_name)
			if(!project)
				continue
			total_ram_used -= stop_project(project)
			if(total_ram_used <= current_ram)
				break
		to_chat(owner, span_warning("Lack of computational capacity. Some programs may have been stopped."))

	var/remaining_cpu = 1
	for(var/project_name in cpu_usage)
		remaining_cpu -= cpu_usage[project_name]

	if(remaining_cpu > 0)
		var/research_points = round(AI_RESEARCH_PER_CPU * (remaining_cpu * current_cpu) * seconds, 0.1)
		ai_add_station_research_points(research_points)

	for(var/project_name in cpu_usage)
		if(!cpu_usage[project_name])
			continue

		var/datum/ai_project/project = get_project_by_name(project_name)
		if(!project)
			cpu_usage[project_name] = 0
			continue

		var/used_cpu = round(cpu_usage[project_name] * seconds * current_cpu, 0.1)
		if(has_completed_project(project.type))
			if(!project.ability_recharge_cost)
				continue
			project.ability_recharge_invested += used_cpu
			if(project.ability_recharge_invested >= project.ability_recharge_cost)
				owner.playsound_local(owner, 'sound/machines/ping.ogg', 50, FALSE)
				recharge_ability(project)
			continue

		project.research_progress += used_cpu
		if(project.research_progress >= project.research_cost)
			owner.playsound_local(owner, 'sound/machines/ping.ogg', 50, FALSE)
			finish_project(project)

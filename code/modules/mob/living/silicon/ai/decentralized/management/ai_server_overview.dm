/obj/machinery/computer/ai_server_console
	name = "\improper AI server overview console"
	desc = "Used for monitoring and managing the various servers assigned to the AI network."
	icon_keyboard = "tech_key"
	icon_screen = "ai-fixer"
	light_color = LIGHT_COLOR_PINK
	circuit = /obj/item/circuitboard/computer/ai_server_overview

/obj/machinery/computer/ai_server_console/network_interface
	name = "\improper AI network interface console"
	desc = "Used for allocating local AI network compute and restoring volatile neural cores."

/obj/machinery/computer/ai_server_console/network_interface/Initialize(mapload)
	var/turf/source_turf = get_turf(src)
	if(source_turf)
		var/obj/machinery/modular_computer/preset/ai_network_interface/interface_console = new(source_turf)
		interface_console.setDir(dir)
		interface_console.pixel_x = pixel_x
		interface_console.pixel_y = pixel_y
	return INITIALIZE_HINT_QDEL

/obj/machinery/computer/ai_server_console/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AiServerConsole", name)
		ui.open()

/obj/machinery/computer/ai_server_console/ui_data(mob/user)
	var/list/data = list()
	var/datum/ai_network/network = get_local_ainet()
	if(network)
		network.rebuild_remote()
		network.update_resources()
	var/list/connected_networks = get_connected_ainets(network)

	data["has_ai_net"] = !!network
	data["network_name"] = network?.custom_name || network?.label || "Unnamed AI Network"
	data["total_cpu"] = network?.resources?.total_cpu() || 0
	data["network_assigned_cpu"] = get_connected_network_cpu(network, connected_networks)
	data["revival_cpu"] = get_connected_revival_cpu(connected_networks)
	data["revival_jobs"] = list()
	for(var/datum/ai_network/connected_network as anything in connected_networks)
		for(var/obj/machinery/ai/data_core/core as anything in connected_network.reviving_ais.Copy())
			if(QDELETED(core) || !core.dead_ai_blackbox)
				connected_network.reviving_ais -= core
				continue
			var/turf/current_turf = get_turf(core)
			data["revival_jobs"] += list(list(
				"area" = "[get_area(core)]",
				"coords" = current_turf ? "[current_turf.x], [current_turf.y], [current_turf.z]" : "N/A",
				"name" = core.dead_ai_blackbox.stored_ai?.real_name || core.dead_ai_blackbox.name,
				"progress" = core.dead_ai_blackbox.processing_progress,
				"required" = AI_BLACKBOX_PROCESSING_REQUIREMENT,
				"integrity" = round((core.dead_ai_blackbox.living_ticks / AI_BLACKBOX_LIFETIME) * 100, 0.1),
			))

	data["servers"] = list()
	var/list/seen_servers = list()
	for(var/datum/ai_network/connected_network as anything in connected_networks)
		for(var/obj/machinery/ai/server_cabinet/holder as anything in connected_network.get_local_nodes_oftype(/obj/machinery/ai/server_cabinet))
			if(QDELETED(holder) || (holder in seen_servers))
				continue
			seen_servers += holder
			var/turf/current_turf = get_turf(holder)
			var/datum/gas_mixture/environment = current_turf?.return_air()
			data["servers"] += list(list(
				"area" = "[get_area(holder)]",
				"working" = holder.valid_holder(),
				"total_cpu" = holder.total_cpu,
				"ram" = holder.total_ram,
				"card_capacity" = "[length(holder.installed_racks)]/[holder.max_racks]",
				"temp" = round(holder.core_temp, 0.1),
				"ambient_temp" = round(environment?.return_temperature() || 0, 0.1),
			))

	return data

/obj/machinery/computer/ai_server_console/ui_act(action, params)
	. = ..()
	if(.)
		return

	var/datum/ai_network/network = get_local_ainet()
	if(!network?.resources)
		return FALSE
	var/list/connected_networks = get_connected_ainets(network)

	switch(action)
		if("enable_revival")
			var/list/revival_networks = get_reviving_ainets(connected_networks)
			if(!length(revival_networks))
				to_chat(usr, span_warning("No volatile neural cores are inserted into connected AI data cores."))
				return TRUE

			var/current_revival_network_cpu = 0
			for(var/datum/ai_network/revival_network as anything in revival_networks)
				current_revival_network_cpu += network.resources.cpu_assigned[revival_network] || 0

			var/available_cpu = max(0, 1 - network.resources.total_cpu_assigned() + current_revival_network_cpu)
			var/cpu_per_network = available_cpu / length(revival_networks)
			for(var/datum/ai_network/revival_network as anything in revival_networks)
				network.resources.set_cpu(revival_network, cpu_per_network)
				revival_network.local_cpu_usage[AI_REVIVAL] = max(0, 1 - get_non_revival_local_cpu(revival_network))

			to_chat(usr, span_notice("AI revival compute has been prioritized across the connected AI network."))
			return TRUE

		if("disable_revival")
			for(var/datum/ai_network/connected_network as anything in connected_networks)
				connected_network.local_cpu_usage[AI_REVIVAL] = 0
			to_chat(usr, span_notice("AI revival compute has been disabled across the connected AI network."))
			return TRUE

	return FALSE

/obj/machinery/computer/ai_server_console/proc/get_local_ainet()
	var/turf/console_turf = get_turf(src)
	if(!console_turf)
		return null
	var/obj/structure/ethernet_cable/ethernet_cable = locate(/obj/structure/ethernet_cable) in console_turf
	return ethernet_cable?.network

/obj/machinery/computer/ai_server_console/proc/get_connected_ainets(datum/ai_network/network)
	. = list()
	if(!network)
		return
	if(network.resources)
		. = network.resources.networks.Copy()
	else
		. += network
	if(!(network in .))
		. += network

/obj/machinery/computer/ai_server_console/proc/get_reviving_ainets(list/networks)
	. = list()
	for(var/datum/ai_network/network as anything in networks)
		for(var/obj/machinery/ai/data_core/core as anything in network.reviving_ais.Copy())
			if(QDELETED(core) || !core.dead_ai_blackbox)
				network.reviving_ais -= core
				continue
			. |= network
			break

/obj/machinery/computer/ai_server_console/proc/get_non_revival_local_cpu(datum/ai_network/network)
	. = 0
	if(!network)
		return
	for(var/activity_name in network.local_cpu_usage)
		if(activity_name == AI_REVIVAL)
			continue
		. += network.local_cpu_usage[activity_name]

/obj/machinery/computer/ai_server_console/proc/get_connected_network_cpu(datum/ai_network/network, list/connected_networks)
	if(!network?.resources)
		return 0
	. = 0
	for(var/datum/ai_network/connected_network as anything in connected_networks)
		. += network.resources.cpu_assigned[connected_network] || 0

/obj/machinery/computer/ai_server_console/proc/get_connected_revival_cpu(list/connected_networks)
	. = 0
	for(var/datum/ai_network/network as anything in connected_networks)
		. = max(., network.local_cpu_usage[AI_REVIVAL] || 0)

/datum/ai_shared_resources
	/// CPU contribution keyed by network.
	var/list/cpu_sources = list()
	/// RAM contribution keyed by network.
	var/list/ram_sources = list()
	/// CPU allocation keyed by AI or network.
	var/list/cpu_assigned = list()
	/// RAM allocation keyed by AI or network.
	var/list/ram_assigned = list()
	/// All networks sharing this pool.
	var/list/networks = list()
	var/previous_ram = 0
	var/human_lock = FALSE

/datum/ai_shared_resources/New(list/network_assigned_cpu, list/network_assigned_ram, datum/ai_network/split_network, datum/ai_network/starting_network, _human_lock = FALSE)
	if(network_assigned_cpu)
		cpu_assigned = network_assigned_cpu.Copy()
	if(network_assigned_ram)
		ram_assigned = network_assigned_ram.Copy()

	if(split_network)
		networks |= split_network
		split_network.resources = src

	if(starting_network)
		networks |= starting_network
		starting_network.resources = src

	human_lock = _human_lock
	update_resources()
	for(var/datum/ai_network/network in networks)
		network.rebuild_remote()
	START_PROCESSING(SSobj, src)

/datum/ai_shared_resources/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/ai_shared_resources/process(seconds_per_tick)
	if(!length(networks))
		return PROCESS_KILL

	var/unused_cpu = max(0, 1 - total_cpu_assigned())
	if(unused_cpu <= 0)
		return

	var/datum/techweb/science/science_tech = locate(/datum/techweb/science) in SSresearch.techwebs
	if(!science_tech)
		return

	var/research_points = max(round(AI_RESEARCH_PER_CPU * (unused_cpu * total_cpu()) * seconds_per_tick, 0.1), 0)
	if(research_points > 0)
		science_tech.add_point_list(list(TECHWEB_POINT_TYPE_GENERIC = research_points))

/datum/ai_shared_resources/proc/total_cpu_assigned()
	. = 0
	for(var/target in cpu_assigned)
		. += cpu_assigned[target]

/datum/ai_shared_resources/proc/total_ram_assigned()
	. = 0
	for(var/target in ram_assigned)
		. += ram_assigned[target]

/datum/ai_shared_resources/proc/total_cpu()
	. = 0
	for(var/source in cpu_sources)
		. += cpu_sources[source]

/datum/ai_shared_resources/proc/total_ram()
	. = 0
	for(var/source in ram_sources)
		. += ram_sources[source]

/datum/ai_shared_resources/proc/update_resources()
	previous_ram = total_ram()
	ram_sources = list()
	cpu_sources = list()
	for(var/datum/ai_network/network in networks)
		ram_sources[network] += network.total_ram()
		cpu_sources[network] += network.total_cpu()
	update_allocations()

/datum/ai_shared_resources/proc/add_resource(datum/ai_shared_resources/new_resources)
	if(!new_resources || new_resources == src)
		return

	for(var/target in new_resources.ram_assigned)
		ram_assigned[target] = new_resources.ram_assigned[target]

	for(var/target in cpu_assigned)
		cpu_assigned[target] = round((cpu_assigned[target] * 0.5) * 100) / 100
	for(var/target in new_resources.cpu_assigned)
		cpu_assigned[target] = round((new_resources.cpu_assigned[target] * 0.5) * 100) / 100

	for(var/datum/ai_network/network in new_resources.networks)
		networks |= network
		network.resources = src

	update_resources()
	qdel(new_resources)

/datum/ai_shared_resources/proc/split_resources(datum/ai_network/split_network)
	if(!split_network || !(split_network in networks))
		return

	var/list/network_cpu_assign = list()
	var/list/network_ram_assign = list()
	var/list/network_ais = split_network.ai_list.Copy()
	var/split_network_cpu = 0

	for(var/target in cpu_assigned.Copy())
		if(target == split_network || target in network_ais)
			network_cpu_assign[target] = cpu_assigned[target]
			split_network_cpu += cpu_assigned[target]
			cpu_assigned[target] = 0

	var/total_usage = total_cpu_assigned()
	if(split_network_cpu)
		for(var/target in network_cpu_assign)
			var/split_usage = network_cpu_assign[target] / split_network_cpu
			network_cpu_assign[target] = round(split_usage, 0.01)

	if(total_usage)
		for(var/target in cpu_assigned)
			if(!cpu_assigned[target])
				continue
			var/split_usage = cpu_assigned[target] / total_usage
			cpu_assigned[target] = round(split_usage, 0.01)

	for(var/target in ram_assigned.Copy())
		if(target == split_network || target in network_ais)
			network_ram_assign[target] = ram_assigned[target]
			ram_assigned[target] = 0

	networks -= split_network
	update_resources()

	new /datum/ai_shared_resources(network_cpu_assign, network_ram_assign, split_network, null, human_lock)

	if(!length(networks))
		qdel(src)

/datum/ai_shared_resources/proc/set_cpu(target, amount)
	if(!istype(target, /datum/ai_network) && !isAI(target))
		stack_trace("Attempted to set_cpu with non-AI/network target! T: [target]")
		return
	if(!target)
		return
	if(amount > 1 || amount < 0)
		return
	cpu_assigned[target] = amount
	update_allocations()

/datum/ai_shared_resources/proc/add_ram(target, amount)
	if(!target || !amount)
		return
	if(!istype(target, /datum/ai_network) && !isAI(target))
		stack_trace("Attempted to add_ram with non-AI/network target! T: [target]")
		return
	ram_assigned[target] += amount
	update_allocations()

/datum/ai_shared_resources/proc/remove_ram(target, amount)
	if(!target || !amount)
		return
	if(!istype(target, /datum/ai_network) && !isAI(target))
		stack_trace("Attempted to remove_ram with non-AI/network target! T: [target]")
		return
	ram_assigned[target] = max((ram_assigned[target] || 0) - amount, 0)
	update_allocations()

/datum/ai_shared_resources/proc/clear_ai_resources(target)
	if(!target)
		return
	if(!istype(target, /datum/ai_network) && !isAI(target))
		stack_trace("Attempted to clear_ai_resources with non-AI/network target! T: [target]")
		return
	cpu_assigned[target] = 0
	ram_assigned[target] = 0
	update_allocations()

/datum/ai_shared_resources/proc/update_allocations()
	var/available_ram = total_ram()
	if(available_ram >= previous_ram)
		return

	var/assigned_ram = total_ram_assigned()
	if(assigned_ram < available_ram)
		return

	var/list/ram_assigned_copy = ram_assigned.Copy()
	var/list/affected_ais = list()

	if(assigned_ram > available_ram)
		var/needed_amount = assigned_ram - available_ram
		for(var/target in ram_assigned_copy)
			if(isAI(target))
				var/mob/living/silicon/ai/ai_mob = target
				if((ram_assigned_copy[ai_mob] || 0) >= needed_amount)
					ram_assigned_copy[ai_mob] -= needed_amount
					assigned_ram -= needed_amount
					affected_ais |= ai_mob
					break
				else if(ram_assigned_copy[ai_mob])
					var/amount = ram_assigned_copy[ai_mob]
					ram_assigned_copy[ai_mob] -= amount
					affected_ais |= ai_mob
					needed_amount -= amount
					assigned_ram -= amount
					if(available_ram >= assigned_ram)
						break
			else
				if((ram_assigned_copy[target] || 0) >= needed_amount)
					ram_assigned_copy[target] -= needed_amount
					assigned_ram -= needed_amount
					break
				else if(ram_assigned_copy[target])
					var/amount = ram_assigned_copy[target]
					ram_assigned_copy[target] -= amount
					needed_amount -= amount
					assigned_ram -= amount
					if(available_ram >= assigned_ram)
						break

	ram_assigned = ram_assigned_copy
	to_chat(affected_ais, span_warning("You have been deducted memory capacity. Please contact your network administrator if you believe this to be an error."))

/datum/ai_shared_resources/proc/get_all_ais()
	. = list()
	for(var/datum/ai_network/network in networks)
		. |= network.ai_list

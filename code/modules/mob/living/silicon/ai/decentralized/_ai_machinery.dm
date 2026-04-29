/obj/machinery/ai
	name = "AI hardware"
	desc = "Server hardware used by a decentralized AI system."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "RD-server-on"
	density = TRUE
	/// Temperature of the hardware core itself.
	/// Match Yog startup behavior so cooling loops have headroom before the safety limit.
	var/core_temp = 193.15
	var/datum/ai_network/network
	/// AI hardware should get hot without dumping most of that heat into the room.
	var/room_heat_share_fraction = 0.1

/obj/machinery/ai/Initialize(mapload)
	. = ..()
	connect_to_ai_network()
	START_PROCESSING(SSmachines, src)
	SSair.start_processing_machine(src)

/obj/machinery/ai/process_atmos(seconds_per_tick)
	var/turf/source_turf = get_turf(src)
	if(!source_turf || isspaceturf(source_turf))
		return

	var/datum/gas_mixture/environment = source_turf.return_air()
	if(!environment)
		return

	var/ambient_temperature = environment.return_temperature()
	// temperature_share expects (sharer, conduction, sharer_temp, sharer_heat_capacity).
	// We exchange heat against a virtual sink (no sharer datum), represented by core_temp.
	core_temp = environment.temperature_share(null, AI_HEATSINK_COEFF, core_temp, AI_HEATSINK_CAPACITY)
	var/ambient_after = environment.return_temperature()
	if(ambient_after > ambient_temperature && room_heat_share_fraction < 1)
		environment.temperature = ambient_temperature + ((ambient_after - ambient_temperature) * clamp(room_heat_share_fraction, 0, 1))
	if(machine_stat & NOPOWER)
		if(core_temp > ambient_temperature)
			var/passive_cooling = AI_POWERED_DOWN_COOLING_RATE * max(seconds_per_tick || 2, 0.1)
			core_temp = max(ambient_temperature, core_temp - passive_cooling)

/obj/machinery/ai/Destroy()
	SSair.stop_processing_machine(src)
	STOP_PROCESSING(SSmachines, src)
	disconnect_from_ai_network()
	return ..()

/obj/machinery/ai/proc/valid_holder()
	if(!network)
		connect_to_ai_network()
	if(!network)
		return FALSE
	if(machine_stat & (BROKEN | EMPED) || !has_power())
		return FALSE
	if(core_temp > get_temp_limit())
		return FALSE
	return TRUE

/obj/machinery/ai/proc/has_power()
	return !(machine_stat & NOPOWER)

/obj/machinery/ai/proc/get_holder_status()
	if(machine_stat & (BROKEN | NOPOWER | EMPED))
		return AI_MACHINE_BROKEN_NOPOWER_EMPED
	if(!network)
		return AI_MACHINE_NO_NETWORK
	if(core_temp > get_temp_limit())
		return AI_MACHINE_TOO_HOT

/obj/machinery/ai/proc/get_temp_limit()
	return network?.get_temp_limit() || AI_TEMP_LIMIT

/obj/machinery/ai/proc/connect_to_ai_network()
	var/turf/source_turf = loc
	if(!isturf(source_turf))
		return FALSE

	var/obj/structure/ethernet_cable/cable = source_turf.get_ai_cable_node()
	if(!cable)
		for(var/obj/structure/ethernet_cable/any_cable in source_turf)
			cable = any_cable
			break
	if(!cable)
		for(var/direction in GLOB.cardinals)
			var/turf/adjacent_turf = get_step(source_turf, direction)
			if(!adjacent_turf)
				continue
			for(var/obj/structure/ethernet_cable/adjacent_cable in adjacent_turf)
				var/obj/structure/ethernet_cable/new_node = new(source_turf)
				new_node.d1 = 0
				new_node.d2 = direction
				new_node.update_icon()
				if(!adjacent_cable.network)
					var/datum/ai_network/adjacent_network = new()
					adjacent_network.add_cable(adjacent_cable)
				if(!new_node.network)
					var/datum/ai_network/node_network = new()
					node_network.add_cable(new_node)
				new_node.mergeConnectedNetworks(new_node.d2)
				new_node.mergeConnectedNetworksOnTurf()
				cable = new_node
				break
			if(cable)
				break
	if(cable && !cable.network)
		var/datum/ai_network/new_ai_network = new()
		new_ai_network.add_cable(cable)
		if(cable.d1)
			cable.mergeConnectedNetworks(cable.d1)
		if(cable.d2)
			cable.mergeConnectedNetworks(cable.d2)
		cable.mergeConnectedNetworksOnTurf()
	if(!cable || !cable.network)
		return FALSE

	cable.network.add_machine(src)
	return TRUE

/obj/machinery/ai/proc/disconnect_from_ai_network()
	if(!network)
		return FALSE
	network.remove_machine(src)
	return TRUE

/obj/machinery/ai/attackby(obj/item/tool, mob/user, params)
	if(istype(tool, /obj/item/stack/ethernet_coil))
		var/obj/item/stack/ethernet_coil/coil = tool
		var/turf/machine_turf = get_turf(src)
		if(!isturf(machine_turf) || !machine_turf.can_have_cabling())
			return
		if(get_dist(src, user) > 1)
			return

		var/obj/structure/ethernet_cable/first_cable_on_turf
		for(var/obj/structure/ethernet_cable/existing_cable in machine_turf)
			if(!first_cable_on_turf)
				first_cable_on_turf = existing_cable
			if(!existing_cable.d1 || !existing_cable.d2)
				coil.cable_join(existing_cable, user)
				return

		if(first_cable_on_turf)
			coil.place_turf(machine_turf, user)
		else
			coil.place_turf(machine_turf, user)
		return

	return ..()

/obj/ai_smoke
	name = "smoke"
	desc = "Very hot!"

/obj/ai_smoke/Initialize(mapload)
	. = ..()
	particles = new /particles/smoke/ai()

/obj/ai_smoke/Destroy(force)
	QDEL_NULL(particles)
	return ..()

/particles/smoke/ai
	grow = 0.1
	height = 75
	lifespan = 1.25 SECONDS
	position = list(0, 0, 0)
	velocity = list(0, 0.15, 0)

/obj/machinery/ai
	name = "AI hardware"
	desc = "Server hardware used by a decentralized AI system."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "RD-server-on"
	density = TRUE
	/// Temperature of the hardware core itself.
	var/core_temp = 193.15
	var/datum/ai_network/network

/obj/machinery/ai/Initialize(mapload)
	. = ..()
	connect_to_ai_network()
	START_PROCESSING(SSmachines, src)
	SSair.start_processing_machine(src)

/obj/machinery/ai/process_atmos()
	var/turf/source_turf = get_turf(src)
	if(!source_turf || isspaceturf(source_turf))
		return

	var/datum/gas_mixture/environment = source_turf.return_air()
	if(!environment)
		return

	core_temp = environment.temperature_share(AI_HEATSINK_COEFF, core_temp, AI_HEATSINK_CAPACITY)

/obj/machinery/ai/Destroy()
	SSair.stop_processing_machine(src)
	STOP_PROCESSING(SSmachines, src)
	disconnect_from_ai_network()
	return ..()

/obj/machinery/ai/proc/valid_holder()
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
		var/turf/user_turf = user.loc
		if(!isturf(user_turf) || user_turf.underfloor_accessibility < UNDERFLOOR_INTERACTABLE || !isfloorturf(user_turf))
			return
		if(get_dist(src, user) > 1)
			return
		coil.place_turf(user_turf, user)
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

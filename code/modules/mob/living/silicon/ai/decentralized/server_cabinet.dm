/obj/machinery/ai/server_cabinet
	name = "server cabinet"
	desc = "A simple cabinet of bPCIe slots for installing server racks."
	icon = 'icons/obj/machines/telecomms_yogai.dmi'
	icon_state = "expansion_bus"
	circuit = /obj/item/circuitboard/machine/server_cabinet
	appearance_flags = KEEP_TOGETHER
	var/list/installed_racks
	var/total_cpu = 0
	var/total_ram = 0
	idle_power_usage = 100
	active_power_usage = 0
	var/cached_power_usage = 0
	var/max_racks = 2
	var/hardware_synced = FALSE
	var/was_valid_holder = FALSE
	var/roundstart = FALSE
	var/valid_ticks
	var/heat_modifier = 1
	var/power_modifier = 1
	var/obj/ai_smoke/smoke

/obj/machinery/ai/server_cabinet/Initialize(mapload)
	. = ..()
	valid_ticks = MAX_AI_SERVER_CABINET_TICKS
	roundstart = mapload
	installed_racks = list()
	GLOB.server_cabinets += src
	update_appearance(UPDATE_ICON)
	RefreshParts()
	sync_rack_inventory()

/obj/machinery/ai/server_cabinet/Destroy()
	installed_racks = list()
	GLOB.server_cabinets -= src
	vis_contents -= smoke
	QDEL_NULL(smoke)
	return ..()

/obj/machinery/ai/server_cabinet/process_atmos(seconds_per_tick)
	if(!length(installed_racks) || cached_power_usage <= 0)
		var/tick_scale = max(seconds_per_tick || 2, 0.1)
		var/idle_temperature = initial(core_temp)
		if(core_temp > idle_temperature)
			core_temp = max(idle_temperature, core_temp - (AI_POWERED_DOWN_COOLING_RATE * tick_scale))
		else
			core_temp = idle_temperature
		return

	. = ..()
	var/turf/source_turf = get_turf(src)
	if(!source_turf || isspaceturf(source_turf))
		return

	var/datum/gas_mixture/environment = source_turf.return_air()
	if(!environment)
		return

	var/ambient_temperature = environment.return_temperature()
	var/active_usage = get_active_usage_scale()
	if(core_temp > ambient_temperature && active_usage < 1)
		var/tick_scale = max(seconds_per_tick || 2, 0.1)
		var/passive_cooling = AI_POWERED_DOWN_COOLING_RATE * (1 - active_usage) * tick_scale
		core_temp = max(ambient_temperature, core_temp - passive_cooling)

/obj/machinery/ai/server_cabinet/RefreshParts()
	. = ..()
	var/new_heat_mod = 1
	var/new_power_mod = 1
	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		new_power_mod -= (capacitor.tier - 1) / 40
	for(var/datum/stock_part/matter_bin/matter_bin in component_parts)
		new_heat_mod -= (matter_bin.tier - 1) / 30
	heat_modifier = new_heat_mod
	power_modifier = new_power_mod
	idle_power_usage = initial(idle_power_usage) * power_modifier

/obj/machinery/ai/server_cabinet/process(seconds_per_tick)
	var/tick_scale = max((seconds_per_tick || 2) / 2, 0.1)
	var/hardware_changed = sync_rack_inventory()
	if(hardware_changed)
		network?.update_resources()
		update_appearance(UPDATE_ICON)
	if(!length(installed_racks) || cached_power_usage <= 0)
		if(smoke)
			vis_contents -= smoke
			QDEL_NULL(smoke)

	valid_ticks = clamp(valid_ticks, 0, MAX_AI_SERVER_CABINET_TICKS)
	if(valid_holder())
		roundstart = FALSE
		var/total_usage = cached_power_usage * power_modifier * get_active_usage_scale()
		if(total_usage > 0)
			use_energy(total_usage * tick_scale)
			// Empty or unused cabinets should not become heaters just because they are networked.
			core_temp += ((total_usage / AI_HEATSINK_CAPACITY) * heat_modifier) * AI_TEMPERATURE_MULTIPLIER * tick_scale
		valid_ticks++
		if(smoke)
			vis_contents -= smoke
			QDEL_NULL(smoke)
		if(!was_valid_holder)
			update_appearance(UPDATE_ICON)
		was_valid_holder = TRUE
		if(!hardware_synced && network)
			network.update_resources()
			hardware_synced = TRUE
	else
		valid_ticks--
		if(core_temp > get_temp_limit())
			if(!smoke)
				smoke = new()
				vis_contents += smoke
		else if(smoke)
			vis_contents -= smoke
			QDEL_NULL(smoke)
		if(was_valid_holder && valid_ticks <= 0)
			was_valid_holder = FALSE
			update_appearance(UPDATE_ICON)
			hardware_synced = FALSE
			network?.update_resources()

/obj/machinery/ai/server_cabinet/proc/sync_rack_inventory()
	var/list/new_racks = list()
	var/new_total_cpu = 0
	var/new_total_ram = 0
	var/new_cached_power_usage = 0

	for(var/obj/item/server_rack/rack in contents)
		new_racks += rack
		new_total_cpu += rack.get_cpu()
		new_total_ram += rack.get_ram()
		new_cached_power_usage += rack.get_power_usage()

	var/changed = FALSE
	if(length(new_racks) != length(installed_racks))
		changed = TRUE
	else
		for(var/obj/item/server_rack/rack in new_racks)
			if(!(rack in installed_racks))
				changed = TRUE
				break

	if(total_cpu != new_total_cpu || total_ram != new_total_ram || cached_power_usage != new_cached_power_usage)
		changed = TRUE

	installed_racks = new_racks
	total_cpu = new_total_cpu
	total_ram = new_total_ram
	cached_power_usage = new_cached_power_usage
	use_power = cached_power_usage > 0 ? ACTIVE_POWER_USE : IDLE_POWER_USE

	return changed

/obj/machinery/ai/server_cabinet/proc/get_active_usage_scale()
	if(!length(installed_racks) || cached_power_usage <= 0)
		return 0
	var/datum/ai_shared_resources/resources = network?.resources
	if(!resources)
		return 0
	var/cpu_scale = clamp(resources.total_cpu_assigned(), 0, 1)
	var/revival_cpu_scale = network ? network.revival_cpu_assigned() : 0
	cpu_scale = max(0, cpu_scale - revival_cpu_scale) + (revival_cpu_scale * AI_REVIVAL_HEAT_MULTIPLIER)
	var/ram_total = max(resources.total_ram(), 0)
	var/ram_scale = ram_total > 0 ? clamp(resources.total_ram_assigned() / ram_total, 0, 1) : 0
	return max(cpu_scale, ram_scale) * AI_SERVER_CABINET_HEAT_SCALE

/obj/machinery/ai/server_cabinet/update_overlays()
	. = ..()
	if(length(installed_racks) > 0)
		. += mutable_appearance(icon, "expansion_bus_top")
	if(length(installed_racks) > 1)
		. += mutable_appearance(icon, "expansion_bus_bottom")
	if(!(machine_stat & (BROKEN | NOPOWER | EMPED)))
		. += mutable_appearance(icon, "expansion_bus_on")
		if(!valid_ticks)
			return
		if(!network)
			return
		if(length(installed_racks) > 0)
			. += mutable_appearance(icon, "expansion_bus_top_on")
		if(length(installed_racks) > 1)
			. += mutable_appearance(icon, "expansion_bus_bottom_on")

/obj/machinery/ai/server_cabinet/update_icon_state()
	. = ..()
	icon_state = panel_open ? "expansion_bus_o" : "expansion_bus"

/obj/machinery/ai/server_cabinet/attackby(obj/item/tool, mob/living/user, params)
	if(istype(tool, /obj/item/server_rack))
		if(length(installed_racks) >= max_racks)
			to_chat(user, span_warning("[src] cannot fit [tool]!"))
			return ..()
		to_chat(user, span_notice("You install [tool] into [src]."))
		tool.forceMove(src)
		sync_rack_inventory()
		network?.update_resources()
		update_appearance(UPDATE_ICON)
		return FALSE

	if(tool.tool_behaviour == TOOL_CROWBAR)
		if(length(installed_racks))
			var/turf/source_turf = get_turf(src)
			for(var/obj/item/item in installed_racks)
				item.forceMove(source_turf)
			sync_rack_inventory()
			network?.update_resources()
			to_chat(user, span_notice("You remove all the racks from [src]."))
			update_appearance(UPDATE_ICON)
			return FALSE
		if(default_deconstruction_crowbar(tool))
			return TRUE

	if(default_deconstruction_screwdriver(user, "expansion_bus_o", "expansion_bus", tool))
		return TRUE

	return ..()

/obj/machinery/ai/server_cabinet/examine(mob/user)
	. = ..()
	var/holder_status = get_holder_status()
	if(holder_status)
		. += span_warning("Machinery non-functional. Reason: [holder_status]")
	if(!valid_ticks)
		. += span_notice("A small screen is displaying the words 'OFFLINE.'")
	. += span_notice("The machine has [length(installed_racks)] racks out of a maximum of [max_racks] installed.")
	. += span_notice("Current power usage multiplier: [span_bold("[round(power_modifier * 100, 0.1)]%")]")
	. += span_notice("Current heat multiplier: [span_bold("[round(heat_modifier * 100, 0.1)]%")]")
	for(var/obj/item/server_rack/rack in installed_racks)
		. += span_notice("There is a rack installed with a processing capacity of [rack.get_cpu()]THz and a memory capacity of [rack.get_ram()]TB. Uses [rack.get_power_usage()]W.")
	. += span_notice("Use a crowbar to remove all currently inserted racks.")

/obj/machinery/ai/server_cabinet/prefilled/Initialize(mapload)
	. = ..()
	new /obj/item/server_rack/roundstart(src)
	sync_rack_inventory()
	network?.update_resources()

/obj/machinery/ai/server_cabinet/connect_to_ai_network()
	. = ..()
	if(network)
		network.update_resources()

/obj/machinery/ai/server_cabinet/disconnect_from_ai_network()
	var/datum/ai_network/old_network = network
	. = ..()
	old_network?.update_resources()

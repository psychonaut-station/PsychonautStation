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

/obj/machinery/ai/server_cabinet/Destroy()
	installed_racks = list()
	GLOB.server_cabinets -= src
	vis_contents -= smoke
	QDEL_NULL(smoke)
	return ..()

/obj/machinery/ai/server_cabinet/RefreshParts()
	var/new_heat_mod = 1
	var/new_power_mod = 1
	for(var/obj/item/stock_parts/capacitor/capacitor in component_parts)
		new_power_mod -= (capacitor.rating - 1) / 40
	for(var/obj/item/stock_parts/matter_bin/matter_bin in component_parts)
		new_heat_mod -= (matter_bin.rating - 1) / 30
	heat_modifier = new_heat_mod
	power_modifier = new_power_mod
	idle_power_usage = initial(idle_power_usage) * power_modifier

/obj/machinery/ai/server_cabinet/process()
	valid_ticks = clamp(valid_ticks, 0, MAX_AI_SERVER_CABINET_TICKS)
	if(valid_holder())
		roundstart = FALSE
		var/total_usage = cached_power_usage * power_modifier
		if(total_usage > 0)
			use_energy(total_usage)
		core_temp += ((total_usage / AI_HEATSINK_CAPACITY) * heat_modifier) * AI_TEMPERATURE_MULTIPLIER
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
		if(!smoke && get_holder_status() == AI_MACHINE_TOO_HOT)
			smoke = new()
			vis_contents += smoke
		if(was_valid_holder && valid_ticks <= 0)
			was_valid_holder = FALSE
			update_appearance(UPDATE_ICON)
			hardware_synced = FALSE
			network?.update_resources()

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
		installed_racks += tool
		var/obj/item/server_rack/rack = tool
		total_cpu += rack.get_cpu()
		total_ram += rack.get_ram()
		cached_power_usage += rack.get_power_usage()
		network?.update_resources()
		use_power = ACTIVE_POWER_USE
		update_appearance(UPDATE_ICON)
		return FALSE

	if(tool.tool_behaviour == TOOL_CROWBAR)
		if(length(installed_racks))
			var/turf/source_turf = get_turf(src)
			for(var/obj/item/item in installed_racks)
				item.forceMove(source_turf)
			installed_racks.len = 0
			total_cpu = 0
			total_ram = 0
			cached_power_usage = 0
			network?.update_resources()
			to_chat(user, span_notice("You remove all the racks from [src]."))
			use_power = IDLE_POWER_USE
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
	var/obj/item/server_rack/roundstart/rack = new(src)
	total_cpu += rack.get_cpu()
	total_ram += rack.get_ram()
	cached_power_usage += rack.get_power_usage()
	installed_racks += rack

/obj/machinery/ai/server_cabinet/connect_to_ai_network()
	. = ..()
	if(network)
		network.update_resources()

/obj/machinery/ai/server_cabinet/disconnect_from_ai_network()
	var/datum/ai_network/old_network = network
	. = ..()
	old_network?.update_resources()

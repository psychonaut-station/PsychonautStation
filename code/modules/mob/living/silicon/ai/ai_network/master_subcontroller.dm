/obj/machinery/ai/master_subcontroller
	name = "master subcontroller"
	desc = "A companion mainframe that handles low-level polling and fast remote control tasks for a decentralized AI."
	icon = 'icons/obj/machines/telecomms_yogai.dmi'
	icon_state = "hub"
	use_power = ACTIVE_POWER_USE
	idle_power_usage = 100
	active_power_usage = 500
	max_integrity = 1000
	circuit = /obj/item/circuitboard/machine/subcontroller

	var/on = TRUE
	var/list/enabled_areas = list(
		"General Areas" = /datum/wires/airlock,
		"Maintenance Tunnels" = /datum/wires/airlock/maint,
		"Command Areas" = /datum/wires/airlock/command,
		"Service Areas" = /datum/wires/airlock/service,
		"Engineering Areas" = /datum/wires/airlock/engineering,
		"Medical Areas" = /datum/wires/airlock/medbay,
		"Science Areas" = /datum/wires/airlock/science,
		"AI Areas" = /datum/wires/airlock/ai,
	)
	var/list/disabled_areas = list(
		"Security Areas" = /datum/wires/airlock/security,
	)

/obj/machinery/ai/master_subcontroller/attackby(obj/item/tool, mob/living/user, params)
	if(tool.tool_behaviour == TOOL_MULTITOOL)
		var/action = alert(user, "What do you wish to do?", name, "Enable Area", "Disable Area", "Cancel")
		if(!action || action == "Cancel")
			return TRUE

		if(action == "Enable Area")
			if(!length(disabled_areas))
				to_chat(user, span_warning("There are no areas to enable."))
				return TRUE
			var/selected_area = input(user, "Please select an area to enable:", name) as null|anything in disabled_areas
			if(!selected_area || !disabled_areas[selected_area])
				return TRUE
			enabled_areas[selected_area] = disabled_areas[selected_area]
			disabled_areas -= selected_area
			update_appearance()
			return TRUE

		if(!length(enabled_areas))
			to_chat(user, span_warning("There are no areas to disable."))
			return TRUE
		var/selected_area = input(user, "Please select an area to disable:", name) as null|anything in enabled_areas
		if(!selected_area || !enabled_areas[selected_area])
			return TRUE
		disabled_areas[selected_area] = enabled_areas[selected_area]
		enabled_areas -= selected_area
		update_appearance()
		return TRUE

	return ..()

/obj/machinery/ai/master_subcontroller/process(seconds_per_tick)
	update_power()
	return ..()

/obj/machinery/ai/master_subcontroller/update_icon_state()
	. = ..()
	if(panel_open)
		icon_state = "[initial(icon_state)]_o"
	else
		icon_state = initial(icon_state)

/obj/machinery/ai/master_subcontroller/update_overlays()
	. = ..()
	if(on)
		. += mutable_appearance(icon, "[initial(icon_state)]_on")

/obj/machinery/ai/master_subcontroller/proc/update_power()
	on = !(machine_stat & (BROKEN | NOPOWER | EMPED))
	update_appearance()

/obj/machinery/ai/master_subcontroller/disconnect_from_ai_network()
	if(network?.cached_subcontroller == src)
		network.cached_subcontroller = null
	return ..()

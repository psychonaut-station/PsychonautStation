/obj/machinery/ai/networking
	name = "networking machine"
	desc = "A high-powered transmitter and receiver for bridging remote AI networks."
	icon = 'icons/obj/networking_machine.dmi'
	icon_state = "base"
	circuit = /obj/item/circuitboard/machine/networking_machine
	density = TRUE
	use_power = NO_POWER_USE
	idle_power_usage = 0
	active_power_usage = 0
	max_integrity = 150

	var/label
	/// Mapping helper for roundstart pairings.
	var/roundstart_connection
	var/obj/machinery/ai/networking/partner
	var/rotation_to_partner = 0
	var/locked = FALSE
	var/obj/machinery/ai/networking/remote_connection_attempt
	var/mob/remote_control
	var/datum/ai_network/cached_old_network

/obj/machinery/ai/networking/Initialize(mapload)
	. = ..()
	if(!label)
		label = num2hex(rand(1, 65535), -1)
	GLOB.ai_networking_machines += src
	if(roundstart_connection)
		addtimer(CALLBACK(src, PROC_REF(roundstart_connect)), 0)
	update_appearance(UPDATE_ICON)

/obj/machinery/ai/networking/Destroy()
	GLOB.ai_networking_machines -= src
	disconnect()
	return ..()

/obj/machinery/ai/networking/update_overlays()
	. = ..()
	var/mutable_appearance/dish_overlay = mutable_appearance(icon, "top", FLY_LAYER)
	var/matrix/turner = matrix()
	turner.Turn(rotation_to_partner - 180)
	dish_overlay.transform = turner
	. += dish_overlay

/obj/machinery/ai/networking/attackby(obj/item/tool, mob/living/user, params)
	if(tool.tool_behaviour == TOOL_MULTITOOL)
		if(partner)
			to_chat(user, span_warning("This machine is already connected to a different machine! Disconnect it first."))
			return TRUE
		remote_connection_attempt = null
		var/list/targets = list()
		for(var/obj/machinery/ai/networking/networking_machine as anything in GLOB.ai_networking_machines)
			if(networking_machine == src)
				continue
			if(networking_machine.z != z)
				continue
			if(networking_machine.partner)
				continue
			targets[networking_machine.label] = networking_machine

		var/attempt_connect = input(user, "Select the machine you wish to connect to.") as null|anything in targets
		if(!attempt_connect)
			return TRUE

		var/obj/machinery/ai/networking/remote_target = targets[attempt_connect]
		if(!remote_target || QDELETED(remote_target))
			return TRUE

		remote_connection_attempt = remote_target
		to_chat(user, span_notice("Manual override primed. Rotate the dish with a wrench, then finalize the link with a screwdriver when aligned."))
		return TRUE

	if(tool.tool_behaviour == TOOL_WRENCH)
		if(partner)
			to_chat(user, span_warning("This machine is already connected to a different machine!"))
			return TRUE
		var/new_rotation = input(user, "Set rotation (0-360):") as null|num
		if(isnull(new_rotation))
			rotation_to_partner = 0
		else
			rotation_to_partner = clamp(new_rotation, 0, 360)
		update_appearance(UPDATE_ICON)
		return TRUE

	if(tool.tool_behaviour == TOOL_SCREWDRIVER)
		if(partner)
			to_chat(user, span_warning("This machine is already connected to a different machine!"))
			return TRUE
		if(!remote_connection_attempt)
			to_chat(user, span_warning("Initialize a target with a multitool first."))
			return TRUE
		var/actual_angle = get_angle(src, remote_connection_attempt)
		if(rotation_to_partner > actual_angle - 20 && rotation_to_partner < actual_angle + 20)
			connect_to_partner(remote_connection_attempt)
			to_chat(user, span_notice("You successfully connect to [remote_connection_attempt.label]!"))
		else
			to_chat(user, span_warning("Unable to establish connection. The dish is not aligned."))
		return TRUE

	if(tool.tool_behaviour == TOOL_WIRECUTTER)
		if(!partner)
			to_chat(user, span_warning("The machine is not connected."))
			return TRUE
		to_chat(user, span_notice("You disconnect the remote link."))
		disconnect()
		return TRUE

	return ..()

/obj/machinery/ai/networking/proc/roundstart_connect()
	if(!network)
		connect_to_ai_network()

	for(var/obj/machinery/ai/networking/networking_machine as anything in GLOB.ai_networking_machines)
		if(partner)
			break
		if(networking_machine == src)
			continue
		if(networking_machine.partner)
			continue
		if(roundstart_connection)
			if(networking_machine.label != roundstart_connection)
				continue
		connect_to_partner(networking_machine, TRUE)
		break

/obj/machinery/ai/networking/proc/disconnect()
	if(!partner)
		return

	var/obj/machinery/ai/networking/old_partner = partner
	var/datum/ai_network/partner_network = old_partner.network

	old_partner.rotation_to_partner = 0
	old_partner.partner = null
	old_partner.update_appearance(UPDATE_ICON)

	partner = null
	rotation_to_partner = 0
	update_appearance(UPDATE_ICON)

	partner_network?.rebuild_remote()
	network?.rebuild_remote()
	partner_network?.network_machine_disconnected(network)
	network?.network_machine_disconnected(partner_network)

/obj/machinery/ai/networking/proc/connect_to_partner(obj/machinery/ai/networking/target, forced = FALSE)
	remote_connection_attempt = null
	if(!target || QDELETED(target))
		return
	if(target == src)
		return
	if(target.partner)
		return
	if(target.locked && !forced)
		return

	partner = target
	rotation_to_partner = get_angle(src, target)
	target.partner = src
	target.rotation_to_partner = get_angle(target, src)
	target.update_appearance(UPDATE_ICON)
	update_appearance(UPDATE_ICON)

	network?.rebuild_remote()
	target.network?.rebuild_remote()

/obj/machinery/ai/networking/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AiNetworking", name)
		ui.open()

/obj/machinery/ai/networking/ui_status(mob/user)
	. = ..()
	if(!QDELETED(remote_control) && user == remote_control)
		. = UI_INTERACTIVE

/obj/machinery/ai/networking/ui_data(mob/user)
	var/list/data = list()

	data["is_connected"] = partner ? partner.label : FALSE
	data["label"] = label
	data["locked"] = locked

	var/list/possible_targets = list()
	for(var/obj/machinery/ai/networking/networking_machine as anything in GLOB.ai_networking_machines)
		if(networking_machine == src)
			continue
		if(!is_station_level(networking_machine.z) && !is_station_level(z) && networking_machine.z != z)
			continue
		if(networking_machine.locked)
			continue
		possible_targets += networking_machine.label

	data["possible_targets"] = possible_targets
	return data

/obj/machinery/ai/networking/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("switch_label")
			if(locked)
				return TRUE
			var/new_label = stripped_input(usr, "Enter a new label.", "Set label", label, 16)
			if(!new_label)
				return TRUE
			for(var/obj/machinery/ai/networking/networking_machine as anything in GLOB.ai_networking_machines)
				if(networking_machine == src)
					continue
				if(networking_machine.label == new_label)
					to_chat(usr, span_warning("A machine with this label already exists!"))
					return TRUE
			label = new_label
			return TRUE

		if("connect")
			if(locked)
				return TRUE
			var/target_label = params["target_label"]
			if(!target_label || target_label == label)
				return TRUE
			for(var/obj/machinery/ai/networking/networking_machine as anything in GLOB.ai_networking_machines)
				if(networking_machine.label != target_label)
					continue
				if(!is_station_level(networking_machine.z) && !is_station_level(z) && networking_machine.z != z)
					return TRUE
				if(networking_machine.locked)
					to_chat(usr, span_warning("Unable to connect to '[target_label]'; it is locked."))
					return TRUE
				if(networking_machine.partner)
					to_chat(usr, span_warning("Unable to connect to '[target_label]'; it already has an active link."))
					return TRUE
				connect_to_partner(networking_machine)
				to_chat(usr, span_notice("Connection established to '[target_label]'."))
				return TRUE
			return TRUE

		if("disconnect")
			if(locked)
				return TRUE
			disconnect()
			return TRUE

		if("toggle_lock")
			locked = !locked
			return TRUE

/obj/machinery/ai/networking/connect_to_ai_network()
	. = ..()
	if(!network || !partner)
		return
	network.rebuild_remote()
	if(cached_old_network)
		cached_old_network.network_machine_disconnected(network)
		cached_old_network = null

/obj/machinery/ai/networking/disconnect_from_ai_network()
	var/datum/ai_network/old_network = network
	cached_old_network = old_network
	. = ..()
	if(old_network && partner)
		old_network.rebuild_remote()

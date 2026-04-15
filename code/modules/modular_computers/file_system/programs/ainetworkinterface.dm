/datum/computer_file/program/ai_network_base/interface
	filename = "aiinterface"
	filedesc = "AI Network Interface"
	extended_desc = "Connects to a nearby decentralized AI network for resource allocation, networking control, and AI transfer operations."
	size = 10
	tgui_id = "NtosAIMonitor"
	var/obj/machinery/ai/networking/active_networking
	var/mob/networking_operator

	/// AI currently being downloaded to the inserted IntelliCard.
	var/mob/living/silicon/ai/downloading
	/// User who initiated the current download.
	var/mob/user_downloading
	/// Download completion percentage.
	var/download_progress = 0
	var/download_warning = FALSE

/datum/computer_file/program/ai_network_base/interface/kill_program(mob/user)
	if(active_networking)
		active_networking.remote_control = null
	active_networking = null
	networking_operator = null
	stop_download(TRUE)
	return ..()

/datum/computer_file/program/ai_network_base/interface/process_tick(seconds_per_tick)
	. = ..()

	if(networking_operator && (!computer?.physical || !networking_operator.Adjacent(computer.physical)))
		if(active_networking)
			active_networking.remote_control = null
		active_networking = null
		networking_operator = null

	var/datum/ai_network/local_network = get_local_ainet()
	if(!local_network || !stored_card)
		stop_download(TRUE)
		return TRUE

	if(!downloading)
		return TRUE
	if(downloading.stat == DEAD)
		stop_download()
		return TRUE
	if(!downloading.can_download)
		stop_download()
		return TRUE
	if(downloading.ai_network?.resources != local_network.resources)
		stop_download()
		return TRUE

	download_progress += AI_DOWNLOAD_PER_PROCESS * downloading.downloadSpeedModifier * seconds_per_tick
	if(download_progress >= 50 && !download_warning)
		download_warning = TRUE
		to_chat(downloading, span_userdanger("Warning! Download is 50% completed! Download location: [get_area(computer.physical)]!"))
	if(download_progress >= 100)
		finish_download()
	return TRUE

/datum/computer_file/program/ai_network_base/interface/ui_data(mob/user)
	var/list/data = list()
	var/datum/ai_network/net = get_ainet(user)

	data["has_ai_net"] = !!net
	data["stored_card"] = !!stored_card
	data["intellicard"] = !!stored_card
	data["stored_ai_name"] = stored_card?.AI?.real_name
	data["stored_ai_health"] = stored_card?.AI ? stored_card.AI.health : 0
	data["intellicard_ai"] = stored_card?.AI?.real_name
	data["intellicard_ai_health"] = stored_card?.AI ? stored_card.AI.health : 0
	data["downloading"] = downloading?.real_name
	data["downloading_ref"] = downloading ? REF(downloading) : null
	data["download_progress"] = round(download_progress, 0.1)
	data["holding_mmi"] = istype(user?.get_active_held_item(), /obj/item/mmi)

	if(!net)
		return data

	data["current_ai_ref"] = isAI(user) ? REF(user) : null
	data["human_only"] = net.resources?.human_lock || FALSE
	data["network_name"] = net.custom_name || net.label || "Unnamed AI Network"
	data["connection_type"] = ismachinery(computer?.physical) ? "wired connection" : "local wire shunt"
	data["can_upload"] = !!net.find_data_core()

	data["total_cpu"] = net.resources?.total_cpu() || 0
	data["total_ram"] = net.resources?.total_ram() || 0
	data["total_assigned_cpu"] = net.resources?.total_cpu_assigned() || 0
	data["total_assigned_ram"] = net.resources?.total_ram_assigned() || 0
	data["network_ref"] = REF(net)
	data["network_assigned_cpu"] = net.resources?.cpu_assigned[net] || 0
	data["network_assigned_ram"] = net.resources?.ram_assigned[net] || 0
	data["bitcoin_amount"] = round(net.bitcoin_payout, 0.1)

	var/remaining_network_cpu = 1
	data["network_cpu_assignments"] = list()
	for(var/project_name in GLOB.possible_ainet_activities)
		var/assigned = net.local_cpu_usage[project_name] || 0
		remaining_network_cpu -= assigned
		data["network_cpu_assignments"] += list(list(
			"name" = project_name,
			"assigned" = assigned,
			"tagline" = GLOB.ainet_activity_tagline[project_name],
			"description" = GLOB.ainet_activity_description[project_name],
		))
	data["remaining_network_cpu"] = max(0, remaining_network_cpu)

	data["networking_devices"] = list()
	for(var/obj/machinery/ai/networking/networker in net.get_local_nodes_oftype(/obj/machinery/ai/networking))
		data["networking_devices"] += list(list(
			"label" = networker.label,
			"ref" = REF(networker),
			"has_partner" = networker.partner ? networker.partner.label : null,
		))

	data["ai_list"] = list()
	for(var/mob/living/silicon/ai/ai_mob as anything in net.get_all_ais())
		data["ai_list"] += list(list(
			"name" = ai_mob.real_name,
			"ref" = REF(ai_mob),
			"can_download" = ai_mob.can_download,
			"health" = ai_mob.health,
			"active" = !!ai_mob.mind,
			"in_core" = istype(ai_mob.loc, /obj/machinery/ai/data_core),
			"assigned_cpu" = net.resources?.cpu_assigned[ai_mob] || 0,
			"assigned_ram" = net.resources?.ram_assigned[ai_mob] || 0,
		))

	return data

/datum/computer_file/program/ai_network_base/interface/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = usr
	var/datum/ai_network/net = get_ainet(user)
	if(!net)
		return FALSE

	switch(action)
		if("eject_card")
			return try_eject(user)

		if("change_network_name")
			var/new_name = stripped_input(user, "Enter a new name for this AI network.", "Network Name", net.custom_name || net.label, 32)
			if(!new_name)
				return TRUE
			new_name = reject_bad_name(new_name, allow_numbers = TRUE, max_length = 32, cap_after_symbols = FALSE)
			if(!new_name)
				to_chat(user, span_warning("The network rejects that name."))
				return TRUE
			net.custom_name = new_name
			return TRUE

		if("control_networking")
			var/obj/machinery/ai/networking/networker = locate(params["ref"]) in net.get_local_nodes_oftype(/obj/machinery/ai/networking)
			if(!networker)
				return TRUE
			if(active_networking)
				active_networking.remote_control = null
			networking_operator = user
			active_networking = networker
			active_networking.remote_control = networking_operator
			networker.ui_interact(user)
			return TRUE

		if("toggle_human_only")
			if(isAI(user))
				return TRUE
			net.resources.human_lock = !net.resources.human_lock
			to_chat(user, span_notice("Network access is now [net.resources.human_lock ? "restricted to organics." : "available to authorized silicon users."]"))
			return TRUE

		if("clear_ai_resources")
			var/target = resolve_resource_target(net, params["target_ai"])
			if(!target || (isAI(user) && net.resources.human_lock))
				return TRUE
			net.resources.clear_ai_resources(target)
			return TRUE

		if("set_cpu")
			var/target = resolve_resource_target(net, params["target_ai"])
			if(!target || (isAI(user) && net.resources.human_lock))
				return TRUE
			var/amount = clamp(text2num(params["amount_cpu"]), 0, 1)
			net.resources.set_cpu(target, amount)
			return TRUE

		if("max_cpu")
			var/target = resolve_resource_target(net, params["target_ai"])
			if(!target || (isAI(user) && net.resources.human_lock))
				return TRUE
			var/amount = (1 - net.resources.total_cpu_assigned()) + (net.resources.cpu_assigned[target] || 0)
			net.resources.set_cpu(target, amount)
			return TRUE

		if("add_ram")
			var/target = resolve_resource_target(net, params["target_ai"])
			if(!target || (isAI(user) && net.resources.human_lock))
				return TRUE
			if(net.resources.total_ram_assigned() >= net.resources.total_ram())
				return TRUE
			net.resources.add_ram(target, 1)
			return TRUE

		if("remove_ram")
			var/target = resolve_resource_target(net, params["target_ai"])
			if(!target || (isAI(user) && net.resources.human_lock))
				return TRUE
			if((net.resources.ram_assigned[target] || 0) <= 0)
				return TRUE
			net.resources.remove_ram(target, 1)
			return TRUE

		if("allocate_network_cpu")
			if(isAI(user) && net.resources.human_lock)
				return TRUE
			var/project_type = params["project_name"]
			if(!(project_type in GLOB.possible_ainet_activities))
				return TRUE
			var/amount = clamp(text2num(params["amount"]), 0, 1)
			var/other_cpu = 0
			for(var/activity_name in net.local_cpu_usage)
				if(activity_name == project_type)
					continue
				other_cpu += net.local_cpu_usage[activity_name]
			net.local_cpu_usage[project_type] = min(amount, max(0, 1 - other_cpu))
			return TRUE

		if("max_network_cpu")
			if(isAI(user) && net.resources.human_lock)
				return TRUE
			var/project_type = params["project_name"]
			if(!(project_type in GLOB.possible_ainet_activities))
				return TRUE
			var/other_cpu = 0
			for(var/activity_name in net.local_cpu_usage)
				if(activity_name == project_type)
					continue
				other_cpu += net.local_cpu_usage[activity_name]
			net.local_cpu_usage[project_type] = max(0, 1 - other_cpu)
			return TRUE

		if("bitcoin_payout")
			var/payout_amount = round(net.bitcoin_payout, 0.1)
			if(payout_amount <= 0)
				return TRUE
			var/obj/item/holochip/holochip = new(computer.physical.drop_location(), payout_amount)
			user.put_in_hands(holochip)
			net.bitcoin_payout = 0
			return TRUE

		if("apply_object")
			var/mob/living/silicon/ai/target_ai = locate(params["ai_ref"]) in net.get_all_ais()
			if(!target_ai)
				to_chat(user, span_warning("Unable to locate AI target."))
				return TRUE
			var/obj/item/held_item = user.get_active_held_item()
			if(!held_item)
				to_chat(user, span_warning("You are not holding an upgrade item."))
				return TRUE
			if(istype(held_item, /obj/item/aiupgrade) || istype(held_item, /obj/item/malf_upgrade))
				held_item.pre_attack(target_ai, user)
				return TRUE
			to_chat(user, span_warning("That item cannot be applied as an AI upgrade."))
			return TRUE

		if("upload_person")
			if(!computer?.physical)
				to_chat(user, span_warning("Console hardware not found."))
				return TRUE
			var/obj/item/mmi/mmi = user.is_holding_item_of_type(/obj/item/mmi)
			if(!mmi)
				to_chat(user, span_warning("You need to be holding an MMI/Posibrain."))
				return TRUE
			if(!mmi.brainmob?.mind)
				to_chat(user, span_warning("[mmi] does not contain an active intelligence."))
				return TRUE

			var/mob/living/brain/brainmob = mmi.brainmob
			brainmob.mind.remove_antags_for_borging()
			if(!brainmob.mind.has_ever_been_ai)
				SSblackbox.record_feedback("amount", "ais_created", 1)

			var/mob/living/silicon/ai/new_ai
			var/datum/ai_laws/laws = new
			laws.set_laws_config()
			if(mmi.overrides_aicore_laws)
				new_ai = new /mob/living/silicon/ai(computer.physical.loc, mmi.laws, brainmob)
				mmi.laws = null
			else
				new_ai = new /mob/living/silicon/ai(computer.physical.loc, laws, brainmob)

			if(mmi.force_replace_ai_name)
				new_ai.fully_replace_character_name(new_ai.name, mmi.replacement_ai_name())

			if(!new_ai.ai_network || new_ai.ai_network.resources != net.resources)
				new_ai.relocate(TRUE, TRUE, net)

			qdel(mmi)
			to_chat(user, span_notice("AI successfully uploaded from MMI."))
			return TRUE

		if("upload_ai")
			if(!stored_card?.AI)
				to_chat(user, span_warning("No AI found on the inserted IntelliCard."))
				return TRUE
			var/obj/machinery/ai/data_core/core = net.find_data_core()
			if(!core)
				to_chat(user, span_warning("No active AI data core is connected to this network."))
				return TRUE
			core.transfer_ai(AI_TRANS_FROM_CARD, user, stored_card.AI, stored_card)
			stored_card.update_appearance()
			return TRUE

		if("start_download")
			if(!stored_card || stored_card.AI || downloading)
				return TRUE
			var/mob/living/silicon/ai/target = locate(params["download_target"]) in net.get_all_ais()
			if(!target || !istype(target.loc, /obj/machinery/ai/data_core) || !target.can_download)
				return TRUE
			downloading = target
			user_downloading = user
			download_progress = 0
			download_warning = FALSE
			to_chat(target, span_userdanger("Warning! Someone is attempting to download you from [get_area(computer.physical)]!"))
			return TRUE

		if("skip_download")
			if(!downloading)
				return TRUE
			if(user == downloading)
				finish_download()
			return TRUE

		if("stop_download")
			if(isAI(user))
				to_chat(user, span_warning("You need physical access to stop the download!"))
				return TRUE
			stop_download()
			return TRUE

	return FALSE

/datum/computer_file/program/ai_network_base/interface/proc/resolve_resource_target(datum/ai_network/net, target_ref)
	if(!target_ref)
		return null
	if(target_ref == REF(net))
		return net
	return locate(target_ref) in net.get_all_ais()

/datum/computer_file/program/ai_network_base/interface/proc/finish_download()
	if(!stored_card || !downloading)
		stop_download(TRUE)
		return
	if(!istype(downloading.loc, /obj/machinery/ai/data_core))
		stop_download(TRUE)
		return
	downloading.transfer_ai(AI_TRANS_TO_CARD, user_downloading, null, stored_card)
	stored_card.update_appearance()
	stop_download(TRUE)

/datum/computer_file/program/ai_network_base/interface/proc/stop_download(silent = FALSE)
	if(downloading && !silent)
		to_chat(downloading, span_userdanger("Download stopped."))
	downloading = null
	user_downloading = null
	download_progress = 0
	download_warning = FALSE

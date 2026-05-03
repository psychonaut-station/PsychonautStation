/obj/machinery/ai/data_core
	name = "AI data core"
	desc = "A computer system capable of hosting a decentralized artificial intelligence."
	icon = 'icons/obj/machines/ai_core.dmi'
	icon_state = "core-offline"
	circuit = /obj/item/circuitboard/machine/ai_data_core
	max_integrity = 500
	active_power_usage = AI_DATA_CORE_POWER_USAGE
	idle_power_usage = 1000
	use_power = IDLE_POWER_USE
	var/disableheat = FALSE
	var/primary = FALSE
	var/valid_ticks
	var/warning_sent = FALSE
	COOLDOWN_DECLARE(warning_cooldown)
	var/heat_modifier = 1
	var/power_modifier = 1
	var/obj/item/stock_parts/power_store/cell/integrated_battery
	var/obj/ai_smoke/smoke
	var/party_generation = 0
	var/party_active = FALSE
	var/obj/item/dead_ai/dead_ai_blackbox
	var/goon_core_enabled = FALSE
	var/goon_core_skin = "default"
	var/goon_background_state = "ai_blue"
	var/goon_light_mode = "auto"
	var/goon_face_state = "ai_happy-dol"

/obj/machinery/ai/data_core/Initialize(mapload)
	. = ..()
	valid_ticks = MAX_AI_DATA_CORE_TICKS
	GLOB.data_cores += src
	if(primary && !GLOB.primary_data_core)
		GLOB.primary_data_core = src
	update_appearance()
	RefreshParts()

/obj/machinery/ai/data_core/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	if(anchored || loc == old_loc)
		return
	refresh_network_connection(FALSE)

/obj/machinery/ai/data_core/proc/toggle_floor_bolts(mob/living/silicon/ai/ai_mob)
	if(anchored)
		set_anchored(FALSE)
		refresh_network_connection(FALSE)
		playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
		to_chat(ai_mob, span_boldnotice("Your data core floor bolts loosen. The chassis can now be moved."))
		to_chat(ai_mob, span_notice("The data core keeps running, but its server cabinet uplink drops until it is secured on a wired tile."))
		return TRUE

	set_anchored(TRUE)
	playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
	var/connected_to_cable = refresh_network_connection(TRUE)
	to_chat(ai_mob, span_boldnotice("Your data core floor bolts lock into place."))
	if(connected_to_cable)
		to_chat(ai_mob, span_notice("The data core reconnects to the local AI network."))
	else
		to_chat(ai_mob, span_warning("No cabinet uplink was found. The data core stays online on isolated power, but server resources are unavailable."))
	return TRUE

/obj/machinery/ai/data_core/proc/refresh_network_connection(allow_cable_connection = TRUE)
	var/datum/ai_network/old_net = network
	if(old_net)
		disconnect_from_ai_network()

	if(allow_cable_connection && connect_to_ai_network())
		return TRUE

	var/datum/ai_network/isolated_network = new()
	isolated_network.add_machine(src)
	for(var/mob/living/silicon/ai/ai_mob in contents)
		var/datum/ai_network/previous_ai_network = ai_mob.ai_network
		if(previous_ai_network && !QDELETED(previous_ai_network))
			previous_ai_network.remove_ai(ai_mob)
		ai_mob.ai_network = isolated_network
		isolated_network.ai_list |= ai_mob
		ai_mob.switch_ainet(previous_ai_network, isolated_network)
		ai_mob.claim_default_network_resources()
		ai_mob.dashboard?.rebuild_projects(TRUE)

	if(old_net && !QDELETED(old_net))
		old_net.rebuild_remote()
		old_net.update_resources()
	isolated_network.update_resources()
	return FALSE

/obj/machinery/ai/data_core/primary
	primary = TRUE

/obj/machinery/ai/data_core/JoinPlayerHere(mob/joining_mob, buckle)
	return

/obj/machinery/ai/data_core/RefreshParts()
	. = ..()
	var/new_heat_mod = 1
	var/new_power_mod = 1
	for(var/obj/item/stock_parts/power_store/cell/cell in component_parts)
		integrated_battery = cell
	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		new_power_mod -= (capacitor.tier - 1) / 50
	for(var/datum/stock_part/matter_bin/matter_bin in component_parts)
		new_heat_mod -= (matter_bin.tier - 1) / 15
	heat_modifier = new_heat_mod
	power_modifier = new_power_mod
	active_power_usage = AI_DATA_CORE_POWER_USAGE * power_modifier

/obj/machinery/ai/data_core/process(seconds_per_tick)
	var/tick_scale = max((seconds_per_tick || 2) / 2, 0.1)
	valid_ticks = clamp(valid_ticks, 0, MAX_AI_DATA_CORE_TICKS)
	if(valid_holder())
		valid_ticks++
		if(icon_state == "core-offline")
			update_appearance(UPDATE_ICON)
		if(smoke)
			vis_contents -= smoke
			QDEL_NULL(smoke)
		use_power = ACTIVE_POWER_USE
		if((machine_stat & NOPOWER) && integrated_battery)
			integrated_battery.use(active_power_usage * CELL_POWERUSE_MULTIPLIER * tick_scale)
		warning_sent = FALSE
	else
		valid_ticks--
		use_power = IDLE_POWER_USE
		if(core_temp > get_temp_limit())
			if(!smoke)
				smoke = new()
				vis_contents += smoke
		else if(smoke)
			vis_contents -= smoke
			QDEL_NULL(smoke)
		if(valid_ticks <= 0)
			update_appearance(UPDATE_ICON)
			for(var/mob/living/silicon/ai/ai_mob in contents)
				if(!ai_mob.is_dying)
					ai_mob.relocate(TRUE)
		if(network?.resources && !warning_sent && COOLDOWN_FINISHED(src, warning_cooldown))
			warning_sent = TRUE
			COOLDOWN_START(src, warning_cooldown, 20 SECONDS)
			var/turf/location_turf = get_turf(src)
			for(var/mob/living/silicon/ai/ai_mob in network.resources.get_all_ais())
				if(ai_mob.is_dying)
					continue
				if(!ai_mob.mind && !ai_mob.deployed_shell?.mind)
					continue
				var/message = "Data core in [get_area(src)] is on the verge of failing! Immediate action required to prevent failure."
				if(location_turf)
					message = "[message] ([location_turf.x], [location_turf.y], [location_turf.z])"
				if(!ai_mob.mind && ai_mob.deployed_shell?.mind)
					to_chat(ai_mob.deployed_shell, span_userdanger(message))
				else
					to_chat(ai_mob, span_userdanger(message))
				ai_mob.playsound_local(ai_mob, 'sound/machines/engine_alert/engine_alert2.ogg', 30)

	if(!(machine_stat & (BROKEN | EMPED)) && has_power() && !disableheat)
		// Keep thermal generation aligned with the machine's actual runtime power mode.
		var/base_power_draw = (use_power == ACTIVE_POWER_USE) ? active_power_usage : idle_power_usage
		var/heat_scale = AI_DATA_CORE_IDLE_HEAT_SCALE
		if(use_power == ACTIVE_POWER_USE)
			heat_scale = dead_ai_blackbox ? AI_DATA_CORE_REVIVAL_HEAT_SCALE : AI_DATA_CORE_ACTIVE_HEAT_SCALE
		var/temp_active_usage = (machine_stat & NOPOWER) ? base_power_draw * CELL_POWERUSE_MULTIPLIER : base_power_draw
		var/temperature_increase = (temp_active_usage / AI_HEATSINK_CAPACITY) * heat_modifier
		core_temp += temperature_increase * AI_TEMPERATURE_MULTIPLIER * heat_scale * tick_scale

/obj/machinery/ai/data_core/Destroy()
	network?.reviving_ais -= src
	var/list/mob/living/silicon/ai/connected_ais = network?.resources?.get_all_ais() || list()
	var/list/mob/living/silicon/ai/affected_ais = connected_ais.Copy()
	var/atom/backup_drop_location = drop_location()
	GLOB.data_cores -= src
	if(GLOB.primary_data_core == src)
		GLOB.primary_data_core = null
	for(var/mob/living/silicon/ai/ai_mob in contents)
		affected_ais |= ai_mob

	for(var/mob/living/silicon/ai/ai_mob as anything in affected_ais)
		connected_ais -= ai_mob
		if(ai_mob.stat == DEAD)
			continue
		ai_mob.create_dead_ai_backup(backup_drop_location, FALSE)
	for(var/mob/living/silicon/ai/ai_mob in connected_ais)
		if(ai_mob.is_dying)
			continue
		if(!ai_mob.mind && ai_mob.deployed_shell?.mind)
			to_chat(ai_mob.deployed_shell, span_userdanger("Warning! Data core brought offline in [get_area(src)]! Verify no malicious action was taken."))
		else
			to_chat(ai_mob, span_userdanger("Warning! Data core brought offline in [get_area(src)]! Verify no malicious action was taken."))
	vis_contents -= smoke
	QDEL_NULL(smoke)
	QDEL_NULL(dead_ai_blackbox)
	return ..()

/obj/machinery/ai/data_core/examine(mob/user)
	. = ..()
	if(primary)
		. += span_notice("This is the <b>primary</b> AI data core.")
	var/holder_status = get_holder_status()
	if(holder_status)
		. += span_warning("Machinery non-functional. Reason: [holder_status]")
	if(!isobserver(user))
		return
	var/mob/dead/observer/ghost = user
	var/mob/living/silicon/ai/occupying_ai = locate(/mob/living/silicon/ai) in contents
	if(can_ghost_reenter_ai(ghost, occupying_ai))
		. += span_notice("Click the data core to re-enter your AI shell.")
	. += "Core temperature: <b>[round(core_temp, 0.1)] K</b>"
	. += "<b>Networked AI Laws:</b>"
	if(network && network.resources)
		for(var/mob/living/silicon/ai/ai_mob in network.resources.get_all_ais())
			. += "<b>[ai_mob]</b>"
			for(var/law in ai_mob.laws.get_law_list(include_zeroth = TRUE))
				. += law

/obj/machinery/ai/data_core/proc/can_ghost_reenter_ai(mob/dead/observer/ghost, mob/living/silicon/ai/occupying_ai)
	if(!ghost?.can_reenter_corpse || !ghost.mind || !occupying_ai?.mind)
		return FALSE
	return ghost.mind == occupying_ai.mind

/obj/machinery/ai/data_core/attack_ghost(mob/dead/observer/user)
	var/mob/living/silicon/ai/occupying_ai = locate(/mob/living/silicon/ai) in contents
	if(can_ghost_reenter_ai(user, occupying_ai))
		if(occupying_ai.key && !IS_FAKE_KEY(occupying_ai.key))
			to_chat(user, span_warning("Another consciousness is in your AI shell... It is resisting you."))
			return TRUE
		if(user.mind.current == occupying_ai)
			user.reenter_corpse()
			return TRUE
		user.client?.view_size.resetToDefault()
		SStgui.on_transfer(user, occupying_ai)
		occupying_ai.PossessByPlayer(user.key)
		occupying_ai.client?.init_verbs()
		occupying_ai.view_core()
		return TRUE
	if(can_ghost_reenter_ai(user, dead_ai_blackbox?.stored_ai))
		var/reconstruction_progress = round(dead_ai_blackbox.processing_progress, 0.1)
		to_chat(user, span_notice("Your volatile neural core is loaded in [src], but reconstruction is not complete yet. Use a connected AI server overview console or AI network interface console to prioritize revival compute."))
		to_chat(user, span_notice("Reconstruction progress: <b>[reconstruction_progress]</b> / <b>[AI_BLACKBOX_PROCESSING_REQUIREMENT]</b>."))
		return TRUE
	return ..()

/obj/machinery/ai/data_core/has_power()
	if(!(machine_stat & NOPOWER))
		return TRUE
	if(integrated_battery?.charge > (active_power_usage * CELL_POWERUSE_MULTIPLIER))
		return TRUE
	return FALSE

/obj/machinery/ai/data_core/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = TRUE, attack_dir, armour_penetration = 0)
	. = ..()
	for(var/mob/living/silicon/ai/ai_mob in contents)
		ai_mob.disconnect_shell()

/obj/machinery/ai/data_core/on_deconstruction(disassembled)
	var/list/mob/living/silicon/ai/affected_ais = network?.resources?.get_all_ais() || list()
	for(var/mob/living/silicon/ai/ai_mob in contents)
		affected_ais |= ai_mob

	for(var/mob/living/silicon/ai/ai_mob as anything in affected_ais)
		if(ai_mob.stat == DEAD || ai_mob.dead_ai_backup_created)
			continue
		ai_mob.create_dead_ai_backup(drop_location(), FALSE)

/obj/machinery/ai/data_core/attackby(obj/item/item, mob/living/user, params)
	if(istype(item, /obj/item/dead_ai))
		if(dead_ai_blackbox)
			to_chat(user, span_warning("There is already a volatile neural core inserted."))
			return TRUE
		if(!can_transfer_ai())
			to_chat(user, span_warning("[src] is currently unable to host an AI backup."))
			return TRUE
		var/obj/item/dead_ai/blackbox = item
		dead_ai_blackbox = blackbox
		blackbox.forceMove(src)
		network?.reviving_ais |= src
		network?.rebuild_remote()
		network?.update_resources()
		to_chat(user, span_notice("You slot [blackbox] into [src]."))
		return TRUE

	return ..()

/obj/machinery/ai/data_core/proc/valid_data_core()
	if(valid_ticks > 0 && network && network.total_cpu() >= AI_CORE_CPU_REQUIREMENT && network.total_ram() >= AI_CORE_RAM_REQUIREMENT)
		return TRUE
	return FALSE

/obj/machinery/ai/data_core/proc/can_transfer_ai()
	if(machine_stat & (BROKEN | EMPED) || !has_power())
		return FALSE
	if(!valid_data_core())
		return FALSE
	return TRUE

/obj/machinery/ai/data_core/proc/transfer_ai_mob(mob/living/silicon/ai/ai_mob)
	ai_mob.forceMove(src)
	GLOB.ai_list |= ai_mob
	GLOB.shuttle_caller_list |= ai_mob
	if(ai_mob.eyeobj)
		ai_mob.eyeobj.forceMove(get_turf(src))

	var/datum/ai_network/old_net = ai_mob.ai_network
	if(network != ai_mob.ai_network)
		old_net?.remove_ai(ai_mob)
		ai_mob.ai_network = network
		if(network && !(ai_mob in network.ai_list))
			network.ai_list += ai_mob
		ai_mob.switch_ainet(old_net, network)
	else if(network && !(ai_mob in network.ai_list))
		network.ai_list += ai_mob

	network?.rebuild_remote()
	network?.update_resources()
	ai_mob.claim_default_network_resources()
	ai_mob.dashboard?.rebuild_projects(TRUE)
	ai_mob.view_core()
	ai_mob.register_station_ai_activation()
	ai_mob.sync_goon_core_customization()

/obj/machinery/ai/data_core/update_overlays(updates)
	. = ..()
	if(!goon_core_enabled)
		return

	var/background_state = is_ai_goon_background_state(goon_background_state) ? goon_background_state : "ai_blue"
	var/face_state = is_ai_goon_face_state(goon_face_state) ? goon_face_state : "ai_happy-dol"
	var/mutable_appearance/background_overlay = mutable_appearance('icons/psychonaut/ai_screens/goon_core.dmi', background_state)
	background_overlay.layer = FLOAT_LAYER + 0.05
	background_overlay.appearance_flags = RESET_COLOR | RESET_ALPHA | KEEP_APART
	. += background_overlay
	. += emissive_appearance('icons/psychonaut/ai_screens/goon_core.dmi', background_state, src)

	var/mutable_appearance/face_overlay = mutable_appearance('icons/psychonaut/ai_screens/goon_core.dmi', face_state)
	face_overlay.layer = FLOAT_LAYER + 0.1
	face_overlay.appearance_flags = RESET_COLOR | RESET_ALPHA | KEEP_APART
	. += face_overlay
	. += emissive_appearance('icons/psychonaut/ai_screens/goon_core.dmi', face_state, src)

	var/forced_light_mode = is_ai_goon_light_mode(goon_light_mode) ? goon_light_mode : "auto"
	if(forced_light_mode != "auto" || has_power())
		var/light_state = get_ai_goon_light_state(goon_core_skin, forced_light_mode, machine_stat & NOPOWER)
		if(light_state)
			var/mutable_appearance/light_overlay = mutable_appearance('icons/psychonaut/ai_screens/goon_core.dmi', light_state)
			light_overlay.layer = FLOAT_LAYER + 0.2
			light_overlay.appearance_flags = RESET_COLOR | RESET_ALPHA | KEEP_APART
			. += light_overlay
			. += emissive_appearance('icons/psychonaut/ai_screens/goon_core.dmi', light_state, src)

/obj/machinery/ai/data_core/update_icon_state()
	. = ..()
	if(goon_core_enabled)
		icon = 'icons/psychonaut/ai_screens/goon_core.dmi'
		icon_state = is_ai_goon_core_skin_state(goon_core_skin) ? goon_core_skin : "default"
		return

	icon = initial(icon)
	if(!(machine_stat & (BROKEN | EMPED)) && has_power() && (valid_data_core() || locate(/mob/living/silicon/ai) in contents))
		icon_state = "core"
	else
		icon_state = "core-offline"

/obj/machinery/ai/data_core/connect_to_ai_network()
	. = ..()
	if(network && dead_ai_blackbox)
		network.reviving_ais |= src
	for(var/mob/living/silicon/ai/ai_mob in contents)
		if(ai_mob.ai_network == network)
			network?.ai_list |= ai_mob
			continue
		var/datum/ai_network/old_net = ai_mob.ai_network
		old_net?.remove_ai(ai_mob)
		ai_mob.ai_network = network
		network.ai_list += ai_mob
		ai_mob.switch_ainet(old_net, network)
		ai_mob.claim_default_network_resources()
	network?.rebuild_remote()
	network?.update_resources()

/obj/machinery/ai/data_core/disconnect_from_ai_network()
	network?.reviving_ais -= src
	return ..()

/obj/machinery/ai/data_core/transfer_ai(interaction, mob/user, mob/living/silicon/ai/AI, obj/item/aicard/card)
	if(!..())
		return

	if(interaction == AI_TRANS_TO_CARD)
		var/mob/living/silicon/ai/occupying_ai = locate(/mob/living/silicon/ai) in contents
		if(!occupying_ai)
			to_chat(user, span_alert("There is no AI loaded in [src]."))
			return
		occupying_ai.transfer_ai(interaction, user, occupying_ai, card)
		return

	if(interaction != AI_TRANS_FROM_CARD)
		return
	if(!AI)
		to_chat(user, span_alert("No AI image found on [card]."))
		return
	if(locate(/mob/living/silicon/ai) in contents)
		to_chat(user, span_warning("[src] is already hosting an AI."))
		return
	if(!can_transfer_ai())
		to_chat(user, span_warning("[src] is not ready to host an AI."))
		return

	AI.set_control_disabled(FALSE)
	AI.radio_enabled = TRUE
	transfer_ai_mob(AI)
	to_chat(AI, span_notice("You have been uploaded to a decentralized data core. Remote device connection restored."))
	to_chat(user, "[span_boldnotice("Transfer successful")]: [AI.name] ([rand(1000,9999)].exe) installed into the decentralized network.")
	card.AI = null
	card.update_appearance()

/obj/machinery/ai/data_core/proc/partytime()
	if(party_active)
		return
	party_active = TRUE
	party_generation++
	continue_party(party_generation)

/obj/machinery/ai/data_core/proc/continue_party(generation)
	if(!party_active || generation != party_generation)
		return
	var/static/list/party_colors = list(
		"#ff4d4d",
		"#66ff66",
		"#4d7dff",
		"#ff9c33",
		"#ff66c4",
		"#b266ff",
	)
	animate(src, color = pick(party_colors), time = 5, easing = SINE_EASING)
	addtimer(CALLBACK(src, PROC_REF(continue_party), generation), 0.5 SECONDS)

/obj/machinery/ai/data_core/proc/stoptheparty()
	if(!party_active)
		return
	party_active = FALSE
	party_generation++
	animate(src, color = null, time = 5)

/obj/machinery/ai/data_core/proc/DabAnimation(angle = 45, speed = 5)
	var/matrix/start_transform = matrix(transform)
	var/start_pixel_x = pixel_x
	var/start_pixel_y = pixel_y
	var/matrix/dabbed = matrix(transform)
	dabbed.Turn(angle)
	animate(src, transform = dabbed, pixel_x = start_pixel_x + 2, pixel_y = start_pixel_y + 2, time = speed)
	animate(transform = start_transform, pixel_x = start_pixel_x, pixel_y = start_pixel_y, time = round(speed * 1.5))

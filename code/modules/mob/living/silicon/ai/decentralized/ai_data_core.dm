/obj/machinery/ai/data_core
	name = "AI data core"
	desc = "A computer system capable of hosting a decentralized artificial intelligence."
	icon = 'icons/obj/machines/ai_core.dmi'
	icon_state = "core-offline"
	circuit = /obj/item/circuitboard/machine/ai_data_core
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

/obj/machinery/ai/data_core/Initialize(mapload)
	. = ..()
	valid_ticks = MAX_AI_DATA_CORE_TICKS
	GLOB.data_cores += src
	if(primary && !GLOB.primary_data_core)
		GLOB.primary_data_core = src
	update_appearance()
	RefreshParts()

/obj/machinery/ai/data_core/primary
	primary = TRUE

/obj/machinery/ai/data_core/JoinPlayerHere(mob/joining_mob, buckle)
	return

/obj/machinery/ai/data_core/RefreshParts()
	var/new_heat_mod = 1
	var/new_power_mod = 1
	for(var/obj/item/stock_parts/power_store/cell/cell in component_parts)
		integrated_battery = cell
	for(var/obj/item/stock_parts/capacitor/capacitor in component_parts)
		new_power_mod -= (capacitor.rating - 1) / 50
	for(var/obj/item/stock_parts/matter_bin/matter_bin in component_parts)
		new_heat_mod -= (matter_bin.rating - 1) / 15
	heat_modifier = new_heat_mod
	power_modifier = new_power_mod
	active_power_usage = AI_DATA_CORE_POWER_USAGE * power_modifier

/obj/machinery/ai/data_core/process()
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
			integrated_battery.use(active_power_usage * CELL_POWERUSE_MULTIPLIER)
		warning_sent = FALSE
	else
		valid_ticks--
		if(!smoke && get_holder_status() == AI_MACHINE_TOO_HOT)
			smoke = new()
			vis_contents += smoke
		if(valid_ticks <= 0)
			use_power = IDLE_POWER_USE
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
		var/temp_active_usage = (machine_stat & NOPOWER) ? active_power_usage * CELL_POWERUSE_MULTIPLIER : active_power_usage
		var/temperature_increase = (temp_active_usage / AI_HEATSINK_CAPACITY) * heat_modifier
		core_temp += temperature_increase * AI_TEMPERATURE_MULTIPLIER

/obj/machinery/ai/data_core/Destroy()
	network?.reviving_ais -= src
	var/list/mob/living/silicon/ai/connected_ais = network?.resources?.get_all_ais() || list()
	GLOB.data_cores -= src
	if(GLOB.primary_data_core == src)
		GLOB.primary_data_core = null
	for(var/mob/living/silicon/ai/ai_mob in contents)
		connected_ais -= ai_mob
		if(!ai_mob.is_dying)
			ai_mob.relocate(TRUE)
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
	return ..()

/obj/machinery/ai/data_core/has_power()
	if((machine_stat & NOPOWER) && integrated_battery)
		if(integrated_battery.charge > (active_power_usage * CELL_POWERUSE_MULTIPLIER))
			return TRUE
	else
		return TRUE
	return FALSE

/obj/machinery/ai/data_core/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = TRUE, attack_dir, armour_penetration = 0)
	. = ..()
	for(var/mob/living/silicon/ai/ai_mob in contents)
		ai_mob.disconnect_shell()

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

	ai_mob.claim_default_network_resources()
	ai_mob.view_core()

/obj/machinery/ai/data_core/update_icon_state()
	. = ..()
	if(!(machine_stat & (BROKEN | EMPED)) && has_power() && valid_data_core())
		icon_state = "core"
	else
		icon_state = "core-offline"

/obj/machinery/ai/data_core/connect_to_ai_network()
	. = ..()
	if(network && dead_ai_blackbox)
		network.reviving_ais |= src
	for(var/mob/living/silicon/ai/ai_mob in contents)
		if(ai_mob.ai_network == network)
			continue
		var/datum/ai_network/old_net = ai_mob.ai_network
		old_net?.remove_ai(ai_mob)
		ai_mob.ai_network = network
		network.ai_list += ai_mob
		ai_mob.switch_ainet(old_net, network)
		ai_mob.claim_default_network_resources()

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
	var/matrix/dabbed = turn(matrix(), angle)
	animate(src, transform = dabbed, time = speed)
	animate(src, transform = matrix(), time = speed)

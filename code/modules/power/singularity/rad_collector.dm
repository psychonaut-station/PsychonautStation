#define RAD_COLLECTOR_EFFICIENCY 80
#define RAD_COLLECTOR_COEFFICIENT 1000
#define RAD_COLLECTOR_STORED_OUT 0.04
#define RAD_COLLECTOR_MINING_CONVERSION_RATE 0.0001

/obj/machinery/power/energy_accumulator/rad_collector
	name = "particle capture array"
	desc = "A device which uses a large plasma-glass sheet to 'catch' particles, harvesting their stored energy. Do not taunt. Can be loaded with a variety of gases to produce additional power."
	icon = 'icons/obj/machines/engine/singularity.dmi'
	icon_state = "ca"
	anchored = FALSE
	density = TRUE
	req_access = list(ACCESS_ENGINE_EQUIP, ACCESS_ATMOSPHERICS)
	max_integrity = 350
	integrity_failure = 0.2
	circuit = /obj/item/circuitboard/machine/rad_collector
	rad_insulation = RAD_EXTREME_INSULATION
	///Stores the loaded tank instance
	var/obj/item/tank/internals/plasma/loaded_tank = null
	///Is the collector working?
	var/active = FALSE
	///Is the collector locked with an id?
	var/locked = FALSE
	///Amount of gas removed per tick
	var/drain_ratio = 0.5
	///Multiplier for the amount of gas removed per tick
	var/power_production_drain = 0.001
	var/bitcoinproduction_drain = 0.015

	var/bitcoin_produced = 0
	//Multiplier for tanks and gases insidee
	var/power_coeff = 1
	var/bitcoinmining = FALSE
	var/obj/item/radio/radio
	var/datum/techweb/sciweb

/obj/machinery/power/energy_accumulator/rad_collector/Initialize(mapload)
	. = ..()
	sciweb = locate(/datum/techweb/science) in SSresearch.techwebs
	register_context()

/obj/machinery/power/energy_accumulator/rad_collector/anchored/Initialize(mapload)
	. = ..()
	set_anchored(TRUE)

/obj/machinery/power/energy_accumulator/rad_collector/process(seconds_per_tick)
	if(isnull(loaded_tank))
		return
	loaded_tank.air_contents.assert_gases(/datum/gas/plasma, /datum/gas/tritium, /datum/gas/oxygen)
	var/totalplasma = loaded_tank.air_contents.gases[/datum/gas/plasma][MOLES]
	var/totaltrit = loaded_tank.air_contents.gases[/datum/gas/tritium][MOLES]
	var/totalo2 = loaded_tank.air_contents.gases[/datum/gas/oxygen][MOLES]
	if(!bitcoinmining)
		if(totalplasma < 0.0001)
			investigate_log("<font color='red'>out of fuel</font>.", INVESTIGATE_ENGINE)
			playsound(src, 'sound/machines/ding.ogg', 50, 1)
			var/msg = "Plasma depleted, recommend replacing tank."
			radio.talk_into(src, msg, RADIO_CHANNEL_ENGINEERING)
			eject()
		else
			var/gasdrained = min(power_production_drain * drain_ratio * seconds_per_tick , totalplasma)
			loaded_tank.air_contents.remove_specific(/datum/gas/plasma, gasdrained)
			loaded_tank.air_contents.assert_gases(/datum/gas/tritium)
			loaded_tank.air_contents.gases[/datum/gas/tritium][MOLES] += gasdrained
			return ..(seconds_per_tick)
	else if(is_station_level(z) && sciweb)
		if(!totaltrit || !totalo2)
			playsound(src, 'sound/machines/ding.ogg', 50, 1)
			eject()
		else
			var/gasdrained = bitcoinproduction_drain * drain_ratio * seconds_per_tick
			loaded_tank.air_contents.remove_specific(/datum/gas/tritium, gasdrained)
			loaded_tank.air_contents.remove_specific(/datum/gas/oxygen, gasdrained)
			loaded_tank.air_contents.assert_gases(/datum/gas/carbon_dioxide)
			loaded_tank.air_contents.gases[/datum/gas/carbon_dioxide][MOLES] += gasdrained * 2

			var/bitcoins_mined = min(stored_energy, (stored_energy*0.04)+1000)
			var/datum/bank_account/department/D = SSeconomy.get_dep_account(ACCOUNT_CAR)
			if(D)
				D.adjust_money(1)
			sciweb.add_point_type(TECHWEB_POINT_TYPE_GENERIC, 0.8 * power_coeff)
			bitcoin_produced = bitcoins_mined * RAD_COLLECTOR_MINING_CONVERSION_RATE
			stored_energy -= bitcoins_mined

/obj/machinery/power/energy_accumulator/rad_collector/interact(mob/user)
	if(!anchored)
		return
	if(locked)
		to_chat(user, span_warning("The controls are locked!"))
		return
	toggle_power()
	user.visible_message(span_notice("[user.name] turns the [src.name] [active? "on":"off"]."), \
	span_notice("You turn the [src.name] [active? "on":"off"]."))
	var/datum/gas_mixture/tank_mix = loaded_tank?.return_air()
	var/fuel
	if(bitcoinmining)
		if(loaded_tank)
			fuel = tank_mix.gases[/datum/gas/plasma][MOLES]
	else
		if(loaded_tank)
			fuel = tank_mix.gases[/datum/gas/tritium][MOLES] + tank_mix.gases[/datum/gas/oxygen][MOLES]
	investigate_log("turned [active?"<font color='green'>on</font>":"<font color='red'>off</font>"] by [key_name(user)]. [loaded_tank?"Fuel: [round(fuel/0.29)]%":"<font color='red'>It is empty</font>"].", INVESTIGATE_ENGINE)

/obj/machinery/power/energy_accumulator/rad_collector/can_be_unfasten_wrench(mob/user, silent)
	if(loaded_tank)
		if(!silent)
			to_chat(user, span_warning("Remove the plasma tank first!"))
		return FAILED_UNFASTEN
	return ..()

/obj/machinery/power/energy_accumulator/rad_collector/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/tank/internals/plasma))
		if(!anchored)
			to_chat(user, span_warning("[src] needs to be secured to the floor first!"))
			return TRUE
		if(loaded_tank)
			to_chat(user, span_warning("There's already a plasma tank loaded!"))
			return TRUE
		if(panel_open)
			to_chat(user, span_warning("Close the maintenance panel first!"))
			return TRUE
		if(!user.transferItemToLoc(W, src))
			return
		loaded_tank = W
		loaded_tank.air_contents.assert_gases(/datum/gas/plasma, /datum/gas/tritium, /datum/gas/oxygen, /datum/gas/carbon_dioxide)
		update_icon()
	else if(W.GetID())
		if(!allowed(user))
			to_chat(user, span_danger("Access denied."))
			return TRUE
		if(!active)
			to_chat(user, span_warning("The controls can only be locked when \the [src] is active!"))
			return TRUE
		locked = !locked
		to_chat(user, span_notice("You [locked ? "lock" : "unlock"] the controls."))
		return TRUE
	else
		return ..()

/obj/machinery/power/energy_accumulator/rad_collector/wrench_act(mob/living/user, obj/item/item)
	. = ..()
	default_unfasten_wrench(user, item, 10)
	return TRUE

/obj/machinery/power/energy_accumulator/rad_collector/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	if(loaded_tank)
		to_chat(user, span_warning("Remove the plasma tank first!"))
	else
		default_deconstruction_screwdriver(user, icon_state, icon_state, I)
	return TRUE

/obj/machinery/power/energy_accumulator/rad_collector/crowbar_act(mob/living/user, obj/item/I)
	if(loaded_tank)
		eject()
		return TRUE
	if(default_deconstruction_crowbar(I))
		return TRUE
	to_chat(user, span_warning("There is no tank loaded!"))
	return TRUE

/obj/machinery/power/energy_accumulator/rad_collector/multitool_act(mob/living/user, obj/item/I)
	if(!is_station_level(z) && !sciweb)
		to_chat(user, span_warning("[src] isn't linked to a research system!"))
		return TRUE
	if(active)
		to_chat(user, span_warning("[src] is currently active, producing [bitcoinmining ? "research points":"power"]."))
		return TRUE
	bitcoinmining = !bitcoinmining
	to_chat(user, span_warning("You [bitcoinmining ? "enable":"disable"] the research point production feature of [src]."))
	return TRUE

/obj/machinery/power/energy_accumulator/rad_collector/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice("The status display reads:")
		. += span_notice("[bitcoinmining ? "Research point production mode" : "Power production mode"]")
		. += span_notice("Radiation collection at <b>[power_coeff*100]%</b>.")
		. += span_notice("Stored <b>[bitcoinmining ? (stored_energy*RAD_COLLECTOR_MINING_CONVERSION_RATE) : display_energy(get_stored_joules())]</b>.")
		. += span_notice("[bitcoinmining ? "Producing <b>[bitcoin_produced*RAD_COLLECTOR_MINING_CONVERSION_RATE]</b>" : "Processing <b>[display_power(processed_energy)]</b>"].")

/obj/machinery/power/energy_accumulator/rad_collector/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = NONE
	if(isnull(held_item))
		return

	if(held_item.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_LMB] = "[anchored ? "Una" : "A"]nchor"
		return CONTEXTUAL_SCREENTIP_SET
	else if(held_item.tool_behaviour == TOOL_CROWBAR && loaded_tank)
		context[SCREENTIP_CONTEXT_LMB] = "Eject tank"
		return CONTEXTUAL_SCREENTIP_SET
	else if(held_item.tool_behaviour == TOOL_MULTITOOL && !active && is_station_level(z) && sciweb)
		context[SCREENTIP_CONTEXT_LMB] = "Change production mode"
		return CONTEXTUAL_SCREENTIP_SET
	else if(istype(held_item, /obj/item/tank/internals/plasma) && !loaded_tank)
		context[SCREENTIP_CONTEXT_LMB] = "Load tank"
		return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/power/energy_accumulator/rad_collector/return_analyzable_air()
	if(loaded_tank)
		return loaded_tank.return_analyzable_air()
	else
		return null

/obj/machinery/power/energy_accumulator/rad_collector/atom_break(damage_flag)
	. = ..()
	if(.)
		eject()

/obj/machinery/power/energy_accumulator/rad_collector/update_icon()
	. = ..()
	cut_overlays()
	if(loaded_tank)
		add_overlay("ptank")
	if(machine_stat & (NOPOWER|BROKEN))
		return
	if(active)
		add_overlay("on")

/obj/machinery/power/energy_accumulator/rad_collector/proc/eject()
	if (!loaded_tank)
		return
	loaded_tank.forceMove(drop_location())
	loaded_tank = null
	if(active)
		toggle_power()
	else
		update_icon()

/obj/machinery/power/energy_accumulator/rad_collector/proc/toggle_power()
	active = !active
	if(active)
		icon_state = "ca_on"
		flick("ca_active", src)
	else
		icon_state = "ca"
		flick("ca_deactive", src)
	update_icon()
	return

/obj/machinery/power/energy_accumulator/rad_collector/should_have_node()
	return anchored

/obj/machinery/power/energy_accumulator/rad_collector/RefreshParts()
	. = ..()
	var/power_multiplier = 0
	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		power_multiplier += capacitor.tier
	power_coeff = max(1 * (power_multiplier / 8), 0.25)

/obj/machinery/power/energy_accumulator/rad_collector/rad_act(intensity)
	if(loaded_tank && active && intensity > RAD_COLLECTOR_EFFICIENCY)
		stored_energy += ((intensity*power_coeff)-RAD_COLLECTOR_EFFICIENCY)*RAD_COLLECTOR_COEFFICIENT

#undef RAD_COLLECTOR_EFFICIENCY
#undef RAD_COLLECTOR_COEFFICIENT
#undef RAD_COLLECTOR_STORED_OUT
#undef RAD_COLLECTOR_MINING_CONVERSION_RATE

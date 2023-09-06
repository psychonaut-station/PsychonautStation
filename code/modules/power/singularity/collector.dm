// stored_energy += (pulse_strength-RAD_COLLECTOR_EFFICIENCY)*RAD_COLLECTOR_COEFFICIENT
#define RAD_COLLECTOR_EFFICIENCY 80 	// radiation needs to be over this amount to get power
#define RAD_COLLECTOR_COEFFICIENT 100
#define RAD_COLLECTOR_STORED_OUT 0.04	// (this*100)% of stored power outputted per tick. Doesn't actualy change output total, lower numbers just means collectors output for longer in absence of a source
#define RAD_COLLECTOR_MINING_CONVERSION_RATE 0.0001 //This is gonna need a lot of tweaking to get right. This is the number used to calculate the conversion of watts to research points per process()
#define RAD_COLLECTOR_OUTPUT min(stored_energy, (stored_energy*RAD_COLLECTOR_STORED_OUT)+3000) //Produces at least 1000 watts if it has more than that stored

/obj/machinery/power/energy_accumulator/rad_collector
	name = "Radiation Collector Array"
	desc = "A device which uses Hawking Radiation and plasma to produce power."
	icon = 'icons/obj/machines/engine/singularity.dmi'
	icon_state = "ca"
	rad_insulation = RAD_EXTREME_INSULATION
	circuit = /obj/item/circuitboard/machine/rad_collector
	var/obj/item/tank/internals/plasma/loaded_tank = null
	var/drainratio = 0.5
	var/powerproduction_drain = 0.01
	var/bitcoinproduction_drain = 0.15
	var/bitcoinmining = FALSE
	var/input_power_multiplier = 1
	var/active = 0
	var/obj/item/radio/radio

/obj/machinery/power/energy_accumulator/rad_collector/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_IN_RANGE_OF_IRRADIATION, PROC_REF(on_pre_potential_irradiation))
	radio = new(src)
	radio.keyslot = new /obj/item/encryptionkey/headset_eng
	radio.subspace_transmission = TRUE
	radio.canhear_range = 0
	radio.recalculateChannels()

/obj/machinery/power/energy_accumulator/rad_collector/Destroy()
	UnregisterSignal(src, COMSIG_IN_RANGE_OF_IRRADIATION)
	QDEL_NULL(radio)
	return ..()

/obj/machinery/power/energy_accumulator/rad_collector/anchored/Initialize(mapload)
	. = ..()
	set_anchored(TRUE)

/obj/machinery/power/energy_accumulator/rad_collector/cable_layer_change_checks(mob/living/user, obj/item/tool)
	if(anchored)
		balloon_alert(user, "unanchor first!")
		return FALSE
	return TRUE

/obj/machinery/power/energy_accumulator/rad_collector/RefreshParts()
	. = ..()
	var/power_multiplier = 0
	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		power_multiplier += capacitor.tier
	input_power_multiplier = max(1 * (power_multiplier / 8), 0.25)

/obj/machinery/power/energy_accumulator/rad_collector/process(delta_time)
	if(isnull(loaded_tank))
		return
	var/totalplasma = loaded_tank.air_contents.get_moles(/datum/gas/plasma)
	var/totaltrit = loaded_tank.air_contents.get_moles(/datum/gas/tritium)
	var/totalo2 = loaded_tank.air_contents.get_moles(/datum/gas/oxygen)
	if(!bitcoinmining)
		if(totalplasma < 0.0001)
			investigate_log("<font color='red'>out of fuel</font>.", INVESTIGATE_ENGINE)
			playsound(src, 'sound/machines/ding.ogg', 50, 1)
			var/msg = "Plasma depleted, recommend replacing tank."
			radio.talk_into(src, msg, RADIO_CHANNEL_ENGINEERING)
			eject()
		else
			var/gasdrained = min(powerproduction_drain*drainratio*delta_time,totalplasma)
			loaded_tank.air_contents.remove_specific(/datum/gas/plasma, gasdrained)
			loaded_tank.air_contents.add_moles(/datum/gas/tritium, gasdrained)
			var/power_produced = RAD_COLLECTOR_OUTPUT
			release_energy(power_produced)
			stored_energy-=power_produced
	else if(is_station_level(z) && SSresearch.science_tech)
		if(!totaltrit || !totalo2)
			playsound(src, 'sound/machines/ding.ogg', 50, 1)
			eject()
		else
			var/gasdrained = bitcoinproduction_drain*drainratio*delta_time
			loaded_tank.air_contents.remove_specific(/datum/gas/tritium, gasdrained)
			loaded_tank.air_contents.remove_specific(/datum/gas/oxygen, gasdrained)
			loaded_tank.air_contents.add_moles(/datum/gas/carbon_dioxide, gasdrained*2)
			var/bitcoins_mined = RAD_COLLECTOR_OUTPUT
			var/datum/bank_account/department/D = SSeconomy.get_dep_account(ACCOUNT_CAR)
			if(D)
				D.adjust_money((bitcoins_mined*RAD_COLLECTOR_MINING_CONVERSION_RATE) / 2)//about 750 credits per minute with 2 emitters and 6 collectors with stock parts
			SSresearch.science_tech.add_point_type(TECHWEB_POINT_TYPE_DEFAULT, bitcoins_mined*RAD_COLLECTOR_MINING_CONVERSION_RATE)//about 1300 points per minute with the above set up
			stored_energy-=bitcoins_mined

/obj/machinery/power/energy_accumulator/rad_collector/interact(mob/user)
	if(anchored)
		toggle_power()
		user.visible_message("[user.name] turns the [src.name] [active? "on":"off"].", \
		"<span class='notice'>You turn the [src.name] [active? "on":"off"].</span>")
		var/fuel = loaded_tank?.air_contents.get_moles(/datum/gas/plasma)
		investigate_log("turned [active?"<font color='green'>on</font>":"<font color='red'>off</font>"] by [key_name(user)]. [loaded_tank?"Fuel: [round(fuel/0.29)]%":"<font color='red'>It is empty</font>"].", INVESTIGATE_ENGINE)
		return

/obj/machinery/power/energy_accumulator/rad_collector/can_be_unfasten_wrench(mob/user, silent)
	if(loaded_tank)
		if(!silent)
			to_chat(user, "<span class='warning'>Remove the plasma tank first!</span>")
		return FAILED_UNFASTEN
	return ..()

/obj/machinery/power/energy_accumulator/rad_collector/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/tank/internals/plasma))
		if(!anchored)
			to_chat(user, "<span class='warning'>[src] needs to be secured to the floor first!</span>")
			return TRUE
		if(loaded_tank)
			to_chat(user, "<span class='warning'>There's already a plasma tank loaded!</span>")
			return TRUE
		if(panel_open)
			to_chat(user, "<span class='warning'>Close the maintenance panel first!</span>")
			return TRUE
		if(!user.transferItemToLoc(W, src))
			return
		loaded_tank = W
		loaded_tank.air_contents.assert_gases(/datum/gas/plasma, /datum/gas/tritium, /datum/gas/oxygen, /datum/gas/carbon_dioxide)
		update_icon()
	else
		return ..()

/obj/machinery/power/energy_accumulator/rad_collector/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	if(loaded_tank)
		to_chat(user, "<span class='warning'>Remove the plasma tank first!</span>")
	else
		default_deconstruction_screwdriver(user, icon_state, icon_state, I)
	return TRUE

/obj/machinery/power/energy_accumulator/rad_collector/crowbar_act(mob/living/user, obj/item/I)
	if(loaded_tank)
		eject()
		return TRUE
	if(default_deconstruction_crowbar(I))
		return TRUE
	to_chat(user, "<span class='warning'>There isn't a tank loaded!</span>")
	return TRUE

/obj/machinery/power/energy_accumulator/rad_collector/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_WRENCH)
		default_unfasten_wrench(user, W, 0)
	else
		return ..()

/obj/machinery/power/energy_accumulator/rad_collector/multitool_act(mob/living/user, obj/item/I)
	if(!is_station_level(z) && !SSresearch.science_tech)
		to_chat(user, "<span class='warning'>[src] isn't linked to a research system!</span>")
		return TRUE
	if(active)
		to_chat(user, "<span class='warning'>[src] is currently active, producing [bitcoinmining ? "research points":"power"].</span>")
		return TRUE
	bitcoinmining = !bitcoinmining
	to_chat(user, "<span class='warning'>You [bitcoinmining ? "enable":"disable"] the research point production feature of [src].</span>")
	return TRUE

/obj/machinery/power/energy_accumulator/rad_collector/return_analyzable_air()
	if(loaded_tank)
		return loaded_tank.return_analyzable_air()
	else
		return null

/obj/machinery/power/energy_accumulator/rad_collector/examine(mob/user)
	. = ..()
	if(active)
		if(!bitcoinmining)
			var/joules = stored_energy * SSmachines.wait * 0.1
			. += "<span class='notice'>[src]'s display states that it has stored <b>[display_joules(joules)]</b>, and is processing <b>[display_power(RAD_COLLECTOR_OUTPUT)]</b>.</span>"
		else
			. += "<span class='notice'>[src]'s display states that it has stored a total of <b>[stored_energy*RAD_COLLECTOR_MINING_CONVERSION_RATE]</b>, and is producing [RAD_COLLECTOR_OUTPUT*RAD_COLLECTOR_MINING_CONVERSION_RATE] research points per minute.</span>"
	else
		if(!bitcoinmining)
			. += "<span class='notice'><b>[src]'s display displays the words:</b> \"Power production mode. Please insert <b>Plasma</b>. Use a multitool to change production modes.\"</span>"
		else
			. += "<span class='notice'><b>[src]'s display displays the words:</b> \"Research point production mode. Please insert <b>Tritium</b> and <b>Oxygen</b>. Use a multitool to change production modes.\"</span>"

/obj/machinery/power/energy_accumulator/rad_collector/atom_break(damage_flag)
	. = ..()
	if(.)
		eject()

/obj/machinery/power/energy_accumulator/rad_collector/proc/eject()
	var/obj/item/tank/internals/plasma/Z = loaded_tank
	if (!Z)
		return
	Z.forceMove(drop_location())
	Z.layer = initial(Z.layer)
	Z.plane = initial(Z.plane)
	loaded_tank = null
	if(active)
		toggle_power()
	else
		update_icon()

/obj/machinery/power/energy_accumulator/rad_collector/update_icon()
	cut_overlays()
	if(loaded_tank)
		add_overlay("ptank")
	if(machine_stat & (NOPOWER|BROKEN))
		return
	if(active)
		add_overlay("on")


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

/obj/machinery/power/energy_accumulator/rad_collector/proc/on_pre_potential_irradiation(datum/source, datum/radiation_pulse_information/pulse_information, insulation_to_target)
	if(loaded_tank && active && pulse_information.max_range > 1)
		stored_energy += pulse_information.max_range * 1000

#undef RAD_COLLECTOR_EFFICIENCY
#undef RAD_COLLECTOR_COEFFICIENT
#undef RAD_COLLECTOR_STORED_OUT
#undef RAD_COLLECTOR_MINING_CONVERSION_RATE
#undef RAD_COLLECTOR_OUTPUT

#define TESLA_DEFAULT_ENERGY (695.304 MEGA JOULES)
#define EBALL_NORMAL 0
#define EBALL_DANGER 1

GLOBAL_LIST_EMPTY(all_energy_balls)

/obj/energy_ball
	var/uid = 0
	var/status = EBALL_NORMAL
	var/zap_icon_state = NONE
	var/zap_energy = TESLA_DEFAULT_ENERGY
	var/zap_flags = ZAP_DEFAULT_FLAGS
	var/absorption_ratio = 0.15
	var/list/gas_percentage = list()
	var/datum/gas_mixture/absorbed_gasmix

	var/particle_energy = SUPERMATTER_DEFAULT_BULLET_ENERGY

	var/external_power_immediate = 0

	var/list/current_gas_behavior

	var/gas_heat_modifier = 0
	var/gas_heat_resistance = 0
	var/gas_power_transmission_rate = 0
	var/gas_powerloss_inhibition = 0
	var/gas_heat_power_generation = 0

	var/temp_limit = T0C + HEAT_PENALTY_THRESHOLD
	var/list/temp_limit_factors

	var/waste_multiplier = 0
	var/list/waste_multiplier_factors

	var/zap_transmission_rate = 1.25
	var/list/zap_factors

	var/powerloss_linear_threshold = 0
	var/powerloss_linear_offset = 0

	var/internal_energy = 0

	var/powerloss_inhibition = 0
	var/heat_power_generation = 0

	SET_BASE_PIXEL(-ICON_SIZE_X, -ICON_SIZE_Y)

/obj/energy_ball/Initialize(mapload, starting_energy = 50, is_miniball = FALSE)
	. = ..()
	current_gas_behavior = init_eball_gas()
	absorbed_gasmix = new()
	powerloss_linear_threshold = sqrt(POWERLOSS_LINEAR_RATE / 3 * POWERLOSS_CUBIC_DIVISOR ** 3)
	powerloss_linear_offset = -1 * powerloss_linear_threshold * POWERLOSS_LINEAR_RATE + (powerloss_linear_threshold / POWERLOSS_CUBIC_DIVISOR) ** 3

/obj/energy_ball/Destroy()
	GLOB.all_energy_balls -= src
	return ..()

/obj/energy_ball/proc/set_color(color)
	if(isnull(color))
		return FALSE
	src.color = color
	for (var/obj/energy_ball/ball in orbiting_balls)
		ball.color = color
	return TRUE

/obj/energy_ball/proc/after_zap(atom/zapped_atom)
	if(isliving(zapped_atom))
		var/mob/living/zapped_mob = zapped_atom
		if(is_clown_job(zapped_mob.mind?.assigned_role))
			if(prob(50))
				energy *= 2
				zap_energy *= 1.5
			else
				energy = 0

/obj/energy_ball/examine(mob/user)
	. = ..()
	if(isobserver(user))
		. += "Energy: [energy]"

/obj/energy_ball/proc/process_atmos()
	var/datum/gas_mixture/env = get_environment()
	absorbed_gasmix = env?.remove_ratio(absorption_ratio) || new()
	absorbed_gasmix.volume = (env?.volume || CELL_VOLUME) * absorption_ratio // To match the pressure.
	calculate_gases()
	calculate_internal_energy()

	for (var/gas_path in absorbed_gasmix.gases)
		var/datum/eball_gas/eball_gas = current_gas_behavior[gas_path]
		eball_gas?.extra_effects(src)

	zap_factors = calculate_zap_transmission_rate()
	temp_limit_factors = calculate_temp_limit()

	waste_multiplier_factors = calculate_waste_multiplier()
	var/device_energy = energy * REACTION_POWER_MODIFIER

	var/datum/gas_mixture/merged_gasmix = absorbed_gasmix.copy()
	merged_gasmix.temperature += device_energy * waste_multiplier / THERMAL_RELEASE_MODIFIER
	merged_gasmix.temperature = clamp(merged_gasmix.temperature, TCMB, 2500 * waste_multiplier)
	merged_gasmix.assert_gases(/datum/gas/plasma, /datum/gas/oxygen)
	merged_gasmix.gases[/datum/gas/plasma][MOLES] += max(device_energy * waste_multiplier / PLASMA_RELEASE_MODIFIER, 0)
	merged_gasmix.gases[/datum/gas/oxygen][MOLES] += max(((device_energy + merged_gasmix.temperature * waste_multiplier) - T0C) / OXYGEN_RELEASE_MODIFIER, 0)
	merged_gasmix.garbage_collect()
	env.merge(merged_gasmix)
	air_update_turf(FALSE, FALSE)

/obj/energy_ball/proc/add_to_cims()
	GLOB.all_energy_balls += src
	uid = GLOB.all_singularities.len + GLOB.all_energy_balls.len

/obj/energy_ball/proc/get_environment()
	var/turf/T = get_turf(src)
	return T.return_air()

/obj/energy_ball/proc/calculate_internal_energy()

	var/list/additive_power = list()

	/// If we have a small amount of external_power_trickle we just round it up to 40.
	additive_power[SM_POWER_EXTERNAL_IMMEDIATE] = external_power_immediate
	external_power_immediate = 0
	additive_power[SM_POWER_HEAT] = gas_heat_power_generation * absorbed_gasmix.temperature * GAS_HEAT_POWER_SCALING_COEFFICIENT

	// I'm sorry for this, but we need to calculate power lost immediately after power gain.
	// Helps us prevent cases when someone dumps superhothotgas into the SM and shoots the power to the moon for one tick.
	/// Power if we dont have decay. Used for powerloss calc.
	var/momentary_power = internal_energy
	for(var/powergain_type in additive_power)
		momentary_power += additive_power[powergain_type]
	if(momentary_power < powerloss_linear_threshold) // Negative numbers
		additive_power[SM_POWER_POWERLOSS] = -1 * (momentary_power / POWERLOSS_CUBIC_DIVISOR) ** 3
	else
		additive_power[SM_POWER_POWERLOSS] = -1 * (momentary_power * POWERLOSS_LINEAR_RATE + powerloss_linear_offset)
	// Positive number
	additive_power[SM_POWER_POWERLOSS_GAS] = -1 * gas_powerloss_inhibition *  additive_power[SM_POWER_POWERLOSS]
	additive_power[SM_POWER_POWERLOSS_SOOTHED] = -1 * min(1-gas_powerloss_inhibition , 0.2) *  additive_power[SM_POWER_POWERLOSS]

	for(var/powergain_types in additive_power)
		internal_energy += additive_power[powergain_types]
	internal_energy = max(internal_energy, 0)
	powerloss_inhibition = (additive_power[SM_POWER_POWERLOSS_GAS] + additive_power[SM_POWER_POWERLOSS_SOOTHED]) * 1e4
	heat_power_generation = additive_power[SM_POWER_HEAT] * 1e4

	return additive_power

/obj/energy_ball/proc/calculate_gases()
	gas_percentage = list()
	gas_power_transmission_rate = 0
	gas_heat_modifier = 0
	gas_heat_resistance = 0
	gas_heat_power_generation = 0
	gas_powerloss_inhibition = 0

	var/total_moles = absorbed_gasmix.total_moles()
	if(total_moles < MINIMUM_MOLE_COUNT) //it's not worth processing small amounts like these, total_moles can also be 0 in vacuume
		return
	for (var/gas_path in absorbed_gasmix.gases)
		var/mole_count = absorbed_gasmix.gases[gas_path][MOLES]
		if(mole_count < MINIMUM_MOLE_COUNT) //save processing power from small amounts like these
			continue
		gas_percentage[gas_path] = mole_count / total_moles
		var/datum/eball_gas/eball_gas = current_gas_behavior[gas_path]
		if(!eball_gas)
			continue
		gas_power_transmission_rate += eball_gas.power_transmission * gas_percentage[gas_path]
		gas_heat_modifier += eball_gas.heat_modifier * gas_percentage[gas_path]
		gas_heat_resistance += eball_gas.heat_resistance * gas_percentage[gas_path]
		gas_heat_power_generation += eball_gas.heat_power_generation * gas_percentage[gas_path]
		gas_powerloss_inhibition += eball_gas.powerloss_inhibition * gas_percentage[gas_path]

	gas_heat_power_generation = clamp(gas_heat_power_generation, 0, 1)
	gas_powerloss_inhibition = clamp(gas_powerloss_inhibition, 0, 1)

/obj/energy_ball/proc/calculate_temp_limit()
	var/list/additive_temp_limit = list()
	additive_temp_limit[SM_TEMP_LIMIT_BASE] = T0C + HEAT_PENALTY_THRESHOLD
	additive_temp_limit[SM_TEMP_LIMIT_GAS] = gas_heat_resistance *  (T0C + HEAT_PENALTY_THRESHOLD)
	additive_temp_limit[SM_TEMP_LIMIT_LOW_MOLES] =  clamp(2 - absorbed_gasmix.total_moles() / 100, 0, 1) * (T0C + HEAT_PENALTY_THRESHOLD)

	temp_limit = 0
	for (var/resistance_type in additive_temp_limit)
		temp_limit += additive_temp_limit[resistance_type]
	temp_limit = max(temp_limit, TCMB)

	return additive_temp_limit

/obj/energy_ball/proc/calculate_waste_multiplier()
	waste_multiplier = 0

	var/additive_waste_multiplier = list()
	additive_waste_multiplier[SM_WASTE_BASE] = 1
	additive_waste_multiplier[SM_WASTE_GAS] = gas_heat_modifier

	for (var/waste_type in additive_waste_multiplier)
		waste_multiplier += additive_waste_multiplier[waste_type]
	waste_multiplier = clamp(waste_multiplier, 0.5, INFINITY)
	return additive_waste_multiplier

/obj/energy_ball/proc/calculate_zap_transmission_rate()
	var/list/additive_transmission_rate = list()
	additive_transmission_rate[SM_ZAP_BASE] = initial(zap_transmission_rate)
	additive_transmission_rate[SM_ZAP_GAS] = gas_power_transmission_rate

	zap_transmission_rate = 0
	for (var/transmission_types in additive_transmission_rate)
		zap_transmission_rate += additive_transmission_rate[transmission_types]
	zap_transmission_rate = max(zap_transmission_rate, 0)
	return additive_transmission_rate

/obj/energy_ball/proc/ntcims_ui_data()
	var/list/data = list()
	data["name"] = name
	data["type"] = "energyball"
	data["id"] = uid
	data["uid"] = "anomaly_[uid]"
	data["energy"] = energy
	data["orbiting_balls"] = orbiting_balls.len
	data["energy_to_lower"] = energy_to_lower
	data["energy_to_raise"] = energy_to_raise
	data["zap_energy"] = max((zap_energy * min(energy/250, zap_transmission_rate)) + heat_power_generation - powerloss_inhibition, 1 MEGA JOULES)

	data["absorbed_ratio"] = absorption_ratio
	var/list/formatted_gas_percentage = list()
	for (var/datum/gas/gas_path as anything in subtypesof(/datum/gas))
		formatted_gas_percentage[gas_path] = gas_percentage?[gas_path] || 0
	data["gas_composition"] = formatted_gas_percentage
	data["gas_temperature"] = absorbed_gasmix.temperature
	data["gas_total_moles"] = absorbed_gasmix.total_moles()
	return data

/// Energy Ball spawned by a energy ball generator
/obj/energy_ball/stationary
	zap_energy = 5 MEGA JOULES

/obj/energy_ball/stationary/Initialize(mapload, starting_energy = 50, is_miniball = FALSE)
	. = ..()
	add_to_cims()

#undef EBALL_NORMAL
#undef EBALL_DANGER

#undef TESLA_DEFAULT_ENERGY

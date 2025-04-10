/proc/init_eball_gas()
	var/list/gas_list = list()
	for (var/eball_gas_path in subtypesof(/datum/eball_gas))
		var/datum/eball_gas/eball_gas = new eball_gas_path
		gas_list[eball_gas.gas_path] = eball_gas
	return gas_list

/// Return a list info of the SM gases.
/// Can only run after init_eball_gas
/proc/eball_gas_data()
	var/list/data = list()
	for (var/gas_path in GLOB.eball_gas_behavior)
		var/datum/eball_gas/eball_gas = GLOB.eball_gas_behavior[gas_path]
		var/list/singular_gas_data = list()
		singular_gas_data["desc"] = eball_gas.desc

		// Positive is true if more of the amount is a good thing.
		var/list/numeric_data = list()
		if(eball_gas.power_transmission)
			var/list/si_derived_data = siunit_isolated(eball_gas.power_transmission * BASE_POWER_TRANSMISSION_RATE, "W/MeV", 2)
			numeric_data += list(list(
				"name" = "Power Transmission Bonus",
				"amount" = si_derived_data["coefficient"],
				"unit" = si_derived_data["unit"],
				"positive" = TRUE,
			))
		if(eball_gas.heat_modifier)
			numeric_data += list(list(
				"name" = "Waste Multiplier",
				"amount" = 100 * eball_gas.heat_modifier,
				"unit" = "%",
				"positive" = FALSE,
			))
		if(eball_gas.heat_resistance)
			numeric_data += list(list(
				"name" = "Heat Resistance",
				"amount" = 100 * eball_gas.heat_resistance,
				"unit" = "%",
				"positive" = TRUE,
			))
		if(eball_gas.heat_power_generation)
			var/list/si_derived_data = siunit_isolated(eball_gas.heat_power_generation * GAS_HEAT_POWER_SCALING_COEFFICIENT MEGA SECONDS / SSair.wait, "eV/K/s", 2)
			numeric_data += list(list(
				"name" = "Heat Power Gain",
				"amount" = si_derived_data["coefficient"],
				"unit" = si_derived_data["unit"],
				"positive" = TRUE,
			))
		if(eball_gas.powerloss_inhibition)
			numeric_data += list(list(
				"name" = "Power Decay Negation",
				"amount" = 100 * eball_gas.powerloss_inhibition,
				"unit" = "%",
				"positive" = TRUE,
			))
		singular_gas_data["numeric_data"] = numeric_data
		data[gas_path] = singular_gas_data
	return data

/// Assoc of eball_gas_behavior[/datum/gas (path)] = datum/eball_gas (instance)
GLOBAL_LIST_INIT(eball_gas_behavior, init_eball_gas())

/datum/eball_gas

	var/gas_path

	var/power_transmission = 0

	var/heat_modifier = 0

	var/heat_resistance = 0

	var/heat_power_generation = 0

	var/powerloss_inhibition = 0

	var/desc

/datum/eball_gas/proc/extra_effects(obj/energy_ball/eball)
	return

/datum/eball_gas/oxygen
	gas_path = /datum/gas/oxygen
	power_transmission = 0.15
	heat_power_generation = 1

/datum/eball_gas/nitrogen
	gas_path = /datum/gas/nitrogen
	heat_modifier = -2.5
	heat_power_generation = -1

/datum/eball_gas/carbon_dioxide
	gas_path = /datum/gas/carbon_dioxide
	heat_modifier = 1
	heat_power_generation = 1
	powerloss_inhibition = 1
	desc = "When absorbed by the Energy Ball and exposed to oxygen, Pluoxium will be generated."

/// Can be on Oxygen or CO2, but better lump it here since CO2 is rarer.
/datum/eball_gas/carbon_dioxide/extra_effects(obj/energy_ball/eball)
	if(!eball.gas_percentage[/datum/gas/carbon_dioxide] || !eball.gas_percentage[/datum/gas/oxygen])
		return
	var/co2_pp = eball.absorbed_gasmix.return_pressure() * eball.gas_percentage[/datum/gas/carbon_dioxide]
	var/co2_ratio = clamp((1/2 * (co2_pp - CO2_CONSUMPTION_PP) / (co2_pp + CO2_PRESSURE_SCALING)), 0, 1)
	var/consumed_co2 = eball.absorbed_gasmix.gases[/datum/gas/carbon_dioxide][MOLES] * co2_ratio
	consumed_co2 = min(
		consumed_co2,
		eball.absorbed_gasmix.gases[/datum/gas/carbon_dioxide][MOLES],
		eball.absorbed_gasmix.gases[/datum/gas/oxygen][MOLES]
	)
	if(!consumed_co2)
		return
	eball.absorbed_gasmix.gases[/datum/gas/carbon_dioxide][MOLES] -= consumed_co2
	eball.absorbed_gasmix.gases[/datum/gas/oxygen][MOLES] -= consumed_co2
	ASSERT_GAS(/datum/gas/pluoxium, eball.absorbed_gasmix)
	eball.absorbed_gasmix.gases[/datum/gas/pluoxium][MOLES] += consumed_co2

/datum/eball_gas/plasma
	gas_path = /datum/gas/plasma
	heat_modifier = 14
	power_transmission = 0.4
	heat_power_generation = 1

/datum/eball_gas/water_vapor
	gas_path = /datum/gas/water_vapor
	heat_modifier = 11
	power_transmission = -0.25
	heat_power_generation = 1

/datum/eball_gas/hypernoblium
	gas_path = /datum/gas/hypernoblium
	heat_modifier = -14
	power_transmission = 0.3
	heat_power_generation = -1

/datum/eball_gas/nitrous_oxide
	gas_path = /datum/gas/nitrous_oxide
	heat_resistance = 5

/datum/eball_gas/tritium
	gas_path = /datum/gas/tritium
	heat_modifier = 9
	power_transmission = 3
	heat_power_generation = 1

/datum/eball_gas/bz
	gas_path = /datum/gas/bz
	heat_modifier = 4
	power_transmission = -0.2
	heat_power_generation = 1
	desc = "Will emit nuclear particles at compositions above 40%"

/// Start to emit radballs at a maximum of 30% chance per tick
/datum/eball_gas/bz/extra_effects(obj/energy_ball/eball)
	if(eball.gas_percentage[/datum/gas/bz] > 0.4 && prob(30 * eball.gas_percentage[/datum/gas/bz]))
		eball.fire_nuclear_particle()

/datum/eball_gas/pluoxium
	gas_path = /datum/gas/pluoxium
	heat_modifier = -1.5
	power_transmission = -0.5
	heat_power_generation = -1

/datum/eball_gas/miasma
	gas_path = /datum/gas/miasma
	heat_power_generation = 0.5

/datum/eball_gas/freon
	gas_path = /datum/gas/freon
	heat_modifier = -9
	power_transmission = -3
	heat_power_generation = -1

/datum/eball_gas/hydrogen
	gas_path = /datum/gas/hydrogen
	heat_modifier = 9
	power_transmission = 2.5
	heat_resistance = 1
	heat_power_generation = 1

/datum/eball_gas/healium
	gas_path = /datum/gas/healium
	heat_modifier = 3
	power_transmission = 0.24
	heat_power_generation = 1

/datum/eball_gas/proto_nitrate
	gas_path = /datum/gas/proto_nitrate
	heat_modifier = -4
	power_transmission = 1.5
	heat_resistance = 4
	heat_power_generation = 1

/datum/eball_gas/zauker
	gas_path = /datum/gas/zauker
	heat_modifier = 7
	power_transmission = 2
	heat_power_generation = 1
	desc = "Will generate electrical zaps."

/datum/eball_gas/zauker/extra_effects(obj/energy_ball/eball)
	if(!prob(eball.gas_percentage[/datum/gas/zauker] * 100))
		return
	playsound(eball.loc, 'sound/items/weapons/emitter2.ogg', 100, TRUE, extrarange = 10)
	tesla_zap(
		source = eball,
		zap_range = 3,
		power = clamp(eball.zap_energy * 1.6 KILO JOULES, 3.2 MEGA JOULES, 16 MEGA JOULES),
		shocked_targets = list(),
		zap_flags = ZAP_EBALL_FLAGS,
		zap_icon = eball.zap_icon_state
	)

/datum/eball_gas/antinoblium
	gas_path = /datum/gas/antinoblium
	heat_modifier = 14
	power_transmission = -0.5
	heat_power_generation = 1

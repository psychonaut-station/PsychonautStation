#define TESLA_DEFAULT_ENERGY (695.304 MEGA JOULES)
#define TESLA_MINI_ENERGY (347.652 MEGA JOULES) // Has a weird scaling thing so this is a lie for now (doesn't generate power anyways).
//Zap constants, speeds up targeting
#define BIKE (COIL + 1)
#define COIL (ROD + 1)
#define ROD (RIDE + 1)
#define RIDE (LIVING + 1)
#define LIVING (MACHINERY + 1)
#define MACHINERY (BLOB + 1)
#define BLOB (STRUCTURE + 1)
#define STRUCTURE (1)

#define EBALL_NORMAL 0
#define EBALL_DANGER 1

GLOBAL_LIST_EMPTY(all_energy_balls)
/// The Tesla engine
/obj/energy_ball
	name = "energy ball"
	desc = "An energy ball."
	icon = 'icons/obj/machines/engine/energy_ball.dmi'
	icon_state = "energy_ball"
	anchored = TRUE
	appearance_flags = LONG_GLIDE
	density = TRUE
	plane = MASSIVE_OBJ_PLANE
	plane = ABOVE_LIGHTING_PLANE
	light_range = 6
	move_resist = INFINITY
	obj_flags = CAN_BE_HIT | DANGEROUS_POSSESSION
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF | SHUTTLE_CRUSH_PROOF
	flags_1 = SUPERMATTER_IGNORES_1

	var/uid = 0

	var/energy
	var/target
	var/list/orbiting_balls = list()
	var/miniball = FALSE
	var/produced_power
	var/energy_to_raise = 32
	var/energy_to_lower = -20
	var/list/shocked_things = list()

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

	energy = starting_energy
	miniball = is_miniball
	START_PROCESSING(SSobj, src)

	if (!is_miniball)
		set_light(10, 7, "#5e5edd")

		var/turf/spawned_turf = get_turf(src)
		message_admins("A tesla has been created at [ADMIN_VERBOSEJMP(spawned_turf)].")
		investigate_log("was created at [AREACOORD(spawned_turf)].", INVESTIGATE_ENGINE)

/obj/energy_ball/Destroy()
	if(orbiting && istype(orbiting.parent, /obj/energy_ball))
		var/obj/energy_ball/parent_energy_ball = orbiting.parent
		parent_energy_ball.orbiting_balls -= src

	QDEL_LIST(orbiting_balls)
	STOP_PROCESSING(SSobj, src)
	GLOB.all_energy_balls -= src

	return ..()

/obj/energy_ball/process()
	if(orbiting)
		energy = 0 // ensure we dont have miniballs of miniballs
	else
		if(!(datum_flags & DF_ISPROCESSING))
			return
		if(energy <= 0)
			investigate_log("collapsed.", INVESTIGATE_ENGINE)
			qdel(src)
			return FALSE
		process_atmos()
		handle_energy()

		move(4 + orbiting_balls.len * 1.5)

		playsound(src.loc, 'sound/effects/magic/lightningbolt.ogg', 100, TRUE, extrarange = 30)

		if(!HAS_TRAIT(src, TRAIT_GRABBED_BY_KINESIS))
			pixel_x = 0
			pixel_y = 0

		shocked_things.Cut(1, shocked_things.len / 1.3)
		var/list/shocking_info = list()
		tesla_zap(source = src, zap_range = 3, power = max((zap_energy * min(energy/250, zap_transmission_rate)) + heat_power_generation - powerloss_inhibition, 1 MEGA JOULES), shocked_targets = shocking_info, zap_flags = ZAP_EBALL_FLAGS, callback = CALLBACK(src, PROC_REF(after_zap)), zap_icon = zap_icon_state)

		pixel_x = -ICON_SIZE_X
		pixel_y = -ICON_SIZE_Y
		for (var/ball in orbiting_balls)
			var/range = rand(1, clamp(orbiting_balls.len, 2, 3))
			var/list/temp_shock = list()
			//We zap off the main ball instead of ourselves to make things looks proper
			tesla_zap(source = src, zap_range = range, power = TESLA_MINI_ENERGY / 7 * range, shocked_targets = temp_shock, zap_icon = zap_icon_state)
			shocking_info += temp_shock
		shocked_things += shocking_info

/obj/energy_ball/examine(mob/user)
	. = ..()
	if(orbiting_balls.len)
		. += "There are [orbiting_balls.len] mini-balls orbiting it."

/obj/energy_ball/proc/move(move_amount)
	var/list/dirs = GLOB.alldirs.Copy()
	if(shocked_things.len)
		for (var/i in 1 to 30)
			var/atom/real_thing = pick(shocked_things)
			dirs += get_dir(src, real_thing) //Carry some momentum yeah? Just a bit tho
	for (var/i in 0 to move_amount)
		var/move_dir = pick(dirs) //ensures teslas don't just sit around
		if (target && prob(10))
			move_dir = get_dir(src, target)
		var/turf/turf_to_move = get_step(src, move_dir)
		if (can_move(turf_to_move))
			forceMove(turf_to_move)
			setDir(move_dir)
			for (var/mob/living/carbon/mob_to_dust in loc)
				dust_mobs(mob_to_dust)

/obj/energy_ball/proc/can_move(turf/to_move)
	if (!to_move)
		return FALSE
	if(HAS_TRAIT(src, TRAIT_GRABBED_BY_KINESIS))
		return FALSE

	for (var/_thing in to_move)
		var/atom/thing = _thing
		if (SEND_SIGNAL(thing, COMSIG_ATOM_SINGULARITY_TRY_MOVE) & SINGULARITY_TRY_MOVE_BLOCK)
			return FALSE

	return TRUE

/obj/energy_ball/proc/handle_energy()
	if(energy >= energy_to_raise)
		energy_to_lower = energy_to_raise - 20
		energy_to_raise = energy_to_raise * 1.25

		playsound(src.loc, 'sound/effects/magic/lightning_chargeup.ogg', 100, TRUE, extrarange = 30)
		addtimer(CALLBACK(src, PROC_REF(new_mini_ball)), 10 SECONDS)
	else if(energy < energy_to_lower && orbiting_balls.len)
		energy_to_raise = energy_to_raise / 1.25
		energy_to_lower = (energy_to_raise / 1.25) - 20

		var/Orchiectomy_target = pick(orbiting_balls)
		qdel(Orchiectomy_target)

/obj/energy_ball/proc/new_mini_ball()
	if(!loc)
		return

	var/obj/energy_ball/miniball = new /obj/energy_ball(
		loc,
		/* starting_energy = */ 0,
		/* is_miniball = */ TRUE
	)

	miniball.transform *= pick(0.3, 0.4, 0.5, 0.6, 0.7)
	var/list/icon_dimensions = get_icon_dimensions(icon)

	var/orbitsize = (icon_dimensions["width"] + icon_dimensions["height"]) * pick(0.4, 0.5, 0.6, 0.7, 0.8)
	orbitsize -= (orbitsize / ICON_SIZE_ALL) * (ICON_SIZE_ALL * 0.25)
	miniball.orbit(src, orbitsize, pick(FALSE, TRUE), rand(10, 25), pick(3, 4, 5, 6, 36))

	if(!isnull(color))
		miniball.color = color

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

	if(absorbed_gasmix.temperature > 12731.5 && gas_percentage[/datum/gas/plasma] > 0.2 && energy > 600)
		if(gas_percentage[/datum/gas/nitrous_oxide] < 0.5)
			explosion(zapped_atom, devastation_range = 2, heavy_impact_range = 2, light_impact_range = 3)

/obj/energy_ball/Bump(atom/A)
	dust_mobs(A)

/obj/energy_ball/Bumped(atom/movable/AM)
	dust_mobs(AM)

/obj/energy_ball/attack_tk(mob/user)
	if(!iscarbon(user))
		return
	var/mob/living/carbon/jedi = user
	to_chat(jedi, span_userdanger("That was a shockingly dumb idea."))
	var/obj/item/organ/brain/rip_u = locate(/obj/item/organ/brain) in jedi.organs
	jedi.ghostize(jedi)
	if(rip_u)
		qdel(rip_u)
	jedi.investigate_log("had [jedi.p_their()] brain dusted by touching [src] with telekinesis.", INVESTIGATE_DEATHS)
	jedi.death()
	return COMPONENT_CANCEL_ATTACK_CHAIN

/obj/energy_ball/orbit(obj/energy_ball/target)
	if (istype(target))
		target.orbiting_balls += src
	. = ..()

/obj/energy_ball/stop_orbit()
	if (orbiting && istype(orbiting.parent, /obj/energy_ball))
		var/obj/energy_ball/orbitingball = orbiting.parent
		orbitingball.orbiting_balls -= src
	. = ..()
	if (!QDELETED(src))
		qdel(src)


/obj/energy_ball/proc/dust_mobs(atom/A)
	if(isliving(A))
		var/mob/living/living = A
		if(living.incorporeal_move || HAS_TRAIT(living, TRAIT_GODMODE))
			return
	if(!iscarbon(A))
		return
	for(var/obj/machinery/power/energy_accumulator/grounding_rod/GR in orange(src, 2))
		if(GR.anchored)
			return
	var/mob/living/carbon/C = A
	C.investigate_log("has been dusted by an energy ball.", INVESTIGATE_DEATHS)
	C.dust()

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

/proc/tesla_zap(atom/source, zap_range = 3, power, cutoff = 4e5, zap_flags = ZAP_DEFAULT_FLAGS, list/shocked_targets = list(), zap_icon, datum/callback/callback)
	if(QDELETED(source))
		return
	if(!(zap_flags & ZAP_ALLOW_DUPLICATES))
		LAZYSET(shocked_targets, source, TRUE) //I don't want no null refs in my list yeah?
	. = source.dir
	if(power < cutoff)
		return

	/*
	THIS IS SO FUCKING UGLY AND I HATE IT, but I can't make it nice without making it slower, check*N rather then n. So we're stuck with it.
	*/
	var/atom/closest_atom
	var/closest_type = 0
	var/static/list/things_to_shock = zebra_typecacheof(list(
		// Things that we want to shock.
		/obj/machinery = TRUE,
		/mob/living = TRUE,
		/obj/structure = TRUE,
		/obj/vehicle/ridden = TRUE,

		// Things that we don't want to shock.
		/obj/machinery/atmospherics = FALSE,
		/obj/machinery/portable_atmospherics = FALSE,
		/obj/machinery/power/emitter = FALSE,
		/obj/machinery/field/generator = FALSE,
		/obj/machinery/field/containment = FALSE,
		/obj/machinery/camera = FALSE,
		/obj/machinery/gateway = FALSE,
		/mob/living/simple_animal = FALSE,
		/obj/structure/disposalpipe = FALSE,
		/obj/structure/disposaloutlet = FALSE,
		/obj/machinery/disposal/delivery_chute = FALSE,
		/obj/structure/sign = FALSE,
		/obj/structure/lattice = FALSE,
		/obj/structure/grille = FALSE,
		/obj/structure/frame/machine = FALSE,
		/obj/machinery/particle_accelerator = FALSE,
		/obj/structure/cable = FALSE
	))

	//Ok so we are making an assumption here. We assume that view() still calculates from the center out.
	//This means that if we find an object we can assume it is the closest one of its type. This is somewhat of a speed increase.
	//This also means we have no need to track distance, as the doview() proc does it all for us.

	//Darkness fucks oview up hard. I've tried dview() but it doesn't seem to work
	//I hate existence
	for(var/atom/A as anything in typecache_filter_list(oview(zap_range+2, source), things_to_shock))
		if(!(zap_flags & ZAP_ALLOW_DUPLICATES) && LAZYACCESS(shocked_targets, A))
			continue
		// NOTE: these type checks are safe because CURRENTLY the range family of procs returns turfs in least to greatest distance order
		// This is unspecified behavior tho, so if it ever starts acting up just remove these optimizations and include a distance check
		if(closest_type >= BIKE)
			break

		else if(istype(A, /obj/vehicle/ridden/bicycle))//God's not on our side cause he hates idiots.
			var/obj/vehicle/ridden/bicycle/B = A
			if(!HAS_TRAIT(B, TRAIT_BEING_SHOCKED) && B.can_buckle)//Gee goof thanks for the boolean
				//we use both of these to save on istype and typecasting overhead later on
				//while still allowing common code to run before hand
				closest_type = BIKE
				closest_atom = B

		else if(closest_type >= COIL)
			continue //no need checking these other things

		else if(istype(A, /obj/machinery/power/energy_accumulator/tesla_coil))
			if(!HAS_TRAIT(A, TRAIT_BEING_SHOCKED))
				closest_type = COIL
				closest_atom = A

		else if(closest_type >= ROD)
			continue

		else if(istype(A, /obj/machinery/power/energy_accumulator/grounding_rod))
			closest_type = ROD
			closest_atom = A

		else if(closest_type >= RIDE)
			continue

		else if(istype(A,/obj/vehicle/ridden))
			var/obj/vehicle/ridden/R = A
			if(R.can_buckle && !HAS_TRAIT(R, TRAIT_BEING_SHOCKED))
				closest_type = RIDE
				closest_atom = A

		else if(closest_type >= LIVING)
			continue

		else if(isliving(A))
			var/mob/living/L = A
			if(L.stat != DEAD && !HAS_TRAIT(L, TRAIT_TESLA_SHOCKIMMUNE) && !HAS_TRAIT(L, TRAIT_BEING_SHOCKED))
				closest_type = LIVING
				closest_atom = A

		else if(closest_type >= MACHINERY)
			continue

		else if(ismachinery(A))
			if(!HAS_TRAIT(A, TRAIT_BEING_SHOCKED))
				closest_type = MACHINERY
				closest_atom = A

		else if(closest_type >= BLOB)
			continue

		else if(istype(A, /obj/structure/blob))
			if(!HAS_TRAIT(A, TRAIT_BEING_SHOCKED))
				closest_type = BLOB
				closest_atom = A

		else if(closest_type >= STRUCTURE)
			continue

		else if(isstructure(A))
			if(!HAS_TRAIT(A, TRAIT_BEING_SHOCKED))
				closest_type = STRUCTURE
				closest_atom = A

	//Alright, we've done our loop, now lets see if was anything interesting in range
	if(!closest_atom)
		return
	//common stuff
	source.Beam(closest_atom, icon_state= (zap_icon || "lightning[rand(1,12)]"), time = 5)
	var/zapdir = get_dir(source, closest_atom)
	if(zapdir)
		. = zapdir

	var/next_range = 2
	if(closest_type == COIL)
		next_range = 5

	if(closest_type == LIVING)
		var/mob/living/closest_mob = closest_atom
		ADD_TRAIT(closest_mob, TRAIT_BEING_SHOCKED, WAS_SHOCKED)
		addtimer(TRAIT_CALLBACK_REMOVE(closest_mob, TRAIT_BEING_SHOCKED, WAS_SHOCKED), 1 SECONDS)
		var/shock_damage = (zap_flags & ZAP_MOB_DAMAGE) ? (min(round(power / 600), 90) + rand(-5, 5)) : 0
		closest_mob.electrocute_act(shock_damage, source, 1, SHOCK_TESLA | ((zap_flags & ZAP_MOB_STUN) ? NONE : SHOCK_NOSTUN))
		if(issilicon(closest_mob))
			var/mob/living/silicon/S = closest_mob
			if((zap_flags & ZAP_MOB_STUN) && (zap_flags & ZAP_MOB_DAMAGE))
				S.emp_act(EMP_LIGHT)
			next_range = 7 // metallic folks bounce it further
		else
			next_range = 5
		power /= 1.5

	else
		power = closest_atom.zap_act(power, zap_flags)

	if(callback)
		callback.Invoke(closest_atom)

	// Electrolysis.
	var/turf/target_turf = get_turf(closest_atom)
	if(target_turf?.return_air())
		var/datum/gas_mixture/air_mixture = target_turf.return_air()
		air_mixture.electrolyze(working_power = power / 200)
		target_turf.air_update_turf()

	if(prob(20))//I know I know
		var/list/shocked_copy = shocked_targets.Copy()
		tesla_zap(source = closest_atom, zap_range = next_range, power = power * 0.5, cutoff = cutoff, zap_flags = zap_flags, shocked_targets = shocked_copy, zap_icon = zap_icon, callback = callback)
		tesla_zap(source = closest_atom, zap_range = next_range, power = power * 0.5, cutoff = cutoff, zap_flags = zap_flags, shocked_targets = shocked_targets, zap_icon = zap_icon, callback = callback)
		shocked_targets += shocked_copy
	else
		tesla_zap(source = closest_atom, zap_range = next_range, power = power, cutoff = cutoff, zap_flags = zap_flags, shocked_targets = shocked_targets, zap_icon = zap_icon, callback = callback)

#undef EBALL_NORMAL
#undef EBALL_DANGER

#undef BIKE
#undef COIL
#undef ROD
#undef RIDE
#undef LIVING
#undef MACHINERY
#undef BLOB
#undef STRUCTURE

#undef TESLA_DEFAULT_ENERGY
#undef TESLA_MINI_ENERGY

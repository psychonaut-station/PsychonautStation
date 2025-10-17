GLOBAL_LIST_EMPTY(all_singularities)

/// The gravitational singularity
/obj/singularity
	var/uid = 0

	/// The intensity multiplier for radiation pulses
	var/intensity_multiplier = 2.5

/obj/singularity/Destroy()
	GLOB.all_singularities -= src
	return ..()

/obj/singularity/proc/is_dangerous()
	if(current_size < STAGE_THREE)
		return FALSE
	else if(current_size <= STAGE_FOUR)
		return check_cardinals_range(0)
	return TRUE

/obj/singularity/examine(mob/user)
	. = ..()
	if(isobserver(user))
		. += "Energy: [energy]"

/obj/singularity/proc/get_energy_to_raise()
	switch(allowed_size)
		if(STAGE_ONE)
			return STAGE_TWO_ENERGY_REQUIREMENT
		if(STAGE_TWO)
			return STAGE_THREE_ENERGY_REQUIREMENT
		if(STAGE_THREE)
			return STAGE_FOUR_ENERGY_REQUIREMENT
		if(STAGE_FOUR)
			return STAGE_FIVE_ENERGY_REQUIREMENT
		if(STAGE_FIVE)
			if(consumed_supermatter)
				return STAGE_SIX_ENERGY_REQUIREMENT
			else
				return INFINITY
		if(STAGE_SIX)
			return INFINITY

/obj/singularity/proc/get_energy_to_lower()
	switch(allowed_size)
		if(STAGE_ONE)
			return 0
		if(STAGE_TWO)
			return STAGE_TWO_ENERGY_REQUIREMENT
		if(STAGE_THREE)
			return STAGE_THREE_ENERGY_REQUIREMENT
		if(STAGE_FOUR)
			return STAGE_FOUR_ENERGY_REQUIREMENT
		if(STAGE_FIVE)
			return STAGE_FIVE_ENERGY_REQUIREMENT
		if(STAGE_SIX)
			return STAGE_SIX_ENERGY_REQUIREMENT

/obj/singularity/proc/add_to_cims()
	GLOB.all_singularities += src
	uid = length(GLOB.all_singularities) + length(GLOB.all_energy_balls)

/obj/singularity/proc/ntcims_ui_data()
	var/list/data = list()
	data["name"] = name
	data["type"] = "singularity"
	data["id"] = uid
	data["uid"] = "anomaly_[uid]"
	data["current_size"] = current_size
	data["energy"] = energy
	data["dissipate_delay"] = dissipate_delay
	data["dissipate_strength"] = dissipate_strength
	data["radiation_pulse"] = energy * 2 + 500
	data["energy_to_lower"] = get_energy_to_lower()
	data["energy_to_raise"] = get_energy_to_raise()
	return data

#define ROUNDCOUNT_SINGULARITY_EATED_SOMEONE -1

/// Singularity spawned by a singularity generator
/obj/singularity/stationary
	intensity_multiplier = 1

/obj/singularity/stationary/Initialize(mapload, starting_energy)
	. = ..()
	add_to_cims()

/obj/singularity/stationary/consume(atom/thing)
	. = ..()
	if(ishuman(thing) && (SSpersistence.rounds_since_singularity_death != ROUNDCOUNT_SINGULARITY_EATED_SOMEONE))
		if(SSpersistence.singularity_death_record < SSpersistence.rounds_since_singularity_death)
			SSpersistence.singularity_death_record = SSpersistence.rounds_since_singularity_death
		SSpersistence.rounds_since_singularity_death = ROUNDCOUNT_SINGULARITY_EATED_SOMEONE
		for (var/obj/machinery/incident_display/sign as anything in GLOB.map_incident_displays)
			sign.update_last_singularity_death(ROUNDCOUNT_SINGULARITY_EATED_SOMEONE, SSpersistence.singularity_death_record)

#undef ROUNDCOUNT_SINGULARITY_EATED_SOMEONE

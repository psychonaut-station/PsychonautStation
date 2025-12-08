
///The storyteller datum. He operates with the SSgamemode data to run events
/datum/storyteller
	/// Name of our storyteller.
	var/name = "Badly coded storyteller"
	/// Description of our storyteller.
	var/desc = "Report this to the coders."
	/// Text that the players will be greeted with when this storyteller is chosen.
	var/welcome_text = "Set your eyes on the horizon."

	var/config_tag

	var/alist/event_weight_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_MAJOR = 1,
		EVENT_TRACK_ROLESET = 1,
	)

	var/alist/extra_settings = list(
		LOW_END = 0,
		HIGH_END = 0,
		EXECUTION_MULTIPLIER_LOW = 1,
		EXECUTION_MULTIPLIER_HIGH = 1,
	)

	/// Multipliers of weight to apply for each tag of an event.
	var/list/tag_multipliers = list()

	var/alist/event_repetition_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_MAJOR = 1,
		EVENT_TRACK_ROLESET = 1,
	)

	/// Whether a storyteller is pickable/can be voted for
	var/restricted = FALSE
	/// If defined, will need a minimum of population to be votable
	var/population_min = 0
	/// If defined, it will not be votable if exceeding the population
	var/population_max = 0
	///weight this has of being picked for random storyteller
	var/weight = 0

/datum/storyteller/New(list/dynamic_config)
	for(var/new_var in dynamic_config?[config_tag])
		if(!(new_var in vars))
			continue
		set_config_value(new_var, dynamic_config[config_tag][new_var])

/// Used for parsing config entries to validate them
/datum/storyteller/proc/set_config_value(new_var, new_val)
	switch(new_var)
		if(NAMEOF(src, config_tag), NAMEOF(src, vars))
			return FALSE
	vars[new_var] = new_val
	return TRUE

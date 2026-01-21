
///The storyteller datum. He operates with the SSgamemode data to run events
/datum/storyteller
	/// Name of our storyteller.
	var/name = "Badly coded storyteller"
	/// Description of our storyteller.
	var/desc = "Report this to the coders."
	/// Text that the players will be greeted with when this storyteller is chosen.
	var/welcome_text = "Set your eyes on the horizon."

	var/config_tag

	// Default Settings
	var/list/settings = list(
		STORYTELLER_EVENT_WEIGHT_MULTIPLIERS = list(
			EVENT_TRACK_MUNDANE = 1,
			EVENT_TRACK_MODERATE = 1,
			EVENT_TRACK_MAJOR = 1,
			EVENT_TRACK_ROLESET = 1,
		),
		STORYTELLER_TAG_MULTIPLIERS = list(),
		STORYTELLER_EVENT_REPETITION_MULTIPLIERS = list(
			EVENT_TRACK_MUNDANE = 1,
			EVENT_TRACK_MODERATE = 1,
			EVENT_TRACK_MAJOR = 1,
			EVENT_TRACK_ROLESET = 1,
		),
		STORYTELLER_GENERAL_MULTIPLIERS = 1,
		EXECUTION_MULTIPLIER_LOW = 1,
		EXECUTION_MULTIPLIER_HIGH = 1,
		TIME_THRESHOLD = INFINITY,
		LOW_END = list(
			ROUNDSTART = 0,
			LIGHT_MIDROUND = 0,
			HEAVY_MIDROUND = 0,
			LATEJOIN = 0,
		),
		HIGH_END = list(
			ROUNDSTART = 0,
			LIGHT_MIDROUND = 0,
			HEAVY_MIDROUND = 0,
			LATEJOIN = 0,
		),
	)

	// Roundstart Special Settings
	var/list/roundstart_settings = list(
		STORYTELLER_EVENT_WEIGHT_MULTIPLIERS = list(
			EVENT_TRACK_MUNDANE = 1,
			EVENT_TRACK_MODERATE = 1,
			EVENT_TRACK_MAJOR = 1,
			EVENT_TRACK_ROLESET = 1,
		),
		STORYTELLER_TAG_MULTIPLIERS = list(),
		STORYTELLER_EVENT_REPETITION_MULTIPLIERS = list(
			EVENT_TRACK_MUNDANE = 1,
			EVENT_TRACK_MODERATE = 1,
			EVENT_TRACK_MAJOR = 1,
			EVENT_TRACK_ROLESET = 1,
		),
		STORYTELLER_GENERAL_MULTIPLIERS = 1,
	)

	// Latejoin Special Settings
	var/list/latejoin_settings = list(
		list(
			STORYTELLER_EVENT_WEIGHT_MULTIPLIERS = list(
				EVENT_TRACK_MUNDANE = 1,
				EVENT_TRACK_MODERATE = 1,
				EVENT_TRACK_MAJOR = 1,
				EVENT_TRACK_ROLESET = 1,
			),
			STORYTELLER_TAG_MULTIPLIERS = list(),
			STORYTELLER_GENERAL_MULTIPLIERS = 1,
			TIME_THRESHOLD = 10 MINUTES,
			EXECUTION_MULTIPLIER_LOW = 1,
			EXECUTION_MULTIPLIER_HIGH = 1,
		)
	)

	// Midround Special Settings
	var/list/midround_settings = list(
		list(
			STORYTELLER_EVENT_WEIGHT_MULTIPLIERS = list(
				EVENT_TRACK_MUNDANE = 1,
				EVENT_TRACK_MODERATE = 1,
				EVENT_TRACK_MAJOR = 1,
				EVENT_TRACK_ROLESET = 1,
			),
			STORYTELLER_TAG_MULTIPLIERS = list(),
			STORYTELLER_EVENT_REPETITION_MULTIPLIERS = list(
				EVENT_TRACK_MUNDANE = 1,
				EVENT_TRACK_MODERATE = 1,
				EVENT_TRACK_MAJOR = 1,
				EVENT_TRACK_ROLESET = 1,
			),
			STORYTELLER_GENERAL_MULTIPLIERS = 1,
			TIME_THRESHOLD = 10 MINUTES,
			EXECUTION_MULTIPLIER_LOW = 1,
			EXECUTION_MULTIPLIER_HIGH = 1,
		)
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

/datum/storyteller/proc/initialize()
	SHOULD_CALL_PARENT(TRUE)

/datum/storyteller/proc/fire(seconds_per_tick)
	return

/datum/storyteller/proc/ruleset_execute(datum/dynamic_ruleset/ruleset, list/selected_minds)
	SHOULD_CALL_PARENT(TRUE)
	return

/datum/storyteller/proc/event_execute(datum/round_event_control/round_event_control)
	SHOULD_CALL_PARENT(TRUE)
	return

/datum/storyteller/proc/set_tier(list/ruleset_to_spawn)
	return ruleset_to_spawn

/// Used for parsing config entries to validate them
/datum/storyteller/proc/set_config_value(new_var, new_val)
	switch(new_var)
		if(NAMEOF(src, config_tag), NAMEOF(src, vars))
			return FALSE
	if(islist(new_val) && (new_var == NAMEOF(src, latejoin_settings) || new_var == NAMEOF(src, midround_settings)))
		new_val = load_tier_list(new_val)
	vars[new_var] = new_val
	return TRUE

/// Used to create tier alists
/datum/storyteller/proc/load_tier_list(list/incoming_list)
	PRIVATE_PROC(TRUE)

	var/alist/tier_list = alist()
	// loads a list of list("2" = 1, "3" = 3) into an alist(2 = 1, 3 = 3)
	for(var/tier in incoming_list)
		tier_list[text2num(tier)] = incoming_list[tier]

	return tier_list

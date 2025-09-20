/datum/storyteller/brute
	name = STORYTELLER_BRUTE
	config_tag = STORYTELLER_BRUTE
	desc = "While the brute will hit hard, it tires quickly."
	event_weight_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_MAJOR = 1,
		EVENT_TRACK_ROLESET = 1.2,
	)

	extra_settings = list(
		LOW_END = 0,
		HIGH_END = 0,
		EXECUTION_MULTIPLIER_LOW = 0.5,
		EXECUTION_MULTIPLIER_HIGH = 0.5,
	)
	population_min = 40 // If crew is gonna get hit hard have the numbers to survive it. Somewhat...
	weight = 1

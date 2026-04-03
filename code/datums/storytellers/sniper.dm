/datum/storyteller/sniper
	name = STORYTELLER_SNIPER
	config_tag = STORYTELLER_SNIPER
	desc = "The Sniper rarely acts, but never misses. Expect very long periods of silence broken by sudden, high-intensity targeted strikes designed to eliminate specific key personnel."
	welcome_text = "Keep your heads down. I am waiting for the perfect shot."
	settings = list(
		STORYTELLER_EVENT_WEIGHT_MULTIPLIERS = list(
			EVENT_TRACK_MUNDANE = 0,
			EVENT_TRACK_MODERATE = 0,
			EVENT_TRACK_MAJOR = 1,
			EVENT_TRACK_ROLESET = 1,
		),
		EXECUTION_MULTIPLIER_LOW = 3,
		EXECUTION_MULTIPLIER_HIGH = 3,
		LOW_END = alist(
			ROUNDSTART = -5,
			LIGHT_MIDROUND = 2,
			HEAVY_MIDROUND = 3,
			LATEJOIN = -5,
		),
		HIGH_END = alist(
			ROUNDSTART = -5,
			LIGHT_MIDROUND = 2,
			HEAVY_MIDROUND = 3,
			LATEJOIN = -5,
		),
	)
	population_min = 50
	weight = 1

/datum/storyteller/cataclysm
	name = STORYTELLER_CATACLYSM
	config_tag = STORYTELLER_CATACLYSM
	desc = "The Cataclysm inverts the difficulty curve, front-loading major disasters at the start of the shift."
	welcome_text = "Immediate emergency protocols active. The worst is not coming; it is already here."

	latejoin_settings = list(
		list(
			STORYTELLER_EVENT_WEIGHT_MULTIPLIERS = list(
				EVENT_TRACK_MUNDANE = 1,
				EVENT_TRACK_MODERATE = 1,
				EVENT_TRACK_MAJOR = 1,
				EVENT_TRACK_ROLESET = 1,
			),
			TIME_THRESHOLD = 15 MINUTES,
			EXECUTION_MULTIPLIER_LOW = 0.2,
			EXECUTION_MULTIPLIER_HIGH = 0.2,
		),
		list(
			STORYTELLER_EVENT_WEIGHT_MULTIPLIERS = list(
				EVENT_TRACK_MUNDANE = 2,
				EVENT_TRACK_MODERATE = 1,
				EVENT_TRACK_MAJOR = 0,
				EVENT_TRACK_ROLESET = 0,
			),
			TIME_THRESHOLD = 4 HOURS,
			EXECUTION_MULTIPLIER_LOW = 1.3,
			EXECUTION_MULTIPLIER_HIGH = 1.3,
		),
	)

	midround_settings = list(
		list(
			STORYTELLER_EVENT_WEIGHT_MULTIPLIERS = list(
				EVENT_TRACK_MUNDANE = 1,
				EVENT_TRACK_MODERATE = 1,
				EVENT_TRACK_MAJOR = 1,
				EVENT_TRACK_ROLESET = 1,
			),
			TIME_THRESHOLD = 15 MINUTES,
			EXECUTION_MULTIPLIER_LOW = 0.2,
			EXECUTION_MULTIPLIER_HIGH = 0.2,
		),
		list(
			STORYTELLER_EVENT_WEIGHT_MULTIPLIERS = list(
				EVENT_TRACK_MUNDANE = 2,
				EVENT_TRACK_MODERATE = 1,
				EVENT_TRACK_MAJOR = 0,
				EVENT_TRACK_ROLESET = 0,
			),
			TIME_THRESHOLD = 4 HOURS,
			EXECUTION_MULTIPLIER_LOW = 1.3,
			EXECUTION_MULTIPLIER_HIGH = 1.3,
		),
	)
	population_min = 55
	weight = 1

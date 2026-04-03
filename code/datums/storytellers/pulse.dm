/datum/storyteller/pulse
	name = STORYTELLER_PULSE
	config_tag = STORYTELLER_PULSE
	desc = "The Pulse alternates between bursts of rapid-fire chaos and periods of dead silence."
	welcome_text = "Local probability sensors are oscillating violently. The chaos will hit in waves."

	midround_settings = list(
		list(
			TIME_THRESHOLD = 15 MINUTES,
			EXECUTION_MULTIPLIER_LOW = 0.5,
			EXECUTION_MULTIPLIER_HIGH = 0.5,
		),
		list(
			TIME_THRESHOLD = 15 MINUTES,
			STORYTELLER_GENERAL_MULTIPLIERS = 0,
		)
	)
	population_min = 35
	weight = 2

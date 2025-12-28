/datum/storyteller/jester
	name = STORYTELLER_JESTER
	config_tag = STORYTELLER_JESTER
	desc = "The Jester will create much more events, with higher possibilities of them repeating."

	settings = list(
		STORYTELLER_EVENT_WEIGHT_MULTIPLIERS = list(
			EVENT_TRACK_MUNDANE = 1.2,
			EVENT_TRACK_MODERATE = 1.3,
			EVENT_TRACK_MAJOR = 1.3,
			EVENT_TRACK_ROLESET = 1,
		),
		STORYTELLER_TAG_MULTIPLIERS = list(),
		STORYTELLER_EVENT_REPETITION_MULTIPLIERS = -1.5,
	)

	population_min = 40
	weight = 2

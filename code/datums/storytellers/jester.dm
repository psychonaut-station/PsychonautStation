/datum/storyteller/jester
	name = STORYTELLER_JESTER
	config_tag = STORYTELLER_JESTER
	desc = "The Jester will create much more events, with higher possibilities of them repeating."
	event_repetition_multiplier = 1.2
	event_weight_multipliers = list(
		EVENT_TRACK_MUNDANE = 1.2,
		EVENT_TRACK_MODERATE = 1.3,
		EVENT_TRACK_MAJOR = 1.3,
		EVENT_TRACK_ROLESET = 1,
		)
	population_min = 40
	weight = 2

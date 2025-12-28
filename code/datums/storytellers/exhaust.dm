/datum/storyteller/exhaust
	name = STORYTELLER_EXHAUST
	config_tag = STORYTELLER_EXHAUST
	desc = "The Exhaust removes every event from the pool as it occurs, forcing increasingly obscure threats to appear."
	welcome_text = "History will not repeat itself today. Once a crisis is solved, it is gone forever."
	settings = list(
		STORYTELLER_EVENT_REPETITION_MULTIPLIERS = 100
	)
	population_min = 30
	weight = 1

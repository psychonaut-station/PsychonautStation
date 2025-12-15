/datum/storyteller/primeordial
	name = STORYTELLER_PRIMEORDIAL
	config_tag = STORYTELLER_PRIMEORDIAL
	desc = "The Primordial follows no clock. Events may occur in rapid succession or be spaced apart by hours. Prediction is impossible; constant vigilance is required."
	welcome_text = "Time has no meaning here. Expect the unexpected, whenever it chooses to arrive."

	population_min = 30
	weight = 1

/datum/storyteller/primeordial/ruleset_execute()
	. = ..()
	after_event()

/datum/storyteller/primeordial/event_execute()
	. = ..()
	after_event()

/datum/storyteller/primeordial/proc/after_event()
	settings[EXECUTION_MULTIPLIER_LOW] = clamp(settings[EXECUTION_MULTIPLIER_LOW] * rand(0.4, 2), 0.4, 2)
	settings[EXECUTION_MULTIPLIER_HIGH] = clamp(settings[EXECUTION_MULTIPLIER_HIGH] * rand(0.4, 2), 0.4, 2)
	log_storyteller("\[[name]\] set lower execution multiplier to [settings[EXECUTION_MULTIPLIER_LOW]]")
	log_storyteller("\[[name]\] set higher execution multiplier to [settings[EXECUTION_MULTIPLIER_HIGH]]")

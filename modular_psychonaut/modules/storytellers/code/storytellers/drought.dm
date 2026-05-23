/datum/storyteller/drought
	name = STORYTELLER_DROUGHT
	config_tag = STORYTELLER_DROUGHT
	desc = "The Drought begins with a heavy storm of events but slowly runs out of energy. The challenge is to survive the initial hour; the aftermath is for survival."
	welcome_text = "The storm is at our door. Survive the first wave, and you might just live."

	settings = list(
		EXECUTION_MULTIPLIER_LOW = 0.3,
		EXECUTION_MULTIPLIER_HIGH = 0.3,
	)

	population_min = 30
	weight = 1

	COOLDOWN_DECLARE(drought_cooldown)

	var/cooldown_duration = 5 MINUTES

/datum/storyteller/drought/initialize()
	. = ..()
	COOLDOWN_START(src, drought_cooldown, cooldown_duration)

/datum/storyteller/drought/fire(seconds_per_tick)
	if(!COOLDOWN_FINISHED(src, drought_cooldown))
		return

	COOLDOWN_START(src, drought_cooldown, cooldown_duration)
	var/execution_multiplier = settings[EXECUTION_MULTIPLIER_LOW]
	execution_multiplier *= 1.3
	settings[EXECUTION_MULTIPLIER_LOW] = execution_multiplier
	settings[EXECUTION_MULTIPLIER_HIGH] = execution_multiplier
	log_storyteller("\[[name]\] set execution multiplier to [execution_multiplier]")


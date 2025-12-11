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

	var/drought_cooldown = 5 MINUTES
	var/last_drought = 0

/datum/storyteller/drought/initialize()
	. = ..()
	last_drought = world.time

/datum/storyteller/drought/fire(seconds_per_tick)
	last_drought = seconds_per_tick * 10
	if(last_drought < drought_cooldown)
		return
	last_drought = 0
	var/execution_multiplier = settings[EXECUTION_MULTIPLIER_LOW]
	execution_multiplier *= 1.3
	settings[EXECUTION_MULTIPLIER_LOW] = execution_multiplier
	settings[EXECUTION_MULTIPLIER_HIGH] = execution_multiplier
	log_storyteller("\[[name]\] set execution multiplier to [execution_multiplier]")


/datum/storyteller/descent
	name = STORYTELLER_DESCENT
	config_tag = STORYTELLER_DESCENT
	desc = "The Descent starts slowly, but gradually lowers the cooldown between events as the shift progresses. By the end, it creates a non-stop barrage of chaos."
	welcome_text = "Gravity is increasing. The slide into chaos has begun. Pace yourselves."

	population_min = 30
	weight = 1

	var/descent_cooldown = 10 MINUTES
	var/last_descent = 0

/datum/storyteller/descent/initialize()
	. = ..()
	last_descent = world.time

/datum/storyteller/descent/fire(seconds_per_tick)
	last_descent = seconds_per_tick * 10
	if(last_descent < descent_cooldown)
		return
	last_descent = 0
	var/execution_multiplier = settings[EXECUTION_MULTIPLIER_LOW]
	execution_multiplier *= 0.9
	settings[EXECUTION_MULTIPLIER_LOW] = execution_multiplier
	settings[EXECUTION_MULTIPLIER_HIGH] = execution_multiplier
	log_storyteller("\[[name]\] set execution multiplier to [execution_multiplier]")


/datum/storyteller/descent
	name = STORYTELLER_DESCENT
	config_tag = STORYTELLER_DESCENT
	desc = "The Descent starts slowly, but gradually lowers the cooldown between events as the shift progresses. By the end, it creates a non-stop barrage of chaos."
	welcome_text = "Gravity is increasing. The slide into chaos has begun. Pace yourselves."

	population_min = 30
	weight = 1

	COOLDOWN_DECLARE(descent_cooldown)

	var/cooldown_duration = 10 MINUTES

/datum/storyteller/descent/initialize()
	. = ..()
	COOLDOWN_START(src, descent_cooldown, cooldown_duration)

/datum/storyteller/descent/fire(seconds_per_tick)
	if(!COOLDOWN_FINISHED(src, descent_cooldown))
		return

	COOLDOWN_START(src, descent_cooldown, cooldown_duration)
	var/execution_multiplier = settings[EXECUTION_MULTIPLIER_LOW]
	execution_multiplier *= 0.9
	settings[EXECUTION_MULTIPLIER_LOW] = execution_multiplier
	settings[EXECUTION_MULTIPLIER_HIGH] = execution_multiplier
	log_storyteller("\[[name]\] set execution multiplier to [execution_multiplier]")


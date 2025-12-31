/datum/storyteller/betrayer
	name = STORYTELLER_BETRAYER
	config_tag = STORYTELLER_BETRAYER
	desc = "The Betrayer lulls the crew into a false sense of security with a peaceful start, only to violently switch to maximum hostility halfway through the shift."
	welcome_text = "Everything looks perfect. Too perfect. Enjoy the peace while it lasts."
	midround_settings = list(
		list(
			STORYTELLER_EVENT_WEIGHT_MULTIPLIERS = list(
				EVENT_TRACK_MUNDANE = 10,
				EVENT_TRACK_MODERATE = 2,
				EVENT_TRACK_MAJOR = 0,
				EVENT_TRACK_ROLESET = 0,
			),
			STORYTELLER_TAG_MULTIPLIERS = list(TAG_POSITIVE = 100),
			TIME_THRESHOLD = 30 MINUTES,
		),
		list(
			STORYTELLER_EVENT_WEIGHT_MULTIPLIERS = list(
				EVENT_TRACK_MUNDANE = 0,
				EVENT_TRACK_MODERATE = 1,
				EVENT_TRACK_MAJOR = 100,
				EVENT_TRACK_ROLESET = 100,
			),
			STORYTELLER_TAG_MULTIPLIERS = list(TAG_POSITIVE = 0),
			TIME_THRESHOLD = INFINITY, // rest of the round
		)
	)
	population_min = 40
	weight = 1

/datum/storyteller/betrayer/initialize()
	. = ..()
	var/positive_time = rand(30 MINUTES, 50 MINUTES)
	midround_settings[1][TIME_THRESHOLD] = positive_time
	log_storyteller("- Storyteller \[[name]\] Positive Time: [positive_time]")

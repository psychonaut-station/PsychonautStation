/datum/storyteller/hermit
	name = STORYTELLER_HERMIT
	config_tag = STORYTELLER_HERMIT
	desc = "The Hermit will create mostly internal conflict around the station, and rarely any external threats."
	event_repetition_multiplier = 1.3 //Hermit has a smaller event pool, let it repeat a bit more
	event_weight_multipliers = list(
		EVENT_TRACK_MUNDANE = 1.2,
		EVENT_TRACK_MODERATE = 1.1,
		EVENT_TRACK_MAJOR = 0.9,
		EVENT_TRACK_ROLESET = 0.9,
	)
	tag_multipliers = list(TAG_EXTERNAL = 0.2, TAG_OUTSIDER_ANTAG = 0.8)
	weight = 3

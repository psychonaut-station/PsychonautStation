/datum/storyteller/operative
	name = STORYTELLER_OPERATIVE
	config_tag = STORYTELLER_OPERATIVE
	desc = "The Operative tries to create more direct confrontation with human threats."
	welcome_text = "The eyes of multiple organizations have been set on the station."
	event_weight_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_MAJOR = 1,
		EVENT_TRACK_ROLESET = 1.1,
	)
	tag_multipliers = list(TAG_ALIEN = 0.4, TAG_CREW_ANTAG = 1.5)
	restricted = TRUE
	population_min = 45
	weight = 1

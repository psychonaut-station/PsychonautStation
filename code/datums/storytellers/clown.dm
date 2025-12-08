/datum/storyteller/clown
	name = STORYTELLER_CLOWN
	config_tag = STORYTELLER_CLOWN
	desc = "The clown creates mostly harmless events, its all fun and games with this one!"
	welcome_text = "HONKHONKHONKHONKHONK!"
	event_weight_multipliers = list(
		EVENT_TRACK_MUNDANE = 5, //admin only, welcome to hell
		EVENT_TRACK_MODERATE = 4,
		EVENT_TRACK_MAJOR = 0.3,
		EVENT_TRACK_ROLESET = 1,
	)

	extra_settings = list(
		LOW_END = 4, //admin only, welcome to hell
		HIGH_END = 2,
		EXECUTION_MULTIPLIER_LOW = 1,
		EXECUTION_MULTIPLIER_HIGH = 1,
	)

	event_repetition_multipliers = 0
	tag_multipliers = list(TAG_COMMUNAL = 1.1, TAG_SPOOKY = 1.2)
	restricted = TRUE //admins can still use this if they want the crew to really suffer, for that reason im going all in

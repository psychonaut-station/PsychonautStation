/datum/storyteller/sleeper
	name = STORYTELLER_SLEEPER
	config_tag = STORYTELLER_SLEEPER
	desc = "The Sleeper will create less impactful events, especially ones involving combat or destruction. The chill experience."
	welcome_text = "The day is going slowly."
	event_weight_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_MODERATE = 1.2,
		EVENT_TRACK_MAJOR = 1.2,
		EVENT_TRACK_ROLESET = 0.1, ///rolesets are entirely evil atm so crank this down
	)
	tag_multipliers = list(TAG_COMBAT = 0.6, TAG_DESTRUCTIVE = 0.7, TAG_POSITIVE = 1.2)
	weight = 2

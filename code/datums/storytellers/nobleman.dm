/datum/storyteller/nobleman
	name = STORYTELLER_NOBLEMAN
	config_tag = STORYTELLER_NOBLEMAN
	desc = "The Nobleman enjoys a good fight but abhors senseless destruction. Prefers heavy hits on single targets."
	event_weight_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_MODERATE = 1.2,
		EVENT_TRACK_MAJOR = 1.15,
		EVENT_TRACK_ROLESET = 1,
		)
	tag_multipliers = list(TAG_COMBAT = 1.4, TAG_DESTRUCTIVE = 0.4, TAG_TARGETED = 1.2)
	population_min = 25 //combat based so we should have some kind of min pop(even if low)
	weight = 3

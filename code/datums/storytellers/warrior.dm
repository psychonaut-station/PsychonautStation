/datum/storyteller/warrior
	name = STORYTELLER_WARRIOR
	config_tag = STORYTELLER_WARRIOR
	desc = "The Warrior will create more impactful events, often focused on combat."
	event_weight_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_MODERATE = 1.3,
		EVENT_TRACK_MAJOR = 1.3,
		EVENT_TRACK_ROLESET = 1,
		)
	tag_multipliers = list(TAG_COMBAT = 1.5)
	population_min = 40
	welcome_text = "You feel like a fight is brewing."
	weight = 1

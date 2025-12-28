/datum/storyteller/specialist
	name = STORYTELLER_SPECIALIST
	config_tag = STORYTELLER_SPECIALIST
	desc = "The Specialist selects a specific pair of event themes for the shift, virtually ignoring all other threat types."
	welcome_text = "Operational parameters have been narrowed. Expect a highly specific threat profile."
	settings = list(
		STORYTELLER_TAG_MULTIPLIERS = list(),
	)
	population_min = 40
	weight = 1

/datum/storyteller/specialist/initialize()
	. = ..()
	var/list/possible_tags = ALL_STORYTELLER_TAGS
	var/first_tag = pick_n_take(possible_tags)
	var/second_tag = pick_n_take(possible_tags)
	var/list/weighted_list = list(
		first_tag = 100,
		second_tag = 100
	)
	for(var/tag in possible_tags)
		weighted_list[tag] = 0
	settings[STORYTELLER_TAG_MULTIPLIERS] = weighted_list
	log_storyteller("- Storyteller \[[name]\] Selected Tags: 1. [first_tag]")
	log_storyteller("- Storyteller \[[name]\] Selected Tags: 2. [second_tag]")

/datum/storyteller/timekeepers
	settings = list(
		EXECUTION_MULTIPLIER_LOW = 0.7,
		EXECUTION_MULTIPLIER_HIGH = 0.7,
	)
	restricted = TRUE // admin only
	var/list/categories

/datum/storyteller/timekeepers/initialize()
	. = ..()
	if(!islist(categories))
		categories = list(categories)

/datum/storyteller/timekeepers/set_tier(list/ruleset_to_spawn)
	var/list/new_ruleset = list()
	var/ruleset_count = 0
	for(var/category in ruleset_to_spawn)
		if(!categories.Find(category))
			ruleset_count += ruleset_to_spawn[category]
			new_ruleset[category] = 0

	ruleset_count /= length(categories)

	for(var/category in categories)
		new_ruleset[category] = ruleset_to_spawn[category] + ruleset_count
		log_storyteller("- Storyteller \[[name]\] set [category] ruleset count to [new_ruleset[category]]")

	return new_ruleset

/datum/storyteller/timekeepers/roundstart
	name = STORYTELLER_VANGUARD
	config_tag = STORYTELLER_VANGUARD
	desc = "The Vanguard doesn't believe in buildup. It front-loads all major threats at the very beginning of the shift. Survive the first 15 minutes, and you might just survive the whole shift."
	welcome_text = "Strike hard, strike fast. The worst is already upon you."
	categories = ROUNDSTART

/datum/storyteller/timekeepers/latejoin
	name = STORYTELLER_GATEKEEPER
	config_tag = STORYTELLER_GATEKEEPER
	desc = "The Gatekeeper ignores the initial crew. Instead, it targets the arrivals shuttle. Every new crewmember is a potential threat, and every docking procedure brings a new disaster."
	welcome_text = "Station population is stable. Monitoring incoming traffic for... anomalies."
	categories = LATEJOIN

/datum/storyteller/timekeepers/midround
	name = STORYTELLER_AMBUSH
	config_tag = STORYTELLER_AMBUSH
	desc = "The Ambush grants you a peaceful start to set up defenses, and a quiet end to evacuate. But the middle of the shift? That belongs to chaos."
	welcome_text = "Get comfortable. You will need your strength for what comes next."
	categories = list(LIGHT_MIDROUND, HEAVY_MIDROUND)

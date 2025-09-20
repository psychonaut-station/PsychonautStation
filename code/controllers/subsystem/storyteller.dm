SUBSYSTEM_DEF(storyteller)
	name = "Storyteller"
	flags = SS_NO_FIRE
	init_stage = INITSTAGE_EARLY

	var/datum/storyteller/current_storyteller

	var/list/storyteller_prototypes = list()
	var/list/storyteller_namelist = list()

/datum/controller/subsystem/storyteller/Initialize()
	var/list/dynamic_config = SSdynamic.get_config()
	storyteller_prototypes = init_storyteller_prototypes(dynamic_config)
	storyteller_namelist = init_storyteller_namelist()
	if(CONFIG_GET(flag/enable_storyteller))
		load_storyteller(dynamic_config)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/storyteller/proc/init_storyteller_prototypes(list/dynamic_config)
	. = list()
	for(var/datum/storyteller/storyteller_type as anything in subtypesof(/datum/storyteller))
		var/datum/storyteller/storyteller = new storyteller_type(dynamic_config)
		. += storyteller

/datum/controller/subsystem/storyteller/proc/init_storyteller_namelist()
	. = list()
	for(var/datum/storyteller/storyteller as anything in storyteller_prototypes)
		.[storyteller.name] = storyteller

/datum/controller/subsystem/storyteller/proc/load_storyteller(list/dynamic_config)
	var/selected_storyteller_name = trim(file2text("data/next_round_storyteller.txt"))

	var/datum/storyteller/selected_storyteller

	if(!selected_storyteller_name || !storyteller_namelist[selected_storyteller_name])
		var/list/storyteller_entries = get_valid_storytellers(weighted = TRUE)
		selected_storyteller_name = pick_weight(storyteller_entries)

	selected_storyteller = storyteller_namelist[selected_storyteller_name]
	var/list/config = SSdynamic.get_config()
	current_storyteller = new selected_storyteller.type(config)
	log_game("Storyteller loaded: [current_storyteller.name]")

/datum/controller/subsystem/storyteller/proc/get_valid_storytellers(weighted = FALSE)
	var/filter_threshold = 0
	if(SSticker.HasRoundStarted())
		filter_threshold = get_active_player_count(alive_check = FALSE, afk_check = TRUE, human_check = FALSE)
	else
		filter_threshold = length(GLOB.clients)

	var/list/valid_storytellers = list()
	var/list/storytellers = shuffle(storyteller_prototypes)

	for(var/datum/storyteller/storyteller in storytellers)
		if(storyteller.always_votable)
			if(weighted)
				valid_storytellers[storyteller.name] = storyteller.weight
			else
				valid_storytellers += storyteller.name
			continue
		if(storyteller.restricted)
			continue
		if(storyteller.population_min > 0 && filter_threshold < storyteller.population_min)
			continue
		if(storyteller.population_max > 0 && filter_threshold > storyteller.population_max)
			continue
		if(weighted)
			valid_storytellers[storyteller.name] = storyteller.weight
		else
			valid_storytellers += storyteller.name

	return valid_storytellers

/datum/controller/subsystem/storyteller/proc/storyteller_desc(storyteller_name)
	. = null
	var/datum/storyteller/storyboy = storyteller_namelist[storyteller_name]
	if(storyboy)
		return storyboy.desc

/datum/controller/subsystem/storyteller/proc/admin_set_storyteller(datum/storyteller/storyteller_type)
	var/list/config = SSdynamic.get_config()
	var/datum/storyteller/old_storyteller = current_storyteller
	current_storyteller = new storyteller_type(config)
	SSdynamic.set_tier(SSdynamic.current_tier.type, SSticker.totalPlayersReady) //Reload the dynamic tier
	qdel(old_storyteller)

/datum/controller/subsystem/storyteller/Recover()
	current_storyteller = SSstoryteller.current_storyteller
	storyteller_prototypes = SSstoryteller.storyteller_prototypes
	storyteller_namelist = SSstoryteller.storyteller_namelist

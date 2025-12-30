SUBSYSTEM_DEF(storyteller)
	name = "Storyteller"
	wait = 30 SECONDS
	init_stage = INITSTAGE_EARLY

	var/datum/storyteller/current_storyteller

	var/datum/storyteller/next_storyteller

	var/list/storyteller_prototypes = list()
	var/list/storyteller_namelist = list()

/datum/controller/subsystem/storyteller/Initialize()
	var/list/dynamic_config = SSdynamic.get_config()
	storyteller_prototypes = init_storyteller_prototypes(dynamic_config)
	storyteller_namelist = init_storyteller_namelist()
	if(CONFIG_GET(flag/enable_storyteller))
		load_storyteller(dynamic_config)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/storyteller/fire(resumed)
	if(isnull(current_storyteller))
		return
	current_storyteller.fire(wait * 0.1)

/datum/controller/subsystem/storyteller/proc/init_storyteller_prototypes(list/dynamic_config)
	. = list()
	for(var/datum/storyteller/storyteller_type as anything in subtypesof(/datum/storyteller))
		if(isnull(storyteller_type::config_tag))
			continue
		var/datum/storyteller/storyteller = new storyteller_type(dynamic_config)
		. += storyteller

/datum/controller/subsystem/storyteller/proc/init_storyteller_namelist()
	. = list()
	for(var/datum/storyteller/storyteller as anything in storyteller_prototypes)
		.[storyteller.name] = storyteller

/datum/controller/subsystem/storyteller/proc/load_storyteller(list/dynamic_config)
	var/default_storyteller = CONFIG_GET(string/default_storyteller)

	var/list/storyteller_data = load_storyteller_data() // Load storyteller from data/next_round_storyteller.json
	var/selected_storyteller_name = storyteller_data["name"]
	var/forced = storyteller_data["forced"]

	var/select_random = FALSE
	var/selected_by = forced ? "Admin" : "Voting"

	if((!(CONFIG_GET(flag/auto_vote_storyteller) || CONFIG_GET(flag/allow_storyteller_vote)) && !forced) || !storyteller_namelist[selected_storyteller_name]) //If (its not chosen by admin and not chosen by players) or its not a valid storyteller, make it randomised
		if(!storyteller_namelist[selected_storyteller_name] && !isnull(selected_storyteller_name))
			stack_trace("Storyteller: [selected_storyteller_name] is not a valid storyteller!")
		select_random = TRUE
		selected_by = "Randomly"

	if(default_storyteller != "Random" && storyteller_namelist[default_storyteller] && select_random) //If default_storyteller is not "Random" and its a valid storyteller and select_random is true, use it
		selected_storyteller_name = default_storyteller
		select_random = FALSE
		selected_by = "Default"

	if(select_random)
		var/list/storyteller_entries = get_valid_storytellers(weighted = TRUE)
		selected_storyteller_name = pick_weight(storyteller_entries)

	var/datum/storyteller/selected_storyteller = storyteller_namelist[selected_storyteller_name]
	var/list/config = SSdynamic.get_config()
	current_storyteller = new selected_storyteller.type(config)
	post_load_storyteller(selected_by)

/datum/controller/subsystem/storyteller/proc/load_storyteller_data()
	var/json_file = file("data/next_round_storyteller.json")
	if(!fexists(json_file))
		return list()

	return json_decode(file2text(json_file))

/datum/controller/subsystem/storyteller/proc/post_load_storyteller(selected_by)
	log_storyteller("Storyteller loading: [current_storyteller.name]")
	current_storyteller.initialize()
	log_game("Storyteller loaded: [current_storyteller.name]")
	log_storyteller("Storyteller loaded: [current_storyteller.name]")
	log_storyteller("- Selected by: [selected_by]")
	SSblackbox.record_feedback(
		"associative",
		"storyteller",
		1,
		list(
			"server_name" = CONFIG_GET(string/serversqlname),
			"name" = current_storyteller.name,
			"selectedby" = selected_by
		)
	)

/datum/controller/subsystem/storyteller/proc/get_valid_storytellers(weighted = FALSE)
	var/filter_threshold = 0
	if(SSticker.HasRoundStarted())
		filter_threshold = get_active_player_count(alive_check = FALSE, afk_check = TRUE, human_check = FALSE)
	else
		filter_threshold = length(GLOB.clients)

	var/list/valid_storytellers = list()
	var/list/storytellers = shuffle(storyteller_prototypes)

	for(var/datum/storyteller/storyteller in storytellers)
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

/datum/controller/subsystem/storyteller/proc/set_storyteller(storyteller_name, for_current_round = FALSE, forced = FALSE)
	. = TRUE
	var/list/config = SSdynamic.get_config()
	var/datum/storyteller/storyteller_prototype = storyteller_namelist[storyteller_name]
	if(isnull(storyteller_prototype))
		stack_trace("Storyteller: [storyteller_name] is not a valid storyteller!")
		return FALSE
	var/user = forced ? key_name_admin(usr) : "\[\"Voting\"\]"
	if(for_current_round) //If the proc called for the current round, change it immediately
		var/datum/storyteller/old_storyteller = current_storyteller
		current_storyteller = new storyteller_prototype.type(config)
		if(!isnull(SSdynamic.current_tier))
			SSdynamic.set_tier(SSdynamic.current_tier.type, SSticker.totalPlayersReady) //Reload the dynamic tier
		qdel(old_storyteller)
		message_admins("[user] changed storyteller to [storyteller_name].")
		log_admin("[user] changed storyteller to [storyteller_name].")
		post_load_storyteller("Admin")
	else //If the proc called for the next round, save it to json
		var/datum/storyteller/old_storyteller = next_storyteller
		next_storyteller = new storyteller_prototype.type //No need to use config, it will handle in the next round
		var/list/next_storyteller_data = list(
			"name" = storyteller_name,
			"forced" = forced
		)
		var/next_storyteller_file = "data/next_round_storyteller.json"
		if (fexists(next_storyteller_file))
			fdel(next_storyteller_file)
		WRITE_FILE(file(next_storyteller_file), json_encode(next_storyteller_data, JSON_PRETTY_PRINT))
		qdel(old_storyteller)
		message_admins("[user] set next round's storyteller to [storyteller_name].")
		log_admin("[user] set next round's storyteller to [storyteller_name].")

/datum/controller/subsystem/storyteller/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, current_storyteller))
		return FALSE
	if(var_name == NAMEOF(src, next_storyteller))
		return FALSE
	return ..()

/datum/controller/subsystem/storyteller/Recover()
	current_storyteller = SSstoryteller.current_storyteller
	storyteller_prototypes = SSstoryteller.storyteller_prototypes
	storyteller_namelist = SSstoryteller.storyteller_namelist

/datum/teammatch_lobby
	var/uid = 0
	///The amount of teammatch games that have been created this round
	var/static/gl_uid = 1

	/// Ckey of the host
	var/host
	/// Assoc list of ckey to list()
	var/list/players = list()
	/// Assoc list of ckey to list()
	var/list/observers = list()

	var/list/teams = list()
	var/list/living_players = list()
	/// The current chosen map
	var/datum/lazy_template/teammatch/map
	var/datum/turf_reservation/location
	var/datum/teammatch_scenerio/scenerio
	/// Whether the lobby is currently playing
	var/playing = TEAMMATCH_NOT_PLAYING
	/// Number of total ready players
	var/ready_count = 0
	var/alist/team_spawns = alist()
	/// artificial time padding when we start loading to give lighting a breather (admin starts will set this to 0)
	var/start_time = 5 SECONDS
	var/start_timer
	var/datum/minimap/minimap
	var/alist/loadout_amounts = alist()

/datum/teammatch_lobby/New(mob/player)
	. = ..()
	if (!player)
		stack_trace("Attempted to create a teammatch lobby without a host.")
		return qdel(src)
	host = player.ckey
	set_scenerio(pick(GLOB.teammatch_game.get_allowed_scenerios()))
	if(isnull(scenerio))
		stack_trace("Attempted to create a teammatch lobby without any scenerio")
		return qdel(src)
	map = GLOB.teammatch_game.maps[pick(scenerio.maps)]
	log_game("[host] created a teammatch lobby.")

	var/datum/teammatch_team/first_team = scenerio.teams[1]
	add_player(player, first_team::default_loadout, first_team, TRUE)

	ui_interact(player)
	addtimer(CALLBACK(src, PROC_REF(lobby_afk_probably)), 5 MINUTES) // being generous here
	uid = "teammatch_[gl_uid++]"

/datum/teammatch_lobby/Destroy(force, ...)
	. = ..()
	for (var/key in players+observers)
		var/datum/tgui/ui = SStgui.get_open_ui(get_mob_by_ckey(key), src)
		if (ui) ui.close()
		remove_ckey_from_play(key)
	if(playing && !isnull(location))
		INVOKE_ASYNC(src, PROC_REF(clear_reservation), location)
	players = null
	observers = null
	QDEL_NULL(scenerio)
	QDEL_LIST_ASSOC_VAL(teams)
	QDEL_LAZYASSOCLIST(team_spawns)
	teams = null
	living_players = null
	loadout_amounts = null
	map?.template_in_use = FALSE //just incase
	map = null
	location = null
	deltimer(start_timer)
	start_timer = null
	delete_minimap(minimap)
	minimap = null

/datum/teammatch_lobby/proc/start_game()
	if (playing)
		return

	if(map.template_in_use)
		to_chat(get_mob_by_ckey(host), span_warning("This map is currently loading for another lobby. Please wait until that other map finishes loading. It would be a disaster if these two mixed up."))
		return


	playing = TEAMMATCH_PRE_PLAYING

	map.template_in_use = TRUE
	RegisterSignal(map, COMSIG_LAZY_TEMPLATE_LOADED, PROC_REF(map_loaded))
	location = map.lazy_load()
	GLOB.teammatch_game.active_scenerios |= scenerio
	if (!location)
		map.template_in_use = FALSE
		UnregisterSignal(map, COMSIG_LAZY_TEMPLATE_LOADED)
		to_chat(get_mob_by_ckey(host), span_warning("Couldn't reserve/load a map location (all locations used?), try again later, or contact a coder."))
		playing = FALSE
		clear_reservation()
		return

	start_timer = addtimer(CALLBACK(src, PROC_REF(start_game_after_delay)), start_time, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE)

/datum/teammatch_lobby/proc/map_loaded(datum/lazy_template/teammatch/source, list/atoms, list/turfs, list/areas)
	SIGNAL_HANDLER
	var/alist/tables = list()
	for(var/thing in atoms)
		if(istype(thing, /obj/effect/landmark/teammatch_player_spawn))
			var/obj/effect/landmark/teammatch_player_spawn/spawner = thing
			LAZYORASSOCLIST(team_spawns, spawner.team_type, thing)
		else if(istype(thing, /obj/effect/landmark/minimap_spawner))
			var/obj/effect/landmark/minimap_spawner/spawner = thing
			tables["[spawner.id]"] = new scenerio.minimap_table_type (get_turf(spawner))
			qdel(spawner)

	scenerio.process_atoms(src, source, atoms)

	INVOKE_ASYNC(src, PROC_REF(setup_minimap), tables, turfs)

	if(istype(source))
		UnregisterSignal(source, COMSIG_LAZY_TEMPLATE_LOADED)
		source.template_in_use = FALSE

/datum/teammatch_lobby/proc/setup_minimap(list/tables, list/turfs)
	if(!scenerio.has_minimap)
		return
	var/turf/any_turf = turfs[1]
	minimap = get_minimap_for_z(any_turf.z, uid, turfs)
	for(var/table_id in tables)
		var/obj/machinery/minimap_table/table = tables[table_id]
		table.target_z_level = any_turf.z
		table.fixed_id = "[uid]"
		table.team_id = table_id
		table.minimap = minimap

/datum/teammatch_lobby/proc/start_game_after_delay()
	if (!length(team_spawns))
		stack_trace("Failed to get enough team spawns when loading teammatch map [map.name] for lobby [host].")
		clear_reservation(location)
		playing = FALSE
		return FALSE

	for (var/team_type in scenerio.teams)
		teams[team_type] = new team_type(FALSE)

	var/list/candidates_by_loadout = list()
	var/list/final_loadouts = list()

	for(var/key in players)
		var/loadout = players[key]["loadout"]
		if(!loadout)
			continue

		if(!candidates_by_loadout[loadout])
			candidates_by_loadout[loadout] = list()
		candidates_by_loadout[loadout] += key

	for(var/datum/teammatch_team/team_type as anything in teams)
		var/datum/teammatch_team/team = get_team(team_type)

		loadout_amounts[team_type] = alist()

		for(var/datum/outfit/teammatch_loadout/loadout_type as anything in team.loadouts)
			var/amount = team.loadouts[loadout_type]
			var/list/candidates = candidates_by_loadout[loadout_type]

			if(!length(candidates))
				loadout_amounts[team_type][loadout_type] = amount
				continue

			if(amount == -1)
				for(var/key in candidates)
					final_loadouts[key] = loadout_type

				loadout_amounts[team_type][loadout_type] = -1

			else if(length(candidates) <= amount)
				for(var/key in candidates)
					final_loadouts[key] = loadout_type

				loadout_amounts[team_type][loadout_type] = amount - length(candidates)
			else
				var/list/winners = pick_n(candidates, amount)
				var/list/losers = candidates - winners

				for(var/key in winners)
					final_loadouts[key] = loadout_type

				for(var/key in losers)
					final_loadouts[key] = team.default_loadout

				loadout_amounts[team_type][loadout_type] = 0

			candidates_by_loadout -= loadout_type

	for (var/key in players)
		var/datum/weakref/observer_ref = players[key]["mob"]
		var/mob/dead/observer/observer = observer_ref?.resolve()
		if (isnull(observer) || !observer.client)
			log_game("Removed player [key] from teammatch lobby [host], as they couldn't be found.")
			remove_ckey_from_play(key)
			continue

		var/datum/outfit/teammatch_loadout/loadout = final_loadouts[key]

		var/player_team = players[key]["team"]
		var/picked_spawn = pick(LAZYACCESS(team_spawns, player_team))
		var/turf/spawn_turf = get_turf(picked_spawn)
		spawn_observer_as_player(key, spawn_turf, loadout)

	for (var/observer_key in observers)
		var/datum/weakref/observer_ref = observers[observer_key]["mob"]
		var/mob/observer = observer_ref?.resolve()
		observer.forceMove(pick(location.reserved_turfs))

	playing = TEAMMATCH_PLAYING
	log_game("Teammatch game [host] started.")
	announce(span_reallybig("GO!"))

	scenerio.post_start(src)

	return TRUE

/datum/teammatch_lobby/proc/spawn_observer_as_player(ckey, turf/loc, datum/outfit/teammatch_loadout/loadout, is_respawn = FALSE)
	if(isnull(loc))
		return FALSE
	var/list/players_info = players[ckey]

	var/team_type = players_info["team"]
	var/datum/teammatch_team/team = teams[team_type]

	if(is_respawn && !team.can_respawn())
		return FALSE

	var/datum/weakref/observer_ref = players_info["mob"]
	var/mob/dead/observer/observer = observer_ref?.resolve()

	if (isnull(observer) || !observer.client)
		remove_ckey_from_play(ckey)
		return FALSE

	if(is_respawn)
		team.start_respawn_timer()

	var/list/loadouts = team.loadouts

	if (!(loadout in loadouts))
		loadout = team.default_loadout

	var/mob/mob_type = loadout.mob_override || /mob/living/carbon/human

	if(!ispath(mob_type, /mob/living))
		stack_trace("Teammatch loadout [loadout.display_name] - non-living mob type detected")
		mob_type = /mob/living/carbon/human

	var/mob/living/new_player = new mob_type(loc)

	if(ishuman(new_player))
		observer.client?.prefs.safe_transfer_prefs_to(new_player)

	if(iscarbon(new_player))
		var/mob/living/carbon/carbon_player = new_player
		carbon_player.dna?.update_dna_identity()
		carbon_player.updateappearance(icon_update = TRUE, mutcolor_update = TRUE, mutations_overlay_update = TRUE)

	new_player.add_traits(list(TRAIT_CANNOT_CRYSTALIZE, TRAIT_PERMANENTLY_MORTAL, TRAIT_TEMPORARY_BODY), INNATE_TRAIT)

	if(observer.mind)
		new_player.AddComponent( \
			/datum/component/temporary_body, \
			old_mind = observer.mind, \
		)

	if(ishuman(new_player))
		var/mob/living/carbon/human/human_player = new_player
		human_player.equipOutfit(loadout)

	new_player.PossessByPlayer(ckey)

	scenerio.player_spawned(src, new_player, loadout, team)

	team.after_spawn(src, scenerio, new_player, loadout)

	living_players |= ckey

	team.add_player(ckey)

	players_info["mob"] = WEAKREF(new_player)

	register_player_signals(new_player)
	return TRUE

/datum/teammatch_lobby/proc/register_player_signals(new_player, from_revive = FALSE)
	RegisterSignals(new_player, list(COMSIG_QDELETING, COMSIG_MOB_GHOSTIZED, COMSIG_LIVING_DEATH), PROC_REF(player_died))
	RegisterSignal(new_player, COMSIG_MOB_MIND_TRANSFERRED_OUT_OF, PROC_REF(mind_transfered))
	if(!from_revive)
		RegisterSignal(new_player, COMSIG_LIVING_REVIVE, PROC_REF(player_revived))

/datum/teammatch_lobby/proc/unregister_player_signals(new_player, can_revive = FALSE)
	UnregisterSignal(new_player, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING, COMSIG_MOB_GHOSTIZED, COMSIG_MOB_MIND_TRANSFERRED_OUT_OF))
	if(!can_revive)
		UnregisterSignal(new_player, COMSIG_LIVING_REVIVE)

/datum/teammatch_lobby/proc/lobby_afk_probably()
	if (QDELING(src) || playing)
		return
	announce(span_warning("Lobby ([host]) was closed due to not starting after 5 minutes, being potentially AFK. Please be faster next time."))
	GLOB.teammatch_game.remove_lobby(host)

/datum/teammatch_lobby/proc/mind_transfered(mob/living/old_body, mob/living/new_body, datum/mind/swapping)
	SIGNAL_HANDLER
	unregister_player_signals(old_body)
	players[new_body.ckey]["mob"] = WEAKREF(new_body)
	register_player_signals(new_body)

/datum/teammatch_lobby/proc/player_died(mob/living/player)
	SIGNAL_HANDLER
	if(isnull(player) || QDELING(src) || HAS_TRAIT_FROM(player, TRAIT_NO_TRANSFORM, MAGIC_TRAIT))
		return

	var/ckey = player.ckey ? player.ckey : player.mind?.key
	if(!islist(players[ckey]))
		for(var/potential_ckey in players)
			var/list/player_info = players[potential_ckey]
			var/datum/weakref/mob_weakref = player_info["mob"]
			if(mob_weakref && mob_weakref == WEAKREF(player))
				ckey = potential_ckey
				break

	if(!islist(players[ckey]) || !(ckey in living_players))
		return

	living_players -= ckey

	var/team_type = players[ckey]["team"]
	var/datum/teammatch_team/team = get_team(team_type)

	team.remove_player(ckey)

	var/mob/dead/observer/ghost = !player.client ? player.get_ghost() : player.ghostize()

	var/can_reenter_corpse = ghost?.can_reenter_corpse || FALSE

	if(!isnull(ghost))
		if(can_reenter_corpse)
			players[ckey]["dead_mob"] = players[ckey]["dead_mob"] || players[ckey]["mob"]
		players[ckey]["mob"] = WEAKREF(ghost)

	unregister_player_signals(player, can_reenter_corpse)

	if(LAZYLEN(team.players) == 0)
		team_lost(team_type)

/datum/teammatch_lobby/proc/player_revived(mob/living/player, revive_flags)
	SIGNAL_HANDLER
	if(isnull(player) || QDELING(src))
		return
	var/ckey = player.ckey ? player.ckey : player.mind?.key
	if(!islist(players[ckey]))
		for(var/potential_ckey in players)
			var/list/player_info = players[potential_ckey]
			var/datum/weakref/mob_weakref = player_info["dead_mob"]
			if(mob_weakref && mob_weakref == WEAKREF(player))
				ckey = potential_ckey
				break

	if(!islist(players[ckey]))
		return

	var/team_type = players[ckey]["team"]
	var/datum/teammatch_team/team = get_team(team_type)

	players[ckey]["dead_mob"] = null
	players[ckey]["mob"] = player

	living_players |= ckey
	team.add_player(ckey)

	register_player_signals(player, TRUE)

/datum/teammatch_lobby/proc/team_lost(datum/teammatch_team/team_type)
	if(playing != TEAMMATCH_PLAYING)
		CRASH("Team lost but game is not started yet!")
	if(!(team_type in teams))
		CRASH("Team lost but not found in teams list")

	var/datum/teammatch_team/team = get_team(team_type)

	team.active = FALSE

	var/list/important_teams = list()
	for(var/datum/teammatch_team/teammatch_team in teams)
		if(teammatch_team.important_team)
			important_teams |= teammatch_team

	if(length(important_teams) <= 1)
		end_game()

/datum/teammatch_lobby/proc/end_game(wintext)
	if (!location)
		CRASH("Reservation of teammatch game [host] deleted during game.")

	announce(span_reallybig("GAME ENDED. [wintext ? "<BR>[wintext]" : ""]"))

	for(var/ckey in players)
		var/datum/weakref/mob_weakref = players[ckey]["mob"]
		var/mob/loser = mob_weakref.resolve()
		if(isliving(loser))
			unregister_player_signals(loser)
			loser.ghostize(can_reenter_corpse = FALSE)
			qdel(loser)
		players[ckey]["mob"] = null

	GLOB.teammatch_game.remove_lobby(host)
	log_game("Teammatch game [host] ended.")

/datum/teammatch_lobby/proc/add_player(mob/mob, loadout, team, host = FALSE, ready = FALSE)
	if (observers[mob.ckey])
		CRASH("Tried to add [mob.ckey] as a player while being an observer.")
	var/list/player_data = list("mob" = WEAKREF(mob), "dead_mob" = null, "host" = host, "ready" = ready, "team" = team, "loadout" = loadout)
	players[mob.ckey] = player_data
	ready_count += ready

/datum/teammatch_lobby/proc/add_observer(mob/mob, host = FALSE)
	if(players[mob.ckey])
		CRASH("Tried to add [mob.ckey] as an observer while being a player.")
	var/list/observer_data = list("mob" = WEAKREF(mob), "host" = host)
	observers[mob.ckey] = observer_data

/datum/teammatch_lobby/proc/remove_ckey_from_play(ckey)
	var/is_likely_player = (ckey in players)
	var/list/main_list = is_likely_player ? players : observers
	var/list/info = main_list[ckey]
	if(is_likely_player && islist(info))
		ready_count -= info["ready"]
	main_list -= ckey

/datum/teammatch_lobby/proc/change_team(mob/mob, ckey, new_team)
	if((ckey in living_players) || isnull(new_team))
		return FALSE
	var/datum/teammatch_team/team = get_team(new_team)
	if(!team.active || (team.max_players != -1 && team.max_players <= get_team_players(new_team)))
		return FALSE

	var/is_likely_player = (ckey in players)
	var/list/main_list = is_likely_player ? players : observers
	var/list/info = main_list[ckey]
	var/is_readied = FALSE
	if(islist(info))
		is_readied = info["ready"]
		if(isnull(mob))
			var/datum/weakref/mob_weakref = info["mob"]
			mob = mob_weakref?.resolve()
	var/datum/outfit/teammatch_loadout/default_loadout = team.default_loadout
	remove_ckey_from_play(ckey)
	add_player(mob, default_loadout, new_team, host == ckey, is_readied)
	return TRUE

/datum/teammatch_lobby/proc/announce(message)
	for (var/key in players+observers)
		var/mob/player = get_mob_by_ckey(key)
		if (!player || !player.client)
			continue
		to_chat(player.client, message)

/datum/teammatch_lobby/proc/leave(ckey)
	if (host == ckey)
		var/total_count = players.len + observers.len
		if (total_count <= 1) // <= just in case.
			GLOB.teammatch_game.remove_lobby(host)
			return
		else
			if (players[ckey] && players.len <= 1)
				for (var/key in observers)
					if (host == key)
						continue
					host = key
					observers[key]["host"] = TRUE
					break
			else
				for (var/key in players)
					if (host == key)
						continue
					host = key
					players[key]["host"] = TRUE
					break
			GLOB.teammatch_game.passoff_lobby(ckey, host)

	remove_ckey_from_play(ckey)

/datum/teammatch_lobby/proc/join(mob/player)
	if (playing || !player)
		return
	if(!(player.ckey in (players+observers)))
		add_observer(player)
	ui_interact(player)

/datum/teammatch_lobby/proc/spectate(mob/player)
	if (!playing || !location || !player)
		return

	if (!observers[player.ckey])
		add_observer(player)
	player.forceMove(pick(location.reserved_turfs))

/datum/teammatch_lobby/proc/check_player_requirments()
	var/list/players_by_team = list()
	for(var/key in players)
		var/team_type = players[key]["team"]
		if(!(team_type in players_by_team))
			players_by_team[team_type] = 0
		players_by_team[team_type]++

	. = TRUE

	for(var/datum/teammatch_team/team_type as anything in scenerio.teams)
		var/datum/teammatch_team/team = get_team(team_type)
		if(team.min_players > players_by_team[team_type])
			. = FALSE
			break

/datum/teammatch_lobby/proc/get_team_players(team_type)
	var/list/team_players = list()
	for(var/key in players)
		var/player_team = players[key]["team"]
		if(player_team == team_type)
			team_players |= key
	return team_players

/datum/teammatch_lobby/proc/set_scenerio(new_scenerio)
	var/datum/teammatch_scenerio/scenerio_prefab = GLOB.teammatch_game.get_allowed_scenerios()[new_scenerio]
	if (playing || !new_scenerio || !scenerio_prefab)
		return FALSE
	if(!isnull(scenerio))
		qdel(scenerio)
	scenerio = new scenerio_prefab.type (src)
	for (var/player_key in players)
		var/team_type = players[player_key]["team"]
		var/datum/teammatch_team/team = get_team(team_type)
		var/list/loadouts = team.loadouts
		if (players[player_key]["loadout"] in loadouts)
			continue
		players[player_key]["loadout"] = loadouts[1]
	return TRUE

/datum/teammatch_lobby/proc/change_map(new_map)
	if (!new_map || !GLOB.teammatch_game.maps[new_map])
		return
	map = GLOB.teammatch_game.maps[new_map]

/datum/teammatch_lobby/proc/clear_reservation(datum/turf_reservation/location)
	if(!location || isnull(map))
		return

	GLOB.teammatch_game.active_scenerios -= scenerio

	var/static/list/ignored_atoms = typecacheof(list(/mob/dead, /obj/effect/landmark, /obj/docking_port))
	var/list/all_atoms_by_turf = list()

	for(var/turf/victimized_turf as anything in location.reserved_turfs)
		var/list/allowed_contents = typecache_filter_list_reverse(victimized_turf.get_all_contents(), ignored_atoms)
		allowed_contents -= victimized_turf
		all_atoms_by_turf[victimized_turf] = allowed_contents
		CHECK_TICK

	for(var/turf/victimized_turf as anything in all_atoms_by_turf) // Beacuse of we use CHECK_TICK some items are being pulled into space so we cannot delete them by using turf.empty()
		var/list/turf_contents = all_atoms_by_turf[victimized_turf]
		QDEL_LIST(turf_contents)
		victimized_turf.empty()
		CHECK_TICK

	map?.reservations -= location
	qdel(location)

/datum/teammatch_lobby/Topic(href, href_list)
	var/mob/dead/observer/ghost = usr
	if (!istype(ghost))
		return
	if(href_list["join"])
		join(ghost)

/datum/teammatch_lobby/ui_state(mob/user)
	return GLOB.observer_state

/datum/teammatch_lobby/proc/fakefill(count)
	for(var/i = 1 to count)
		var/datum/teammatch_team/picked_team = pick(scenerio.teams)

		players["[rand(1,999)]"] = list("mob" = WEAKREF(usr), "host" = FALSE, "ready" = FALSE, "team" = "[picked_team]", "loadout" = "[picked_team::default_loadout]")

/datum/teammatch_lobby/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, null)
	if(!ui)
		ui = new(user, src, "TeammatchLobby")
		ui.open()

/datum/teammatch_lobby/ui_static_data(mob/user)
	. = list()
	.["maps"] = list()

	.["maps"] = sort_list(.["maps"])

/datum/teammatch_lobby/ui_data(mob/user)
	var/list/data = list()

	var/is_player = LAZYFIND(players, user.ckey)
	var/is_host = (user.ckey == host)
	var/is_admin = check_rights_for(user.client, R_ADMIN)

	data["admin"] = is_admin
	data["host"] = is_host

	data["scenerios"] = get_scenerios()

	data["scenerio"] = list()
	data["scenerio"]["name"] = scenerio.name
	data["scenerio"]["desc"] = scenerio.desc

	data["maps"] = scenerio.maps

	data["map"] = list()
	data["map"]["name"] = map.name
	data["map"]["desc"] = map.desc

	data["teams"] = get_teams()

	data["players"] = get_player_list()
	data["observers"] = get_observer_list()

	data["playing"] = playing
	data["self"] = user.ckey

	if(is_player)
		var/team_type = players[user.ckey]["team"]
		var/datum/teammatch_team/team = get_team(team_type)
		data["my_team"] = team_type
		data["can_respawn"] = (playing == TEAMMATCH_PLAYING && team.can_respawn())
		data["respawn_timeleft"] = COOLDOWN_TIMELEFT(team, respawn_cooldown)

	return data

/datum/teammatch_lobby/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(. || !isobserver(usr))
		return

	switch(action)
		if ("join_team")
			if (playing == TEAMMATCH_PRE_PLAYING || living_players[usr.ckey])
				return FALSE
			var/datum/teammatch_team/team = text2path(params["team"])
			return change_team(usr, usr.ckey, team)

		if ("respawn")
			if (playing == TEAMMATCH_PLAYING && !living_players[usr.ckey])
				var/player_team = players[usr.ckey]["team"]
				var/player_loadout = players[usr.ckey]["loadout"]
				var/datum/teammatch_team/team = get_team(player_team)
				if(!team.can_respawn())
					return FALSE

				var/picked_spawn = pick(LAZYACCESS(team_spawns, player_team))
				var/turf/spawn_turf = get_turf(picked_spawn)

				var/leftover_amount = loadout_amounts[player_team][player_loadout]

				if(leftover_amount == 0)
					player_loadout = team.default_loadout
				else if(leftover_amount > 0)
					loadout_amounts[player_team][player_loadout] = leftover_amount-1

				return spawn_observer_as_player(usr.ckey, spawn_turf, player_loadout, TRUE)

		if ("start_game")
			if(playing)
				return FALSE
			if (usr.ckey != host)
				return FALSE
			if (!check_player_requirments())
				to_chat(usr, span_warning("Not enough players to start yet."))
				return FALSE
			start_game()
			return TRUE

		if ("leave_game")
			leave(usr.ckey)
			ui.close()
			GLOB.teammatch_game.ui_interact(usr)
			return TRUE

		if ("change_loadout")
			if (playing == TEAMMATCH_PRE_PLAYING || living_players[usr.ckey])
				return FALSE
			if (params["player"] != usr.ckey && host != usr.ckey)
				return FALSE
			var/my_team = players[params["player"]]["team"]
			var/datum/teammatch_team/team = get_team(my_team)
			var/list/loadouts = team.loadouts
			for (var/datum/outfit/teammatch_loadout/possible_loadout as anything in loadouts)
				if (params["loadout"] != initial(possible_loadout.display_name))
					continue
				players[params["player"]]["loadout"] = possible_loadout
				break
			return TRUE

		if ("observe")
			if (playing)
				return FALSE
			if (players[usr.ckey])
				remove_ckey_from_play(usr.ckey)
			add_observer(usr, host == usr.ckey)
			return TRUE

		if ("ready")
			if(!(usr.ckey in players))
				return FALSE
			players[usr.ckey]["ready"] ^= 1
			ready_count += (players[usr.ckey]["ready"] * 2) - 1
			if (ready_count >= players.len && check_player_requirments())
				start_game()
			return TRUE

		if ("host") // Host functions
			if (playing || (usr.ckey != host && !check_rights(R_ADMIN)))
				return FALSE
			var/uckey = params["id"]
			switch (params["func"])
				if ("Kick")
					leave(uckey)
					var/umob = get_mob_by_ckey(uckey)
					var/datum/tgui/uui = SStgui.get_open_ui(umob, src)
					uui?.close()
					GLOB.teammatch_game.ui_interact(umob)
					return TRUE
				if ("Transfer host")
					if (host == uckey)
						return FALSE
					GLOB.teammatch_game.passoff_lobby(host, uckey)
					host = uckey
					return TRUE
				if ("Observer")
					var/umob = get_mob_by_ckey(uckey)
					if (players[uckey])
						remove_ckey_from_play(uckey)
						add_observer(umob, host == uckey)
					return TRUE
				if ("change_scenerio")
					if (playing)
						return FALSE
					if (!(params["scenerio"] in GLOB.teammatch_game.scenerios))
						return FALSE
					return set_scenerio(params["scenerio"])
				if ("change_map")
					if (playing)
						return FALSE
					if (!(params["map"] in scenerio.maps))
						return FALSE
					change_map(params["map"])
					return TRUE
				if ("change_team")
					if (playing == TEAMMATCH_PRE_PLAYING || living_players[uckey])
						return FALSE
					var/datum/teammatch_team/team = get_team(text2path(params["team"]))
					return change_team(null, uckey, team)

		if ("admin") // Admin functions
			if (!check_rights(R_ADMIN))
				message_admins("[usr.key] has attempted to use admin functions in a teammatch lobby without being an admin!")
				log_admin("[key_name(usr)] tried to use the teammatch lobby admin functions without authorization.")
				return
			switch (params["func"])
				if ("Force start")
					log_admin("[key_name(usr)] force started teammatch lobby [host].")
					start_time = 0
					start_game()

	return FALSE

/datum/teammatch_lobby/proc/get_player_list()
	var/list/player_list = list()
	for (var/player_key in players)
		var/list/player_info = players[player_key]
		var/datum/weakref/mob_weakref = player_info["mob"]
		var/mob/player_mob = mob_weakref?.resolve()
		if (isnull(player_mob) || !player_mob.client)
			leave(player_key)
			continue

		var/list/player = player_info.Copy()
		player["key"] = player_key
		var/datum/outfit/teammatch_loadout/tm_loadout = player_info["loadout"]
		player["loadout"] = tm_loadout::display_name


		if(!player_info["team"])
			player["team"] = "team1"
		else
			player["team"] = player_info["team"]

		UNTYPED_LIST_ADD(player_list, player)
	return player_list

/datum/teammatch_lobby/proc/get_observer_list()
	var/list/observer_list = list()

	for (var/observer_key in observers)
		var/list/observer_info = observers[observer_key]
		var/datum/weakref/observer_weakref = observer_info["mob"]
		var/mob/observer_mob = observer_weakref?.resolve()

		if (isnull(observer_mob) || !observer_mob.client)
			leave(observer_key)
			continue

		var/list/observer = observer_info.Copy()
		observer["key"] = observer_key

		UNTYPED_LIST_ADD(observer_list, observer)

	return observer_list

/datum/teammatch_lobby/proc/get_team(team_type)
	return (playing == TEAMMATCH_PLAYING) ? teams[team_type] : GLOB.teammatch_game.teams[team_type]

/datum/teammatch_lobby/proc/get_teams()
	var/list/all_teams = alist()
	for(var/datum/teammatch_team/team_type as anything in scenerio.teams)
		var/datum/teammatch_team/team = get_team(team_type)
		if(isnull(team))
			continue
		var/list/loadouts = list()
		for (var/datum/outfit/teammatch_loadout/loadout as anything in team.loadouts)
			loadouts += loadout::display_name

		var/list/team_info = list(
			"name" = team.name,
			"color" = team.color,
			"default_loadout" = team.default_loadout,
			"loadouts" = loadouts,
			"min_players" = team.min_players,
			"max_players" = team.max_players,
			"is_active" = team.active
		)

		LAZYSET(all_teams, team_type, team_info)

	return all_teams

/datum/teammatch_lobby/proc/get_scenerios()
	var/list/scenerios = list()
	for (var/scenerio_name in GLOB.teammatch_game.get_allowed_scenerios())
		scenerios += scenerio_name
	scenerios = sort_list(scenerios)
	return scenerios

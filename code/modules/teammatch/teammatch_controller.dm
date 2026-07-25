/datum/teammatch_controller
	/// All teammatch scenerios
	var/list/datum/teammatch_scenerio/scenerios = list()
	/// All teammatch map templates
	var/list/datum/lazy_template/teammatch/maps = list()
	/// Assoc list of all lobbies (ckey = lobby)
	var/list/datum/teammatch_lobby/lobbies = list()
	/// Assoc list of all teams (path = team)
	var/list/datum/teammatch_team/teams = list()
	/// Used scenerios
	var/list/datum/teammatch_scenerio/active_scenerios = list()

/datum/teammatch_controller/New()
	. = ..()
	if (GLOB.teammatch_game)
		qdel(src)
		CRASH("A teammatch controller already exists.")
	GLOB.teammatch_game = src

	for (var/datum/lazy_template/teammatch/template as anything in subtypesof(/datum/lazy_template/teammatch))
		var/map_name = initial(template.name)
		maps[map_name] = new template

	for (var/datum/teammatch_scenerio/scenerio as anything in subtypesof(/datum/teammatch_scenerio))
		var/scenerio_name = initial(scenerio.name)
		scenerios[scenerio_name] = new scenerio

	for (var/team_type in subtypesof(/datum/teammatch_team))
		teams[team_type] = new team_type(TRUE)

/datum/teammatch_controller/proc/create_new_lobby(mob/host)
	if(!length(get_allowed_scenerios()))
		to_chat(host, span_warning("Cannot create a new lobby, there is no allowed scenerios to open"))
		return FALSE
	lobbies[host.ckey] = new /datum/teammatch_lobby(host)
	deadchat_broadcast(" has opened a new teammatch lobby. <a href=byond://?src=[REF(lobbies[host.ckey])];join=1>(Join)</a>", "<B>[host]</B>")
	return TRUE

/datum/teammatch_controller/proc/remove_lobby(ckey)
	var/lobby = lobbies[ckey]
	lobbies[ckey] = null
	lobbies.Remove(ckey)
	qdel(lobby)

/datum/teammatch_controller/proc/passoff_lobby(host, new_host)
	lobbies[new_host] = lobbies[host]
	lobbies[host] = null
	lobbies.Remove(host)

/datum/teammatch_controller/proc/get_allowed_scenerios() as /list
	var/list/all_scenerios = scenerios.Copy()
	for(var/datum/teammatch_scenerio/scenerio in active_scenerios)
		if(!scenerio.is_singular)
			continue
		all_scenerios -= scenerio.name

	return all_scenerios

/datum/teammatch_controller/ui_state(mob/user)
	return GLOB.observer_state

/datum/teammatch_controller/proc/find_lobby_by_user(ckey)
	for(var/lobbykey in lobbies)
		var/datum/teammatch_lobby/lobby = lobbies[lobbykey]
		if(ckey in (lobby.players+lobby.observers))
			return lobby

/datum/teammatch_controller/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, null)
	if(!ui)
		ui = new(user, src, "TeammatchPanel")
		ui.open()

/datum/teammatch_controller/ui_data(mob/user)
	. = ..()
	.["lobbies"] = list()
	.["hosting"] = FALSE
	.["admin"] = check_rights_for(user.client, R_ADMIN)
	for (var/ckey in lobbies)
		var/datum/teammatch_lobby/lobby = lobbies[ckey]
		if (user.ckey == ckey)
			.["hosting"] = TRUE
		if (user.ckey in (lobby.observers+lobby.players))
			.["playing"] = ckey
		.["lobbies"] += list(list(
			name = ckey,
			players = lobby.players.len,
			map = lobby.map.name,
			scenerio = lobby.scenerio.name,
			playing = lobby.playing
		))

/datum/teammatch_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(. || !isobserver(usr))
		return FALSE
	switch (action)
		if ("host")
			if(!(GLOB.ghost_role_flags & GHOSTROLE_MINIGAME))
				tgui_alert(usr, "Teammatch has been temporarily disabled by admins.")
				return FALSE
			if (lobbies[usr.ckey])
				return FALSE
			if(!SSticker.HasRoundStarted())
				tgui_alert(usr, "The round hasn't started yet!")
				return FALSE
			ui.close()
			return create_new_lobby(usr)
		if ("view")
			if(!(GLOB.ghost_role_flags & GHOSTROLE_MINIGAME))
				tgui_alert(usr, "Teammatch has been temporarily disabled by admins.")
				return FALSE
			var/lobby = params["id"]
			if (!lobbies[lobby])
				return FALSE
			lobbies[lobby].ui_interact(usr)
			return TRUE
		if ("admin")
			if (!check_rights(R_ADMIN))
				message_admins("[usr.key] has attempted to use admin functions in the teammatch panel!")
				log_admin("[key_name(usr)] tried to use the teammatch panel admin functions without authorization.")
				return FALSE
			var/lobby = params["id"]
			switch (params["func"])
				if ("Close")
					remove_lobby(lobby)
					log_admin("[key_name(usr)] removed teammatch lobby [lobby].")
				if ("View")
					lobbies[lobby].ui_interact(usr)
			return TRUE

/// MENTOR PRIVATE MESSAGE ///

ADMIN_VERB_ONLY_CONTEXT_MENU(cmd_mentor_pm_context, R_NONE, "Mentor PM Mob", mob/target in world)
	if(!ismob(target))
		to_chat(
			src,
			type = MESSAGE_TYPE_ADMINPM,
			html = span_danger("Error: Mentor-PM-Context: Target mob is not a mob, somehow."),
			confidential = TRUE
		)
		return
	user.cmd_admin_pm(target.client, null, TRUE)
	BLACKBOX_LOG_ADMIN_VERB("Mentor PM Mob")

ADMIN_VERB(cmd_mentor_pm_panel, R_NONE, "Mentor PM", "Show a list of clients to PM", ADMIN_CATEGORY_MAIN)
	var/list/targets = list()
	for(var/client/client in GLOB.clients)
		var/nametag = ""
		var/mob/lad = client.mob
		var/mob_name = lad?.name
		var/real_mob_name = lad?.real_name
		if(!lad)
			nametag = "(No Mob)"
		else if(isnewplayer(lad))
			nametag = "(New Player)"
		else if(isobserver(lad))
			nametag = "[mob_name](Ghost)"
		else
			nametag = "[real_mob_name](as [mob_name])"
		targets["[nametag] - [client]"] = client

	var/target = input(src,"To whom shall we send a message?", "Mentor PM", null) as null|anything in sort_list(targets)
	if (isnull(target))
		return
	user.cmd_admin_pm(targets[target], null, TRUE)
	BLACKBOX_LOG_ADMIN_VERB("Mentor PM")

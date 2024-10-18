/client/verb/verify_in_discord()
	set category = "OOC"
	set name = "Verify Discord Account"
	set desc = "Verify your discord account with your BYOND account"

	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(src, span_warning("This feature requires the SQL backend to be running."))
		return

	if(!CONFIG_GET(string/discordbotcommandprefix))
		to_chat(src, span_warning("This feature is disabled."))
		return

	if(!SSdiscord || !SSdiscord.reverify_cache)
		to_chat(src, span_warning("Wait for the Discord subsystem to finish initialising"))
		return

	if(!verification_menu)
		verification_menu = new(usr)

	verification_menu.ui_interact(usr)

/datum/verification_menu
	var/client/holder
	var/last_refresh = 0
	var/discord_id
	var/token

/datum/verification_menu/New(user)
	if(istype(user, /client))
		holder = user
	else
		var/mob/mob_user = user
		holder = mob_user.client

	lookup()

/datum/verification_menu/proc/lookup(refresh = FALSE)
	if(isnull(holder))
		return

	var/discord_id = SSdiscord.lookup_id(holder.ckey)

	if(discord_id)
		holder.fetch_discord(refresh, discord_id)
		if(refresh)
			holder.prefs.refresh_membership()
	else
		var/cached_token = SSdiscord.reverify_cache[holder.ckey]

		if(cached_token && cached_token != "")
			token = cached_token
		else
			token = SSdiscord.get_or_generate_one_time_token_for_ckey(holder.ckey)
			SSdiscord.reverify_cache[holder.ckey] = token

		holder.prefs.unlock_content = FALSE

	if(src.discord_id != discord_id)
		src.discord_id = discord_id
		update_static_data(holder.mob)

/datum/verification_menu/proc/can_refresh()
	return last_refresh != 0 ? world.time - last_refresh > 30 SECONDS : TRUE

/datum/verification_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/verification_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DiscordVerification")
		ui.open()

/datum/verification_menu/ui_data(mob/user)
	. = ..()
	.["refresh"] = can_refresh()

/datum/verification_menu/ui_static_data(mob/user)
	. = ..()
	if(holder.discord)
		.["linked"] = TRUE
		.["display_name"] = holder.discord["global_name"]
		.["username"] = holder.discord["username"]
		.["discriminator"] = holder.discord["discriminator"]
		.["patron"] = holder.prefs.unlock_content
	else
		.["token"] = token
	.["prefix"] = CONFIG_GET(string/discordbotcommandprefix)

/datum/verification_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "refresh" && can_refresh())
		last_refresh = world.time
		lookup(refresh = TRUE)
		return TRUE

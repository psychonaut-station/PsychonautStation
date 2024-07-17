/client/verb/verify_in_discord()
	set category = "OOC"
	set name = "Verify Discord Account"
	set desc = "Verify your discord account with your BYOND account"

	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(src, span_warning("This feature requires the SQL backend to be running."))
		return

	if(!CONFIG_GET(string/discordbotcommandprefix) || !CONFIG_GET(string/discordbottoken) || !CONFIG_GET(string/discorduserendpoint))
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
	var/token
	var/discord_id
	var/display_name
	var/username
	var/discriminator

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
	var/update = FALSE

	if(src.discord_id != discord_id)
		update = TRUE

	src.discord_id = discord_id

	if(discord_id)
		fetch_discord()
		if(refresh)
			holder.check_patreon()
	else
		var/cached_token = SSdiscord.reverify_cache[holder.ckey]

		if(cached_token && cached_token != "")
			token = cached_token
		else
			token = SSdiscord.get_or_generate_one_time_token_for_ckey(holder.ckey)
			SSdiscord.reverify_cache[holder.ckey] = token

		holder.patron = FALSE

	if(update)
		update_static_data(holder.mob)

/datum/verification_menu/proc/fetch_discord()
	var/datum/http_request/request = new ()
	request.prepare(RUSTG_HTTP_METHOD_GET, "[CONFIG_GET(string/discorduserendpoint)]/[discord_id]", headers = list("Authorization" = "Bot [CONFIG_GET(string/discordbottoken)]"))
	request.begin_async()

	UNTIL(request.is_complete())

	var/datum/http_response/response = request.into_response()

	if(!response.errored && response.status_code == 200)
		var/list/json = json_decode(response.body)
		display_name = json["global_name"]
		username = json["username"]
		discriminator = json["discriminator"]

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
	if(discord_id)
		.["linked"] = TRUE
		.["display_name"] = display_name
		.["username"] = username
		.["discriminator"] = discriminator
		.["patron"] = holder.patron
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

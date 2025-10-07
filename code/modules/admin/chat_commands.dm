/// Reload admins tgs chat command. Intentionally not validated.
/datum/tgs_chat_command/reload_admins
	name = "reload_admins"
	help_text = "Forces the server to reload admins."
	admin_only = TRUE

/datum/tgs_chat_command/reload_admins/Run(datum/tgs_chat_user/sender, params)
	ReloadAsync()
	log_admin("[sender.friendly_name] reloaded admins via chat command.")
	message_admins("[sender.friendly_name] reloaded admins via chat command.")
	return new /datum/tgs_message_content("Admins reloaded.")

/datum/tgs_chat_command/reload_admins/proc/ReloadAsync()
	set waitfor = FALSE
	load_admins()

/// subtype tgs chat command with validated admin ranks. Only supports discord.
/datum/tgs_chat_command/validated
	ignore_type = /datum/tgs_chat_command/validated
	admin_only = TRUE
	var/required_rights = 0 //! validate discord userid is linked to a game admin with these flags.


/// called by tgs
/datum/tgs_chat_command/validated/Run(datum/tgs_chat_user/sender, params)
	if (!CONFIG_GET(flag/secure_chat_commands) || CONFIG_GET(flag/admin_legacy_system) || !SSdbcore.Connect())
		return Validated_Run(sender, params)

	var/discord_id = SSdiscord.get_discord_id_from_mention(sender.mention) || sender.id
	if (!discord_id)
		return new /datum/tgs_message_content("Error: Unknown error trying to get your discord id.")

	var/datum/admins/linked_admin
	var/admin_ckey = ckey(SSdiscord.lookup_ckey(discord_id))

	if (admin_ckey)
		linked_admin = GLOB.admin_datums[admin_ckey] || GLOB.deadmins[admin_ckey]
	else
		return new /datum/tgs_message_content("Error: Could not find a linked ckey for your discord id.")

	if (!linked_admin)
		return new /datum/tgs_message_content("Error: Your linked ckey (`[admin_ckey]`) was not found in the admin list. If this is a mistake you can try `reload_admins`")

	if (!linked_admin.check_for_rights(required_rights))
		return new /datum/tgs_message_content("Error: Your linked ckey (`[admin_ckey]`) does not have sufficient rights to do that. You require one of the following flags: `[rights2text(required_rights," ")]`")

	return Validated_Run(sender, params)


/// Called if the sender passes validation checks or if those checks are disabled.
/datum/tgs_chat_command/validated/proc/Validated_Run(datum/tgs_chat_user/sender, params)
	RETURN_TYPE(/datum/tgs_message_content)
	CRASH("[type] has no implementation for Validated_Run()")

/datum/tgs_chat_command/validated/ahelp
	name = "ahelp"
	help_text = "<ckey|ticket #> <message|ticket <close|resolve|icissue|reject|reopen <ticket #>|list>>"
	admin_only = TRUE
	required_rights = R_ADMIN

/datum/tgs_chat_command/validated/ahelp/Validated_Run(datum/tgs_chat_user/sender, params)
	var/list/all_params = splittext(params, " ")
	if(all_params.len < 2)
		return new /datum/tgs_message_content("Insufficient parameters")
	var/target = all_params[1]
	all_params.Cut(1, 2)
	var/id = text2num(target)
	if(id != null)
		var/datum/admin_help/AH = GLOB.ahelp_tickets.TicketByID(id)
		if(AH)
			target = AH.initiator_ckey
		else
			return new /datum/tgs_message_content("Ticket #[id] not found!")
	return new /datum/tgs_message_content(TgsPm(target, all_params.Join(" "), sender.friendly_name))

/datum/tgs_chat_command/validated/namecheck
	name = "namecheck"
	help_text = "Returns info on the specified target"
	admin_only = TRUE
	required_rights = R_ADMIN

/datum/tgs_chat_command/validated/namecheck/Validated_Run(datum/tgs_chat_user/sender, params)
	params = trim(params)
	if(!params)
		return new /datum/tgs_message_content("Insufficient parameters")
	log_admin("Chat Name Check: [sender.friendly_name] on [params]")
	message_admins("Name checking [params] from [sender.friendly_name]")
	return new /datum/tgs_message_content(keywords_lookup(params, 1))

/datum/tgs_chat_command/validated/adminwho
	name = "adminwho"
	help_text = "Lists administrators currently on the server"
	admin_only = TRUE
	required_rights = 0

/datum/tgs_chat_command/validated/adminwho/Validated_Run(datum/tgs_chat_user/sender, params)
	return new /datum/tgs_message_content(tgsadminwho())

/datum/tgs_chat_command/validated/sdql
	name = "sdql"
	help_text = "Runs an SDQL query"
	admin_only = FALSE
	required_rights = R_DEBUG

/datum/tgs_chat_command/validated/sdql/Validated_Run(datum/tgs_chat_user/sender, params)
	var/list/results = HandleUserlessSDQL(sender.friendly_name, params)
	if(!results)
		return new /datum/tgs_message_content("Query produced no output")
	var/list/text_res = results.Copy(1, 3)
	var/list/refs = results.len > 3 ? results.Copy(4) : null
	return new /datum/tgs_message_content("[text_res.Join("\n")][refs ? "\nRefs: [refs.Join(" ")]" : ""]")

/datum/tgs_chat_command/validated/tgsstatus
	name = "status"
	help_text = "Gets the admincount, playercount, gamemode, and true game mode of the server"
	admin_only = TRUE
	required_rights = R_ADMIN

/datum/tgs_chat_command/validated/tgsstatus/Validated_Run(datum/tgs_chat_user/sender, params)
	var/list/adm = get_admin_counts()
	var/list/allmins = adm["total"]
	var/status = "Admins: [allmins.len] (Active: [english_list(adm["present"])] AFK: [english_list(adm["afk"])] Stealth: [english_list(adm["stealth"])] Skipped: [english_list(adm["noflags"])]). "
	status += "Players: [GLOB.clients.len] (Active: [get_active_player_count(FALSE, TRUE, FALSE)]). Round has [SSticker.HasRoundStarted() ? "" : "not "]started."
	return new /datum/tgs_message_content(status)

/datum/tgs_chat_command/validated/tidi
	name = "tidi"
	help_text = "Gets the time dilation"
	required_rights = R_DEBUG
	admin_only = FALSE

/datum/tgs_chat_command/validated/tidi/Validated_Run(datum/tgs_chat_user/sender, params)
	var/message_body = "Time Dilation: [round(SStime_track.time_dilation_current,1)]% \
						AVG:([round(SStime_track.time_dilation_avg_fast,1)]%, \
						[round(SStime_track.time_dilation_avg,1)]%, \
						[round(SStime_track.time_dilation_avg_slow,1)]%)"

	return new /datum/tgs_message_content(message_body)

/datum/tgs_chat_command/validated/mc
	name = "mc"
	help_text = "Master Controller status"
	required_rights = R_DEBUG
	admin_only = FALSE

/datum/tgs_chat_command/validated/mc/Validated_Run(datum/tgs_chat_user/sender, params)
	var/message_body = "CPU: [world.cpu]\n\
						Instances: [num2text(world.contents.len, 10)]\n\
						World Time: [world.time]\n\
						Byond: (FPS:[world.fps]) (TickCount:[world.time/world.tick_lag]) (TickDrift:[round(Master.tickdrift,1)]([round((Master.tickdrift/(world.time/world.tick_lag))*100,0.1)]%)) (Internal Tick Usage: [round(MAPTICK_LAST_INTERNAL_TICK_USAGE,0.1)]%)\n\
						Runtimes: [GLOB.total_runtimes]/[GLOB.total_runtimes_skipped]\n"

	if (SSgarbage)
		message_body += "SSgarbage: TD: [SSgarbage.totaldels], TG: [SSgarbage.totalgcs], Q: [SSgarbage.queues.len]"

	return new /datum/tgs_message_content(message_body)

/datum/tgs_chat_command/validated/reload_config
	name = "reload_config"
	help_text = "Reloads config"
	required_rights = R_DEBUG | R_SERVER
	admin_only = FALSE

/datum/tgs_chat_command/validated/reload_config/Validated_Run(datum/tgs_chat_user/sender, params)
	if (!config)
		return new /datum/tgs_message_content("Game is not ready yet.")

	config.full_wipe()
	config.Load(world.params[OVERRIDE_CONFIG_DIRECTORY_PARAMETER])
	log_admin("[sender.friendly_name] has forcefully reloaded the configuration from disk.")
	message_admins("[sender.friendly_name] has forcefully reloaded the configuration from disk.")

	return new /datum/tgs_message_content("Reloaded config")

/datum/tgs_chat_command/validated/toggle_cdn
	name = "toggle_cdn"
	help_text = "Toggle CDN on/off"
	required_rights = R_DEBUG | R_SERVER
	admin_only = FALSE

/datum/tgs_chat_command/validated/toggle_cdn/Validated_Run(datum/tgs_chat_user/sender, params)
	if (!SSassets)
		return new /datum/tgs_message_content("Game is not ready yet.")

	var/new_transport = "simple"
	var/current_transport = CONFIG_GET(string/asset_transport)
	if (!current_transport || current_transport == "simple")
		new_transport = "webroot"
	else
		new_transport = "simple"

	CONFIG_SET(string/asset_transport, new_transport)
	SSassets.OnConfigLoad()

	if (SSassets.transport.validate_config())
		message_admins("[sender.friendly_name] has changed asset transport to [new_transport].")
		log_admin("[sender.friendly_name] has changed asset transport to [new_transport].")
		return new /datum/tgs_message_content("Asset transport is set to [new_transport].")
	else
		message_admins("[sender.friendly_name] tried to change asset transport to [new_transport] but failed.")
		log_admin("[sender.friendly_name] tried to change asset transport to [new_transport] but failed.")
		return new /datum/tgs_message_content("Cannot change asset transport! Check asset log.")

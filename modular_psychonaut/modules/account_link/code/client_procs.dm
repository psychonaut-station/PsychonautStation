/client/proc/fetch_discord(no_cache = FALSE, discord_id)
	if(!no_cache && !isnull(discord))
		return discord

	if(!CONFIG_GET(string/apiurl) || !CONFIG_GET(string/apitoken))
		return

	discord_id = discord_id || SSdiscord.lookup_id(ckey)

	if(!discord_id)
		return

	var/datum/http_request/request = new ()
	request.prepare(RUSTG_HTTP_METHOD_GET, "[CONFIG_GET(string/apiurl)]/discord/user?discord_id=[discord_id]", headers = list("X-EXP-KEY" = "[CONFIG_GET(string/apitoken)]"))
	request.begin_async()

	UNTIL(request.is_complete())

	var/datum/http_response/response = request.into_response()

	if(!response.errored && response.status_code == 200)
		discord = json_decode(response.body)
	else if(response.status_code == 404)
		discord = FALSE
	else
		discord = null

	return discord

/client/proc/is_discord_member(discord_id)
	if(!CONFIG_GET(string/apiurl) || !CONFIG_GET(string/apitoken))
		return

	discord_id = discord_id || SSdiscord.lookup_id(ckey)

	if(!discord_id)
		return

	var/datum/http_request/request = new ()
	request.prepare(RUSTG_HTTP_METHOD_GET, "[CONFIG_GET(string/apiurl)]/discord/member?discord_id=[discord_id]", headers = list("X-EXP-KEY" = "[CONFIG_GET(string/apitoken)]"))
	request.begin_async()

	UNTIL(request.is_complete())

	var/datum/http_response/response = request.into_response()

	if(!response.errored)
		if(response.status_code == 200)
			return TRUE
		else if(response.status_code == 404)
			return FALSE

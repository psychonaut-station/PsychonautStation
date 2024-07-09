GLOBAL_LIST_INIT(patrons, init_patrons())

/proc/init_patrons()
	. = world.file2list("data/patrons.txt")
	after_init_patrons(.)

/proc/after_init_patrons(list/patrons)
	set waitfor = 0

	var/endpoint = CONFIG_GET(string/patreonendpoint)
	if(endpoint)
		for(var/discord_id in patrons)
			var/datum/http_request/request = new ()
			request.prepare(RUSTG_HTTP_METHOD_GET, "[endpoint]?discord_id=[discord_id]")
			request.begin_async()

			UNTIL(request.is_complete())

			var/datum/http_response/response = request.into_response()

			if(!response.errored && response.status_code == 200)
				var/list/json = json_decode(response.body)
				if(!json["patron"])
					patrons -= discord_id

/proc/is_patron(client/client, ignore_localhost = FALSE)
	if(istype(client, /mob))
		var/mob/mob = client
		client = mob.client

	if(isnull(client))
		return FALSE

	if(isnull(client.patron))
		var/discord_id = SSdiscord.lookup_id(client.ckey)
		if(discord_id in GLOB.patrons)
			client.patron = TRUE
		else if(!ignore_localhost && client.is_localhost())
			client.patron = TRUE
		else
			client.patron = FALSE

	return client.patron

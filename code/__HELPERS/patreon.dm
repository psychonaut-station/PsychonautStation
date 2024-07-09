/proc/is_patron(client/client, ignore_localhost = FALSE, refetch = FALSE)
	if(istype(client, /mob))
		var/mob/mob = client
		client = mob.client

	if(isnull(client))
		return FALSE

	if(refetch || isnull(client.patron))
		if(!ignore_localhost && client.is_localhost())
			client.patron = TRUE
		else
			var/endpoint = CONFIG_GET(string/patreonendpoint)
			if(endpoint)
				var/discord_id = SSdiscord.lookup_id(client.ckey)
				if(discord_id)
					var/datum/http_request/request = new ()
					request.prepare(RUSTG_HTTP_METHOD_GET, "[endpoint][discord_id]")
					request.begin_async()

					UNTIL(request.is_complete())

					var/datum/http_response/response = request.into_response()

					if(!response.errored && response.status_code == 200)
						var/list/json = json_decode(response["body"])
						if(json["patron"])
							client.patron = TRUE
						else
							client.patron = FALSE
				else
					client.patron = FALSE
			else
				client.patron = FALSE

	return client.patron

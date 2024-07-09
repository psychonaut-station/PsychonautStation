GLOBAL_LIST_INIT(patrons, init_patrons())

/proc/init_patrons()
	if(fexists("data/patrons.txt"))
		. = world.file2list("data/patrons.txt")
		after_init_patrons(.)
	else
		. = list()

/proc/after_init_patrons(list/patrons)
	set waitfor = 0

	var/endpoint = CONFIG_GET(string/patreonendpoint)
	if(!endpoint)
		return

	for(var/ckey in patrons)
		var/datum/http_request/request = new ()
		request.prepare(RUSTG_HTTP_METHOD_GET, "[endpoint]?ckey=[ckey]")
		request.begin_async()

		UNTIL(request.is_complete())

		var/datum/http_response/response = request.into_response()

		if(!response.errored && response.status_code == 200)
			var/list/json = json_decode(response.body)
			if(!json["patron"])
				patrons -= ckey

/proc/is_patron(client/client, ignore_localhost = FALSE)
	if(isnull(client))
		return FALSE

	if(istype(client, /mob))
		var/mob/mob = client
		client = mob.client

	if(isnull(client.patron))
		if(client.ckey in GLOB.patrons)
			client.patron = TRUE
		else if(!ignore_localhost && client.is_localhost())
			client.patron = TRUE
		else
			client.patron = FALSE

	return client.patron

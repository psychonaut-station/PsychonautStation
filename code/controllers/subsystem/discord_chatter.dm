SUBSYSTEM_DEF(discord_chatter)
	name = "Discord Chatter"
	flags = SS_BACKGROUND
	wait = 10
	init_order = INIT_ORDER_DISCORD

	var/list/poly_speech = list()
	var/last_time

/datum/controller/subsystem/discord_chatter/Initialize()
	var/json_file = file("data/npc_saves/Poly.json")

	if(!fexists(json_file))
		return SS_INIT_NO_NEED

	var/list/json = json_decode(file2text(json_file))
	poly_speech = json["phrases"]

	last_time = rustg_unix_timestamp()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/discord_chatter/fire()
	if(isnull(poly_speech) || !poly_speech.len)
		return 

	var/current_time = rustg_unix_timestamp()
	var/tickrate = CONFIG_GET(number/discord_chatter_tickrate)
	if (current_time - last_time < tickrate)
		return

	last_time = current_time

	var/list/webhook_info = list()
	webhook_info["content"] = pick(poly_speech)

	var/list/headers = list()
	headers["Content-Type"] = "application/json"

	var/webhook = CONFIG_GET(string/discord_chatter_webhook_url)
	var/datum/http_request/request = new()

	request.prepare(RUSTG_HTTP_METHOD_POST, webhook, json_encode(webhook_info), headers, "tmp/subsys_discord_chatter.json")
	request.begin_async()

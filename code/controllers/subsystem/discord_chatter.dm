SUBSYSTEM_DEF(discord_chatter)
	name = "Discord Chatter"
	flags = SS_BACKGROUND
	wait = 600  						// 10 mins
	init_order = INIT_ORDER_DISCORD

	var/list/poly_speech = list()

/datum/controller/subsystem/discord_chatter/Initialize()
	if (!CONFIG_GET(flag/discord_chatter))
		return SS_INIT_FAILURE

	var/json_file = file("data/npc_saves/Poly.json")
	if(!fexists(json_file))
		return SS_INIT_FAILURE

	var/list/json = json_decode(file2text(json_file))
	poly_speech = json["phrases"]

	if(isnull(poly_speech) || !poly_speech.len)
		return SS_INIT_FAILURE

	return SS_INIT_SUCCESS

/datum/controller/subsystem/discord_chatter/fire()
	var/webhook = CONFIG_GET(string/discord_chatter_webhook_url)

	var/list/webhook_info = list()
	webhook_info["content"] = pick(poly_speech)

	var/list/headers = list()
	headers["Content-Type"] = "application/json"
	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_POST, webhook, json_encode(webhook_info), headers, "tmp/subsys_discord_chatter.json")
	request.begin_async()

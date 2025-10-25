
/client/proc/check_patreon()
	if(!CONFIG_GET(string/apiurl) || !CONFIG_GET(string/apitoken))
		return FALSE

	var/datum/http_request/request = new ()
	request.prepare(RUSTG_HTTP_METHOD_GET, "[CONFIG_GET(string/apiurl)]/patreon?ckey=[ckey]", headers = list("X-EXP-KEY" = "[CONFIG_GET(string/apitoken)]"))
	request.begin_async()

	UNTIL(request.is_complete())

	var/datum/http_response/response = request.into_response()

	if(!response.errored && response.status_code == 200)
		var/list/json = json_decode(response.body)
		return json["patron"]

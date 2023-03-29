/datum/tgs_chat_command/tgscheck
	name = "check"
	help_text = "Check round status"

/datum/tgs_chat_command/tgscheck/Run(datum/tgs_chat_user/sender, params)
	return "[GLOB.round_id ? "Round #[GLOB.round_id]: " : ""] [GLOB.clients.len] oyuncu ile [SSticker.HasRoundStarted() ? (SSticker.IsRoundInProgress() ? "devam etmekte" : "bitmek üzere") : "başlıyor"]."

/datum/tgs_chat_command/poly
	name = "poly"
	help_text = "Poly"

/datum/tgs_chat_command/poly/Run(datum/tgs_chat_user/sender, params)
	var/static/list/poly_speech = null

	if (!poly_speech)
		var/json_file = file("data/npc_saves/Poly.json")
		if (!fexists(json_file))
			poly_speech = list("abi poly'i oldurmusler")
		else
			var/list/json = json_decode(file2text(json_file))
			poly_speech = json["phrases"]

	return pick(poly_speech)

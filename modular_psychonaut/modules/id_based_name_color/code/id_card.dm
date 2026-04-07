/obj/item/card/id/advanced
	/// If this is set, will manually override the chat span used for the wearer's name, normally set by the trim. Intended for admins to VV edit and chameleon ID cards.
	var/trim_chat_span_override

/obj/item/card/id/proc/chat_span()
	return trim?.chat_span()

/obj/item/card/id/advanced/chat_span()
	return trim_chat_span_override || ..()

/datum/id_trim/proc/chat_span()
	if(sechud_icon_state == SECHUD_UNKNOWN)
		return "job__unassigned"
	var/trimmed_hud_state = copytext(sechud_icon_state, 4)
	if(trimmed_hud_state)
		return "job__[trimmed_hud_state]"
	else
		return "job__unknown"

/datum/id_trim/centcom/ert/chat_span()
	return "job__ert"

/datum/id_trim/centcom/ert/clown/chat_span()
	return "job__clown"

/datum/id_trim/job/bridge_assistant/chat_span()
	return "job__bridgeassistant"


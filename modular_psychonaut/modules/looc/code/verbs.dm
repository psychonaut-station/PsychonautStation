// Client

/client/verb/looc(msg as text)
	set name = "LOOC"
	set category = "OOC"

	if(GLOB.say_disabled) //This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return

	if(!msg)
		return

	var/client_initalized = VALIDATE_CLIENT_INITIALIZATION(src)
	if(isnull(mob) || !client_initalized)
		if(!client_initalized)
			unvalidated_client_error() // we only want to throw this warning message when it's directly related to client failure.

		to_chat(usr, span_warning("Failed to send your LOOC message. You attempted to send the following message:\n[span_big(msg)]"))
		return

	var/admin = check_rights(R_ADMIN, FALSE)
	if(mob.stat == DEAD && !admin)
		to_chat(src, span_warning("You must be alive to use LOOC."))
		return

	msg = trim(copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN))
	var/raw_msg = msg

	if(!msg)
		return

	var/list/filter_result = is_ooc_filtered(msg)
	if (!CAN_BYPASS_FILTER(usr) && filter_result)
		REPORT_CHAT_FILTER_TO_USER(usr, filter_result)
		log_filter("LOOC", msg, filter_result)
		return

	// Protect filter bypassers from themselves.
	// Demote hard filter results to soft filter results if necessary due to the danger of accidentally speaking in OOC.
	var/list/soft_filter_result = filter_result || is_soft_ooc_filtered(msg)

	if (soft_filter_result)
		if(tgui_alert(usr,"Your message contains \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\". \"[soft_filter_result[CHAT_FILTER_INDEX_REASON]]\", Are you sure you want to say it?", "Soft Blocked Word", list("Yes", "No")) != "Yes")
			return
		message_admins("[ADMIN_LOOKUPFLW(usr)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term. Message: \"[msg]\"")
		log_admin_private("[key_name(usr)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term. Message: \"[msg]\"")


	msg = emoji_parse(msg)

	if(!admin)
		if(!GLOB.looc_allowed)
			to_chat(src, span_warning("LOOC is globally muted"))
			return
		if(prefs.muted & MUTE_LOOC)
			to_chat(src, span_warning("You cannot use LOOC (muted)."))
			return
		if(handle_spam_prevention(raw_msg, MUTE_LOOC))
			return
		if(findtext(raw_msg, "byond://"))
			to_chat(src, span_boldannounce("<B>Advertising other servers is not allowed.</B>"))
			log_admin("[key_name(src)] has attempted to advertise in LOOC: [raw_msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in LOOC: [raw_msg]")
			return

	if(is_banned_from(ckey, "LOOC"))
		to_chat(src, span_warning("You have been banned from LOOC."))
		return

	var/pref_enable_looc = prefs.read_preference(/datum/preference/toggle/enable_looc)
	if(!pref_enable_looc)
		to_chat(src, span_danger("You have LOOC muted."))
		return

	mob.log_talk(raw_msg, LOG_LOOC)

	var/message

	if(admin && isobserver(mob))
		message = span_looc(span_prefix("LOOC: [usr.client.holder.fakekey ? "Administrator" : usr.client.key]: [msg]"))
		for(var/mob/M in range(mob))
			var/avoid_highlight = M?.canon_client == src
			to_chat(M, message, avoid_highlighting = avoid_highlight)
	else
		message = span_looc(span_prefix("LOOC: [mob.name]: [msg]"))
		for(var/mob/M in range(mob))
			var/avoid_highlight = M?.canon_client == src
			to_chat(M, message, avoid_highlighting = avoid_highlight)

// Server


ADMIN_VERB(toggle_looc, R_ADMIN, "Toggle LOOC", "Toggle the LOOC channel on or off.", ADMIN_CATEGORY_SERVER)
	toggle_looc()
	log_admin("[key_name(user)] toggled LOOC.")
	message_admins("[key_name_admin(user)] toggled LOOC.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle LOOC", "[GLOB.looc_allowed ? "Enabled" : "Disabled"]"))

/proc/toggle_looc(toggle = null)
	if(toggle != null)
		if(toggle != GLOB.looc_allowed)
			GLOB.looc_allowed = toggle
		else
			return
	else //otherwise just toggle it
		GLOB.looc_allowed = !GLOB.looc_allowed

/datum/admin_help/proc/SendNoticeSound(client/C)
	switch (ticket_type)
		if (TICKET_TYPE_ADMIN)
			SEND_SOUND(C, sound('sound/effects/adminhelp.ogg'))
		if (TICKET_TYPE_MENTOR)
			SEND_SOUND(C, sound('sound/machines/compiler/compiler-stage2.ogg'))

GLOBAL_DATUM_INIT(mentor_help_ui_handler, /datum/mentor_help_ui_handler, new)

/datum/mentor_help_ui_handler
	var/list/ahelp_cooldowns = list()

/datum/mentor_help_ui_handler/ui_state(mob/user)
	return GLOB.always_state

/datum/mentor_help_ui_handler/ui_data(mob/user)
	. = list()
	var/list/admins = get_admin_counts(R_MENTOR)
	.["adminCount"] = length(admins["present"])

/datum/mentor_help_ui_handler/ui_static_data(mob/user)
	. = list()

/datum/mentor_help_ui_handler/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Mentorhelp")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/mentor_help_ui_handler/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/client/user_client = usr.client
	var/message = sanitize_text(trim(params["message"]))

	if(user_client.adminhelptimerid)
		return

	perform_mentorhelp(user_client, message)
	ui.close()

/datum/mentor_help_ui_handler/proc/perform_mentorhelp(client/user_client, message)
	if(GLOB.say_disabled) //This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."), confidential = TRUE)
		return

	if(!message)
		return

	//handle muting and automuting
	if(user_client.prefs.muted & MUTE_ADMINHELP)
		to_chat(user_client, span_danger("Error: Mentor-PM: You cannot send adminhelps (Muted)."), confidential = TRUE)
		return
	if(user_client.handle_spam_prevention(message, MUTE_ADMINHELP))
		return

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Mentorhelp")

	if(user_client.current_ticket)
		user_client.current_ticket.TimeoutVerb()
		user_client.current_ticket.MessageNoRecipient(message, FALSE)
		return

	new /datum/admin_help(message, user_client, FALSE, FALSE, TICKET_TYPE_MENTOR)

/client/verb/mentorhelp()
	set category = "Admin"
	set name = "Mentorhelp"
	GLOB.mentor_help_ui_handler.ui_interact(mob)

/// TICKET HELPER ///

GLOBAL_DATUM_INIT(ticket_helper_ui_handler, /datum/ticket_helper_ui_handler, new)

/datum/ticket_helper_ui_handler

/datum/ticket_helper_ui_handler/ui_state(mob/user)
	return GLOB.always_state

/datum/ticket_helper_ui_handler/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TicketSelectHelper")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/ticket_helper_ui_handler/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("ticket_mentor")
			GLOB.mentor_help_ui_handler.ui_interact(usr)
		if("ticket_admin")
			GLOB.admin_help_ui_handler.ui_interact(usr)

	ui.close()

/client/verb/tickethelper()
	set name = "Tickethelper"
	set hidden = TRUE

	GLOB.ticket_helper_ui_handler.ui_interact(mob)

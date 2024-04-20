#define MESSAGE_COOLDOWN (60 SECONDS)
#define REQUEST_SUPERVISOR_COOLDOWN (300 SECONDS)

/obj/machinery/computer/secretary_console
	name = "secretary console"
	desc = "A console for communicating with central command."
	icon_file_screen = 'icons/psychonaut/obj/machines/computer.dmi'
	icon_screen = "secretary_console"
	icon_keyboard = "rd_key"
	circuit = /obj/item/circuitboard/computer/secretary_console
	light_color = LIGHT_COLOR_BLUE

	COOLDOWN_DECLARE(static/message_cooldown)
	COOLDOWN_DECLARE(static/request_supervisor_cooldown)

/obj/machinery/computer/secretary_console/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	AI_notify_hack()
	obj_flags |= EMAGGED
	return TRUE

/obj/machinery/computer/secretary_console/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if((!istype(H.mind?.assigned_role, /datum/job/nt_secretary) || HAS_TRAIT(user, TRAIT_ILLITERATE)) && !(obj_flags & EMAGGED))
		to_chat(user, span_warning("You don't know how to use this!"))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "SecretaryConsole", name)
		ui.open()

/obj/machinery/computer/secretary_console/ui_data(mob/user)
	var/list/data = list(
		"emagged" = FALSE,
	)
	if (obj_flags & EMAGGED)
		data["emagged"] = TRUE
	data["canSendMessage"] = COOLDOWN_FINISHED(src, message_cooldown)
	data["canRequestSupervisor"] = COOLDOWN_FINISHED(src, request_supervisor_cooldown)
	data["SupervisorRequestCooldown"] = DisplayTimeText(COOLDOWN_TIMELEFT(src, request_supervisor_cooldown), 1)
	data["MessageSendCooldown"] = DisplayTimeText(COOLDOWN_TIMELEFT(src, message_cooldown), 1)
	return data

/obj/machinery/computer/secretary_console/ui_act(action, list/params)
	. = ..()
	if (.)
		return
	switch(action)
		if("send_Message")
			if(!COOLDOWN_FINISHED(src, message_cooldown))
				to_chat(usr, span_notice("You have to wait before sending another message."))
				return FALSE
			var/message = tgui_input_text(usr, "", "Message to Central Command")
			if(!message)
				return FALSE
			message_centcom(message, usr)
			to_chat(usr, span_notice("Message transmitted to Central Command."))
			COOLDOWN_START(src, message_cooldown, MESSAGE_COOLDOWN)
			return TRUE
		if("requestSupervisor")
			if(!COOLDOWN_FINISHED(src, request_supervisor_cooldown))
				to_chat(usr, span_notice("You have to wait before request supervisor."))
				return FALSE
			var/reason = tgui_input_text(usr, "", "Reason for requesting supervisor")
			if(!reason)
				return FALSE
			supervisor_request(reason, usr)
			COOLDOWN_START(src, request_supervisor_cooldown, REQUEST_SUPERVISOR_COOLDOWN)
			return TRUE

#undef MESSAGE_COOLDOWN
#undef REQUEST_SUPERVISOR_COOLDOWN

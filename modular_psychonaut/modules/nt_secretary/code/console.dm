#define MESSAGE_COOLDOWN 60 SECONDS
#define REQUEST_SUPERVISOR_COOLDOWN 5 MINUTES

/obj/machinery/computer/secretary_console
	name = "secretary console"
	desc = "A console for communicating with Central Command."
	icon_screen_file = 'modular_psychonaut/master_files/icons/obj/machines/computer.dmi'
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
	if((!istype(user.mind?.assigned_role, /datum/job/nt_secretary) && !(obj_flags & EMAGGED)) || HAS_TRAIT(user, TRAIT_ILLITERATE))
		to_chat(user, span_warning("You don't know how to use this!"))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "SecretaryConsole", name)
		ui.open()

/obj/machinery/computer/secretary_console/ui_data(mob/user)
	. = list()
	.["emagged"] = (obj_flags & EMAGGED)
	.["canSendMessage"] = COOLDOWN_FINISHED(src, message_cooldown)
	.["canRequestSupervisor"] = COOLDOWN_FINISHED(src, request_supervisor_cooldown)
	.["SupervisorRequestCooldown"] = DisplayTimeText(COOLDOWN_TIMELEFT(src, request_supervisor_cooldown), 1)
	.["MessageSendCooldown"] = DisplayTimeText(COOLDOWN_TIMELEFT(src, message_cooldown), 1)

/obj/machinery/computer/secretary_console/ui_act(action, list/params)
	. = ..()
	if (.)
		return
	switch(action)
		if("send_message")
			if(!COOLDOWN_FINISHED(src, message_cooldown))
				to_chat(usr, span_notice("You have to wait before sending another message."))
				return FALSE
			var/message = tgui_input_text(usr, "", "Message to [command_name()]")
			if(!message)
				return FALSE
			message_centcom(message, usr)
			to_chat(usr, span_notice("Message transmitted to [command_name()]."))
			COOLDOWN_START(src, message_cooldown, MESSAGE_COOLDOWN)
			return TRUE
		if("request_supervisor")
			if(!COOLDOWN_FINISHED(src, request_supervisor_cooldown))
				to_chat(usr, span_notice("You have to wait before requesting a new supervisor."))
				return FALSE
			var/reason = tgui_input_text(usr, "", "Reason for requesting a supervisor")
			if(!reason)
				return FALSE
			request_supervisor(reason, usr)
			COOLDOWN_START(src, request_supervisor_cooldown, REQUEST_SUPERVISOR_COOLDOWN)
			return TRUE

/obj/machinery/computer/secretary_console/proc/request_supervisor(text, mob/sender)
	var/message = copytext_char(sanitize(text), 1, MAX_MESSAGE_LEN)
	GLOB.requests.message_centcom(sender.client, message)
	to_chat(GLOB.admins, span_adminnotice("<b><font color=blue>SUPERVISOR REQUEST:</font>[ADMIN_FULLMONTY(sender)] [ADMIN_CENTCOM_REPLY(sender)]:</b> [message]"), confidential = TRUE)
	for(var/client/staff as anything in GLOB.admins)
		SEND_SOUND(staff, sound('sound/misc/server-ready.ogg'))
	for(var/obj/machinery/computer/communications/console in GLOB.shuttle_caller_list)
		console.override_cooldown()

/obj/item/circuitboard/computer/secretary_console
	name = "Secretary Console"
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/computer/secretary_console

#undef MESSAGE_COOLDOWN
#undef REQUEST_SUPERVISOR_COOLDOWN

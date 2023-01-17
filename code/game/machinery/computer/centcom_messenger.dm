#define MESSAGE_COOLDOWN (60 SECONDS)

/obj/machinery/computer/centcom_messenger
	name = "centcom messenger console"
	desc = "A console for communicating with central command."
	icon_screen = "centcom_messenger"
	icon_keyboard = "tech_key"
	circuit = /obj/item/circuitboard/computer/centcom_messenger
	light_color = LIGHT_COLOR_BLUE

	COOLDOWN_DECLARE(static/message_cooldown)

/obj/machinery/computer/centcom_messenger/emag_act(mob/user, obj/item/card/emag/emag_card)
	return //todo

/obj/machinery/computer/centcom_messenger/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(!H.mind.secretary || HAS_TRAIT(user, TRAIT_ILLITERATE))
		to_chat(user, span_warning("You don't know how to use this!"))
		return
	else if(!COOLDOWN_FINISHED(src, message_cooldown))
		to_chat(usr, span_notice("You have to wait before sending another message."))
		return
	var/message = tgui_input_text(user, "", "Message to Central Command")
	message_centcom(message, usr)
	to_chat(usr, span_notice("Message transmitted to Central Command."))
	COOLDOWN_START(src, message_cooldown, MESSAGE_COOLDOWN)

#undef MESSAGE_COOLDOWN

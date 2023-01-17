#define ANNOUNCEMENT_COOLDOWN (600 SECONDS)

/obj/machinery/computer/announcer
	name = "announcer console"
	desc = "A console used for news and low-priority announcements."
	icon_screen = "announcer"
	icon_keyboard = "rd_key"
	circuit = /obj/item/circuitboard/computer/announcer
	light_color = LIGHT_COLOR_BLUE

	COOLDOWN_DECLARE(static/announcement_cooldown)

/obj/machinery/computer/announcer/emag_act(mob/user, obj/item/card/emag/emag_card)
	return //todo

/obj/machinery/computer/announcer/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(!H.mind.secretary || HAS_TRAIT(user, TRAIT_ILLITERATE))
	//if(!HAS_TRAIT(user, TRAIT_SECRETARY) || HAS_TRAIT(user, TRAIT_ILLITERATE))
		to_chat(user, span_warning("You don't know how to use this!"))
		return
	else if(!COOLDOWN_FINISHED(src, announcement_cooldown))
		to_chat(usr, span_notice("You have to wait before making an announcement."))
		return
	var/message = tgui_input_text(user, "", "Announcement")
	if(!message)
		return
	priority_announce(message, null, 'sound/misc/breaking_news.ogg', "Secretary", has_important_message=TRUE, players=GLOB.player_list)
	COOLDOWN_START(src, announcement_cooldown, ANNOUNCEMENT_COOLDOWN)
	message_admins("[ADMIN_LOOKUPFLW(usr)] has used the secretary's announcer console.")

#undef ANNOUNCEMENT_COOLDOWN

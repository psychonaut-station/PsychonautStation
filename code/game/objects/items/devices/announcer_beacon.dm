#define ANNOUNCEMENT_COOLDOWN (120 SECONDS)

/obj/item/announcementbeacon
	name = "Announcement Beacon"
	desc = "A beacon used for news and low-priority announcements."
	icon = 'icons/obj/device.dmi'
	icon_state = "announcement_beacon"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	var/isEmagged = FALSE

	COOLDOWN_DECLARE(static/announcement_cooldown)

/obj/item/announcementbeacon/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	obj_flags |= EMAGGED
	return TRUE

/obj/item/announcementbeacon/attack_self(mob/user)
	if (!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if((!H.mind.curator || HAS_TRAIT(user, TRAIT_ILLITERATE)) && !(obj_flags & EMAGGED))
		to_chat(user, span_warning("You don't know how to use this!"))
		return
	else if(!COOLDOWN_FINISHED(src, announcement_cooldown))
		to_chat(usr, span_notice("You have to wait before making an announcement."))
		return
	var/message = tgui_input_text(user, "", "Announcement")
	if(!message)
		return
	priority_announce(message, null, 'sound/misc/announce_dig.ogg', "Curator", has_important_message=TRUE, players=GLOB.player_list)
	COOLDOWN_START(src, announcement_cooldown, ANNOUNCEMENT_COOLDOWN)
	message_admins("[ADMIN_LOOKUPFLW(usr)] has used the curator's announcer beacon.")

/obj/item/announcementbeacon/examine(mob/user)
	. = ..()
	if(!COOLDOWN_FINISHED(src, announcement_cooldown))
		. += span_notice("Cooldown: [DisplayTimeText(COOLDOWN_TIMELEFT(src, announcement_cooldown), 1)]")

#undef ANNOUNCEMENT_COOLDOWN

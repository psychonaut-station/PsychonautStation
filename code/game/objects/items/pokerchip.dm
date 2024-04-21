/obj/item/pokerchip
	name = "poker chip"
	desc = "A small disk-shaped counter used to represent money when gambling."
	icon = 'icons/obj/gambling.dmi'
	base_icon_state = "pokerchip"
	throwforce = 0
	force = 0
	w_class = WEIGHT_CLASS_TINY
	var/credits = 1
	var/static/max_overlays = MAX_ATOM_OVERLAYS - 2
	var/static/list/steps = list("100", "50", "25", "10", "5", "1")
	var/static/list/offsets = list(
		list(list("x" = 0, "y" = 0)),
		list(list("x" = -3, "y" = -2), list("x" = 4, "y" = 1)),
		list(list("x" = -3, "y" = -4), list("x" = 4, "y" = -1), list("x" = -3, "y" = 3)),
		list(list("x" = -3, "y" = -6), list("x" = 4, "y" = -3), list("x" = -4, "y" = 2), list("x" = 2, "y" = 5)),
		list(list("x" = -6, "y" = -7), list("x" = 1, "y" = -4), list("x" = -7, "y" = 1), list("x" = -1, "y" = 4), list("x" = 7, "y" = 1)),
		list(list("x" = -6, "y" = -7), list("x" = 1, "y" = -4), list("x" = -7, "y" = 1), list("x" = -1, "y" = 4), list("x" = 8, "y" = 0), list("x" = 5, "y" = 7)),
	)

/obj/item/pokerchip/Initialize(mapload, amount)
	. = ..()
	if(amount)
		if(spread_chips_len(amount) < max_overlays)
			credits = amount
	update_appearance()

/obj/item/pokerchip/examine(mob/user)
	. = ..()
	. += \
	span_notice("It's worth [credits] credit[( credits > 1 ) ? "s" : ""].") + "\n" +\
	span_notice("Alt-Click to split.")

/obj/item/pokerchip/update_name()
	name = "\improper [credits]cr worth poker chip stack"
	return ..()

/obj/item/pokerchip/update_overlays()
	. = ..()
	var/list/chips = spread_chips(credits)
	var/index_row = 1
	for(var/chip in chips)
		var/chip_amount = chips[chip]
		for(var/index_column in 1 to chip_amount)
			var/mutable_appearance/pokerchip_overlay = mutable_appearance(
				icon,
				"[base_icon_state][index_column == chip_amount ? "-n" : null]-[chip]",
				layer + ((steps.len - index_row - 1) * MAX_ATOM_OVERLAYS + index_column) * 1e-4
			)
			pokerchip_overlay.pixel_x = offsets[chips.len][index_row]["x"]
			pokerchip_overlay.pixel_y = offsets[chips.len][index_row]["y"] + (index_column - 1) * 2
			. += pokerchip_overlay
		index_row += 1

/obj/item/pokerchip/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/pokerchip))
		var/obj/item/pokerchip/H = I
		if(spread_chips_len(credits + H.credits) >= max_overlays)
			to_chat(user, span_warning("You cannot add more chips to the stack."))
			return TRUE
		credits += H.credits
		user.visible_message(\
			span_notice("[user] added [H.credits]cr worth chips to [src]."),\
			span_notice("You added [H.credits]cr worth chips to [src]."))
		user.balloon_alert_to_viewers("adds [H.credits]cr")
		update_appearance()
		qdel(H)

/obj/item/pokerchip/click_alt(mob/user)
	if(!user.can_perform_action(src, NEED_DEXTERITY | FORBID_TELEKINESIS_REACH))
		return
	var/split_amount = tgui_input_number(user, "How many credits worth chip do you want to extract from the stack? (Max: [credits] cr)", "Poker chip", max_value = credits)
	if(!split_amount || QDELETED(user) || QDELETED(src) || issilicon(user) || !usr.can_perform_action(src, NEED_DEXTERITY | FORBID_TELEKINESIS_REACH))
		return
	if(spread_chips_len(credits - split_amount) >= max_overlays || spread_chips_len(split_amount) >= max_overlays)
		to_chat(user, span_warning("You couldn't extract [split_amount]cr worth chips into a new stack."))
		return
	var/new_credits = spend(split_amount)
	var/obj/item/pokerchip/H = new(user, new_credits)
	if(!user.put_in_hands(H))
		H.forceMove(user.drop_location())
	if(!isnull(src))
		add_fingerprint(user)
	H.add_fingerprint(user)
	user.visible_message(\
		span_notice("[user] extracts [split_amount]cr worth chips from into a new stack."),\
		span_notice("You extract [split_amount]cr worth chips into a new stack."))
	user.balloon_alert_to_viewers("takes [split_amount]cr")

/obj/item/pokerchip/proc/spend(amount)
	if(credits >= amount)
		credits -= amount
		if(credits == 0)
			qdel(src)
		else
			update_appearance()
		return amount
	else
		qdel(src)
		return credits

/obj/item/pokerchip/proc/spread_chips(balance)
	var/list/chips = list()
	for(var/chip in steps)
		var/num = text2num(chip)
		var/rnd = round(balance / num)
		if(rnd > 0)
			chips[chip] = rnd
			balance = balance % num
	return reverseList(chips)

/obj/item/pokerchip/proc/spread_chips_len(balance)
	var/L = spread_chips(balance)
	var/T = 0
	for(var/K in L)
		T += L[K]
	return T

/obj/item/pokerchip/thousand
	credits = 1000

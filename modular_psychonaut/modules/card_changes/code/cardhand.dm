/obj/item/toy/cards/cardhand/attack_self_secondary(mob/user, modifiers)
	. = ..()

	if(!isliving(user) || !user.can_perform_action(src, NEED_DEXTERITY | FORBID_TELEKINESIS_REACH))
		return

	var/list/handradial = list()
	for(var/obj/item/toy/singlecard/card in fetch_card_atoms())
		handradial[card] = image(icon = src.icon, icon_state = card.icon_state)

	var/obj/item/toy/singlecard/choice = show_radial_menu(usr, src, handradial, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 36, require_near = TRUE)
	if(!choice)
		return FALSE

	choice.Flip()

	update_appearance()

/obj/item/toy/cards/cardhand/click_alt_secondary(mob/user)
	. = ..()

	if(!isliving(user) || !user.can_perform_action(src, NEED_DEXTERITY | FORBID_TELEKINESIS_REACH) || user.held_items[user.active_hand_index] != src)
		return

	for(var/obj/item/toy/singlecard/card in fetch_card_atoms())
		card.Flip()

	update_appearance()

/mob/Logout()
	SEND_SIGNAL(src, COMSIG_MOB_LOGOUT)
	log_message("[key_name(src)] is no longer owning mob [src]([src.type])", LOG_OWNERSHIP)
	SStgui.on_logout(src)
	remove_from_player_list()
	update_ambience_area(null) // Unset ambience vars so it plays again on login

	if(client && isliving(src) && (!iscyborg(src) && !isaicamera(src) && !isAI(src)))
		client.screen -= name_tag_shadow
		name_tag_shadow.UnregisterSignal(src, COMSIG_MOVABLE_Z_CHANGED)
		hud_used?.always_visible_inventory -= name_tag_shadow
		QDEL_NULL(name_tag_shadow)

	..()

	if(loc)
		loc.on_log(FALSE)

	become_uncliented()

	return TRUE

/proc/get_sechud_icon(sechud_icon_state)
	. = DEFAULT_HUD_FILE
	if(GLOB.psychonaut_sechuds.Find(sechud_icon_state))
		return PSYCHONAUT_HUD_FILE

/// Returns the trim sechud icon state.
/obj/item/card/id/proc/get_trim_sechud_icon()
	var/sechud_icon_state = get_trim_sechud_icon_state()
	return get_sechud_icon(sechud_icon_state)

/atom/proc/set_hud_image(hud_type, hud_icon)
	if (!hud_list) // Still initializing
		return
	var/image/holder = hud_list[hud_type]
	if (!holder)
		return
	if (!istype(holder)) // Can contain lists for HUD_LIST_LIST hinted HUDs, if someone fucks up and passes this here we wanna know about it
		CRASH("[src] ([type]) had a HUD_LIST_LIST hud_type [hud_type] passed into set_hud_image_state!")
	holder.icon = hud_icon

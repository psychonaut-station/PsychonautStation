/**
 * AI Core Display Picker TGUI
 * Allows AIs to select core display options with search functionality
 */
/datum/ai_core_display_picker
	var/mob/living/silicon/ai/ai_user

/datum/ai_core_display_picker/New(mob/living/silicon/ai/user)
	ai_user = user

/datum/ai_core_display_picker/ui_status(mob/user, datum/ui_state/state)
	if(!ai_user || user != ai_user || ai_user.incapacitated)
		return UI_CLOSE
	return ..()

/datum/ai_core_display_picker/ui_state(mob/user)
	return GLOB.always_state

/datum/ai_core_display_picker/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AiCoreDisplayPicker")
		ui.open()

/datum/ai_core_display_picker/ui_close(mob/user)
	if(ai_user)
		ai_user.core_display_picker = null

/datum/ai_core_display_picker/ui_data(mob/user)
	var/list/data = list()

	// If no override is set, find the actual current display from the AI's icon state
	var/current_display = ai_user.display_icon_override
	var/current_icon = ai_user.icon // PSYCHONAUT ADDITION - AI_SCREENS
	if(!current_display)
		// Default to "Blue" if no override
		current_display = "Blue"
		current_icon = initial(ai_user.icon)
		// Try to identify current display
		if(ai_user.icon_state)
			for(var/display_name in GLOB.ai_core_display_screens)
				if("ai-[LOWER_TEXT(display_name)]" == ai_user.icon_state)
					current_display = display_name
					break

	// PSYCHONAUT ADDITION BEGIN - AI_SCREENS
	if(GLOB.ai_core_display_screen_icons.Find(preferred_icon))
		screen_icon = GLOB.ai_core_display_screen_icons[preferred_icon]
	// PSYCHONAUT ADDITION END - AI_SCREENS

	data["current_display"] = current_display

	// Get icon for current display
	var/current_icon_state = resolve_ai_icon_sync(current_display)
	data["current_icon"] = list(
		"icon" = screen_icon, // PSYCHONAUT EDIT ADDITION - AI_SCREENS - Original: "icon" = 'icons/mob/silicon/ai.dmi',
		"icon_state" = current_icon_state
	)

	var/list/options = list()

	for(var/option_name in GLOB.ai_core_display_screens)
		var/icon_state = resolve_ai_icon_sync(option_name)
		var/list/option_data = list(
			"name" = option_name,
			"icon_state" = icon_state,
			"icon" = screen_icon // PSYCHONAUT EDIT ADDITION - AI_SCREENS - Original: "icon" = 'icons/mob/silicon/ai.dmi'
		)
		options += list(option_data)

	data["options"] = options

	return data

/datum/ai_core_display_picker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("select_option")
			var/chosen_option = params["option"]
			if(chosen_option in GLOB.ai_core_display_screens)
				ai_user.display_icon_override = chosen_option
				ai_user.set_core_display_icon(chosen_option)
				return TRUE

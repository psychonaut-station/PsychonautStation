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
	var/list/available_options = ai_user.get_available_core_display_options()
	var/list/all_options = ai_user.get_available_core_display_options(TRUE)

	var/current_display = ai_user.selected_display_name
	if(!current_display || !(current_display in all_options))
		current_display = "Blue"

	data["current_display"] = current_display


	// Get icon for current display
	var/current_icon_state = get_ai_display_state(current_display)
	var/current_icon = get_ai_display_icon(current_display)
	data["current_icon"] = list(
		"icon" = current_icon,
		"icon_state" = current_icon_state
	)

	var/list/options = list()

	for(var/option_name in available_options)
		var/icon_state = get_ai_display_state(option_name)
		var/icon = get_ai_display_icon(option_name)
		var/list/option_data = list(
			"name" = option_name,
			"icon_state" = icon_state,
			"icon" = icon
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
			var/list/available_options = ai_user.get_available_core_display_options()
			if(chosen_option in available_options)
				ai_user.set_core_display_icon(chosen_option)
				return TRUE

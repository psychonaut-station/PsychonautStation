/datum/ai_goon_core_customizer
	var/mob/living/silicon/ai/ai_user

/datum/ai_goon_core_customizer/New(mob/living/silicon/ai/user)
	ai_user = user

/datum/ai_goon_core_customizer/ui_status(mob/user, datum/ui_state/state)
	if(!ai_user || user != ai_user || ai_user.incapacitated || !ai_user.has_goon_core_refit())
		return UI_CLOSE
	return UI_INTERACTIVE

/datum/ai_goon_core_customizer/ui_state(mob/user)
	return GLOB.always_state

/datum/ai_goon_core_customizer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AiGoonCoreCustomizer", "Goon Core Matrix")
		ui.open()

/datum/ai_goon_core_customizer/ui_close(mob/user)
	if(ai_user)
		ai_user.goon_core_customizer = null

/datum/ai_goon_core_customizer/ui_data(mob/user)
	init_ai_goon_face_options()
	var/list/data = list()
	var/current_core_name = get_ai_goon_core_label(ai_user.goon_core_skin)
	var/current_background_name = get_ai_goon_background_label(ai_user.goon_core_background)
	var/current_light_mode_name = get_ai_goon_light_mode_label(ai_user.goon_core_light_mode)
	var/current_face_name = get_ai_goon_face_label(ai_user.goon_core_face)

	data["icon"] = 'icons/psychonaut/ai_screens/goon_core.dmi'
	data["current_core_name"] = current_core_name
	data["current_core_state"] = ai_user.goon_core_skin
	data["current_core_description"] = GLOB.ai_goon_core_skin_descriptions[current_core_name] || ""
	data["current_background_name"] = current_background_name
	data["current_background_state"] = ai_user.goon_core_background
	data["current_light_mode_name"] = current_light_mode_name
	data["current_light_mode"] = ai_user.goon_core_light_mode
	data["current_face_name"] = current_face_name
	data["current_face_state"] = ai_user.goon_core_face
	data["current_light_state"] = get_ai_goon_light_state(ai_user.goon_core_skin, ai_user.goon_core_light_mode, FALSE)
	data["core_count"] = length(GLOB.ai_goon_core_skin_options)
	data["background_count"] = length(GLOB.ai_goon_background_options)
	data["light_mode_count"] = length(GLOB.ai_goon_light_mode_options)
	data["face_count"] = length(GLOB.ai_goon_face_options)

	data["core_options"] = list()
	for(var/core_name in GLOB.ai_goon_core_skin_options)
		data["core_options"] += list(list(
			"name" = core_name,
			"state" = GLOB.ai_goon_core_skin_options[core_name],
			"description" = GLOB.ai_goon_core_skin_descriptions[core_name] || "",
		))

	data["background_options"] = list()
	for(var/background_name in GLOB.ai_goon_background_options)
		data["background_options"] += list(list(
			"name" = background_name,
			"state" = GLOB.ai_goon_background_options[background_name],
		))

	data["light_mode_options"] = list()
	for(var/light_mode_name in GLOB.ai_goon_light_mode_options)
		var/light_mode = GLOB.ai_goon_light_mode_options[light_mode_name]
		data["light_mode_options"] += list(list(
			"name" = light_mode_name,
			"state" = light_mode,
			"preview_state" = get_ai_goon_light_state(ai_user.goon_core_skin, light_mode, FALSE) || ai_user.goon_core_skin,
		))

	data["face_options"] = list()
	for(var/face_name in GLOB.ai_goon_face_options)
		data["face_options"] += list(list(
			"name" = face_name,
			"state" = GLOB.ai_goon_face_options[face_name],
		))

	return data

/datum/ai_goon_core_customizer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ai_user)
		return FALSE

	switch(action)
		if("select_core")
			var/selected_core = params["state"]
			if(!is_ai_goon_core_skin_state(selected_core))
				return FALSE
			ai_user.set_goon_core_visuals(selected_core, null, TRUE)
			return TRUE
		if("select_background")
			var/selected_background = params["state"]
			if(!is_ai_goon_background_state(selected_background))
				return FALSE
			ai_user.set_goon_core_visuals(null, null, TRUE, selected_background)
			return TRUE
		if("select_light_mode")
			var/selected_light_mode = params["state"]
			if(!is_ai_goon_light_mode(selected_light_mode))
				return FALSE
			ai_user.set_goon_core_light_mode(selected_light_mode, TRUE)
			return TRUE
		if("select_face")
			var/selected_face = params["state"]
			if(!is_ai_goon_face_state(selected_face))
				return FALSE
			ai_user.set_goon_core_visuals(null, selected_face, TRUE)
			return TRUE

	return FALSE

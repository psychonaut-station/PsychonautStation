
/obj/vehicle/sealed/car/vim/ui_close(mob/user)
	. = ..()
	ui_view.hide_from(user)

/obj/vehicle/sealed/car/vim/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Vim", name)
		ui.open()
		ui_view.display_to(user)

/obj/vehicle/sealed/car/vim/ui_status(mob/user)
	if(driver == user)
		return UI_INTERACTIVE
	return min(
		ui_status_only_living(user),
	)

/obj/vehicle/sealed/car/vim/ui_static_data(mob/user)
	var/list/data = list()
	data["minfreq"] = MIN_FREE_FREQ
	data["maxfreq"] = MAX_FREE_FREQ
	return data

/obj/vehicle/sealed/car/vim/ui_data(mob/user)
	var/list/data = list()
	var/datum/component/shell/vim_shell = GetComponent(/datum/component/shell)
	var/obj/item/integrated_circuit/vim_circuit = vim_shell.attached_circuit
	var/obj/item/stock_parts/cell/circuitcell = vim_circuit?.get_cell()
	var/charge
	var/maxcharge
	if(vim_shell && circuitcell)
		charge = circuitcell.charge
		maxcharge = circuitcell.maxcharge
	else
		charge = null
		maxcharge = null
	ui_view.appearance = appearance
	data["name"] = name
	data["integrity"] = atom_integrity/max_integrity
	data["circuit"] = vim_circuit ? TRUE : FALSE
	data["power_level"] = charge
	data["power_max"] = maxcharge
	data["mech_view"] = ui_view.assigned_map
	if(radio)
		data["microphone"] = radio.get_broadcasting()
		data["speaker"] = radio.get_listening()
		data["frequency"] = radio.get_frequency()
	return data

/obj/vehicle/sealed/car/vim/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("toggle_microphone")
			radio.set_broadcasting(!radio.get_broadcasting())
		if("toggle_speaker")
			radio.set_listening(!radio.get_listening())
		if("set_frequency")
			radio.set_frequency(sanitize_frequency(params["new_frequency"], radio.freerange, FALSE))
		if("toggle_lights")
			SEND_SIGNAL(src, COMSIG_VIM_HEADLIGHTS_TOGGLED, headlights_toggle)
			headlights_toggle = !headlights_toggle
			set_light_on(headlights_toggle)
			update_appearance()

	return TRUE

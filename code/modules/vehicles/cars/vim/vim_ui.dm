
/obj/vehicle/sealed/car/vim/ui_close(mob/user)
	. = ..()
	ui_view.hide_from(user)

/obj/vehicle/sealed/car/vim/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Mecha", name)
		ui.open()
		ui_view.display_to(user)

/obj/vehicle/sealed/car/vim/ui_status(mob/user)
	if(driver == user)
		return UI_INTERACTIVE
	return min(
		ui_status_only_living(user),
	)

/obj/vehicle/sealed/car/vim/ui_data(mob/user)
	var/list/data = list()
	ui_view.appearance = appearance
	data["name"] = name
	data["integrity"] = atom_integrity/max_integrity
	data["power_level"] = cell?.charge
	data["power_max"] = cell?.maxcharge
	data["mech_view"] = ui_view.assigned_map

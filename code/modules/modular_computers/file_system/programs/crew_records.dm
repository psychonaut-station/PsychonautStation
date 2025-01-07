/datum/computer_file/program/crew_records
	filename = "crewrecords"
	filedesc = "Crew Records"
	downloader_category = PROGRAM_CATEGORY_DEVICE
	program_icon = "clipboard-user"
	program_open_overlay = "crew"
	extended_desc = "Program for viewing and printing the current crew manifest"
	program_flags = PROGRAM_ON_NTNET_STORE | PROGRAM_REQUIRES_NTNET
	download_access = list(ACCESS_COMMAND, ACCESS_DETECTIVE)
	size = 8
	tgui_id = "NtosCrewRecords"

	var/authenticated = FALSE
	/// The character preview view for the UI.
	var/atom/movable/screen/map_view/char_preview/character_preview_view

/datum/computer_file/program/crew_records/Destroy()
	QDEL_NULL(character_preview_view)
	return ..()

/datum/computer_file/program/secureye/kill_program(mob/user)
	if(user)
		ui_close(user)
	return ..()

/datum/computer_file/program/crew_records/ui_interact(mob/user, datum/tgui/ui)
	character_preview_view = create_character_preview_view(user)

/datum/computer_file/program/crew_records/ui_static_data(mob/user)
	var/list/data = list()
	data["min_age"] = AGE_MIN
	data["max_age"] = AGE_MAX
	return data

/datum/computer_file/program/crew_records/ui_data(mob/user)
	var/list/data = list()

	var/has_access = (authenticated && isliving(user))

	data["authenticated"] = has_access

	if(!has_access)
		return data

	data["assigned_view"] = USER_PREVIEW_ASSIGNED_VIEW(user.ckey)

	data["station_z"] = !!(computer?.z && is_station_level(computer?.z))
	var/list/records = list()
	for(var/datum/record/crew/target in GLOB.manifest.general)
		records += list(list(
			age = target.age,
			blood_type = target.blood_type,
			crew_ref = REF(target),
			gender = target.gender,
			major_disabilities = target.major_disabilities_desc,
			minor_disabilities = target.minor_disabilities_desc,
			name = target.name,
			quirk_notes = target.quirk_notes,
			rank = target.rank,
			species = target.species,
			trim = target.trim,
			employment_records = target.employment_records,
			exploit_records = target.exploit_records,
		))

	data["records"] = records

	return data

/datum/computer_file/program/crew_records/ui_close(mob/user)
	. = ..()
	user.client?.screen_maps -= USER_PREVIEW_ASSIGNED_VIEW(user.ckey)
	if((LAZYLEN(open_uis) <= 1) && character_preview_view) //only delete the preview if we're the last one to close the console.
		QDEL_NULL(character_preview_view)

/datum/computer_file/program/crew_records/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui.user

	var/datum/record/crew/target
	if(params["crew_ref"])
		target = locate(params["crew_ref"]) in GLOB.manifest.general

	switch(action)
		if("edit_field")
			target = locate(params["ref"]) in GLOB.manifest.general
			var/field = params["field"]
			if(!field || !(field in target?.vars))
				return FALSE

			var/value = trim(params["value"], MAX_BROADCAST_LEN)
			computer.investigate_log("[key_name(user)] changed the field: \"[field]\" with value: \"[target.vars[field]]\" to new value: \"[value || "Unknown"]\"", INVESTIGATE_RECORDS)
			target.vars[field] = value || "Unknown"

			return TRUE

		if("expunge_record")
			if(!target)
				return FALSE
			// Don't let people off station futz with the station network.
			if(!is_station_level(computer.z))
				computer.balloon_alert(user, "out of range!")
				return TRUE

			expunge_record_info(target)
			computer.balloon_alert(user, "record expunged")
			playsound(computer, 'sound/machines/terminal/terminal_eject.ogg', 70, TRUE)
			computer.investigate_log("[key_name(user)] expunged the record of [target.name].", INVESTIGATE_RECORDS)

			return TRUE

		if("login")
			authenticated = secure_login(user)
			computer.investigate_log("[key_name(user)] [authenticated ? "successfully logged" : "failed to log"] into the [computer].", INVESTIGATE_RECORDS)
			return TRUE

		if("logout")
			computer.balloon_alert(user, "logged out")
			playsound(computer, 'sound/machines/terminal/terminal_off.ogg', 70, TRUE)
			authenticated = FALSE

			return TRUE

		if("purge_records")
			// Don't let people off station futz with the station network.
			if(!is_station_level(computer.z))
				computer.balloon_alert(user, "out of range!")
				return TRUE

			ui.close()
			computer.balloon_alert(user, "purging records...")
			playsound(computer, 'sound/machines/terminal/terminal_alert.ogg', 70, TRUE)

			if(do_after(user, 5 SECONDS))
				for(var/datum/record/crew/entry in GLOB.manifest.general)
					expunge_record_info(entry)

				computer.balloon_alert(user, "records purged")
				playsound(computer, 'sound/machines/terminal/terminal_off.ogg', 70, TRUE)
				computer.investigate_log("[key_name(user)] purged all records.", INVESTIGATE_RECORDS)
			else
				computer.balloon_alert(user, "interrupted!")

			return TRUE

		if("view_record")
			if(!target)
				return FALSE

			update_preview(user, params["assigned_view"], target)
			return TRUE

	return FALSE

/// Creates a character preview view for the UI.
/datum/computer_file/program/crew_records/proc/create_character_preview_view(mob/user)
	var/assigned_view = USER_PREVIEW_ASSIGNED_VIEW(user.ckey)
	if(user.client?.screen_maps[assigned_view])
		return

	var/atom/movable/screen/map_view/char_preview/new_view = new(null, src)
	new_view.generate_view(assigned_view)
	new_view.display_to(user)
	return new_view

/// Takes a record and updates the character preview view to match it.
/datum/computer_file/program/crew_records/proc/update_preview(mob/user, assigned_view, datum/record/crew/target)
	var/mutable_appearance/preview = new(target.character_appearance)
	preview.underlays += mutable_appearance('icons/effects/effects.dmi', "static_base", alpha = 20)
	preview.add_overlay(mutable_appearance(generate_icon_alpha_mask('icons/effects/effects.dmi', "scanline"), alpha = 20))

	var/atom/movable/screen/map_view/char_preview/old_view = user.client?.screen_maps[assigned_view]?[1]
	if(!old_view)
		return

	old_view.appearance = preview.appearance

/datum/computer_file/program/crew_records/proc/expunge_record_info(datum/record/crew/target)
	if(!target)
		return FALSE

	target.age = 18
	target.blood_type = pick(list("A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"))
	target.gender = "Unknown"
	target.major_disabilities = ""
	target.major_disabilities_desc = ""
	target.minor_disabilities = ""
	target.minor_disabilities_desc = ""
	target.name = "Unknown"
	target.quirk_notes = ""
	target.rank = "Unknown"
	target.species = "Unknown"
	target.trim = "Unknown"

	return TRUE

/// Secure login
/datum/computer_file/program/crew_records/proc/secure_login(mob/user)
	var/mob/living/L = user

	var/obj/item/card/id/id_card = L.get_idcard(hand_first = TRUE)

	if(!check_access(id_card) && !check_access(computer.computer_id_slot))
		computer.balloon_alert(user, "access denied")
		playsound(computer, 'sound/machines/terminal/terminal_error.ogg', 70, TRUE)
		return FALSE

	computer.balloon_alert(user, "logged in")
	playsound(computer, 'sound/machines/terminal/terminal_on.ogg', 70, TRUE)

	return TRUE

/datum/computer_file/program/crew_records/proc/check_access(obj/item/I)
	var/access_list = (I ? I.GetAccess() : null)
	if(!length(download_access))
		return TRUE

	if(!length(access_list) || !islist(access_list))
		return FALSE

	for(var/req in download_access)
		if(req in access_list)
			return TRUE

	return FALSE

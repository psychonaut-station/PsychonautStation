/obj/machinery/computer/records/crew
	name = "crew records console"
	desc = "This can be used to check crew records."
	icon_screen = "explosive"
	icon_keyboard = "security_key"
	req_one_access = list(ACCESS_COMMAND, ACCESS_DETECTIVE)
	circuit = /obj/item/circuitboard/computer/crew_data
	light_color = LIGHT_COLOR_BLUE

/obj/machinery/computer/records/crew/syndie
	icon_keyboard = "syndie_key"
	req_one_access = list(ACCESS_SYNDICATE)

/obj/machinery/computer/records/crew/laptop
	name = "crew laptop"
	desc = "A cheap Nanotrasen crew laptop, it functions as a crew records computer. It's bolted to the table."
	icon = 'modular_psychonaut/master_files/icons/obj/machines/computer.dmi'
	icon_state = "laptop"
	icon_screen = "crewlaptop"
	icon_keyboard = "laptop_key"
	pass_flags = PASSTABLE
	projectiles_pass_chance = 100

/obj/machinery/computer/records/crew/attacked_by(obj/item/attacking_item, mob/living/user)
	. = ..()
	if(!istype(attacking_item, /obj/item/photo))
		return
	insert_new_record(user, attacking_item)

/obj/machinery/computer/records/crew/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	if(.)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		character_preview_view = create_character_preview_view(user)
		ui = new(user, src, "CrewRecords")
		ui.set_autoupdate(FALSE)
		ui.open()

/obj/machinery/computer/records/crew/ui_data(mob/user)
	var/list/data = ..()

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

/obj/machinery/computer/records/crew/ui_static_data(mob/user)
	var/list/data = list()
	data["min_age"] = AGE_MIN
	data["max_age"] = AGE_MAX
	return data

/// Deletes crew information from a record.
/obj/machinery/computer/records/crew/expunge_record_info(datum/record/crew/target)
	if(!target)
		return FALSE

	target.age = 18
	target.blood_type = pick("A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-")
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
	target.employment_records = ""
	target.exploit_records = ""

	return TRUE

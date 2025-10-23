/// Renders a ckey's preferences appearance from their savefile
/proc/render_offline_appearance(ckey, mob/living/carbon/human/dummy/our_human)
	if(!ckey || is_guest_key(ckey) || (!isnull(our_human) && !istype(our_human)))
		return FALSE
	var/save_path = "data/player_saves/[ckey[1]]/[ckey]/preferences.json"
	if(!fexists(save_path))
		return FALSE
	var/list/tree = json_decode(rustg_file_read(save_path))	// Reading savefile
	var/default_slot = tree["default_slot"] || 1
	var/selected_char = tree["character[default_slot]"] || tree["character1"]

	var/list/job_preferences = SANITIZE_LIST(selected_char?["job_preferences"])

	var/datum/job/selected_job
	var/highest_pref = 0

	for(var/job in job_preferences)
		if(job_preferences[job] > highest_pref)
			selected_job = SSjob.get_job(job)
			highest_pref = job_preferences[job]

	if(selected_job && !ispath(selected_job::spawn_type, /mob/living/carbon/human)) // If the selected job's spawn_type isnt human (AI, cyborg etc.) we just returning mutable_appearance
		var/mob/living/spawn_type = selected_job::spawn_type
		var/mutable_appearance/appearance = mutable_appearance(spawn_type::icon, spawn_type::icon_state)
		appearance.name = ckey
		if(ispath(spawn_type, /mob/living/silicon/ai))
			var/ai_core_value = selected_char?["preferred_ai_core_display"]
			appearance.icon_state = resolve_ai_icon_sync(ai_core_value)
		return appearance

	var/we_created = FALSE
	if(isnull(our_human))
		our_human = new()
		we_created = TRUE
	else
		our_human.wipe_state() // We're wiping the dummys overlays and outfit
		our_human.set_species(/datum/species/human) // We're setting it to human beacuse if the savefile doesnt have species entry, it doesnt use previous icon's species
		our_human.icon_render_keys = list()
		our_human.update_body(is_creating = TRUE) // We're recreating bodyparts etc.

	for (var/datum/preference/preference as anything in get_preferences_in_priority_order()) // Apply the preferences in priority order
		if (preference.savefile_identifier != PREFERENCE_CHARACTER)
			continue
		var/saved_data = selected_char?[preference.savefile_key]
		if(!saved_data)
			continue
		var/new_value = preference.deserialize(saved_data)

		preference.apply_to_human(our_human, new_value)

	var/datum/outfit/equipped_outfit

	if(selected_job) // Selecting and creating outfit datum
		var/datum/outfit/outfit_type
		if(selected_job::outfit)
			outfit_type = selected_job::outfit
		if(selected_char?["species"] == SPECIES_PLASMAMAN && selected_job::plasmaman_outfit) // If they are plasmaman, give them plasmaman outfit
			outfit_type = selected_job::outfit
		if(outfit_type)
			equipped_outfit = new outfit_type()
	else
		equipped_outfit = new()

	var/list/loadout_preference_list = SANITIZE_LIST(selected_char?["loadout_list"])
	var/datum/preference/loadout/loadout_preference = GLOB.preference_entries[/datum/preference/loadout]

	var/list/loadout_datums = loadout_list_to_datums(loadout_preference.deserialize(loadout_preference_list))

	for(var/datum/loadout_item/item as anything in loadout_datums) // Adding loadout items to outfit
		item.insert_path_into_outfit(equipped_outfit, our_human, TRUE)

	equipped_outfit.equip(our_human, TRUE)

	var/list/all_quirks = SANITIZE_LIST(selected_char?["all_quirks"])
	if(SSquirks?.initialized)
		our_human.cleanse_quirk_datums() // We need to clean all the quirk datums every time
		for(var/quirk_name in all_quirks)
			var/datum/quirk/quirk_type = SSquirks.quirks[quirk_name]
			if(!(initial(quirk_type.quirk_flags) & QUIRK_CHANGES_APPEARANCE))
				continue
			our_human.add_quirk(quirk_type)

	var/mutable_appearance/appearance = new
	appearance.appearance = our_human.appearance
	appearance.name = ckey
	if(we_created)
		qdel(our_human)

	return appearance

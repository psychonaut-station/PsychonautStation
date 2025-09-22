ADMIN_VERB(storyteller_panel, R_ADMIN, "Storyteller Panel", "Change the Storyteller.", ADMIN_CATEGORY_GAME)
	storyteller_panel(user.mob)

/proc/storyteller_panel(mob/user)
	if(!check_rights(R_ADMIN))
		return
	var/datum/storyteller_panel/tgui = new()
	tgui.ui_interact(user)

	log_admin("[key_name(user)] opened the Storyteller Panel.")
	if(!isobserver(user))
		message_admins("[key_name_admin(user)] opened the Storyteller Panel.")
	BLACKBOX_LOG_ADMIN_VERB("Storyteller Panel")

/datum/storyteller_panel

/datum/storyteller_panel/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/datum/storyteller_panel/ui_close()
	qdel(src)

/datum/storyteller_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "StorytellerAdmin")
		ui.open()

/datum/storyteller_panel/ui_data(mob/user)
	var/next_storyteller
	if(SSstoryteller.next_storyteller)
		next_storyteller = SSstoryteller.next_storyteller.name

	var/list/data = list()
	var/list/storytellers = list()
	for(var/datum/storyteller/storyteller in SSstoryteller.storyteller_prototypes)
		storytellers += list(list(
			"name" = storyteller.name,
			"desc" = storyteller.desc,
			"restricted" = storyteller.restricted
		))
	data["storytellers"] = storytellers
	data["current_storyteller"] = SSstoryteller.current_storyteller?.name
	data["next_storyteller"] = next_storyteller
	return data

/datum/storyteller_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("set_storyteller")
			var/storyteller_name = params["storyteller_name"]
			var/for_current_round = params["current_round"]
			return SSstoryteller.set_storyteller(storyteller_name, for_current_round, TRUE)
		if("storyteller_vv")
			ui.user?.client?.debug_variables(SSstoryteller)
			return TRUE

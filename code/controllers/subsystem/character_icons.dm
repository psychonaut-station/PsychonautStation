SUBSYSTEM_DEF(character_icons)
	name = "Character Icons"
	flags = SS_NO_INIT
	priority = FIRE_PRIORITY_CHARACTER_ICONS
	wait = 20 MINUTES

	var/list/queued_icons  = list()
	var/list/round_character_icons = list()

/datum/controller/subsystem/character_icons/fire(resumed)
	if(!queued_icons.len)
		return

	while(queued_icons.len)
		var/id = queued_icons[queued_icons.len]
		var/mutable_appearance/appearance = queued_icons[id]
		queued_icons.len--
		var/datum/universal_icon/output = get_flat_uni_icon_for_all_directions(appearance)
		round_character_icons["[id]"] = output.to_list()
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/character_icons/proc/add_to_queue(id, mutable_appearance/appearance)
	queued_icons["[id]"] = appearance

/datum/controller/subsystem/character_icons/proc/get_flat_uni_icon_for_all_directions(atom/thing)
	var/datum/universal_icon/output = uni_icon('icons/effects/effects.dmi', "nothing")
	output.scale(64,64)
	for(var/direction in GLOB.cardinals)
		var/datum/universal_icon/partial = get_flat_uni_icon(thing, defdir = direction)
		switch(direction)
			if(SOUTH)
				output.blend_icon(partial, ICON_OVERLAY, 1, 33)
			if(NORTH)
				output.blend_icon(partial, ICON_OVERLAY, 33, 33)
			if(EAST)
				output.blend_icon(partial, ICON_OVERLAY)
			if(WEST)
				output.blend_icon(partial, ICON_OVERLAY, 33, 1)
		CHECK_TICK
	return output

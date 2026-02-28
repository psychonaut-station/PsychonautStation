SUBSYSTEM_DEF(character_icons)
	name = "Character Icons"
	flags = SS_NO_INIT
	priority = FIRE_PRIORITY_CHARACTER_ICONS
	wait = 10 MINUTES

	var/list/processing_icons = list()

	var/list/currentrun = list()

	var/list/round_character_icons = list()

/datum/controller/subsystem/character_icons/fire(resumed)
	if(!resumed)
		src.currentrun = processing_icons.Copy()

	while(currentrun.len)
		var/datum/weakref/weakref = currentrun[currentrun.len]
		var/mutable_appearance/appearance = currentrun[weakref]

		currentrun.len--
		update_character_icon(weakref, null, appearance)

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/character_icons/Recover()
	processing_icons = SScharacter_icons.processing_icons
	round_character_icons = SScharacter_icons.round_character_icons

/datum/controller/subsystem/character_icons/proc/add_to_queue(datum/weakref/mind_weakref)
	var/datum/mind/character_mind = mind_weakref?.resolve()
	var/mob/living/living_mob = character_mind?.current

	var/mutable_appearance/appearance = update_character_icon(mind_weakref, character_mind)

	if(isnull(appearance)) return

	var/character_name = character_mind.name || living_mob.real_name

	var/id = "[character_name]_[ckey(character_mind.key)]"

	if(SSticker.current_state == GAME_STATE_PLAYING && !processing_icons[mind_weakref])
		save_character(id, appearance) // If the character icon doesnt exist and game is started, save it now

	CHECK_TICK

	processing_icons[mind_weakref] = appearance
	return appearance

/datum/controller/subsystem/character_icons/proc/handle_roundstart()
	debug_to_adminlog("DEBUG: SScharacter_icons saving [processing_icons.len] icons", processing_icons.len)
	for(var/datum/weakref/weakref in processing_icons)
		var/mutable_appearance/appearance = processing_icons[weakref]
		var/datum/mind/character_mind = weakref?.resolve()
		var/mob/living/living_mob = character_mind?.current

		var/character_name = character_mind.name || living_mob.real_name
		var/id = "[character_name]_[ckey(character_mind.key)]"
		save_character(id, appearance)
		CHECK_TICK

/datum/controller/subsystem/character_icons/proc/save_character(id, mutable_appearance/appearance)
	round_character_icons["[id]"] = get_iconforge_sprites_data(appearance)

/datum/controller/subsystem/character_icons/proc/update_character_icon(datum/weakref/mind_weakref, datum/mind/character_mind, mutable_appearance/appearance)
	if(!character_mind)
		character_mind = mind_weakref?.resolve()

	var/mob/living/living_mob = character_mind?.current

	CHECK_TICK

	var/mutable_appearance/old_appearance = appearance || processing_icons[mind_weakref] // appearance overridesi varsa onu kullan yoksa eskiden processlendiyse onu getir

	if(!appearance) // Appearance yoksa
		if(old_appearance) // Weakref önceden processlendiyse onu getir
			appearance = old_appearance
		else if(living_mob) // Yoksa ve living_mob gerçekce sıfırdan olustur
			appearance = new (living_mob.get_mob_appearance())

	if(character_mind && living_mob && old_appearance && living_mob.stat != DEAD) // Appearance eskiden processlendiyse güncelle
		if(istype(living_mob) && !isbrain(living_mob))
			appearance.copy_overlays(living_mob, TRUE)
		else
			appearance.appearance = living_mob.get_mob_appearance()

	if(!appearance) return

	CHECK_TICK

	appearance.transform = matrix() // Eğer ikon yatıyor durumda ise vs düzgün durmasını sağla
	appearance.setDir(SOUTH) // Güneye (bize) bakmasını sağla

	CHECK_TICK

	var/character_name = character_mind.name || living_mob.real_name

	if(character_mind && living_mob) // Credits shit
		var/bound_width = living_mob.bound_width || world.icon_size
		appearance.maptext_width = 88
		appearance.maptext_height = world.icon_size * 1.5
		appearance.maptext_x = ((88 - bound_width) * -0.5) - living_mob.base_pixel_x
		appearance.maptext_y = -16
		appearance.maptext = "<center>[character_name]</center>"

	return appearance

/datum/controller/subsystem/character_icons/proc/get_character_icon(datum/weakref/weakref)
	if(isnull(weakref))
		return
	return processing_icons[weakref]

/datum/controller/subsystem/character_icons/proc/get_flat_uni_icon_for_all_directions(atom/thing) // Çok kastırırsa sadece southa çeviririz
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

/datum/controller/subsystem/character_icons/proc/debug_to_adminlog(text, character_length) // JUST FOR TM
	message_admins(text)
	if(character_length)
		SSblackbox.record_feedback("nested tally", "generate_character_icons", list("generated" = character_length))

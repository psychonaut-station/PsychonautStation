/datum/mood_event/efkar
	hidden = TRUE
	timeout = 30 MINUTES  // make it long so the song wont keep playing over and over

/datum/mood_event/efkar/add_effects(param)
	if (isnull(owner))
		return

	to_chat(owner, span_notice("A song starts playing inside your head."))
	owner.playsound_local(get_turf(owner), 'modular_psychonaut/master_files/sound/effects/mood_efkar.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = TRUE)

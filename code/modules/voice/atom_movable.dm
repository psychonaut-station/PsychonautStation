/atom/movable
	var/datum/atom_voice/bark_voice = null
	/// When barks are queued, this gets passed to the bark proc. If long_bark_start_time doesn't match the args passed to the bark proc (if passed at all), then the bark simply doesn't play. Basic curtailing of spam~
	var/long_bark_start_time = -1

/atom/movable/proc/initial_voice_pack_id()
	return null

/atom/movable/proc/get_bark_voice() as /datum/atom_voice
	if (bark_voice)
		return bark_voice
	bark_voice = new()
	bark_voice.set_voice_pack(initial_voice_pack_id())
	return bark_voice

/// Sets the voicepack for the atom, using the voicepack's ID
/atom/movable/proc/set_voice_pack(id)
	if (bark_voice)
		bark_voice.set_voice_pack(id)
	else
		bark_voice = new()
		bark_voice.set_voice_pack(id)

/atom/movable/proc/can_long_bark()
	return FALSE

/mob/living/initial_voice_pack_id()
	return length(GLOB.random_voice_packs) ? pick(GLOB.random_voice_packs) : "fallback.fallback"

/mob/living/silicon/robot/initial_voice_pack_id()
	return "talk.cyborg"

/mob/living/silicon/ai/initial_voice_pack_id()
	return "talk.bottalk_1"

/mob/can_long_bark()
	return !isnull(client)

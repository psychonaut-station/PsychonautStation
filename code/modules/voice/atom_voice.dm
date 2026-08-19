/datum/atom_voice
	var/datum/voice_pack/voicepack
	var/pitch = 1
	var/pitch_range = 0.2
	var/base_volume = 300
	var/speed = 6

/datum/atom_voice/proc/set_voice_pack(id)
	voicepack = GLOB.voice_pack_list[id]

/datum/atom_voice/proc/copy_from(datum/atom_voice/other)
	voicepack = other.voicepack
	pitch = other.pitch
	pitch_range = other.pitch_range
	base_volume = other.base_volume
	speed = other.speed

/datum/atom_voice/proc/set_from_prefs(datum/preferences/prefs)
	if (!prefs)
		return
	set_voice_pack(prefs.read_preference(/datum/preference/choiced/voice_pack))
	pitch = prefs.read_preference(/datum/preference/numeric/bark_speech_pitch)
	speed = prefs.read_preference(/datum/preference/numeric/bark_speech_speed)
	pitch_range = prefs.read_preference(/datum/preference/numeric/bark_pitch_range)

/datum/atom_voice/proc/randomise(atom/who)
	set_voice_pack(pick(GLOB.random_voice_packs))
	pitch = ((who.gender == MALE ? rand(60, 120) : (who.gender == FEMALE ? rand(80, 140) : rand(60,140))) / 100)
	pitch_range = 0.2
	speed = 6
	base_volume = 300

/// Plays a bark sound to an individual listener mob, respecting their preferences and speaker properties
/datum/atom_voice/proc/play_bark_to(mob/hearer, atom/movable/speaker, talk_icon_state, is_speaker_whispering, message_len, message_range)
	if (!voicepack || !GLOB.voices_enabled || QDELETED(speaker) || QDELETED(hearer))
		return
	if (!message_len)
		return

	var/client/hearer_client = hearer.client
	if (!hearer_client?.prefs)
		return
	if (!hearer_client.prefs.read_preference(/datum/preference/toggle/barks_enabled))
		return

	var/is_yell = talk_icon_state == "2"
	var/volume = min(base_volume * (is_yell ? 1.5 : 1), 300)
	var/sound_range = message_range + 1

	if (is_speaker_whispering)
		volume *= 0.5
		sound_range += 1

	var/sound_idx = 1
	if (is_yell)
		sound_idx = 3
	else if (talk_icon_state == "1")
		sound_idx = 2

	var/cant_long_bark = !speaker.can_long_bark()
	if (cant_long_bark || hearer_client.prefs.read_preference(/datum/preference/toggle/barks_short))
		play_single_bark(hearer, sound_range, volume, 0, speaker, sound_idx)
	else
		play_long_bark(hearer, sound_range, volume, is_yell, message_len, speaker, sound_idx)

/datum/atom_voice/proc/play_long_bark(mob/hearer, sound_range, volume, is_yell, message_len, atom/movable/speaker, sound_idx = 1)
	if(!voicepack || QDELETED(speaker) || QDELETED(hearer))
		return 0
	var/vocal_speed = clamp(speed, voicepack.min_speed, voicepack.max_speed)
	var/bark_speed_baseline = 4
	var/base_duration = vocal_speed / bark_speed_baseline

	var/num_barks = min(round(message_len / vocal_speed), 24)
	var/total_delay = 0

	if (speaker.long_bark_start_time < world.time)
		speaker.long_bark_start_time = world.time

	for (var/i in 0 to num_barks)
		if (total_delay > (1.5 SECONDS))
			break
		if (total_delay == 0)
			play_single_bark(hearer, sound_range, volume, speaker.long_bark_start_time, speaker, sound_idx)
		else
			addtimer(CALLBACK(src, PROC_REF(play_single_bark), hearer, sound_range, volume, speaker.long_bark_start_time, speaker, sound_idx), total_delay)
		total_delay += base_duration + (rand(0, round(base_duration * (is_yell ? 5 : 10))) / 10)
	return total_delay

/datum/atom_voice/proc/play_single_bark(mob/hearer, distance, volume, queue_time, atom/movable/speaker, sound_idx = 1, sound/sound_override = null)
	if(QDELETED(speaker) || QDELETED(hearer))
		return
	if(queue_time && speaker.long_bark_start_time != queue_time)
		return
	if(!voicepack && !sound_override)
		return

	var/client/hearer_client = hearer.client
	if(!hearer_client?.prefs)
		return

	var/vocal_pitch = pitch + (rand(pitch_range * -50, pitch_range * 50) / 100)
	vocal_pitch = clamp(vocal_pitch, voicepack ? voicepack.min_pitch : VOICE_DEFAULT_MINPITCH, voicepack ? voicepack.max_pitch : VOICE_DEFAULT_MAXPITCH)

	var/falloff_exponent = distance / 7
	var/turf/turf = get_turf(speaker)

	var/mob/speaker_mob = ismob(speaker) ? speaker : null
	var/client/speaker_client = speaker_mob?.client
	var/speaker_wants_simple = speaker_client?.prefs?.read_preference(/datum/preference/toggle/voice_sounds_only_simple)

	var/pitch_to_use = 0
	var/sound/sound_to_use
	var/volume_to_use = volume
	if (sound_override)
		sound_to_use = sound_override
	else
		if (speaker_wants_simple && voicepack && !voicepack.is_simple && voicepack.simple_equiv)
			if(length(voicepack.simple_equiv.sounds))
				sound_to_use = voicepack.simple_equiv.sounds[clamp(sound_idx, 1, length(voicepack.simple_equiv.sounds))]
			volume_to_use *= voicepack.simple_equiv.volume
		else if (voicepack)
			volume_to_use *= voicepack.volume
			if(length(voicepack.sounds))
				sound_to_use = voicepack.sounds[clamp(sound_idx, 1, length(voicepack.sounds))]
		if (!hearer_client.prefs.read_preference(/datum/preference/toggle/barks_limited_pitch))
			pitch_to_use = vocal_pitch

	if(!sound_to_use)
		return

	hearer.playsound_local(turf, vol = volume_to_use, vary = TRUE,
		max_distance = distance, falloff_distance = 0, use_reverb = FALSE,
		falloff_exponent = falloff_exponent,
		distance_multiplier = 1, channel = 0,
		sound_to_use = sound_to_use,
		frequency = pitch_to_use,
	)


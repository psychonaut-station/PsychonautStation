/datum/preference_middleware/bark
	COOLDOWN_DECLARE(bark_cooldown)

	action_delegations = list(
		"play_bark" = PROC_REF(play_bark),
	)

/datum/preference_middleware/bark/proc/play_bark(list/params, mob/user)
	if(!COOLDOWN_FINISHED(src, bark_cooldown) || !user)
		return TRUE
	var/datum/atom_voice/temp_voice = new()
	temp_voice.set_from_prefs(preferences)
	if(temp_voice.voicepack)
		var/duration = temp_voice.long_bark(list(user), 7, 300, FALSE, 32, user)
		QDEL_IN(temp_voice, duration)
	else
		qdel(temp_voice)
	COOLDOWN_START(src, bark_cooldown, 2 SECONDS)
	return TRUE

/datum/preference/choiced/voice_pack
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "voice_pack"

/datum/preference/choiced/voice_pack/proc/display_name(value)
	var/datum/voice_pack/voicepack = GLOB.voice_pack_list[value]
	if(voicepack?.name)
		return voicepack.name
	return value

/datum/preference/choiced/voice_pack/compile_constant_data()
	var/list/data = ..()
	var/list/display_names = list()
	for(var/key in get_choices())
		display_names[key] = display_name(key)
	data[CHOICED_PREFERENCE_DISPLAY_NAMES] = display_names
	return data

/datum/preference/choiced/voice_pack/compile_ui_data(mob/user, value)
	return display_name(value)

/datum/preference/choiced/voice_pack/init_possible_values()
	var/list/possible = list()
	for(var/key in GLOB.voice_pack_list)
		var/datum/voice_pack/vp = GLOB.voice_pack_list[key]
		if(!vp.hidden)
			possible += key
	return possible

/datum/preference/choiced/voice_pack/is_valid(value)
	if (!istext(value))
		return FALSE
	var/datum/voice_pack/voicepack = GLOB.voice_pack_list[value]
	if (!voicepack)
		return FALSE
	return !voicepack.hidden

/datum/preference/choiced/voice_pack/apply_to_human(mob/living/carbon/human/target, value)
	target.set_voice_pack(value)

/datum/preference/choiced/voice_pack/create_default_value()
	return length(GLOB.random_voice_packs) ? pick(GLOB.random_voice_packs) : "fallback.fallback"

/datum/preference/numeric/bark_speech_speed
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "bark_speech_speed"
	minimum = VOICE_DEFAULT_MINSPEED
	maximum = VOICE_DEFAULT_MAXSPEED
	step = 1

/datum/preference/numeric/bark_speech_speed/apply_to_human(mob/living/carbon/human/target, value)
	target.get_bark_voice().speed = value

/datum/preference/numeric/bark_speech_speed/create_default_value()
	return 6

/datum/preference/numeric/bark_speech_pitch
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "bark_speech_pitch"
	minimum = VOICE_DEFAULT_MINPITCH
	maximum = VOICE_DEFAULT_MAXPITCH
	step = 0.1

/datum/preference/numeric/bark_speech_pitch/apply_to_human(mob/living/carbon/human/target, value)
	target.get_bark_voice().pitch = value

/datum/preference/numeric/bark_speech_pitch/create_default_value()
	return 1

/datum/preference/numeric/bark_pitch_range
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "bark_pitch_range"
	minimum = VOICE_DEFAULT_MINVARY
	maximum = VOICE_DEFAULT_MAXVARY
	step = 0.1

/datum/preference/numeric/bark_pitch_range/apply_to_human(mob/living/carbon/human/target, value)
	target.get_bark_voice().pitch_range = value

/datum/preference/numeric/bark_pitch_range/create_default_value()
	return 0.2

/datum/preference/toggle/barks_enabled
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "voice_sounds_enabled"
	savefile_identifier = PREFERENCE_PLAYER
	default_value = TRUE

/datum/preference/toggle/barks_short
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "voice_sounds_short"
	savefile_identifier = PREFERENCE_PLAYER
	default_value = FALSE

/datum/preference/toggle/barks_limited_pitch
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "voice_sounds_limited_pitch"
	savefile_identifier = PREFERENCE_PLAYER
	default_value = FALSE

/datum/preference/toggle/voice_sounds_only_simple
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "voice_sounds_only_simple"
	savefile_identifier = PREFERENCE_PLAYER
	default_value = FALSE

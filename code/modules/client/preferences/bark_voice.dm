/datum/preference_middleware/bark
	COOLDOWN_DECLARE(bark_cooldown)

	action_delegations = list(
		"play_bark" = PROC_REF(play_bark),
		"open_voice_screen" = PROC_REF(open_voice_screen),
	)
	var/datum/voice_screen/voice_screen
	var/atom/movable/barker

/datum/preference_middleware/bark/proc/open_voice_screen(list/params, mob/user)
	if(voice_screen)
		voice_screen.ui_interact(user)
		return TRUE
	else
		voice_screen = new(src)
		voice_screen.ui_interact(user)
		return FALSE

/datum/preference_middleware/bark/proc/play_bark(list/params, mob/user)
	if(!COOLDOWN_FINISHED(src, bark_cooldown) || !user)
		return TRUE
	if (!barker)
		barker = new()
		barker.bark_voice = new()
	barker.bark_voice.set_from_prefs(preferences)
	if(!barker.bark_voice.voicepack)
		return TRUE
	var/turf/user_turf = get_turf(user)
	if (user_turf)
		barker.forceMove(user_turf)
	barker.bark_voice.long_bark(list(user), 7, 300, FALSE, 32, barker)
	COOLDOWN_START(src, bark_cooldown, 2 SECONDS)
	return TRUE

/datum/preference_middleware/bark/Destroy()
	QDEL_NULL(barker)
	QDEL_NULL(voice_screen)
	return ..()

/datum/preference/choiced/voice_pack
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "voice_pack"

/datum/preference/choiced/voice_pack/compile_ui_data(mob/user, value)
	var/datum/voice_pack/voicepack = GLOB.voice_pack_list[value]
	if(!voicepack)
		return "Default"
	return voicepack.group_name + ": " + voicepack.name

/datum/preference/choiced/voice_pack/init_possible_values()
	var/list/possible = list()
	for(var/key in GLOB.voice_pack_list)
		var/datum/voice_pack/VP = GLOB.voice_pack_list[key]
		if(!VP.hidden)
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
	step = 0.01

/datum/preference/numeric/bark_speech_speed/apply_to_human(mob/living/carbon/human/target, value)
	target.bark_voice.speed = value

/datum/preference/numeric/bark_speech_speed/create_default_value()
	return 6

/datum/preference/numeric/bark_speech_pitch
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "bark_speech_pitch"
	minimum = VOICE_DEFAULT_MINPITCH
	maximum = VOICE_DEFAULT_MAXPITCH
	step = 0.01

/datum/preference/numeric/bark_speech_pitch/apply_to_human(mob/living/carbon/human/target, value)
	target.bark_voice.pitch = value

/datum/preference/numeric/bark_speech_pitch/create_default_value()
	return 1

/datum/preference/numeric/bark_pitch_range
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "bark_pitch_range"
	minimum = VOICE_DEFAULT_MINVARY
	maximum = VOICE_DEFAULT_MAXVARY
	step = 0.01

/datum/preference/numeric/bark_pitch_range/apply_to_human(mob/living/carbon/human/target, value)
	target.bark_voice.pitch_range = value

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

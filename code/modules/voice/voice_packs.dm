#define VOICE_PACKS_FILE "config/psychonaut/voice_packs.toml"

/proc/get_voice_pack_sound(voice_pack_obj, group_path, sound_name)
	var/sound_path = voice_pack_obj[sound_name]
	if (!sound_path)
		return null
	if (group_path)
		return sound("[group_path]/[sound_path]")
	else
		return sound(sound_path)

/proc/gen_voice_packs()
	if(!fexists(VOICE_PACKS_FILE))
		log_config("No voice packs file found, generating fallback")
		var/datum/voice_pack/fallback/voicepack = new()
		GLOB.voice_pack_groups_visible[voicepack.group_name] = list(voicepack)
		GLOB.voice_pack_groups_all[voicepack.group_name] = list(voicepack)
		GLOB.random_voice_packs = list(voicepack.id)
		return list(voicepack.id = voicepack)

	var/output = rustg_read_toml_file(VOICE_PACKS_FILE)
	if(!islist(output))
		log_config("Failed to parse TOML voice pack file: [output]")
		output = list()
	var/list/voice_pack_list = list()

	for (var/group_id in output)
		var/group_obj = output[group_id]
		var/group_name = group_obj["name"]
		var/group_path = group_obj["path"]
		var/list/visible_voice_packs = list()
		var/list/all_voice_packs = null

		if (!group_name)
			continue

		for (var/voice_pack_id, voice_pack_obj in group_obj)
			if (voice_pack_id == "name" || voice_pack_id == "path")
				continue
			var/datum/voice_pack/voice_pack = new()

			voice_pack.id = "[group_id].[voice_pack_id]"
			voice_pack.name = voice_pack_obj["name"]
			voice_pack.group_name = group_name

			if (!voice_pack.name)
				continue

			voice_pack.sounds = list(
				get_voice_pack_sound(voice_pack_obj, group_path, "path"),
				get_voice_pack_sound(voice_pack_obj, group_path, "ask_path") || get_voice_pack_sound(voice_pack_obj, group_path, "ask"),
				get_voice_pack_sound(voice_pack_obj, group_path, "exclaim_path") || get_voice_pack_sound(voice_pack_obj, group_path, "exclaim"),
			)
			if (!voice_pack.sounds[1])
				continue
			for (var/i in 2 to 3)
				if (!voice_pack.sounds[i])
					voice_pack.sounds[i] = voice_pack.sounds[1]

			voice_pack.max_pitch = voice_pack_obj["max_pitch"] || VOICE_DEFAULT_MAXPITCH
			voice_pack.min_pitch = voice_pack_obj["min_pitch"] || VOICE_DEFAULT_MINPITCH
			voice_pack.max_speed = voice_pack_obj["max_speed"] || VOICE_DEFAULT_MAXSPEED
			voice_pack.min_speed = voice_pack_obj["min_speed"] || VOICE_DEFAULT_MINSPEED
			voice_pack.volume = voice_pack_obj["volume"] || 1

			voice_pack_list[voice_pack.id] = voice_pack
			if (voice_pack_obj["allow_random"])
				GLOB.random_voice_packs += voice_pack.id

			if (voice_pack_obj["hidden"])
				if(!all_voice_packs)
					all_voice_packs = visible_voice_packs.Copy()
				all_voice_packs += voice_pack
			else
				visible_voice_packs += voice_pack
				voice_pack.hidden = FALSE
				if (all_voice_packs)
					all_voice_packs += voice_pack

			voice_pack.is_simple = voice_pack_obj["allow_random"]

		if (length(visible_voice_packs))
			GLOB.voice_pack_groups_visible[group_name] = visible_voice_packs
		if (all_voice_packs)
			GLOB.voice_pack_groups_all[group_name] = all_voice_packs
		else if (length(visible_voice_packs))
			GLOB.voice_pack_groups_all[group_name] = visible_voice_packs

	if (!length(GLOB.random_voice_packs))
		var/datum/voice_pack/fallback/fallback_pack = new()
		voice_pack_list[fallback_pack.id] = fallback_pack
		GLOB.random_voice_packs += fallback_pack.id
		GLOB.voice_pack_groups_visible[fallback_pack.group_name] = list(fallback_pack)
		GLOB.voice_pack_groups_all[fallback_pack.group_name] = list(fallback_pack)

	for (var/voice_pack_id in voice_pack_list)
		var/datum/voice_pack/voice_pack = voice_pack_list[voice_pack_id]
		if (!voice_pack.is_simple && length(GLOB.random_voice_packs))
			voice_pack.simple_equiv = voice_pack_list[pick(GLOB.random_voice_packs)]

	return voice_pack_list

/datum/voice_pack
	var/name
	var/id
	var/group_name
	var/list/sounds
	var/max_pitch = VOICE_DEFAULT_MAXPITCH
	var/min_pitch = VOICE_DEFAULT_MINPITCH
	var/max_speed = VOICE_DEFAULT_MAXSPEED
	var/min_speed = VOICE_DEFAULT_MINSPEED
	var/volume = 1
	var/hidden = TRUE
	var/is_simple
	var/datum/voice_pack/simple_equiv

/datum/voice_pack/fallback
	name = "Fallback"
	id = "fallback.fallback"
	group_name = "Fallback"
	sounds = list(
		sound('sound/effects/adminhelp.ogg'),
		sound('sound/effects/adminhelp.ogg'),
		sound('sound/effects/adminhelp.ogg'),
	)
	hidden = FALSE
	is_simple = TRUE

#undef VOICE_PACKS_FILE

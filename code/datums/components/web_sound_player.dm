#define SHELLEO_ERRORLEVEL 1
#define SHELLEO_STDOUT 2
#define SHELLEO_STDERR 3

#define VV_HK_PLAY_URL "play_url"
#define VV_HK_STOP "stop"
#define VV_HK_SET_LOOP "set_loop"
#define VV_HK_SET_RANGE "set_range"

#define STOP(src) "(<a href='byond://?src=[REF(src)];stop=1'>STOP</a>)"

#define get_volume(player, atom) (player.parent != atom ? (player.range - get_dist(player.parent, atom) - 0.9) / player.range : 1)
#define check_timestamp(track) (world.time - track.timestamp < WEB_SOUND_CACHE_DURATION)
#define check_timestamp_list(track) (islist(track) && (world.time - track["timestamp"] < WEB_SOUND_CACHE_DURATION))
#define is_playing(player) (player.track && world.time - player.track_started_at < player.track.duration)

GLOBAL_LIST_EMPTY(web_track_cache)

/datum/web_track
	var/url
	var/title
	var/duration
	var/display_duration
	var/webpage_url
	var/webpage_url_html
	var/artist
	var/album
	var/timestamp
	var/mob_name
	var/mob_ckey
	var/list/as_list

/datum/web_track/New(url, title, webpage_url, duration, artist, album, mob_name = "John Doe", mob_ckey = "Administrator")
	src.url = url
	src.title = title
	src.duration = duration
	src.display_duration = DisplayTimeText(duration, 1)
	src.webpage_url = webpage_url
	src.webpage_url_html = webpage_url ? "<a href=\"[webpage_url]\">[title]</a>" : title
	src.artist = artist
	src.album = album
	src.mob_name = mob_name
	src.mob_ckey = mob_ckey
	timestamp = world.time
	as_list = serialize()

/datum/web_track/proc/update()
	var/list/track_data = url_to_web_track(webpage_url, data_only = TRUE)
	if(islist(track_data))
		New(track_data["url"], track_data["title"], track_data["webpage_url"], track_data["duration"] * 10, track_data["artist"], track_data["album"], mob_name, mob_ckey)
		return TRUE
	return FALSE

/datum/web_track/proc/serialize(list/options, list/semvers)
	. = list()
	.["title"] = title
	.["duration"] = display_duration
	.["link"] = webpage_url
	.["webpage_url"] = webpage_url
	.["webpage_url_html"] = webpage_url_html
	.["artist"] = artist
	.["album"] = album
	.["mob_name"] = mob_name
	.["mob_ckey"] = mob_ckey
	.["mob_key_name"] = key_name(mob_ckey, FALSE, TRUE)
	.["track_id"] = REF(src)

/datum/component/web_sound_player
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/datum/proximity_monitor/advanced/mob_collector/proximity_monitor
	var/datum/status_effect/status_effect
	var/list/listeners
	var/datum/web_track/track
	var/datum/web_track/last_track
	var/track_started_at = 0
	var/loop = FALSE
	var/source_name
	var/player_id
	var/range

/datum/component/web_sound_player/Initialize(_range = 8, _source_name, _status_effect = /datum/status_effect/good_music, ...)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	var/atom/atom_parent = parent
	if(!atom_parent.loc)
		return COMPONENT_INCOMPATIBLE

	if(!isnum(_range) || _range < 1)
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_PROXIMITY_MOB_ENTERED, PROC_REF(on_mob_entered))
	RegisterSignal(parent, COMSIG_PROXIMITY_MOB_LEFT, PROC_REF(on_mob_left))
	RegisterSignal(parent, COMSIG_PROXIMITY_MOB_MOVED, PROC_REF(on_mob_moved))

	proximity_monitor = new (parent, _range, FALSE, FALSE)
	status_effect = _status_effect
	player_id = REF(src)
	range = _range

	if(_source_name)
		source_name = _source_name
	else
		source_name = "[parent]"

/datum/component/web_sound_player/Destroy(force, silent)
	track_started_at = 0
	last_track = null
	track = null

	if(LAZYLEN(listeners))
		for(var/mob/listener as anything in listeners)
			listener.client?.tgui_panel?.destroy_jukebox_player(player_id)

	QDEL_NULL(proximity_monitor)
	UnregisterSignal(parent, list(COMSIG_PROXIMITY_MOB_ENTERED, COMSIG_PROXIMITY_MOB_LEFT, COMSIG_PROXIMITY_MOB_MOVED))
	STOP_PROCESSING(SSprocessing, src)

	return ..()

/datum/component/web_sound_player/process(seconds_per_tick)
	if(status_effect && is_playing(src))
		if(LAZYLEN(listeners))
			for(var/mob/living/listener in listeners)
				listener.apply_status_effect(status_effect)

	if(track && world.time - track_started_at >= track.duration)
		stop()
		SEND_SIGNAL(src, COMSIG_WEB_SOUND_ENDED, track, loop)
		if(loop)
			play(last_track)

	if(!is_playing(src))
		STOP_PROCESSING(SSprocessing, src)

/datum/component/web_sound_player/Topic(href, list/href_list)
	. = ..()
	if(!check_rights(R_SOUND))
		return
	if(href_list["stop"])
		if(stop())
			var/atom/atom_parent = parent
			var/area_name = get_area_name(atom_parent, TRUE)
			log_admin("[key_name(usr)] stopped [atom_parent] playing web sound at [area_name].")
			message_admins("[key_name(usr, TRUE)] stopped [atom_parent] playing web sound at [area_name].")

/datum/component/web_sound_player/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---------")
	VV_DROPDOWN_OPTION(VV_HK_PLAY_URL, "Play URL")
	VV_DROPDOWN_OPTION(VV_HK_STOP, "Stop")
	VV_DROPDOWN_OPTION(VV_HK_SET_LOOP, "Set Loop")
	VV_DROPDOWN_OPTION(VV_HK_SET_RANGE, "Set Range")

/datum/component/web_sound_player/vv_do_topic(list/href_list)
	. = ..()
	if(!check_rights(R_SOUND))
		return
	if(href_list[VV_HK_PLAY_URL])
		var/url = input(usr, "Enter content URL (youtube only)", "Play URL") as text|null
		if(length(url) && play_url(url))
			var/atom/atom_parent = parent
			var/area_name = get_area_name(atom_parent, TRUE)
			log_admin("[key_name(usr)] played web sound [track.webpage_url] on [atom_parent] at [area_name]")
			message_admins("[key_name(usr, TRUE)] played web sound [track.webpage_url_html] on [atom_parent] at [area_name]. [ADMIN_QUE(usr)] [ADMIN_JMP(atom_parent)] [STOP(src)]")
	if(href_list[VV_HK_STOP])
		if(stop())
			var/atom/atom_parent = parent
			var/area_name = get_area_name(atom_parent, TRUE)
			log_admin("[key_name(usr)] stopped [atom_parent] playing web sound at [area_name].")
			message_admins("[key_name(usr, TRUE)] stopped [atom_parent] playing web sound at [area_name].")
	if(href_list[VV_HK_SET_LOOP])
		var/_loop = input(usr, "1 for true, 0 for false", "Set Loop", loop) as num|null
		if(_loop == 1)
			loop = TRUE
		else if(_loop == 0)
			loop = FALSE
	if(href_list[VV_HK_SET_RANGE])
		var/_range = input(usr, "1 is minimum", "Set Range", range) as num|null
		if(_range >= 1 && _range != range)
			set_range(_range)

/datum/component/web_sound_player/proc/play(datum/web_track/track)
	if(!istype(track))
		return FALSE
	if(!check_timestamp(track))
		var/update = track.update()
		if(!update)
			stop()
			return FALSE
	stop()
	src.track = track
	track_started_at = world.time
	START_PROCESSING(SSprocessing, src)
	SEND_SIGNAL(src, COMSIG_WEB_SOUND_STARTED, track)
	for(var/mob/listener as anything in listeners)
		var/pref_volume = listener.client?.prefs.read_preference(/datum/preference/numeric/volume/sound_instruments)
		if(pref_volume)
			listener.client.tgui_panel?.play_jukebox_music(player_id, source_name, track.url, track.as_list, get_volume(src, listener) * pref_volume / 100)
	return TRUE

/datum/component/web_sound_player/proc/play_url(url)
	var/datum/web_track/_track = url_to_web_track(url)
	if(istype(_track))
		return play(_track)
	return FALSE

/datum/component/web_sound_player/proc/stop()
	if(track)
		track_started_at = 0
		last_track = track
		track = null
		STOP_PROCESSING(SSprocessing, src)
		SEND_SIGNAL(src, COMSIG_WEB_SOUND_STOPPED, track)
		for(var/mob/listener as anything in listeners)
			listener.client?.tgui_panel?.stop_jukebox_music(player_id)
		return TRUE
	return FALSE

/datum/component/web_sound_player/proc/set_range(_range, force_rebuild = FALSE)
	if(!force_rebuild && _range == range)
		return
	range = _range
	proximity_monitor.set_range(_range, force_rebuild)

/datum/component/web_sound_player/proc/on_mob_entered(datum/source, mob/mob)
	SIGNAL_HANDLER
	var/pref_volume = mob.client?.prefs.read_preference(/datum/preference/numeric/volume/sound_instruments)
	if(pref_volume)
		if(!LAZYFIND(listeners, mob))
			LAZYADD(listeners, mob)
		if(is_playing(src))
			var/list/options = track.as_list.Copy()
			options["start"] = (world.time - track_started_at) / 10
			mob.client.tgui_panel?.play_jukebox_music(player_id, source_name, track.url, options, get_volume(src, mob) * pref_volume / 100)
	RegisterSignal(mob, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(on_mob_login))

/datum/component/web_sound_player/proc/on_mob_left(datum/source, mob/mob)
	SIGNAL_HANDLER
	if(LAZYFIND(listeners, mob))
		LAZYREMOVE(listeners, mob)
		var/client/client = mob.client || GLOB.directory[ckey(mob.mind?.key)]
		client?.tgui_panel?.destroy_jukebox_player(player_id)
	UnregisterSignal(mob, COMSIG_MOB_CLIENT_LOGIN)

/datum/component/web_sound_player/proc/on_mob_moved(datum/source, mob/mob)
	SIGNAL_HANDLER
	if(is_playing(src) && LAZYFIND(listeners, mob))
		var/pref_volume = mob.client?.prefs.read_preference(/datum/preference/numeric/volume/sound_instruments) || 100
		mob.client?.tgui_panel?.set_jukebox_volume(player_id, get_volume(src, mob) * pref_volume / 100)

/datum/component/web_sound_player/proc/on_mob_login(mob/source, client/client)
	SIGNAL_HANDLER
	var/pref_volume = client?.prefs.read_preference(/datum/preference/numeric/volume/sound_instruments)
	if(pref_volume)
		if(LAZYFIND(listeners, source))
			LAZYADD(listeners, source)
		if(is_playing(src))
			var/list/options = track.as_list.Copy()
			options["start"] = (world.time - track_started_at) / 10
			client.tgui_panel?.play_jukebox_music(player_id, source_name, track.url, options, get_volume(src, source) * pref_volume / 100)

/proc/url_to_web_track(url, data_only = FALSE)
	var/invoke_youtubedl = CONFIG_GET(string/invoke_youtubedl)

	if(!invoke_youtubedl)
		return WEB_SOUND_ERR_YTDL_NOT_CONFIGURED

	if(!findtext(url, regex(replacetext(CONFIG_GET(string/request_internet_allowed), ",", "|"), "i")))
		return WEB_SOUND_ERR_INVALID_URL

	var/list/track_data
	var/list/cached_track_data = GLOB.web_track_cache[url]

	if(isnull(cached_track_data) || !check_timestamp_list(cached_track_data))
		var/cookies = CONFIG_GET(string/ytdl_cookies)
		var/list/output = world.shelleo("[invoke_youtubedl] --geo-bypass --format \"bestaudio\[ext=mp3]/best\[ext=mp4]\[height <= 360]/bestaudio\[ext=m4a]/bestaudio\[ext=aac]\" --dump-single-json --no-playlist [cookies ? "--cookies [cookies]" : ""] -- \"[shell_url_scrub(url)]\"")

		var/errorlevel = output[SHELLEO_ERRORLEVEL]
		var/stdout = output[SHELLEO_STDOUT]

		if(errorlevel)
			GLOB.web_track_cache[url] = WEB_SOUND_ERR_JSON_RETRIEVAL
			return WEB_SOUND_ERR_JSON_RETRIEVAL

		try
			track_data = json_decode(stdout)
		catch
			GLOB.web_track_cache[url] = WEB_SOUND_ERR_JSON_PARSING
			return WEB_SOUND_ERR_JSON_PARSING

		if(!findtext(track_data["url"], GLOB.is_http_protocol))
			GLOB.web_track_cache[url] = WEB_SOUND_ERR_NOT_HTTPS
			return WEB_SOUND_ERR_NOT_HTTPS

		if(track_data["duration"] * 10 > WEB_SOUND_MAX_DURATION)
			GLOB.web_track_cache[url] = WEB_SOUND_ERR_DURATION
			return WEB_SOUND_ERR_DURATION

		track_data["timestamp"] = world.time
		GLOB.web_track_cache[url] = track_data

		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_web_track_cache), url), WEB_SOUND_CACHE_DURATION)

		if(data_only)
			return track_data

		return new /datum/web_track(
			url = track_data["url"],
			title = track_data["title"],
			webpage_url = track_data["webpage_url"],
			duration = track_data["duration"] * 10,
			artist = track_data["artist"],
			album = track_data["album"],
		)
	else if(islist(cached_track_data))
		return new /datum/web_track(
			url = cached_track_data["url"],
			title = cached_track_data["title"],
			webpage_url = cached_track_data["webpage_url"],
			duration = cached_track_data["duration"] * 10,
			artist = cached_track_data["artist"],
			album = cached_track_data["album"],
		)
	else
		return cached_track_data

/proc/remove_web_track_cache(key)
	var/list/track_data = GLOB.web_track_cache[key]
	if(islist(track_data))
		if(!check_timestamp_list(track_data))
			GLOB.web_track_cache -= key
		else
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_web_track_cache), key), WEB_SOUND_CACHE_DURATION - world.time - track_data["timestamp"])

#undef get_volume
#undef check_timestamp
#undef check_timestamp_list
#undef is_playing

#undef STOP

#undef VV_HK_PLAY_URL
#undef VV_HK_STOP
#undef VV_HK_SET_LOOP
#undef VV_HK_SET_RANGE

#undef SHELLEO_ERRORLEVEL
#undef SHELLEO_STDOUT
#undef SHELLEO_STDERR

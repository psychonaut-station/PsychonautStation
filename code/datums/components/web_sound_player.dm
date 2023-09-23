#define SHELLEO_ERRORLEVEL 1
#define SHELLEO_STDOUT 2
#define SHELLEO_STDERR 3

#define get_volume(player, atom) ((player.range - get_dist(player.parent, atom) - 0.9) / player.range)
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
	return track_data

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
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS

	var/datum/proximity_monitor/advanced/mob_collector/proximity_monitor
	var/list/listeners
	var/datum/web_track/track
	var/datum/web_track/last_track
	var/track_started_at = 0
	var/source_name
	var/player_id
	var/range

/datum/component/web_sound_player/Initialize(_range, _source_name, ...)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	if(!isnum(_range) || _range < 1)
		return COMPONENT_INCOMPATIBLE

	proximity_monitor = new (parent, _range, FALSE, FALSE)
	player_id = REF(src)
	range = _range

	if(_source_name)
		source_name = _source_name
	else
		source_name = "[parent]"

	RegisterSignal(parent, COMSIG_PROXIMITY_MOB_ENTERED, PROC_REF(on_mob_entered))
	RegisterSignal(parent, COMSIG_PROXIMITY_MOB_LEFT, PROC_REF(on_mob_left))
	RegisterSignal(parent, COMSIG_PROXIMITY_MOB_MOVED, PROC_REF(on_mob_moved))

/datum/component/web_sound_player/Destroy(force, silent)
	track_started_at = 0
	last_track = null
	track = null

	if(LAZYLEN(listeners))
		for(var/mob/user as anything in listeners)
			user.client?.tgui_panel?.destroy_jukebox_player(player_id)

	QDEL_NULL(proximity_monitor)
	UnregisterSignal(parent, list(COMSIG_PROXIMITY_MOB_ENTERED, COMSIG_PROXIMITY_MOB_LEFT, COMSIG_PROXIMITY_MOB_MOVED))

	return ..()

/datum/component/web_sound_player/InheritComponent(datum/component/C, i_am_original)
	var/datum/component/web_sound_player/new_component = C
	proximity_monitor.set_range(new_component.range)

/datum/component/web_sound_player/proc/play(datum/web_track/track)
	if(!istype(track))
		return FALSE
	if(!check_timestamp(track))
		var/update = track.update()
		if(update != TRUE)
			stop()
			return FALSE
	if(is_playing(src))
		stop()
	src.track = track
	track_started_at = world.time
	for(var/mob/user as anything in listeners)
		if(user.client?.prefs.read_preference(/datum/preference/toggle/sound_jukebox))
			user.client.tgui_panel?.play_jukebox_music(player_id, source_name, track.url, track.as_list, get_volume(src, user))
	return TRUE

/datum/component/web_sound_player/proc/play_url(url)
	var/datum/web_track/_track = url_to_web_track(url)
	if(istype(_track))
		play(_track)
		return TRUE
	return FALSE

/datum/component/web_sound_player/proc/stop()
	track_started_at = 0
	last_track = track
	track = null
	for(var/mob/user as anything in listeners)
		user.client?.tgui_panel?.stop_jukebox_music(player_id)

/datum/component/web_sound_player/proc/on_mob_entered(datum/source, mob/user)
	SIGNAL_HANDLER
	if(user.client?.prefs.read_preference(/datum/preference/toggle/sound_jukebox))
		if(!LAZYFIND(listeners, user))
			LAZYADD(listeners, user)
		if(is_playing(src))
			var/list/options = track.as_list.Copy()
			options["start"] = (world.time - track_started_at) / 10
			user.client.tgui_panel?.play_jukebox_music(player_id, source_name, track.url, options, get_volume(src, user))
	RegisterSignal(user, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(on_mob_login))

/datum/component/web_sound_player/proc/on_mob_left(datum/source, mob/user)
	SIGNAL_HANDLER
	if(LAZYFIND(listeners, user))
		LAZYREMOVE(listeners, user)
		var/client/client = user.client || GLOB.directory[ckey(user.mind?.key)]
		client?.tgui_panel?.destroy_jukebox_player(player_id)
	UnregisterSignal(user, COMSIG_MOB_CLIENT_LOGIN)

/datum/component/web_sound_player/proc/on_mob_moved(datum/source, mob/user)
	SIGNAL_HANDLER
	if(is_playing(src) && LAZYFIND(listeners, user))
		user.client?.tgui_panel?.set_jukebox_volume(player_id, get_volume(src, user))

/datum/component/web_sound_player/proc/on_mob_login(mob/source, client/client)
	SIGNAL_HANDLER
	if(client?.prefs.read_preference(/datum/preference/toggle/sound_jukebox))
		if(LAZYFIND(listeners, source))
			LAZYADD(listeners, source)
		if(is_playing(src))
			var/list/options = track.as_list.Copy()
			options["start"] = (world.time - track_started_at) / 10
			client.tgui_panel?.play_jukebox_music(player_id, source_name, track.url, options, get_volume(src, source))

/proc/url_to_web_track(url, data_only = FALSE)
	var/invoke_youtubedl = CONFIG_GET(string/invoke_youtubedl)

	if(!invoke_youtubedl)
		return WEB_SOUND_ERR_YTDL_NOT_CONFIGURED

	var/list/track_data
	var/list/cached_track_data = GLOB.web_track_cache[url]

	if(isnull(cached_track_data) || !check_timestamp_list(cached_track_data))
		var/list/output = world.shelleo("[invoke_youtubedl] --geo-bypass --format \"bestaudio\[ext=mp3]/best\[ext=mp4]\[height <= 360]/bestaudio\[ext=m4a]/bestaudio\[ext=aac]\" --dump-single-json --no-playlist -- \"[shell_url_scrub(url)]\"")

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

#undef SHELLEO_ERRORLEVEL
#undef SHELLEO_STDOUT
#undef SHELLEO_STDERR

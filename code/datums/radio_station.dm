#define check_timestamp(track) (world.time - track.timestamp < WEB_SOUND_CACHE_DURATION)
/datum/radio_station
	var/id
	var/name = "Radio Station"
	var/freq = 0
	var/list/musics = list()

	var/list/listeners = list()
	var/list/cached_volumes = list()

	var/datum/web_track/current_playing
	var/current_playing_index = 0
	var/busy = FALSE
	var/track_started_at = 0
	COOLDOWN_DECLARE(next_song_cooldown)

/datum/radio_station/New(name, freq, list/musics)
	src.name = name
	src.freq = freq
	src.musics = shuffle(musics)
	src.id = "rs_[REF(src)]"
	START_PROCESSING(SSradio_stations, src)

/datum/radio_station/process(seconds_per_tick)
	if(busy)
		return FALSE
	if(COOLDOWN_FINISHED(src, next_song_cooldown))
		play_music()

/datum/radio_station/proc/play_music()
	busy = TRUE
	var/next_music_index = get_next_music_index()
	var/music_url = musics[next_music_index]
	var/datum/web_track/track = url_to_web_track(music_url)
	current_playing = track
	current_playing_index = next_music_index
	track_started_at = world.time
	COOLDOWN_START(src, next_song_cooldown, track.duration)
	for(var/mob/listener in listeners)
		play(listener)
	load_next_song()
	busy = FALSE

/datum/radio_station/proc/play(mob/listener, cached_volume)
	var/datum/web_track/track = current_playing
	cached_volume = cached_volume || get_cached_volume(listener)
	var/pref_volume = listener.client?.prefs.read_preference(/datum/preference/numeric/volume/sound_instruments)
	var/volume = (sqrt(cached_volume) / 100) * (pref_volume / 100)

	var/list/options = track.as_list.Copy()
	options["start"] = (world.time - track_started_at) / 10
	if(volume)
		listener.client.tgui_panel?.play_jukebox_music(id, name, track.url, options, volume)

/datum/radio_station/proc/stop(mob/listener)
	listener.client?.tgui_panel?.destroy_jukebox_player(id)

/datum/radio_station/proc/update(mob/listener, cached_volume)
	if(LAZYLEN(listeners) && LAZYLEN(listeners[listener]))
		cached_volume = cached_volume || get_cached_volume(listener)
		var/pref_volume = listener.client?.prefs.read_preference(/datum/preference/numeric/volume/sound_instruments)
		var/volume = (sqrt(cached_volume) / 100) * (pref_volume / 100)
		listener.client?.tgui_panel?.set_jukebox_volume(id, volume)

/datum/radio_station/proc/get_cached_volume(mob/listener)
	var/volume_pow = LAZYACCESS(cached_volumes, REF(listener))
	if(isnull(volume_pow))
		volume_pow = update_cached_volume(freq, listener)

	return max(0, volume_pow)

/datum/radio_station/proc/update_cached_volume(mob/listener)
	var/list/sources = LAZYACCESS(listeners, listener)
	var/volume_pow = 0
	if(LAZYLEN(sources))
		for(var/datum/weakref/source in sources)
			var/datum/component/shared_sound_player/player = source.resolve()
			if(!player)
				continue
			volume_pow += LAZYACCESS(player.listeners, listener)
		set_cached_volume(listener, volume_pow)
	return max(0, volume_pow)

/datum/radio_station/proc/set_cached_volume(mob/listener, volume_power)
	volume_power = max(0, volume_power)
	LAZYSET(cached_volumes, REF(listener), volume_power)

	return TRUE

/datum/radio_station/proc/load_next_song()
	var/next_music_index = get_next_music_index()
	var/music_url = musics[next_music_index]
	url_to_web_track(music_url)

/datum/radio_station/proc/get_next_music_index()
	. = 0
	if(current_playing_index + 1 > length(musics))
		. = 1
	else
		. = current_playing_index + 1

/datum/radio_station/proc/add_to_listeners(mob/listener, datum/weakref/source, volume)
	if(!istype(listener))
		return
	if(source in LAZYACCESS(listeners, listener)) // mob zaten listenerlerde var
		return
	var/new_volume = get_cached_volume(listener) + volume
	set_cached_volume(listener, new_volume)
	var/is_playing = FALSE
	if(LAZYLEN(listeners) && LAZYLEN(listeners[listener]))
		is_playing = TRUE
	LAZYORASSOCLIST(listeners, listener, source)
	if(is_playing)
		update(listener, new_volume)
	else
		play(listener, new_volume)

/datum/radio_station/proc/remove_from_listeners(mob/listener, datum/weakref/source, old_volume)
	if(!istype(listener))
		return
	if(!(source in LAZYACCESS(listeners, listener))) // mob zaten listenerlerden silinmiş
		return

	var/new_volume = get_cached_volume(listener) - old_volume
	set_cached_volume(listener, new_volume)
	LAZYREMOVEASSOC(listeners, listener, source)
	if(LAZYLEN(listeners) && LAZYLEN(listeners[listener]))
		update(listener, new_volume)
	else
		stop(listener)

/datum/radio_station/proc/update_listener(mob/listener, datum/weakref/source, old_volume, volume)
	if(!istype(listener))
		return
	if(source in LAZYACCESS(listeners, listener))
		var/new_volume = get_cached_volume(listener) - old_volume + volume
		set_cached_volume(listener, new_volume)
		update(listener, new_volume)
	else
		add_to_listeners(listener, source, volume)

/datum/radio_station/proc/tune_in_radio(datum/component/shared_sound_player/player)
	var/list/listeners = SANITIZE_LIST(player.listeners)
	for(var/mob/listener in listeners)
		var/volume = listeners[listener]
		add_to_listeners(listener, WEAKREF(player), volume)

/datum/radio_station/proc/tune_out_radio(datum/component/shared_sound_player/player)
	var/list/listeners = SANITIZE_LIST(player.listeners)
	for(var/mob/listener in listeners)
		var/volume = listeners[listener]
		remove_from_listeners(listener, WEAKREF(player), volume)

#undef check_timestamp

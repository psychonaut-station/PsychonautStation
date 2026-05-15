PROCESSING_SUBSYSTEM_DEF(radio_stations)
	name = "Radio Stations"
	runlevels = RUNLEVEL_GAME
	flags = SS_BACKGROUND|SS_POST_FIRE_TIMING
	wait = 5 SECONDS

	var/list/datum/radio_station/radio_stations = list()
	var/list/radio_stations_by_freq = list()

	var/list/datum/component/shared_sound_player/all_players = list() // For VV

/datum/controller/subsystem/processing/radio_stations/Initialize()
	initialize_music_stations()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/processing/radio_stations/proc/initialize_music_stations()
	var/list/data = safe_json_decode(file2text("[global.config.directory]/radio_stations.json"))
	if(!data)
		return FALSE
	var/list/stations = data["stations"]
	for (var/i in 1 to stations.len)
		var/freq = MIN_MUSIC_FREQ + (i-1) * 2 // Frequencies are always odd numbers
		var/list/station_data = stations[i]
		var/name = station_data["name"] + " [format_frequency(freq)]"
		var/list/radio_musics = station_data["musics"]

		var/datum/radio_station/station = new (name, freq, radio_musics)
		radio_stations += station
		radio_stations_by_freq["[freq]"] = station
	return TRUE

/datum/controller/subsystem/processing/radio_stations/proc/add_listener(mob/listener, freq, datum/weakref/weakref, volume)
	var/datum/radio_station/station = radio_stations_by_freq["[freq]"]
	if(!station)
		return

	station.add_to_listeners(listener, weakref, volume)

/datum/controller/subsystem/processing/radio_stations/proc/remove_listener(mob/listener, freq, datum/weakref/weakref, old_volume)
	var/datum/radio_station/station = radio_stations_by_freq["[freq]"]
	if(!station)
		return
	station.remove_from_listeners(listener, weakref, old_volume)

/datum/controller/subsystem/processing/radio_stations/proc/update_listener(mob/listener, freq, datum/weakref/weakref, old_volume, volume)
	var/datum/radio_station/station = radio_stations_by_freq["[freq]"]
	if(!station)
		return
	station.update_listener(listener, weakref, old_volume, volume)

/datum/controller/subsystem/processing/radio_stations/proc/tune_radio(datum/component/shared_sound_player/player, old_freq, freq)
	var/datum/radio_station/old_station = radio_stations_by_freq["[old_freq]"]
	if(old_station)
		old_station.tune_out_radio(player)

	var/datum/radio_station/station = radio_stations_by_freq["[freq]"]
	if(!station)
		return
	station.tune_in_radio(player)

/datum/controller/subsystem/processing/radio_stations/proc/add_player(datum/component/shared_sound_player/player)
	LAZYADD(all_players, player)

/datum/controller/subsystem/processing/radio_stations/proc/remove_player(datum/component/shared_sound_player/player)
	LAZYREMOVE(all_players, player)

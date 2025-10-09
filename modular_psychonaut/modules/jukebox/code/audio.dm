/datum/tgui_panel/proc/destroy_jukebox_player(jukebox_id)
	if(!is_ready())
		return
	window.send_message("audio/jukebox/destroy", list("jukeboxId" = jukebox_id))

/datum/tgui_panel/proc/play_jukebox_music(jukebox_id, source_name, url, extra_data, volume)
	if(!is_ready())
		return
	if(!findtext(url, GLOB.is_http_protocol))
		return
	var/list/payload = list()
	if(length(extra_data) > 0)
		for(var/key in extra_data)
			payload[key] = extra_data[key]
	payload["jukeboxId"] = jukebox_id
	payload["sourceName"] = source_name
	payload["url"] = url
	payload["volume"] = clamp(volume, 0, 1)
	window.send_message("audio/jukebox/playMusic", payload)

/datum/tgui_panel/proc/stop_jukebox_music(jukebox_id)
	if(!is_ready())
		return
	window.send_message("audio/jukebox/stopMusic", list("jukeboxId" = jukebox_id))

/datum/tgui_panel/proc/set_jukebox_volume(jukebox_id, volume)
	if(!is_ready())
		return
	window.send_message("audio/jukebox/setVolume", list("jukeboxId" = jukebox_id, "volume" = clamp(volume, 0, 1)))

/datum/tgui_panel/proc/destroy_all_jukebox()
	if(!is_ready())
		return
	window.send_message("audio/jukebox/destroyAll")

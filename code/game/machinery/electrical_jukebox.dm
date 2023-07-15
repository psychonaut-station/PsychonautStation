#define SHELLEO_ERRORLEVEL 1
#define SHELLEO_STDOUT 2
#define SHELLEO_STDERR 3

#define CURRENT_TIME "current_time"

/datum/web_track
	var/url = ""
	var/title = ""
	var/webpage_url = ""
	var/webpage_url_html = ""
	// seconds
	var/duration = 0
	var/display_duration = ""
	var/artist = ""
	var/upload_date = ""
	var/album = ""
	var/list/extra_data = list()

/datum/web_track/New(url, title, webpage_url, duration, artist, upload_date, album)
	src.url = url
	src.title = title
	src.webpage_url = webpage_url
	src.webpage_url_html = webpage_url ? "<a href=\"[webpage_url]\">[title]</a>" : title
	src.duration = duration
	src.display_duration = DisplayTimeText(duration * 1 SECONDS, 1)
	src.artist = artist
	src.upload_date = upload_date
	src.album = album
	extra_data = parse_extra_data()

/datum/web_track/proc/parse_extra_data()
	var/list/extra_data = list()
	extra_data["title"] = src.title
	extra_data["duration"] = src.display_duration
	extra_data["link"] = src.webpage_url
	extra_data["artist"] = src.artist
	extra_data["upload_date"] = src.upload_date
	extra_data["album"] = src.album
	return extra_data

/obj/machinery/electrical_jukebox
	name = "electrical jukebox"
	desc = "An advanced music player supports web musics."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "e-jukebox"
	density = TRUE

	// kendi bulunduğu turf dahil tek bir yöne
	var/radius = 12
	var/busy = FALSE
	var/ytdl

	var/datum/web_track/current_track
	var/datum/proximity_monitor/advanced/jukebox/proximity

/obj/machinery/electrical_jukebox/Initialize(mapload)
	. = ..()
	ytdl = CONFIG_GET(string/invoke_youtubedl)
	proximity = new(src, radius)
	RegisterSignal(src, COMSIG_CD_STOP(CURRENT_TIME), PROC_REF(on_cd_stop))

/obj/machinery/electrical_jukebox/Destroy()
	. = ..()
	stop_music()
	QDEL_NULL(proximity)

/obj/machinery/electrical_jukebox/update_icon_state()
	icon_state = "[initial(icon_state)][is_playing() ? "-active" : null]"
	return ..()

/obj/machinery/electrical_jukebox/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(busy)
		return FALSE
	if(is_playing())
		to_chat(user, span_warning("You cannot unsecure [src] while its on!"), confidential = TRUE)
		return FALSE
	default_unfasten_wrench(user, tool)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/electrical_jukebox/ui_status(mob/user)
	if(!ytdl)
		to_chat(user, span_boldwarning("Youtube-dl was not configured, action unavailable"), confidential = TRUE)
		user.playsound_local(src, 'sound/misc/compiler-failure.ogg', 25, TRUE)
		return UI_CLOSE
	return ..()

/obj/machinery/electrical_jukebox/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ElectricalJukebox", name)
		ui.open()

/obj/machinery/electrical_jukebox/ui_data(mob/user)
	var/list/data = list()
	data["playing_sound_data"] = current_track?.extra_data || null
	data["timeleft"] = current_track?.duration ? DisplayTimeText((current_track.duration * 1 SECONDS) - S_TIMER_COOLDOWN_TIMELEFT(src, CURRENT_TIME) || 1 SECONDS, 1) : null
	data["active"] = is_playing()
	data["busy"] = busy
	return data

/obj/machinery/electrical_jukebox/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	if(!HAS_TRAIT(usr, TRAIT_CAN_USE_JUKEBOX) && !is_admin(usr.client))
		to_chat(usr, span_warning("You are not allowed to use [src]."), confidential = TRUE)
		return

	switch(action)
		if("toggle")
			if(is_playing())
				stop_music()
			else
				if(usr.can_perform_action(src, FORBID_TELEKINESIS_REACH) || !busy)
					if(!anchored)
						to_chat(usr, span_warning("The [src] needs to be secured first!"), confidential = TRUE)
						return
					var/input = tgui_input_text(usr, "Enter content URL (supported sites only)", "Electrical Jukebox")
					if(input && usr.can_perform_action(src, FORBID_TELEKINESIS_REACH)) // regex iyi olur
						play_music(usr, input)
			return
		if("volume")
			// volume
			return

/obj/machinery/electrical_jukebox/proc/is_playing()
	return TIMER_COOLDOWN_CHECK(src, CURRENT_TIME)
/obj/machinery/electrical_jukebox/proc/get_web_sound(input)
	if(!ytdl)
		return "Youtube-dl was not configured, action unavailable"

	var/shell_scrubbed_input = shell_url_scrub(input)
	var/list/output = world.shelleo("[ytdl] --geo-bypass --format \"bestaudio\[ext=mp3]/best\[ext=mp4]\[height <= 360]/bestaudio\[ext=m4a]/bestaudio\[ext=aac]\" --dump-single-json --no-playlist -- \"[shell_scrubbed_input]\"")

	var/errorlevel = output[SHELLEO_ERRORLEVEL]
	var/stdout = output[SHELLEO_STDOUT]
	var/stderr = output[SHELLEO_STDERR]

	if(errorlevel)
		return "Youtube-dl URL retrieval FAILED:\n[stderr]"

	var/list/data
	try
		data = json_decode(stdout)

		if(!findtext(data["url"], GLOB.is_http_protocol))
			return "The media provider returned a content URL that isn't using the HTTP or HTTPS protocol. This is a security risk and the sound will not be played."

		var/datum/web_track/track = new(data["url"], data["title"], data["webpage_url"], data["duration"], data["artist"], data["upload_date"], data["album"])

		return track
	catch(var/exception/e)
		return "Youtube-dl JSON parsing FAILED:\n[e]: [stdout]"

/obj/machinery/electrical_jukebox/proc/play_music(mob/user, input)
	if(is_playing())
		to_chat(user, span_warning("Its already playing!"), confidential = TRUE)
		return
	if(!anchored)
		to_chat(user, span_warning("The [src] needs to be secured first!"), confidential = TRUE)
		return

	busy = TRUE
	var/datum/web_track/track = get_web_sound(input)
	busy = FALSE

	if(!istype(track))
		if(istext(track))
			tgui_alert(user, track, "Electrical Jukebox", list("Ok"))
			to_chat(user, span_boldwarning(track), confidential = TRUE)

	var/area_name = get_area_name(src, TRUE)

	log_admin("[key_name(user)] played web sound on [src] at [area_name]: [track.webpage_url_html]")
	message_admins("[key_name(user)] played web sound on [src] at [area_name]: [track.webpage_url_html]")

	SSblackbox.record_feedback("nested tally", "played_url", 1, list("[user.ckey]", "[input]"))

	current_track = track
	S_TIMER_COOLDOWN_START(src, CURRENT_TIME, track.duration * 1 SECONDS)
	update_icon_state()

	for(var/mob/M in range(radius - 1, src))
		to_chat(M, span_boldannounce("[user.name] played [track.webpage_url_html] on [src]"), confidential = TRUE)
		var/client/C = M.client
		if(C && C.tgui_panel && C.prefs.read_preference(/datum/preference/toggle/sound_jukebox))
			C.tgui_panel.play_music(track.url, track.extra_data)

/obj/machinery/electrical_jukebox/proc/stop_music()
	S_TIMER_COOLDOWN_RESET(src, CURRENT_TIME)
	QDEL_NULL(current_track)
	for(var/mob/M in range(radius - 1, src))
		M?.client?.tgui_panel?.stop_music()

/obj/machinery/electrical_jukebox/proc/on_cd_stop()
	SIGNAL_HANDLER
	stop_music()

/obj/machinery/electrical_jukebox/proc/mob_entered(mob/M)
	if(is_playing())
		current_track.extra_data["start"] = current_track.duration - (S_TIMER_COOLDOWN_TIMELEFT(src, CURRENT_TIME) / 10) || 0 // saniye gerek
		M?.client?.tgui_panel?.play_music(current_track.url, current_track.extra_data)

/obj/machinery/electrical_jukebox/proc/mob_left(mob/M)
	if(is_playing())
		M?.client?.tgui_panel?.stop_music()

/datum/proximity_monitor/advanced/jukebox
	var/list/mobs_inside = list()

/datum/proximity_monitor/advanced/jukebox/on_uncrossed(turf/source, atom/movable/gone, direction)
	. = ..()
	if(ismob(gone))
		var/mob/M = gone
		if(mobs_inside.Find(M))
			if(get_dist(source, host) >= current_range)
				mobs_inside -= M
				INVOKE_ASYNC(host, TYPE_PROC_REF(/obj/machinery/electrical_jukebox, mob_left), M)
			else
				// move
		else if(get_dist(source, host) < current_range && M.client)
			mobs_inside += M
			INVOKE_ASYNC(host, TYPE_PROC_REF(/obj/machinery/electrical_jukebox, mob_entered), M)

/obj/item/electrical_jukebox_beacon
	name = "electrical jukebox beacon"
	desc = "N.T. approved electrical jukebox beacon, toss it down and you will have a complementary electrical jukebox delivered to you."
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beacon"
	var/used

/obj/item/electrical_jukebox_beacon/attack_self()
	if(used)
		return
	loc.visible_message(span_warning("\The [src] begins to beep loudly!"))
	used = TRUE
	addtimer(CALLBACK(src, PROC_REF(launch_payload)), 40)

/obj/item/electrical_jukebox_beacon/proc/launch_payload()
	var/obj/structure/closet/supplypod/centcompod/toLaunch = new()
	new /obj/machinery/electrical_jukebox(toLaunch)
	new /obj/effect/pod_landingzone(drop_location(), toLaunch)
	qdel(src)

#undef SHELLEO_ERRORLEVEL
#undef SHELLEO_STDOUT
#undef SHELLEO_STDERR

#define SHELLEO_ERRORLEVEL 1
#define SHELLEO_STDOUT 2
#define SHELLEO_STDERR 3

#define COMSIG_PROXIMITY_MOB_ENTERED "proximity_mob_entered"
#define COMSIG_PROXIMITY_MOB_LEFT "proximity_mob_left"

#define STOP(src) "(<a href='?src=[REF(src)];cancel=1'>STOP</a>)"
#define REMOVETRAIT(src, user) "(<a href='?src=[REF(src)];removetrait=[REF(user)]'>REMOVE TRAIT</a>)"
#define CLEARQUEUE(src) "(<a href='?src=[REF(src)];clearqueue=1'>CLEAR QUEUE</a>)"

#define CACHE_DURATION 5 MINUTES

/datum/web_track
	var/url = "" // cdn url
	var/title = ""
	var/duration = 0 // in seconds
	var/display_duration = "" // -> 2 minutes 4 seconds
	// human url of track
	var/webpage_url = ""
	var/webpage_url_html = "" // anchor -> <a href="bbb">xxx<a/>
	// not neccessary but cool
	var/upload_date = ""
	var/artist = ""
	var/album = ""
	// id like
	var/timestamp = 1
	// required for tgui panel
	var/list/extra_data = list()
	// logging etc
	var/mob_name = ""
	var/mob_ckey = ""
	var/mob_key_name = ""

/datum/web_track/New(url, title, webpage_url, duration, artist, upload_date, album, mob_name, mob_ckey, mob_key_name)
	src.url = url
	src.title = title
	src.duration = duration
	src.display_duration = DisplayTimeText(duration * 1 SECONDS, 1)
	src.webpage_url = webpage_url
	src.webpage_url_html = webpage_url ? "<a href=\"[webpage_url]\">[title]</a>" : title
	src.upload_date = upload_date
	src.artist = artist
	src.album = album
	timestamp = world.time
	extra_data = parse_extra_data()
	src.mob_name = mob_name
	src.mob_ckey = mob_ckey
	src.mob_key_name = mob_key_name

/datum/web_track/proc/parse_extra_data()
	var/list/extra_data = list()
	extra_data["title"] = title
	extra_data["duration"] = display_duration
	extra_data["link"] = webpage_url
	extra_data["artist"] = artist
	extra_data["upload_date"] = upload_date
	extra_data["album"] = album
	extra_data["timestamp"] = timestamp
	return extra_data

/obj/machinery/electrical_jukebox
	name = "electrical jukebox"
	desc = "An advanced music player supports web musics sex."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "e-jukebox"
	density = TRUE

	var/radius = 12 // kendi bulunduğu turf dahil tek bir yöne
	var/busy = FALSE // youtube-dl çalışma aralığı
	var/ytdl // config
	var/loop = FALSE
	var/track_started_at = 0
	var/datum/web_track/current_track
	var/datum/proximity_monitor/advanced/jukebox/proximity_monitor
	var/list/queue = list()
	var/caching = TRUE
	var/list/cached_sounds = list()

/obj/machinery/electrical_jukebox/Initialize(mapload)
	. = ..()

	ytdl = CONFIG_GET(string/invoke_youtubedl)
	if(!ytdl) return

	RegisterSignal(src, COMSIG_PROXIMITY_MOB_ENTERED, PROC_REF(on_mob_entered))
	RegisterSignal(src, COMSIG_PROXIMITY_MOB_LEFT, PROC_REF(on_mob_left))

	INVOKE_ASYNC(src, PROC_REF(init_proximity_monitor))

/obj/machinery/electrical_jukebox/proc/init_proximity_monitor()
	if(istype(loc, /obj/structure/closet/supplypod))
		var/obj/structure/closet/supplypod/pod = loc
		sleep(pod.delays[POD_TRANSIT] + pod.delays[POD_FALLING] + pod.delays[POD_OPENING])

	proximity_monitor = new(src, radius)

/obj/machinery/electrical_jukebox/Destroy()
	. = ..()
	stop_music()

	for(var/track in queue)
		queue -= track
		qdel(track)

	QDEL_NULL(queue)
	QDEL_NULL(proximity_monitor)

	UnregisterSignal(src, COMSIG_PROXIMITY_MOB_ENTERED)
	UnregisterSignal(src, COMSIG_PROXIMITY_MOB_LEFT)

/obj/machinery/electrical_jukebox/Topic(href, href_list)
	if(href_list["cancel"])
		if(!current_track)
			to_chat(usr, span_admin("[src] is not playing"))
			return
		stop_music()
		message_admins("[key_name_admin(usr)] stopped [src] at [get_area_name(src)].")
		log_admin_private("[key_name(usr)] stopped [src] at [get_area_name(src)].")
	if(href_list["clearqueue"])
		if(queue.len == 0)
			to_chat(usr, span_admin("The queue is empty"))
			return
		for(var/track in queue)
			queue -= track
			qdel(track)
		message_admins("[key_name_admin(usr)] cleared queue of [src] at [get_area_name(src)].")
		log_admin_private("[key_name(usr)] cleared queue of [src] at [get_area_name(src)].")
	if(href_list["removetrait"])
		var/mob/target = locate(href_list["removetrait"])
		if(!HAS_TRAIT(target, TRAIT_CAN_USE_JUKEBOX))
			to_chat(usr, span_admin("[target]'s jukebox trait is already removed"))
			return
		REMOVE_TRAIT(target, TRAIT_CAN_USE_JUKEBOX, null)
		message_admins("[key_name_admin(usr)] removed [target]'s jukebox trait.")
		log_admin_private("[key_name(usr)] removed [target]'s jukebox trait.")

/obj/machinery/electrical_jukebox/process()
	if(current_track && world.time - track_started_at > current_track.duration * 10)
		skip_music()

/obj/machinery/electrical_jukebox/update_icon_state()
	icon_state = "[initial(icon_state)][is_playing() ? "-active" : null]"
	return ..()

/obj/machinery/electrical_jukebox/can_be_unfasten_wrench(mob/user, silent)
	. = ..()
	if(busy || is_playing())
		to_chat(user, span_warning("You cannot unsecure [src] while its on!"), confidential = TRUE)
		return CANT_UNFASTEN

/obj/machinery/electrical_jukebox/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
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
		ui = new(user, src, "ElectricalJukebox")
		ui.open()

/obj/machinery/electrical_jukebox/ui_data(mob/user)
	var/list/data = list()
	if(current_track)
		var/elapsed = world.time - track_started_at
		data["current_track"] = current_track.extra_data
		data["elapsed"] = DisplayTimeText(elapsed <= (current_track.duration * 10) ? elapsed : (current_track.duration * 10), 1)
	else
		data["current_track"] = null
		data["elapsed"] = null
	data["active"] = is_playing()
	data["busy"] = busy
	data["queue"] = list()
	data["loop"] = loop
	for(var/datum/web_track/track in queue)
		data["queue"] += list(track.extra_data)
	return data

/obj/machinery/electrical_jukebox/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	if(!HAS_TRAIT(usr, TRAIT_CAN_USE_JUKEBOX) && !is_admin(usr.client))
		to_chat(usr, span_warning("You are not allowed to use [src]."), confidential = TRUE)
		return

	if(busy || !usr.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return

	switch(action)
		if("toggle")
			if(is_playing())
				stop_music()
			else
				if(!can_play(usr))
					return
				if(queue.len > 0)
					var/datum/web_track/track = queue[1]
					queue -= track
					play_music_by_track(track)
				else
					var/input = tgui_input_music("Play")
					if(input)
						play_music_by_input(usr, input)
			return
		if("add_queue")
			var/input = tgui_input_music("Add to Queue")
			if(input)
				add_to_queue(usr, input)
			return
		if("clear_queue") //2. onaylama gerekçek
			for(var/track in queue)
				queue -= track
				qdel(track)
		if("remove_queue")
			if(params["index"] > queue.len)
				return
			var/track = queue[params["index"]]
			if(track)
				queue -= track
				qdel(track)
			return
		if("skip")
			skip_music(TRUE)
			return
		if("loop")
			loop = !loop
			return

/obj/machinery/electrical_jukebox/proc/is_playing()
	if(current_track && world.time - track_started_at < current_track.duration * 10)
		return TRUE
	return FALSE

/obj/machinery/electrical_jukebox/proc/tgui_input_music(title)
	var/input = tgui_input_text(usr, "Enter content URL (supported sites only)", title)
	if(input && length(input) > 10 && usr.can_perform_action(src, FORBID_TELEKINESIS_REACH)) // regex iyi olurdu
		return input

/obj/machinery/electrical_jukebox/proc/get_web_sound_(input, mob_name, mob_ckey, mob_key_name)
	if(!ytdl)
		return "Youtube-dl was not configured, action unavailable"

	var/list/data
	var/cached = cached_sounds[input]

	if(caching && cached && world.time - cached["timestamp"] < CACHE_DURATION)
		data = cached
	else
		var/shell_scrubbed_input = shell_url_scrub(input)
		var/list/output = world.shelleo("[ytdl] --geo-bypass --format \"bestaudio\[ext=mp3]/best\[ext=mp4]\[height <= 360]/bestaudio\[ext=m4a]/bestaudio\[ext=aac]\" --dump-single-json --no-playlist -- \"[shell_scrubbed_input]\"")

		var/errorlevel = output[SHELLEO_ERRORLEVEL]
		var/stdout = output[SHELLEO_STDOUT]
		var/stderr = output[SHELLEO_STDERR]

		if(errorlevel)
			return "Youtube-dl URL retrieval FAILED:\n[stderr]"

		try
			data = json_decode(stdout)
		catch(var/exception/e)
			return "Youtube-dl JSON parsing FAILED:\n[e]: [stdout]"

		if(!findtext(data["url"], GLOB.is_http_protocol))
			return "The media provider returned a content URL that isn't using the HTTP or HTTPS protocol. This is a security risk and the sound will not be played."

		if(data["duration"] > 60 * 10) // 10min
			return "Duration too long!"

		data["timestamp"] = world.time

		if(caching)
			cached_sounds[input] = data

	// url, title, webpage_url, duration, artist, upload_date, album, mob_name, mob_ckey, mob_key_name
	var/datum/web_track/track = new(
		url = data["url"],
		title = data["title"],
		webpage_url = data["webpage_url"],
		duration = data["duration"],
		artist = data["artist"],
		upload_date = data["upload_date"],
		album = data["album"],
		mob_name = mob_name,
		mob_ckey = mob_ckey,
		mob_key_name = mob_key_name
	)

	return track

/obj/machinery/electrical_jukebox/proc/get_web_sound(input, mob_name, mob_ckey, mob_key_name)
	busy = TRUE
	. = get_web_sound_(input, mob_name, mob_ckey, mob_key_name)
	busy = FALSE
	return .

/obj/machinery/electrical_jukebox/proc/play_in_radius(datum/web_track/track)
	say("Now playing: [track.title] added by [track.mob_name].")
	for(var/mob/user in range(radius - 1, src))
		var/client/client = user.client
		if(client && client.tgui_panel && client.prefs.read_preference(/datum/preference/toggle/sound_jukebox))
			to_chat(user, "[icon2html(src, client)] [span_boldnotice("Playing [track.webpage_url_html] added by [track.mob_name] on [src].")]")
			client.tgui_panel.play_music(track.url, track.extra_data)

/obj/machinery/electrical_jukebox/proc/stop_in_radius()
	for(var/mob/user in range(radius - 1, src))
		if(user && user.client && user.client.tgui_panel)
			user.client.tgui_panel.stop_music()

/obj/machinery/electrical_jukebox/proc/can_play(mob/user = null)
	if(is_playing())
		if(user)
			to_chat(user, span_warning("Its already playing!"), confidential = TRUE)
		return FALSE
	if(!anchored)
		if(user)
			to_chat(user, span_warning("The [src] needs to be secured first!"), confidential = TRUE)
		return FALSE
	return TRUE

/obj/machinery/electrical_jukebox/proc/play_music_by_track(datum/web_track/track, looped = FALSE)
	if(!can_play())
		return FALSE

	if(world.time - track.timestamp > CACHE_DURATION)
		var/datum/web_track/new_track = get_web_sound(track.webpage_url, track.mob_name, track.mob_ckey, track.mob_key_name)
		qdel(track)
		track = new_track

	if(!check_track(track))
		qdel(track)
		say("Track is not available. [track.title]")
		return FALSE

	if(!looped)
		QDEL_NULL(current_track)

	current_track = track
	track_started_at = world.time
	update_icon_state()

	play_in_radius(track)

	var/area_name = get_area_name(src, TRUE)

	log_admin("Playing web sound [track.webpage_url_html] on [src] added by [track.mob_key_name] at [area_name]")
	message_admins("Playing web sound [track.title] on [src] at added by [track.mob_key_name] at [area_name]. [STOP(src)]")

	SSblackbox.record_feedback("nested tally", "played_url", 1, list("[track.mob_ckey]", "[track.webpage_url]"))

	return TRUE

/obj/machinery/electrical_jukebox/proc/play_music_by_input(mob/user, input)
	if(!can_play())
		return FALSE

	var/datum/web_track/track = get_web_sound(input, user.name, user.ckey, key_name(user))

	if(!check_track(track))
		qdel(track)
		say("Track is not available. [track.title]")
		return FALSE

	QDEL_NULL(current_track)
	current_track = track
	track_started_at = world.time
	update_icon_state()

	play_in_radius(track)

	var/area_name = get_area_name(src, TRUE)

	log_admin("[key_name(user)] played web sound [track.webpage_url_html] on [src] at [area_name]")
	message_admins("[key_name(user)] played web sound [track.title] on [src] at [area_name]. [ADMIN_QUE(user)] [ADMIN_JMP(src)] [STOP(src)] [REMOVETRAIT(src, user)]")

	SSblackbox.record_feedback("nested tally", "played_url", 1, list("[user.ckey]", "[input]"))

	return TRUE

/obj/machinery/electrical_jukebox/proc/add_to_queue(mob/user, input)
	if(busy)
		return FALSE

	var/datum/web_track/track = get_web_sound(input, user.name, user.ckey, key_name(user))

	if(!check_track(track))
		qdel(track)
		say("Track is not available. [track.title]")
		return FALSE

	var/area_name = get_area_name(src, TRUE)

	log_admin("[key_name(user)] added web sound [track.webpage_url_html] to queue on [src] at [area_name]")
	message_admins("[key_name(user)] added web sound [track.title] to queue on [src] at [area_name]. [ADMIN_QUE(user)] [ADMIN_JMP(src)] [CLEARQUEUE(src)] [REMOVETRAIT(src, user)]")

	queue += track

	return TRUE

/obj/machinery/electrical_jukebox/proc/stop_music()
	track_started_at = 0
	QDEL_NULL(current_track)
	stop_in_radius()

/obj/machinery/electrical_jukebox/proc/skip_music(manually = FALSE)
	if(loop && !manually)
		track_started_at = 0
		stop_in_radius()
		play_music_by_track(current_track, TRUE)
	else
		stop_music()
		if(queue.len > 0)
			var/datum/web_track/track = queue[1]
			queue -= track
			play_music_by_track(track)

/obj/machinery/electrical_jukebox/proc/check_track(datum/web_track/track)
	if(!istype(track))
		return FALSE
	if(!track.url || length(track.url) < 8)
		return FALSE
	return TRUE

/obj/machinery/electrical_jukebox/proc/on_mob_entered(datum/source, mob/user)
	SIGNAL_HANDLER
	if(is_playing() && user.client?.prefs.read_preference(/datum/preference/toggle/sound_jukebox))
		current_track.extra_data["start"] = (world.time - track_started_at) / 10 || 0
		user.client?.tgui_panel?.play_music(current_track.url, current_track.extra_data)

/obj/machinery/electrical_jukebox/proc/on_mob_left(datum/source, mob/user)
	SIGNAL_HANDLER
	if(is_playing())
		user.client?.tgui_panel?.stop_music()

/datum/proximity_monitor/advanced/jukebox
	var/list/mobs_inside = list()
/datum/proximity_monitor/advanced/jukebox/New(atom/_host, range, _ignore_if_not_on_turf)
	. = ..()
	for(var/mob/user in range(range, host))
		if(user.client)
			mobs_inside += user
			SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_ENTERED, user)

/datum/proximity_monitor/advanced/jukebox/on_uncrossed(turf/source, atom/movable/gone, direction)
	. = ..()
	if(ismob(gone))
		var/mob/user = gone
		if(mobs_inside.Find(user))
			if(get_dist(gone, host) >= current_range)
				mobs_inside -= user
				SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_LEFT, user)

/datum/proximity_monitor/advanced/jukebox/on_entered(turf/source, atom/movable/entered)
	. = ..()
	if(ismob(entered))
		var/mob/user = entered
		if(user.client && !mobs_inside.Find(user) && get_dist(user, host) < current_range)
			mobs_inside += user
			SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_ENTERED, user)

/obj/item/electrical_jukebox_beacon
	name = "electrical jukebox beacon"
	desc = "N.T. approved electrical jukebox beacon, toss it down and you will have a complementary electrical jukebox delivered to you."
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beacon"

/obj/item/electrical_jukebox_beacon/attack_self()
	loc.visible_message(span_warning("\The [src] begins to beep loudly!"))
	var/obj/structure/closet/supplypod/centcompod/toLaunch = new()
	var/obj/machinery/electrical_jukebox/jukebox = new(toLaunch)
	new /obj/effect/pod_landingzone(drop_location(), toLaunch)
	jukebox.anchored = FALSE
	qdel(src)

#undef CACHE_DURATION

#undef STOP
#undef REMOVETRAIT
#undef CLEARQUEUE

#undef COMSIG_PROXIMITY_MOB_ENTERED
#undef COMSIG_PROXIMITY_MOB_LEFT

#undef SHELLEO_ERRORLEVEL
#undef SHELLEO_STDOUT
#undef SHELLEO_STDERR

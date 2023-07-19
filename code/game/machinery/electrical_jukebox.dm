#define SHELLEO_ERRORLEVEL 1
#define SHELLEO_STDOUT 2
#define SHELLEO_STDERR 3

#define COMSIG_PROXIMITY_MOB_ENTERED "proximity_mob_entered"
#define COMSIG_PROXIMITY_MOB_LEFT "proximity_mob_left"

#define STOP(src) "(<a href='?src=[REF(src)];cancel=1'>STOP</a>)"
#define REMOVETRAIT(src, user) "(<a href='?src=[REF(src)];removetrait=[REF(user)]'>REMOVE TRAIT</a>)"
#define CLEARQUEUE(src) "(<a href='?src=[REF(src)];clearqueue=1'>CLEAR QUEUE</a>)"
#define APPROVEREQUEST(src, track) "(<a href='?src=[REF(src)];approve=[REF(track)]'>APPROVE</a>)"
#define DENYREQUEST(src, track) "(<a href='?src=[REF(src)];deny=[REF(track)]'>DENY</a>)"

#define CACHE_DURATION 5 MINUTES
#define MAX_SOUND_DURATION 10 MINUTES
#define REQUEST_COOLDOWN 15 SECONDS

#define YTDL_REGEX @"^(https?:\/\/)?(www\.)?(soundcloud\.com\/|youtube\.com\/|youtu\.be\/)[\w\-\/?=&]*$"

/datum/web_track
	var/url = ""
	var/title = ""
	var/duration = 0
	var/display_duration = ""
	var/webpage_url = ""
	var/webpage_url_html = ""
	var/upload_date = ""
	var/artist = ""
	var/album = ""
	var/timestamp = 0
	var/mob_name = ""
	var/mob_ckey = ""
	var/mob_key_name = ""
	var/requested = FALSE
	var/list/as_list = list()

/datum/web_track/New(url, title, webpage_url, duration, artist, upload_date, album, mob_name, mob_ckey, mob_key_name)
	src.url = url
	src.title = title
	src.duration = duration
	src.display_duration = DisplayTimeText(duration, 1)
	src.webpage_url = webpage_url
	src.webpage_url_html = webpage_url ? "<a href=\"[webpage_url]\">[title]</a>" : title
	src.upload_date = upload_date
	src.artist = artist
	src.album = album
	timestamp = world.time
	src.mob_name = mob_name
	src.mob_ckey = mob_ckey
	src.mob_key_name = mob_key_name
	as_list = parse_as_list()

/datum/web_track/proc/parse_as_list()
	var/list/track_as_list = list()
	track_as_list["title"] = title
	track_as_list["duration"] = display_duration
	track_as_list["link"] = webpage_url
	track_as_list["webpage_url"] = webpage_url
	track_as_list["webpage_url_html"] = webpage_url_html
	track_as_list["upload_date"] = upload_date
	track_as_list["artist"] = artist
	track_as_list["album"] = album
	track_as_list["timestamp"] = timestamp
	track_as_list["mob_name"] = mob_name
	track_as_list["mob_ckey"] = mob_ckey
	track_as_list["mob_key_name"] = mob_key_name
	return track_as_list

/obj/machinery/electrical_jukebox
	name = "electrical jukebox"
	desc = "An advanced music player supports web music."
	icon = 'icons/obj/machines/music.dmi'
	icon_state = "e-jukebox"
	density = TRUE

	var/radius = 12
	var/busy = FALSE
	var/ytdl
	var/static/regex/ytdl_regex = regex(YTDL_REGEX, "s")
	var/loop = FALSE
	var/track_started_at = 0
	var/datum/web_track/current_track
	var/datum/proximity_monitor/advanced/jukebox/proximity_monitor
	var/list/queue = list()
	var/list/requests = list()
	var/request_cooldown = 0

	var/list/cached_sounds = list()

	var/list/bad_input_cache = list()

	var/list/mobs_in_range

/obj/machinery/electrical_jukebox/Initialize(mapload)
	. = ..()

	ytdl = CONFIG_GET(string/invoke_youtubedl)

	if(!ytdl)
		return

	RegisterSignal(src, COMSIG_PROXIMITY_MOB_ENTERED, PROC_REF(on_mob_entered))
	RegisterSignal(src, COMSIG_PROXIMITY_MOB_LEFT, PROC_REF(on_mob_left))
	RegisterSignal(src, COMSIG_QDELETING, PROC_REF(cleanup))

	INVOKE_ASYNC(src, PROC_REF(init_proximity_monitor))

/obj/machinery/electrical_jukebox/proc/init_proximity_monitor()
	if(istype(loc, /obj/structure/closet/supplypod))
		var/obj/structure/closet/supplypod/pod = loc
		sleep(pod.delays[POD_TRANSIT] + pod.delays[POD_FALLING] + pod.delays[POD_OPENING] + 1)

	proximity_monitor = new(src, radius)
	proximity_monitor.recalculate_field()

/obj/machinery/electrical_jukebox/proc/cleanup()
	stop_music()

	for(var/track in queue)
		qdel(track)
	for(var/track in requests)
		qdel(track)

	QDEL_NULL(queue)
	QDEL_NULL(requests)
	QDEL_NULL(proximity_monitor)
	QDEL_NULL(cached_sounds)
	QDEL_NULL(bad_input_cache)

	UnregisterSignal(src, COMSIG_PROXIMITY_MOB_ENTERED)
	UnregisterSignal(src, COMSIG_PROXIMITY_MOB_LEFT)
	UnregisterSignal(src, COMSIG_QDELETING)

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
			to_chat(usr, span_admin("[target]'s jukebox trait has already removed"))
			return
		REMOVE_TRAIT(target, TRAIT_CAN_USE_JUKEBOX, null)
		message_admins("[key_name_admin(usr)] removed [key_name(target, TRUE)]'s jukebox trait.")
		log_admin_private("[key_name(usr)] removed [key_name(target, TRUE)]'s jukebox trait.")
	if(href_list["approve"])
		var/datum/web_track/track = locate(href_list["approve"])
		if(!requests.Find(track))
			to_chat(usr, span_admin("The request has already approved/denied/discarded"))
			return
		requests -= track
		track.requested = TRUE
		if(queue.len == 0 && !is_playing())
			track_started_at = 0
			play_music_by_track(track)
		else
			queue += track
		message_admins("[key_name_admin(usr)] approved [key_name(track.mob_key_name, TRUE)]'s web sound request [track.webpage_url_html].")
		log_admin_private("[key_name(usr)] approved [key_name(track.mob_key_name, TRUE)]'s web sound request [track.webpage_url_html].")
	if(href_list["deny"])
		var/datum/web_track/track = locate(href_list["deny"])
		if(!requests.Find(track))
			to_chat(usr, span_admin("The request has already approved/denied/discarded"))
			return
		requests -= track
		message_admins("[key_name_admin(usr)] denied [key_name(track.mob_key_name, TRUE)]'s web sound request [track.webpage_url_html].")
		log_admin_private("[key_name(usr)] denied [key_name(track.mob_key_name, TRUE)]'s web sound request [track.webpage_url_html].")
		qdel(track)

/obj/machinery/electrical_jukebox/process()
	if(current_track && world.time - track_started_at > current_track.duration)
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

/obj/machinery/electrical_jukebox/welder_act(mob/living/user, obj/item/tool)
	if(density)
		if(atom_integrity < max_integrity)
			if(tool.tool_start_check(user, amount = 1))
				user.visible_message( \
					span_notice("[user] begins welding the [src]."), \
					span_notice("You begin repairing the [src]..."), \
					span_hear("You hear welding."))
			if(tool.use_tool(src, user, 40, volume = 50))
				atom_integrity = max_integrity
				set_machine_stat(machine_stat & ~BROKEN)
				user.visible_message( \
					span_notice("[user] finishes welding the [src]."), \
					span_notice("You finish repairing the [src]."))
				update_appearance()
		else
			to_chat(user, span_notice("The [src] doesn't need repairing."))
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
	if(current_track)
		var/elapsed = world.time - track_started_at
		data["current_track"] = current_track.as_list
		data["elapsed"] = DisplayTimeText(elapsed <= (current_track.duration) ? elapsed : (current_track.duration), 1)
		data["requested"] = current_track.requested
	else
		data["current_track"] = null
		data["elapsed"] = null
		data["requested"] = FALSE
	data["active"] = is_playing()
	data["busy"] = busy
	data["loop"] = loop
	data["can_mob_use"] = can_mob_use(user)
	data["user_key_name"] = key_name(user)
	data["queue"] = list()
	for(var/datum/web_track/track in queue)
		data["queue"] += list(track.as_list)
	data["requests"] = list()
	for(var/datum/web_track/track in requests)
		data["requests"] += list(track.as_list)
	return data

/obj/machinery/electrical_jukebox/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	if(!usr.can_perform_action(src, FORBID_TELEKINESIS_REACH) || busy)
		return

	if(action != "new_request" && action != "discard_request" && !can_mob_use(usr))
		to_chat(usr, span_warning("You are not allowed to use [src]."), confidential = TRUE)
		return

	if(busy)
		return

	switch(action)
		if("toggle")
			if(is_playing())
				stop_music()
			else
				if(!can_play_music(usr))
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
		if("skip")
			skip_music(manually = TRUE)
			return
		if("loop")
			loop = !loop
			return
		if("add_queue")
			var/input = tgui_input_music("Add to Queue")
			if(input)
				add_music_to_queue_by_input(usr, input)
			return
		if("clear_queue")
			for(var/track in queue)
				queue -= track
				qdel(track)
		if("remove_queue")
			remove_track_from_track_list(queue, params["timestamp"])
			return
		if("new_request")
			var/time_elapsed = request_cooldown != 0 ? world.time - request_cooldown : REQUEST_COOLDOWN
			if(time_elapsed >= REQUEST_COOLDOWN)
				var/input = tgui_input_music("New Request")
				if(input)
					new_request(usr, input)
			else
				var/display_time = DisplayTimeText(REQUEST_COOLDOWN - time_elapsed)
				say("You cannot request a new music for [display_time].")
				balloon_alert(usr, "[display_time]!")
			return
		if("approve_request")
			var/datum/web_track/track = get_track_from_list_by_timestamp(requests, params["timestamp"])
			if(track)
				approve_request(track)
			else
				to_chat(usr, span_warning("The request has already approved/denied/discarded."), confidential = TRUE)
			return
		if("deny_request")
			var/datum/web_track/track = get_track_from_list_by_timestamp(requests, params["timestamp"])
			if(track)
				remove_track_from_track_list(requests, params["timestamp"])
			else
				to_chat(usr, span_warning("The request has already approved/denied/discarded."), confidential = TRUE)
			return
		if("discard_request")
			var/datum/web_track/track = get_track_from_list_by_timestamp(requests, params["timestamp"])
			if(track)
				remove_track_from_track_list(requests, params["timestamp"])
			else
				to_chat(usr, span_warning("The request has already approved/denied/discarded."), confidential = TRUE)
			return

/obj/machinery/electrical_jukebox/proc/get_track_from_list_by_timestamp(list/track_list, timestamp)
	var/datum/web_track/track
	for(var/datum/web_track/T in track_list)
		if(T.timestamp == timestamp)
			track = T
			break
	return track

/obj/machinery/electrical_jukebox/proc/remove_track_from_track_list(list/track_list, timestamp)
	var/datum/web_track/track = get_track_from_list_by_timestamp(track_list, timestamp)
	if(track)
		track_list -= track
		qdel(track)

/obj/machinery/electrical_jukebox/proc/new_request(mob/user, input)
	if(busy)
		return FALSE

	if(bad_input_cache.Find(input))
		var/cache = bad_input_cache[input]
		if(istext(cache))
			say("Track is not available.")
			to_chat(user, "Track is not available", , confidential = TRUE)
		return FALSE

	var/datum/web_track/track = get_web_sound(input, user.name, user.ckey, key_name(user))
	request_cooldown = world.time

	if(!check_track(track))
		if(!istext(track))
			say("Track is not available. [track?.title]")
			qdel(track)
		else
			say("Track is not available.")
		return FALSE

	var/area_name = get_area_name(src, TRUE)

	log_admin("[key_name(user)] requested a web sound [track.webpage_url_html] on [src] at [area_name]")
	message_admins("[key_name(user, TRUE)] requested a web sound [track.webpage_url_html] on [src] at [area_name]. [ADMIN_FULLMONTY_NONAME(user)] [ADMIN_JMP(src)] [APPROVEREQUEST(src, track)] [DENYREQUEST(src, track)]")

	requests += track

	return TRUE

/obj/machinery/electrical_jukebox/proc/approve_request(datum/web_track/track)
	if(!istype(track) || !requests.Find(track))
		return FALSE
	requests -= track
	track.requested = TRUE
	if(queue.len == 0 && !is_playing())
		track_started_at = 0
		play_music_by_track(track)
	else
		queue += track
	message_admins("[key_name_admin(usr)] [usr.job] approved [key_name(track.mob_key_name, TRUE)]'s web sound request [track.webpage_url_html].")
	return TRUE

/obj/machinery/electrical_jukebox/proc/deny_request(timestamp)

/obj/machinery/electrical_jukebox/proc/is_playing()
	if(current_track && world.time - track_started_at < current_track.duration)
		return TRUE
	return FALSE

/obj/machinery/electrical_jukebox/proc/tgui_input_music(title)
	var/input = tgui_input_text(usr, "Enter content URL (supported sites only, soundcloud, youtube)", title)
	if(input && usr.can_perform_action(src, FORBID_TELEKINESIS_REACH) && findtext(input, ytdl_regex))
		return input

/obj/machinery/electrical_jukebox/proc/get_web_sound_(input, mob_name, mob_ckey, mob_key_name)
	if(!ytdl)
		return "Youtube-dl was not configured, action unavailable"

	var/list/data
	var/cached = cached_sounds[input]

	if(cached && world.time - cached["timestamp"] < CACHE_DURATION)
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

		if(data["duration"] > MAX_SOUND_DURATION / 10)
			return "Duration too long!"

		data["timestamp"] = world.time

		if(cached)
			qdel(cached)

		cached_sounds[input] = data

		qdel(output)

	// url, title, webpage_url, duration, artist, upload_date, album, mob_name, mob_ckey, mob_key_name
	var/datum/web_track/track = new(
		url = data["url"],
		title = data["title"],
		webpage_url = data["webpage_url"],
		duration = data["duration"] * 10,
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
	var/datum/web_track/track = get_web_sound_(input, mob_name, mob_ckey, mob_key_name)
	busy = FALSE
	if(!check_track(track))
		var/client/client = GLOB.directory[ckey(mob_ckey)]
		var/mob/user = client.mob
		message_admins("[key_name(mob_ckey, TRUE)] requested a bad url on [src] at [get_area_name(src)]. Request: [input] Result: [istext(track) ? track : "no result"] [ADMIN_FULLMONTY_NONAME(user)] [ADMIN_JMP(src)] [REMOVETRAIT(src, user)]")
		bad_input_cache[input] = track
	return track

/obj/machinery/electrical_jukebox/proc/play_in_mob_list(datum/web_track/track)
	say("Now playing: [track.title] added by [track.mob_name].")
	for(var/mob/user in mobs_in_range)
		var/client/client = user.client
		if(client && client.tgui_panel && client.prefs.read_preference(/datum/preference/toggle/sound_jukebox))
			to_chat(user, "[icon2html(src, client)] [span_boldnotice("Playing [track.webpage_url_html] added by [track.mob_name] on [src].")]")
			client.tgui_panel.play_music(track.url, track.as_list)

/obj/machinery/electrical_jukebox/proc/stop_in_mob_list()
	for(var/mob/user in mobs_in_range)
		if(user && user.client && user.client.tgui_panel)
			user.client.tgui_panel.stop_music()

/obj/machinery/electrical_jukebox/proc/can_play_music(mob/user = null)
	if(is_playing())
		if(user)
			to_chat(user, span_warning("Its already playing!"), confidential = TRUE)
		return FALSE
	if(!anchored)
		if(user)
			to_chat(user, span_warning("The [src] needs to be secured first!"), confidential = TRUE)
			balloon_alert(user, "secure first!")
		return FALSE
	return TRUE

/obj/machinery/electrical_jukebox/proc/can_mob_use(mob/user)
	// if(HAS_TRAIT(user, TRAIT_CAN_USE_JUKEBOX))
	if(HAS_TRAIT(user, TRAIT_CAN_USE_JUKEBOX) || is_admin(user.client))
		return TRUE
	return FALSE

/obj/machinery/electrical_jukebox/proc/play_music_by_track(datum/web_track/track, looped = FALSE)
	if(busy || !can_play_music())
		return FALSE

	if(world.time - track.timestamp > CACHE_DURATION)
		var/datum/web_track/new_track = get_web_sound(track.webpage_url, track.mob_name, track.mob_ckey, track.mob_key_name)
		qdel(track)
		track = new_track

	if(!check_track(track))
		if(!istext(track))
			say("Track is not available. [track?.title]")
			qdel(track)
		else
			say("Track is not available.")
		return FALSE

	if(!looped)
		QDEL_NULL(current_track)

	current_track = track
	track_started_at = world.time
	update_icon_state()

	play_in_mob_list(track)

	var/area_name = get_area_name(src, TRUE)
	var/client/client = GLOB.directory[ckey(track.mob_ckey)]
	var/mob/user = client.mob

	log_admin("Playing web sound [track.webpage_url_html] on [src] added by [track.mob_key_name] at [area_name]")
	message_admins("Playing web sound [track.title] on [src] at added by [key_name(track.mob_key_name, TRUE)] at [area_name]. [ADMIN_FULLMONTY_NONAME(user)] [ADMIN_JMP(src)] [STOP(src)]")

	SSblackbox.record_feedback("nested tally", "played_url", 1, list("[track.mob_ckey]", "[track.webpage_url]"))

	return TRUE

/obj/machinery/electrical_jukebox/proc/play_music_by_input(mob/user, input)
	if(busy || !can_play_music(user))
		return FALSE

	if(bad_input_cache.Find(input))
		var/cache = bad_input_cache[input]
		if(istext(cache))
			say("Track is not available.")
			to_chat(user, "Track is not available.", , confidential = TRUE)
		return FALSE

	var/datum/web_track/track = get_web_sound(input, user.name, user.ckey, key_name(user))

	if(!check_track(track))
		if(!istext(track))
			say("Track is not available. [track?.title]")
			qdel(track)
		else
			say("Track is not available.")
		return FALSE

	QDEL_NULL(current_track)
	current_track = track
	track_started_at = world.time
	update_icon_state()

	play_in_mob_list(track)

	var/area_name = get_area_name(src, TRUE)

	log_admin("[key_name(user)] played web sound [track.webpage_url_html] on [src] at [area_name]")
	message_admins("[key_name(user, TRUE)] played web sound [track.title] on [src] at [area_name]. [ADMIN_FULLMONTY_NONAME(user)] [ADMIN_JMP(src)] [STOP(src)] [REMOVETRAIT(src, user)]")

	SSblackbox.record_feedback("nested tally", "played_url", 1, list("[user.ckey]", "[input]"))

	return TRUE

/obj/machinery/electrical_jukebox/proc/add_music_to_queue_by_input(mob/user, input)
	if(busy)
		return FALSE

	if(bad_input_cache.Find(input))
		var/cache = bad_input_cache[input]
		if(istext(cache))
			say("Track is not available.")
			to_chat(user, "Track is not available.", , confidential = TRUE)
		return FALSE

	var/datum/web_track/track = get_web_sound(input, user.name, user.ckey, key_name(user))

	if(!check_track(track))
		if(!istext(track))
			say("Track is not available. [track?.title]")
			qdel(track)
		else
			say("Track is not available.")
		return FALSE

	var/area_name = get_area_name(src, TRUE)

	log_admin("[key_name(user)] added web sound [track.webpage_url_html] to queue on [src] at [area_name]")
	message_admins("[key_name(user, TRUE)] added web sound [track.title] to queue on [src] at [area_name]. [ADMIN_FULLMONTY_NONAME(user)] [ADMIN_JMP(src)] [CLEARQUEUE(src)] [REMOVETRAIT(src, user)]")

	queue += track

	return TRUE

/obj/machinery/electrical_jukebox/proc/stop_music()
	track_started_at = 0
	QDEL_NULL(current_track)
	stop_in_mob_list()

/obj/machinery/electrical_jukebox/proc/skip_music(manually = FALSE)
	if(loop && !manually)
		track_started_at = 0
		stop_in_mob_list()
		play_music_by_track(current_track, looped = TRUE)
	else
		stop_music()
		if(queue.len > 0)
			var/datum/web_track/track = queue[1]
			queue -= track
			play_music_by_track(track)

/obj/machinery/electrical_jukebox/proc/check_track(datum/web_track/track)
	if(!istype(track))
		return FALSE
	return TRUE

/obj/machinery/electrical_jukebox/proc/on_mob_entered(datum/source, mob/user)
	SIGNAL_HANDLER
	if(is_playing() && user.client?.prefs.read_preference(/datum/preference/toggle/sound_jukebox))
		current_track.as_list["start"] = (world.time - track_started_at) / 10
		user.client.tgui_panel?.play_music(current_track.url, current_track.as_list)

/obj/machinery/electrical_jukebox/proc/on_mob_left(datum/source, mob/user)
	SIGNAL_HANDLER
	if(is_playing())
		user.client?.tgui_panel?.stop_music()

/datum/proximity_monitor/advanced/jukebox
	loc_connections = list(
		// COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
		// COMSIG_ATOM_EXITED = PROC_REF(on_uncrossed),
		COMSIG_ATOM_ABSTRACT_ENTERED = PROC_REF(on_entered),
		COMSIG_ATOM_ABSTRACT_EXITED = PROC_REF(on_uncrossed),
		COMSIG_ATOM_INITIALIZED_ON = PROC_REF(on_entered),
	)
	var/list/mobs_in_range = list()

/datum/proximity_monitor/advanced/jukebox/New(obj/machinery/electrical_jukebox/host, range, ignore_if_not_on_turf)
	. = ..()
	if(!istype(host))
		qdel(src)
		return
	host.mobs_in_range = mobs_in_range
	for(var/mob/user in range(range, host))
		if(user.client)
			mobs_in_range += user
			SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_ENTERED, user)
/datum/proximity_monitor/advanced/jukebox/Destroy()
	. = ..()
	qdel(mobs_in_range)
/datum/proximity_monitor/advanced/jukebox/on_uncrossed(turf/source, atom/movable/gone, direction)
	. = ..()
	if(ismob(gone))
		var/mob/user = gone
		if(mobs_in_range.Find(user))
			if(get_dist(gone, host) >= current_range || gone.z != host.z) // get_dist z levelin farklı olduğunu fark edemiyor
				mobs_in_range -= user
				SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_LEFT, user)

/datum/proximity_monitor/advanced/jukebox/on_entered(turf/source, atom/movable/entered)
	. = ..()
	if(ismob(entered))
		var/mob/user = entered
		if(user.client && !mobs_in_range.Find(user) && get_dist(user, host) < current_range)
			mobs_in_range += user
			SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_ENTERED, user)

/datum/proximity_monitor/advanced/jukebox/on_moved(atom/movable/movable, atom/old_loc)
	. = ..()
	if(movable == host)
		var/list/old_list = mobs_in_range.Copy()
		mobs_in_range.Cut()
		for(var/mob/user in range(current_range, host))
			if(old_list.Find(user))
				mobs_in_range += user
			else
				if(user.client)
					mobs_in_range += user
					SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_ENTERED, user)
		for(var/mob/user in old_list)
			if(!mobs_in_range.Find(user))
				SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_LEFT, user)
		qdel(old_list)

/obj/item/electrical_jukebox_beacon
	name = "electrical jukebox beacon"
	desc = "N.T. approved electrical jukebox beacon, toss it down and you will have a complementary electrical jukebox delivered to you."
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beacon"

/obj/item/electrical_jukebox_beacon/attack_self()
	loc.visible_message(span_warning("\The [src] begins to beep loudly!"))
	var/obj/structure/closet/supplypod/centcompod/pod = new()
	var/obj/machinery/electrical_jukebox/jukebox = new(pod)
	new /obj/effect/pod_landingzone(drop_location(), pod)
	jukebox.anchored = FALSE
	qdel(src)

#undef YTDL_REGEX

#undef REQUEST_COOLDOWN
#undef MAX_SOUND_DURATION
#undef CACHE_DURATION

#undef STOP
#undef REMOVETRAIT
#undef CLEARQUEUE
#undef APPROVEREQUEST
#undef DENYREQUEST

#undef COMSIG_PROXIMITY_MOB_ENTERED
#undef COMSIG_PROXIMITY_MOB_LEFT

#undef SHELLEO_ERRORLEVEL
#undef SHELLEO_STDOUT
#undef SHELLEO_STDERR

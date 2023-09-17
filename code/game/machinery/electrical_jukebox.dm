#define SHELLEO_ERRORLEVEL 1
#define SHELLEO_STDOUT 2
#define SHELLEO_STDERR 3

#define ERR_YTDL_NOT_CONFIGURED "Youtube-dl was not configured, action unavailable"
#define ERR_NOT_HTTPS "The media provider returned a content URL that isn't using the HTTP or HTTPS protocol. This is a security risk and the sound will not be played."
#define ERR_JSON_RETRIEVAL "Youtube-dl URL retrieval failed"
#define ERR_JSON_PARSING "Youtube-dl JSON parsing failed"
#define ERR_DURATION "Duration too long"

#define STOP(src) "(<a href='?src=[REF(src)];stop=1'>STOP</a>)"
#define REMOVEQUEUE(src, track) "(<a href='?src=[REF(src)];removequeue=[REF(track)]'>REMOVE</a>)"
#define DENYREQUEST(src, track) "(<a href='?src=[REF(src)];deny=[REF(track)]'>DENY</a>)"
#define BANJUKEBOX(src, client) "(<a href='?src=[REF(src)];ban=[REF(client)]'>JUKEBOX BAN</a>)"
#define UNBANJUKEBOX(src, client) "(<a href='?src=[REF(src)];unban=[REF(client)]'>UNBAN</a>)"

#define CACHE_DURATION 4 MINUTES
#define MAX_SOUND_DURATION 10 MINUTES
#define REQUEST_COOLDOWN 20 SECONDS

#define get_volume(jukebox, atom) ((jukebox.range - get_dist(jukebox, atom) - 0.9) / jukebox.range)

GLOBAL_LIST_EMPTY(jukebox_invalid_cache)
GLOBAL_LIST_EMPTY(jukebox_cache)
GLOBAL_LIST_EMPTY_TYPED(jukebox_ban, /client)

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

/datum/web_track/New(url, title, webpage_url, duration, artist, album, mob_name, mob_ckey)
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

/obj/machinery/electrical_jukebox
	name = "electrical jukebox"
	desc = "An advanced music player supports web music."
	icon = 'icons/psychonaut/obj/machines/music.dmi'
	icon_state = "e-jukebox"
	density = TRUE

	var/jukebox_id
	var/datum/weakref/owner
	var/check_trait = FALSE
	var/invoke_youtubedl
	var/range = 16
	var/busy = FALSE
	var/loop = FALSE
	var/track_started_at = 0
	var/request_cooldown = 0
	var/list/queue = list()
	var/list/requests = list()
	var/list/listeners_in_range = list()
	var/datum/web_track/current_track
	var/datum/proximity_monitor/advanced/mob_collector/proximity_monitor
	// var/static/regex/ytdl_regex = regex(@"^(https?:\/\/)?(www\.)?(youtube\.com\/|youtu\.be\/)[\w\-\/?=&%]*$", "s")
	var/static/regex/ytdl_regex = regex(@"^.+$", "s")

/obj/machinery/electrical_jukebox/bar
	check_trait = TRUE

/obj/machinery/electrical_jukebox/Initialize(mapload)
	. = ..()

	jukebox_id = REF(src)
	invoke_youtubedl = CONFIG_GET(string/invoke_youtubedl)

	if(invoke_youtubedl)
		RegisterSignal(src, COMSIG_PROXIMITY_MOB_ENTERED, PROC_REF(on_mob_entered))
		RegisterSignal(src, COMSIG_PROXIMITY_MOB_LEFT, PROC_REF(on_mob_left))
		RegisterSignal(src, COMSIG_PROXIMITY_MOB_MOVED, PROC_REF(on_mob_moved))
		INVOKE_ASYNC(src, PROC_REF(init_proximity_monitor))

	update_icon_state()

/obj/machinery/electrical_jukebox/proc/init_proximity_monitor()
	if(istype(loc, /obj/structure/closet/supplypod))
		var/obj/structure/closet/supplypod/pod = loc
		sleep(pod.delays[POD_TRANSIT] + pod.delays[POD_FALLING] + pod.delays[POD_OPENING] + 1)

	proximity_monitor = new(src, range, FALSE, FALSE)
	proximity_monitor.recalculate_field()

/obj/machinery/electrical_jukebox/Destroy()
	if(invoke_youtubedl)
		stop_music()

		for(var/track in queue)
			qdel(track)
		for(var/track in requests)
			qdel(track)

		for(var/mob/user in listeners_in_range)
			user.client?.tgui_panel?.destroy_jukebox_player(jukebox_id)

		qdel(proximity_monitor)

	qdel(queue)
	qdel(requests)
	qdel(listeners_in_range)

	return ..()

/obj/machinery/electrical_jukebox/Topic(href, href_list)
	if(!is_admin(usr.client))
		return
	var/admin_key_name = key_name(usr)
	if(href_list["stop"])
		if(!current_track)
			to_chat(usr, span_admin("[src] is not playing"))
			return
		stop_music()
		var/area_name = get_area_name(src)
		message_admins("[admin_key_name] stopped [src] at [area_name].")
		log_admin_private("[admin_key_name] stopped [src] at [area_name].")
	if(href_list["removequeue"])
		var/datum/web_track/track = locate(href_list["removequeue"]) in queue
		if(track)
			var/user_key_name = key_name(track.mob_ckey, TRUE)
			queue -= track
			message_admins("[admin_key_name] removed track [track.webpage_url_html] from queue added by [user_key_name].")
			log_admin_private("[admin_key_name] removed track [track.webpage_url_html] from queue added by [user_key_name].")
			qdel(track)
		else
			if(REF(current_track) == href_list["removequeue"])
				var/user_key_name = key_name(current_track.mob_ckey, TRUE)
				skip_music()
				message_admins("[admin_key_name] removed track [current_track.webpage_url_html] added by [user_key_name] while playing.")
				log_admin_private("[admin_key_name] removed track [current_track.webpage_url_html] added by [user_key_name] while playing.")
			else
				to_chat(usr, span_admin("The track has already removed"))
	if(href_list["deny"])
		var/datum/web_track/track = locate(href_list["deny"]) in requests
		if(track)
			var/user_key_name = key_name(track.mob_ckey, TRUE)
			requests -= track
			message_admins("[admin_key_name] denied [user_key_name]'s web sound request [track.webpage_url_html].")
			log_admin_private("[admin_key_name] denied [user_key_name]'s web sound request [track.webpage_url_html].")
			qdel(track)
		else
			to_chat(usr, span_admin("The request has already approved/denied/discarded"))
	if(href_list["ban"])
		var/client/client = locate(href_list["ban"])
		var/client_key_name = key_name(client, TRUE)
		if(!GLOB.jukebox_ban.Find(client))
			GLOB.jukebox_ban += client
			message_admins("[admin_key_name] banned [client_key_name] from using jukebox for this round. [UNBANJUKEBOX(src, client)]")
			log_admin_private("[admin_key_name] banned [client_key_name] from using jukebox for this round.")
		else
			to_chat(usr, span_admin("[client_key_name] has already banned from using jukebox."))
	if(href_list["unban"])
		var/client/client = locate(href_list["unban"])
		var/client_key_name = key_name(client, TRUE)
		if(GLOB.jukebox_ban.Find(client))
			GLOB.jukebox_ban -= client
			message_admins("[admin_key_name] unbanned [client_key_name] from using jukebox. [BANJUKEBOX(src, client)]")
			log_admin_private("[admin_key_name] unbanned [client_key_name] from using jukebox.")
		else
			to_chat(usr, span_admin("[client_key_name] has already unbanned from using jukebox."))

/obj/machinery/electrical_jukebox/process()
	if(current_track && world.time - track_started_at > current_track.duration)
		skip_music()

/obj/machinery/electrical_jukebox/update_icon_state()
	icon_state = "[initial(icon_state)][invoke_youtubedl ? is_playing() ? "-active" : null : "-broken"]"
	return ..()

/obj/machinery/electrical_jukebox/can_be_unfasten_wrench(mob/user, silent)
	. = ..()
	if(busy || is_playing())
		to_chat(user, span_warning("You cannot unsecure [src] while its on!"))
		return CANT_UNFASTEN

/obj/machinery/electrical_jukebox/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/electrical_jukebox/welder_act(mob/living/user, obj/item/tool)
	if(atom_integrity < max_integrity)
		if(!tool.tool_start_check(user, amount = 1))
			return TOOL_ACT_TOOLTYPE_SUCCESS
		user.visible_message( \
			span_notice("[user] starts to repair [src]."), \
			span_notice("You begin repairing the [src]..."), \
			span_hear("You hear welding."))
		if(tool.use_tool(src, user, 40, volume = 50))
			atom_integrity = max_integrity
			set_machine_stat(machine_stat & ~BROKEN)
			user.visible_message( \
				span_notice("[user] finishes reparing [src]."), \
				span_notice("You finish repairing the [src]."))
			update_appearance()
	else
		to_chat(user, span_notice("The [src] doesn't need repairing."))
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/electrical_jukebox/on_set_is_operational(old_value)
	. = ..()
	if(!is_operational)
		stop_music()

/obj/machinery/electrical_jukebox/ui_status(mob/user)
	if(!invoke_youtubedl)
		user.playsound_local(src, 'sound/misc/compiler-failure.ogg', 25, TRUE)
		return UI_CLOSE
	return ..()

/obj/machinery/electrical_jukebox/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ElectricalJukebox", name)
		ui.open()

/obj/machinery/electrical_jukebox/ui_data(mob/user)
	. = list()
	if(current_track)
		var/elapsed = world.time - track_started_at
		.["current_track"] = current_track.as_list
		.["elapsed"] = DisplayTimeText(elapsed <= (current_track.duration) ? elapsed : (current_track.duration), 1)
	else
		.["current_track"] = null
		.["elapsed"] = null
	.["active"] = is_playing()
	.["busy"] = busy
	.["loop"] = loop
	.["can_mob_use"] = can_mob_use(user)
	.["banned"] = GLOB.jukebox_ban.Find(user.client) ? TRUE : FALSE
	.["user_key_name"] = key_name(user)
	.["queue"] = list()
	for(var/datum/web_track/track in queue)
		.["queue"] += list(track.as_list)
	.["requests"] = list()
	for(var/datum/web_track/track in requests)
		.["requests"] += list(track.as_list)

/obj/machinery/electrical_jukebox/ui_act(action, list/params)
	. = ..()

	if(. || busy || !is_operational || !usr.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return

	if(GLOB.jukebox_ban.Find(usr.client))
		to_chat(usr, span_warning("You are banned from using [src] for this round."))
		return

	if(action != "new_request" && action != "discard_request" && !can_mob_use(usr))
		to_chat(usr, span_warning("You are not allowed to use [src]."))
		return

	switch(action)
		if("toggle")
			if(is_playing())
				stop_music()
			else
				if(!anchored)
					to_chat(usr, span_warning("[src] needs to be secured first!"))
					balloon_alert(usr, "secure first!")
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
				add_queue(usr, input)
			return
		if("clear_queue")
			for(var/track in queue)
				queue -= track
				qdel(track)
		if("remove_queue")
			var/datum/web_track/track = locate(params["track_id"]) in queue
			if(track)
				queue -= track
				qdel(track)
			return
		if("new_request")
			var/time_elapsed = request_cooldown != 0 ? world.time - request_cooldown : REQUEST_COOLDOWN
			if(time_elapsed >= REQUEST_COOLDOWN)
				var/input = tgui_input_music("New Request")
				if(input)
					new_request(usr, input)
			else
				var/display_time = DisplayTimeText(REQUEST_COOLDOWN - time_elapsed)
				say("You cannot make a new request for [display_time].")
				balloon_alert(usr, "[display_time]!")
			return
		if("approve_request")
			var/datum/web_track/track = locate(params["track_id"]) in requests
			if(track)
				requests -= track
				queue += track
			return
		if("discard_request")
			var/datum/web_track/track = locate(params["track_id"]) in requests
			if(track)
				requests -= track
				qdel(track)
			return

/obj/machinery/electrical_jukebox/proc/get_web_sound_(input, mob_name, mob_ckey)
	if(!invoke_youtubedl)
		return ERR_YTDL_NOT_CONFIGURED

	var/list/data
	var/cached = GLOB.jukebox_cache[input]

	if(cached && world.time - cached["timestamp"] < CACHE_DURATION)
		data = cached
	else
		var/shell_scrubbed_input = shell_url_scrub(input)
		var/list/output = world.shelleo("[invoke_youtubedl] --geo-bypass --format \"bestaudio\[ext=mp3]/best\[ext=mp4]\[height <= 360]/bestaudio\[ext=m4a]/bestaudio\[ext=aac]\" --dump-single-json --no-playlist -- \"[shell_scrubbed_input]\"")

		var/errorlevel = output[SHELLEO_ERRORLEVEL]
		var/stdout = output[SHELLEO_STDOUT]

		if(errorlevel)
			return ERR_JSON_RETRIEVAL

		try
			data = json_decode(stdout)
		catch
			return ERR_JSON_PARSING

		if(!findtext(data["url"], GLOB.is_http_protocol))
			return ERR_NOT_HTTPS

		if(data["duration"] > MAX_SOUND_DURATION / 10)
			return ERR_DURATION

		data["timestamp"] = world.time

		if(cached)
			qdel(cached)
		GLOB.jukebox_cache[input] = data

	var/datum/web_track/track = new(
		url = data["url"],
		title = data["title"],
		webpage_url = data["webpage_url"],
		duration = data["duration"] * 10,
		artist = data["artist"],
		album = data["album"],
		mob_name = mob_name,
		mob_ckey = mob_ckey
	)

	return track

/obj/machinery/electrical_jukebox/proc/get_web_sound(input, mob_name, mob_ckey)
	busy = TRUE
	var/datum/web_track/track = get_web_sound_(input, mob_name, mob_ckey)
	busy = FALSE
	if(!istype(track))
		GLOB.jukebox_invalid_cache[input] = track
	return track

/obj/machinery/electrical_jukebox/proc/play_in_range(datum/web_track/track)
	say("Now playing: [track.title] added by [track.mob_name].")
	for(var/mob/user in listeners_in_range)
		if(user.client?.prefs.read_preference(/datum/preference/toggle/sound_jukebox))
			to_chat(user, "[icon2html(src, user.client)] [span_boldnotice("Playing [track.webpage_url_html] added by [track.mob_name] on [src].")]")
			user.client.tgui_panel?.play_jukebox_music(jukebox_id, track.url, track.as_list, get_volume(src, user))

/obj/machinery/electrical_jukebox/proc/stop_in_range()
	for(var/mob/user in listeners_in_range)
		user.client?.tgui_panel?.stop_jukebox_music(jukebox_id)

/obj/machinery/electrical_jukebox/proc/play_music_by_track(datum/web_track/track, looped = FALSE, input = FALSE)
	if(busy || is_playing() || !anchored || !is_operational || !check_track(track))
		return

	if(world.time - track.timestamp > CACHE_DURATION)
		var/datum/web_track/new_track = get_web_sound(track.webpage_url, track.mob_name, track.mob_ckey)
		qdel(track)
		track = new_track

	if(current_track && !looped)
		qdel(current_track)

	current_track = track
	track_started_at = world.time
	update_icon_state()

	play_in_range(track)

	var/area_name = get_area_name(src, TRUE)
	var/client/client = GLOB.directory[ckey(track.mob_ckey)]

	if(input)
		log_admin("[key_name(client)] played web sound [track.webpage_url] on [src] at [area_name]")
		message_admins("[key_name(client, TRUE)] played web sound [track.webpage_url_html] on [src] at [area_name]. [ADMIN_QUE(client.mob)] [ADMIN_JMP(src)] [STOP(src)] [BANJUKEBOX(src, client)]")
	else
		log_admin("Playing web sound [track.webpage_url] on [src] added by [key_name(client)] at [area_name]")
		message_admins("Playing web sound [track.webpage_url_html] on [src] added by [key_name(client, TRUE)] at [area_name]. [ADMIN_QUE(client.mob)] [ADMIN_JMP(src)] [STOP(src)] [BANJUKEBOX(src, client)]")

	SSblackbox.record_feedback("nested tally", "jukebox_played_url", 1, list("[client.ckey]", "[track.webpage_url]"))

/obj/machinery/electrical_jukebox/proc/play_music_by_input(mob/user, input)
	if(busy || is_playing() || !anchored || !is_operational || !check_input(user, input))
		return

	var/datum/web_track/track = get_web_sound(input, user.name, user.ckey, key_name(user))

	if(!check_track(track, user))
		return

	play_music_by_track(track, FALSE, TRUE)

/obj/machinery/electrical_jukebox/proc/stop_music()
	track_started_at = 0
	if(current_track)
		QDEL_NULL(current_track)
	stop_in_range()
	update_icon_state()

/obj/machinery/electrical_jukebox/proc/skip_music(manually = FALSE)
	if(loop && !manually)
		track_started_at = 0
		stop_in_range()
		play_music_by_track(current_track, looped = TRUE)
	else
		stop_music()
		if(queue.len > 0)
			var/datum/web_track/track = queue[1]
			queue -= track
			play_music_by_track(track)

/obj/machinery/electrical_jukebox/proc/add_queue(mob/user, input)
	if(busy || !is_operational || !check_input(user, input))
		return

	var/datum/web_track/track = get_web_sound(input, user.name, user.ckey, key_name(user))

	if(!check_track(track, user))
		return

	queue += track

	var/area_name = get_area_name(src, TRUE)

	log_admin("[key_name(user)] added web sound [track.webpage_url_html] to queue on [src] at [area_name]")
	message_admins("[key_name(user, TRUE)] added web sound [track.title] to queue on [src] at [area_name]. [ADMIN_QUE(user)] [ADMIN_JMP(src)] [REMOVEQUEUE(src, track)] [BANJUKEBOX(src, user.client)]")

/obj/machinery/electrical_jukebox/proc/new_request(mob/user, input)
	if(busy || !is_operational || !check_input(user, input))
		return

	var/datum/web_track/track = get_web_sound(input, user.name, user.ckey, key_name(user))

	request_cooldown = world.time

	if(!check_track(track, user))
		return

	requests += track

	var/area_name = get_area_name(src, TRUE)

	log_admin("[key_name(user)] requested a web sound [track.webpage_url_html] on [src] at [area_name]")
	message_admins("[key_name(user, TRUE)] requested a web sound [track.webpage_url_html] on [src] at [area_name]. [ADMIN_QUE(user)] [ADMIN_JMP(src)] [DENYREQUEST(src, track)] [BANJUKEBOX(src, user.client)]")

/obj/machinery/electrical_jukebox/proc/is_playing()
	if(current_track && world.time - track_started_at < current_track.duration)
		return TRUE
	return FALSE

/obj/machinery/electrical_jukebox/proc/can_mob_use(mob/user)
	if(owner?.resolve() == user || (check_trait && HAS_TRAIT(user, TRAIT_CAN_USE_JUKEBOX)))
		return TRUE
	return FALSE

/obj/machinery/electrical_jukebox/proc/check_input(mob/user, input)
	var/cached = GLOB.jukebox_invalid_cache[input]
	if(cached)
		check_track(cached, user)
		return FALSE
	return TRUE

/obj/machinery/electrical_jukebox/proc/check_track(datum/web_track/track, mob/user)
	if(!istype(track))
		if(user)
			if(track == ERR_DURATION)
				to_chat(user, span_warning("The duration of the music must be less than [DisplayTimeText(MAX_SOUND_DURATION, 1)]!"))
				balloon_alert(user, "duration too long!")
			else
				to_chat(user, span_warning("Track is not available."))
				balloon_alert("unavailable!")
		return FALSE
	return TRUE

/obj/machinery/electrical_jukebox/proc/tgui_input_music(title)
	var/input = tgui_input_text(usr, "Enter content URL (youtube only)", title)
	if(input && usr.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		if(findtext(input, ytdl_regex))
			return input
		else
			return tgui_input_music(title)

/obj/machinery/electrical_jukebox/proc/on_mob_moved(datum/source, mob/user)
	SIGNAL_HANDLER
	if(is_playing() && listeners_in_range.Find(user))
		user.client?.tgui_panel?.set_jukebox_volume(jukebox_id, get_volume(src, user))

/obj/machinery/electrical_jukebox/proc/on_mob_entered(datum/source, mob/user)
	SIGNAL_HANDLER
	if(user.client?.prefs.read_preference(/datum/preference/toggle/sound_jukebox))
		if(!listeners_in_range.Find(user))
			listeners_in_range += user
		if(is_playing())
			var/list/options = current_track.as_list.Copy()
			options["start"] = (world.time - track_started_at) / 10
			user.client.tgui_panel?.play_jukebox_music(jukebox_id, current_track.url, options, get_volume(src, user))
	RegisterSignal(user, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(on_mob_login))

/obj/machinery/electrical_jukebox/proc/on_mob_left(datum/source, mob/user)
	SIGNAL_HANDLER
	if(listeners_in_range.Find(user))
		listeners_in_range -= user
		var/client/client = user.client || GLOB.directory[ckey(user.mind?.key)]
		client?.tgui_panel?.destroy_jukebox_player(jukebox_id)
	UnregisterSignal(user, COMSIG_MOB_CLIENT_LOGIN)

/obj/machinery/electrical_jukebox/proc/on_mob_login(mob/source, client/client)
	SIGNAL_HANDLER
	if(client?.prefs.read_preference(/datum/preference/toggle/sound_jukebox))
		if(!listeners_in_range.Find(source))
			listeners_in_range += source
		if(is_playing())
			var/list/options = current_track.as_list.Copy()
			options["start"] = (world.time - track_started_at) / 10
			client.tgui_panel?.play_jukebox_music(jukebox_id, current_track.url, options, get_volume(src, source))

/obj/item/electrical_jukebox_beacon
	name = "electrical jukebox beacon"
	desc = "N.T. approved electrical jukebox beacon, toss it down and you will have a complementary electrical jukebox delivered to you."
	icon = 'icons/obj/machines/floor.dmi'
	icon_state = "floor_beacon"
	var/check_trait = FALSE

/obj/item/electrical_jukebox_beacon/bar
	check_trait = TRUE

/obj/item/electrical_jukebox_beacon/attack_self(mob/user)
	loc.visible_message(span_warning("[src] begins to beep loudly!"))
	var/obj/structure/closet/supplypod/centcompod/pod = new ()
	var/obj/machinery/electrical_jukebox/jukebox = new (pod)
	new /obj/effect/pod_landingzone(drop_location(), pod)
	jukebox.owner = WEAKREF(user)
	jukebox.check_trait = check_trait
	jukebox.anchored = FALSE
	qdel(src)

// debug item
/obj/item/boombox
	name = "Boombox"
	icon = 'icons/obj/toys/plushes.dmi'
	icon_state = "pkplush"
	var/obj/machinery/electrical_jukebox/jukebox

/obj/item/boombox/Initialize(mapload)
	. = ..()
	jukebox = new(get_turf(src))
	jukebox.forceMove(src)
	jukebox.anchored = TRUE
	if(ismob(loc))
		jukebox.owner = WEAKREF(loc)
	else if(isturf(loc))
		for(var/mob/mob in loc)
			if(mob.client)
				jukebox.owner = WEAKREF(mob)
				break

/obj/item/boombox/ui_status(mob/user)
	if(!jukebox.invoke_youtubedl)
		user.playsound_local(src, 'sound/misc/compiler-failure.ogg', 25, TRUE)
		return UI_CLOSE
	return ..()

/obj/item/boombox/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ElectricalJukebox", name)
		ui.open()

/obj/item/boombox/ui_data(mob/user)
	. = jukebox.ui_data(user)

/obj/item/boombox/ui_act(action, list/params)
	. = ..()

	if(. || jukebox.busy || !jukebox.is_operational || !usr.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return

	if(action != "new_request" && action != "discard_request" && !jukebox.can_mob_use(usr))
		to_chat(usr, span_warning("You are not allowed to use [src]."))
		return

	switch(action)
		if("toggle")
			if(jukebox.is_playing())
				jukebox.stop_music()
			else
				if(jukebox.queue.len > 0)
					var/datum/web_track/track = jukebox.queue[1]
					jukebox.queue -= track
					jukebox.play_music_by_track(track)
				else
					var/input = jukebox.tgui_input_music("Play")
					if(input)
						jukebox.play_music_by_input(usr, input)
			return
		if("skip")
			jukebox.skip_music(manually = TRUE)
			return
		if("loop")
			jukebox.loop = !jukebox.loop
			return
		if("add_queue")
			var/input = jukebox.tgui_input_music("Add to Queue")
			if(input)
				jukebox.add_queue(usr, input)
			return
		if("clear_queue")
			for(var/track in jukebox.queue)
				jukebox.queue -= track
				qdel(track)
		if("remove_queue")
			var/datum/web_track/track = locate(params["track_id"]) in jukebox.queue
			if(track)
				jukebox.queue -= track
				qdel(track)
			return
		if("new_request")
			var/time_elapsed = jukebox.request_cooldown != 0 ? world.time - jukebox.request_cooldown : REQUEST_COOLDOWN
			if(time_elapsed >= REQUEST_COOLDOWN)
				var/input = jukebox.tgui_input_music("New Request")
				if(input)
					jukebox.new_request(usr, input)
			else
				var/display_time = DisplayTimeText(REQUEST_COOLDOWN - time_elapsed)
				say("You cannot make a new request for [display_time].")
				balloon_alert(usr, "[display_time]!")
			return
		if("approve_request")
			var/datum/web_track/track = locate(params["track_id"]) in jukebox.requests
			if(track)
				jukebox.requests -= track
				jukebox.queue += track
			return
		if("discard_request")
			var/datum/web_track/track = locate(params["track_id"]) in jukebox.requests
			if(track)
				jukebox.requests -= track
				qdel(track)
			return

#undef get_volume

#undef REQUEST_COOLDOWN
#undef MAX_SOUND_DURATION
#undef CACHE_DURATION

#undef STOP
#undef REMOVEQUEUE
#undef DENYREQUEST
#undef BANJUKEBOX
#undef UNBANJUKEBOX

#undef ERR_YTDL_NOT_CONFIGURED
#undef ERR_NOT_HTTPS
#undef ERR_JSON_RETRIEVAL
#undef ERR_JSON_PARSING
#undef ERR_DURATION

#undef SHELLEO_ERRORLEVEL
#undef SHELLEO_STDOUT
#undef SHELLEO_STDERR

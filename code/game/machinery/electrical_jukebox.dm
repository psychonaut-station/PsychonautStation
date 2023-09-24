#define STOP(src) "(<a href='?src=[REF(src)];stop=1'>STOP</a>)"
#define REMOVEQUEUE(src, track) "(<a href='?src=[REF(src)];removequeue=[REF(track)]'>REMOVE</a>)"
#define DENYREQUEST(src, track) "(<a href='?src=[REF(src)];deny=[REF(track)]'>DENY</a>)"
#define BANJUKEBOX(src, client) "(<a href='?src=[REF(src)];ban=[REF(client)]'>JUKEBOX BAN</a>)"
#define UNBANJUKEBOX(src, client) "(<a href='?src=[REF(src)];unban=[REF(client)]'>UNBAN</a>)"

#define check_jukebox(jukebox) !(jukebox.busy || is_playing(jukebox) || !jukebox.anchored || !jukebox.is_operational)
#define is_playing(jukebox) (jukebox.player && jukebox.player.track && world.time - jukebox.player.track_started_at < jukebox.player.track.duration)
#define can_mob_use(jukebox, mob) (jukebox.owner?.resolve() == mob || (jukebox.check_trait && HAS_TRAIT(mob, TRAIT_CAN_USE_JUKEBOX)))

GLOBAL_LIST_EMPTY_TYPED(jukebox_ban, /client)

/obj/machinery/electrical_jukebox
	name = "electrical jukebox"
	desc = "An advanced music player supports web music."
	icon = 'icons/psychonaut/obj/machines/music.dmi'
	icon_state = "e-jukebox"
	density = TRUE

	var/datum/weakref/owner
	var/invoke_youtubedl
	var/check_trait = FALSE
	var/range = 16
	var/busy = FALSE
	var/request_cooldown = 20 SECONDS
	var/last_requested_at = 0
	var/list/queue
	var/list/requests
	var/datum/component/web_sound_player/player

/obj/machinery/electrical_jukebox/Initialize(mapload)
	. = ..()
	invoke_youtubedl = CONFIG_GET(string/invoke_youtubedl)

	if(invoke_youtubedl)
		player = AddComponent(/datum/component/web_sound_player, range)
		RegisterSignal(player, COMSIG_WEB_SOUND_ENDED, PROC_REF(on_ended))
		forceMove(loc)
	else
		update_icon_state()

/obj/machinery/electrical_jukebox/Destroy()
	if(invoke_youtubedl)
		if(is_playing(src))
			stop()
		qdel(player)
	return ..()

/obj/machinery/electrical_jukebox/Topic(href, href_list)
	if(!is_admin(usr.client))
		return
	var/admin_key_name = key_name(usr)
	if(href_list["stop"])
		if(!is_playing(src))
			to_chat(usr, span_admin("[src] is not playing"))
			return
		stop()
		var/area_name = get_area_name(src)
		message_admins("[admin_key_name] stopped [src] at [area_name].")
		log_admin("[admin_key_name] stopped [src] at [area_name].")
	if(href_list["removequeue"])
		var/datum/web_track/track
		if(LAZYLEN(queue))
			track = locate(href_list["removequeue"]) in queue
		if(track)
			var/user_key_name = key_name(track.mob_ckey, TRUE)
			LAZYREMOVE(queue, track)
			message_admins("[admin_key_name] removed track [track.webpage_url_html] from queue added by [user_key_name].")
			log_admin("[admin_key_name] removed track [track.webpage_url_html] from queue added by [user_key_name].")
			qdel(track)
		else
			if(REF(player.track) == href_list["removequeue"])
				var/user_key_name = key_name(player.track.mob_ckey, TRUE)
				skip()
				message_admins("[admin_key_name] removed track [player.track.webpage_url_html] added by [user_key_name] while playing.")
				log_admin("[admin_key_name] removed track [player.track.webpage_url_html] added by [user_key_name] while playing.")
			else
				to_chat(usr, span_admin("The track has already removed"))
	if(href_list["deny"])
		var/datum/web_track/track
		if(LAZYLEN(requests))
			track = locate(href_list["deny"]) in requests
		if(track)
			var/user_key_name = key_name(track.mob_ckey, TRUE)
			LAZYREMOVE(requests, track)
			message_admins("[admin_key_name] denied [user_key_name]'s web sound request [track.webpage_url_html].")
			log_admin("[admin_key_name] denied [user_key_name]'s web sound request [track.webpage_url_html].")
		else
			to_chat(usr, span_admin("The request has already approved/denied/discarded"))
	if(href_list["ban"])
		var/client/client = locate(href_list["ban"])
		var/client_key_name = key_name(client, TRUE)
		if(!GLOB.jukebox_ban.Find(client))
			GLOB.jukebox_ban += client
			message_admins("[admin_key_name] banned [client_key_name] from using jukebox for this round. [UNBANJUKEBOX(src, client)]")
			log_admin("[admin_key_name] banned [client_key_name] from using jukebox for this round.")
		else
			to_chat(usr, span_admin("[client_key_name] has already banned from using jukebox."))
	if(href_list["unban"])
		var/client/client = locate(href_list["unban"])
		var/client_key_name = key_name(client, TRUE)
		if(GLOB.jukebox_ban.Find(client))
			GLOB.jukebox_ban -= client
			message_admins("[admin_key_name] unbanned [client_key_name] from using jukebox. [BANJUKEBOX(src, client)]")
			log_admin("[admin_key_name] unbanned [client_key_name] from using jukebox.")
		else
			to_chat(usr, span_admin("[client_key_name] has already unbanned from using jukebox."))

/obj/machinery/electrical_jukebox/update_icon_state()
	icon_state = "[initial(icon_state)][invoke_youtubedl ? is_playing(src) ? "-active" : null : "-broken"]"
	return ..()

/obj/machinery/electrical_jukebox/can_be_unfasten_wrench(mob/user, silent)
	. = ..()
	if(busy || is_playing(src))
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
			span_notice("You begin repairing [src]..."), \
			span_hear("You hear welding."))
		if(tool.use_tool(src, user, 40, volume = 50))
			atom_integrity = max_integrity
			set_machine_stat(machine_stat & ~BROKEN)
			user.visible_message( \
				span_notice("[user] finishes reparing [src]."), \
				span_notice("You finish repairing [src]."))
			update_appearance()
	else
		to_chat(user, span_notice("[src] doesn't need repairing."))
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/electrical_jukebox/on_set_is_operational(old_value)
	. = ..()
	if(!is_operational)
		stop()

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
	if(player.track)
		var/elapsed = world.time - player.track_started_at
		.["current_track"] = player.track.as_list
		.["elapsed"] = DisplayTimeText(elapsed <= (player.track.duration) ? elapsed : (player.track.duration), 1)
	else
		.["current_track"] = null
		.["elapsed"] = null
	.["active"] = is_playing(src)
	.["busy"] = busy
	.["loop"] = player.loop
	.["can_mob_use"] = can_mob_use(src, user)
	.["banned"] = GLOB.jukebox_ban.Find(user.client) ? TRUE : FALSE
	.["user_key_name"] = key_name(user)
	.["queue"] = list()
	if(LAZYLEN(queue))
		for(var/datum/web_track/track as anything in queue)
			.["queue"] += list(track.as_list)
	.["requests"] = list()
	if(LAZYLEN(requests))
		for(var/datum/web_track/track as anything in requests)
			.["requests"] += list(track.as_list)

/obj/machinery/electrical_jukebox/ui_act(action, list/params)
	. = ..()

	if(. || busy || !is_operational || !usr.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return

	if(GLOB.jukebox_ban.Find(usr.client))
		to_chat(usr, span_warning("You are banned from using [src] for this round."))
		return

	if(action != "new_request" && action != "discard_request" && !can_mob_use(src, usr))
		to_chat(usr, span_warning("You are not allowed to use [src]."))
		return

	switch(action)
		if("toggle")
			if(is_playing(src))
				stop()
			else
				if(!anchored)
					to_chat(usr, span_warning("[src] needs to be secured first!"))
					balloon_alert(usr, "secure first!")
					return
				if(LAZYLEN(queue) > 0)
					var/datum/web_track/track = LAZYACCESS(queue, 1)
					LAZYREMOVE(queue, track)
					play_by_track(track)
				else
					var/input = tgui_music_input("Play")
					if(input)
						play_by_input(usr, input)
			return
		if("skip")
			skip(manually = TRUE)
			return
		if("loop")
			player.loop = !player.loop
			return
		if("add_queue")
			var/input = tgui_music_input("Add to Queue")
			if(input)
				add_queue(usr, input)
			return
		if("clear_queue")
			LAZYNULL(queue)
		if("remove_queue")
			var/datum/web_track/track
			if(LAZYLEN(queue))
				track = locate(params["track_id"]) in queue
			if(track)
				LAZYREMOVE(queue, track)
			return
		if("new_request")
			var/time_elapsed = last_requested_at != 0 ? world.time - last_requested_at : request_cooldown
			if(time_elapsed >= request_cooldown)
				var/input = tgui_music_input("New Request")
				if(input)
					add_queue(usr, input, request = TRUE)
			else
				say("You cannot make a new request for [DisplayTimeText(request_cooldown - time_elapsed)].")
			return
		if("approve_request")
			var/datum/web_track/track
			if(LAZYLEN(requests))
				track = locate(params["track_id"]) in requests
			if(track)
				LAZYREMOVE(requests, track)
				LAZYADD(queue, track)
			return
		if("discard_request")
			var/datum/web_track/track
			if(LAZYLEN(requests))
				track = locate(params["track_id"]) in requests
			if(track)
				LAZYREMOVE(requests, track)
			return

/obj/machinery/electrical_jukebox/proc/get_web_track(input, mob_name, mob_ckey)
	busy = TRUE
	var/datum/web_track/track = url_to_web_track(input)
	busy = FALSE
	if(istype(track))
		track.mob_name = mob_name
		track.mob_ckey = mob_ckey
	return track

/obj/machinery/electrical_jukebox/proc/play_by_track(datum/web_track/track, queued = TRUE)
	if(!check_jukebox(src) || !check_track(track))
		return
	busy = TRUE
	var/playing = player.play(track)
	busy = FALSE
	if(playing)
		say("Now playing: [track.title] added by [track.mob_name].")
		update_icon_state()

		var/area_name = get_area_name(src, TRUE)
		var/client/client = GLOB.directory[ckey(track.mob_ckey)]

		if(!queued)
			log_admin("[key_name(client)] played web sound [track.webpage_url] on [src] at [area_name]")
			message_admins("[key_name(client, TRUE)] played web sound [track.webpage_url_html] on [src] at [area_name]. [ADMIN_QUE(client.mob)] [ADMIN_JMP(src)] [STOP(src)] [BANJUKEBOX(src, client)]")
		else
			log_admin("Playing web sound [track.webpage_url] on [src] added by [key_name(client)] at [area_name]")
			message_admins("Playing web sound [track.webpage_url_html] on [src] added by [key_name(client, TRUE)] at [area_name]. [ADMIN_QUE(client.mob)] [ADMIN_JMP(src)] [STOP(src)] [BANJUKEBOX(src, client)]")

		SSblackbox.record_feedback("nested tally", "jukebox_played_url", 1, list("[client.ckey]", "[track.webpage_url]"))

/obj/machinery/electrical_jukebox/proc/play_by_input(mob/user, input)
	if(!check_jukebox(src) || !check_input(user, input))
		return
	var/datum/web_track/track = get_web_track(input, user.name, user.ckey)
	if(!check_track(track, user))
		return
	play_by_track(track, queued = FALSE)

/obj/machinery/electrical_jukebox/proc/stop()
	player.stop()
	update_icon_state()

/obj/machinery/electrical_jukebox/proc/skip(manually = FALSE)
	if(!player.loop || manually)
		stop()
		if(LAZYLEN(queue))
			var/datum/web_track/track = LAZYACCESS(queue, 1)
			play_by_track(track)
			LAZYREMOVE(queue, track)

/obj/machinery/electrical_jukebox/proc/on_ended(datum/web_track/track, loop)
	SIGNAL_HANDLER
	if(!loop)
		skip()

/obj/machinery/electrical_jukebox/proc/add_queue(mob/user, input, request = FALSE)
	if(busy || !is_operational || !check_input(user, input))
		return
	var/datum/web_track/track = get_web_track(input, user.name, user.ckey)
	if(request)
		last_requested_at = world.time
	if(!check_track(track, user))
		return
	var/area_name = get_area_name(src, TRUE)
	if(request)
		LAZYADD(requests, track)
		log_admin("[key_name(user)] requested a web sound [track.webpage_url_html] on [src] at [area_name]")
		message_admins("[key_name(user, TRUE)] requested a web sound [track.webpage_url_html] on [src] at [area_name]. [ADMIN_QUE(user)] [ADMIN_JMP(src)] [DENYREQUEST(src, track)] [BANJUKEBOX(src, user.client)]")
	else
		LAZYADD(queue, track)
		log_admin("[key_name(user)] added web sound [track.webpage_url_html] to queue on [src] at [area_name]")
		message_admins("[key_name(user, TRUE)] added web sound [track.title] to queue on [src] at [area_name]. [ADMIN_QUE(user)] [ADMIN_JMP(src)] [REMOVEQUEUE(src, track)] [BANJUKEBOX(src, user.client)]")

/obj/machinery/electrical_jukebox/proc/check_input(mob/user, input)
	var/cached_input = GLOB.web_track_cache[input]
	if(!isnull(cached_input) && !islist(cached_input))
		check_track(cached_input, user)
		return FALSE
	return TRUE

/obj/machinery/electrical_jukebox/proc/check_track(datum/web_track/track, mob/user)
	if(!istype(track))
		if(user)
			if(track == WEB_SOUND_ERR_DURATION)
				to_chat(user, span_warning("The duration of the music must be less than [DisplayTimeText(WEB_SOUND_MAX_DURATION, 1)]!"))
			else
				to_chat(user, span_warning("Track is unavailable."))
		return FALSE
	return TRUE

/obj/machinery/electrical_jukebox/proc/tgui_music_input(title)
	var/input = tgui_input_text(usr, "Enter content URL (youtube only)", title)
	if(input && usr.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		if(findtext(input, GLOB.youtubedl_regex))
			return input
		else
			return tgui_music_input(title)

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

#undef check_jukebox
#undef is_playing
#undef can_mob_use

#undef STOP
#undef REMOVEQUEUE
#undef DENYREQUEST
#undef BANJUKEBOX
#undef UNBANJUKEBOX

/// Camera subtype shared by all bodycam implementations.
/obj/machinery/camera/bodycam
	network = list(CAMERANET_NETWORK_SS13)
	internal_light = FALSE
	start_active = TRUE
	view_range = 3
	/// Lazy list of viewers currently watching this camera.
	var/list/sources_watching
	/// Optional pausable component for wearable bodycams.
	var/datum/component/pausable_bodycam/bodycam_component

/obj/machinery/camera/bodycam/Initialize(mapload)
	. = ..()
	if(!isliving(loc))
		return INITIALIZE_HINT_QDEL

	SScameras.remove_camera_from_chunk(src)
	if(myarea)
		LAZYREMOVE(myarea.cameras, src)
		myarea = null

/obj/machinery/camera/bodycam/Destroy()
	clear_watchers()
	bodycam_component = null
	return ..()

/obj/machinery/camera/bodycam/on_start_watching(datum/source)
	LAZYADD(sources_watching, source)
	if(can_use())
		var/mob/living/host = loc
		host?.throw_alert(ALERT_BODYCAM_VIEWED, /atom/movable/screen/alert/bodycam_viewed)
	bodycam_component?.on_watch_start(source)

/obj/machinery/camera/bodycam/on_stop_watching(datum/no_longer_watching)
	LAZYREMOVE(sources_watching, no_longer_watching)
	var/mob/living/host = loc
	if(!LAZYLEN(sources_watching) && host?.has_alert(ALERT_BODYCAM_VIEWED))
		host.clear_alert(ALERT_BODYCAM_VIEWED)
	bodycam_component?.on_watch_stop(no_longer_watching)

/obj/machinery/camera/bodycam/proc/clear_watchers()
	var/mob/living/host = loc
	if(host?.has_alert(ALERT_BODYCAM_VIEWED))
		host.clear_alert(ALERT_BODYCAM_VIEWED)
	LAZYCLEARLIST(sources_watching)

/atom/movable/screen/alert/bodycam_viewed
	name = "Bodycam Viewed"
	desc = "Someone is currently watching your bodycam feed."
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "recording"

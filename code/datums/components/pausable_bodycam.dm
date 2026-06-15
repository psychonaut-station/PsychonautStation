GLOBAL_LIST_EMPTY(pausable_bodycams)

/// Component used by wearable bodycams that should only update while actively viewed or near an AI.
/datum/component/pausable_bodycam
	dupe_mode = COMPONENT_DUPE_UNIQUE
	VAR_PRIVATE/obj/machinery/camera/bodycam/bodycam
	var/camera_update_time = 0.5 SECONDS
	var/list/sources_watching
	var/camera_is_awake = FALSE

/datum/component/pausable_bodycam/Initialize(
	camera_name = "bodycam",
	c_tag = capitalize(camera_name),
	network = CAMERANET_NETWORK_SS13,
	emp_proof = FALSE,
	camera_update_time = 0.5 SECONDS,
	camera_enabled = TRUE,
)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	src.camera_update_time = camera_update_time

	bodycam = new(parent)
	bodycam.bodycam_component = src
	bodycam.network = list(network)
	bodycam.name = camera_name
	bodycam.c_tag = c_tag
	bodycam.camera_enabled = camera_enabled
	if(emp_proof)
		bodycam.AddElement(/datum/element/empprotection, EMP_PROTECT_ALL)

	GLOB.pausable_bodycams += src
	RegisterSignals(bodycam, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED), PROC_REF(camera_gone))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))

/datum/component/pausable_bodycam/Destroy()
	force_pause()
	GLOB.pausable_bodycams -= src
	if(!QDELETED(bodycam))
		UnregisterSignal(bodycam, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
		bodycam.bodycam_component = null
		QDEL_NULL(bodycam)
	return ..()

/datum/component/pausable_bodycam/proc/on_watch_start(datum/source)
	prune_sources_watching()
	LAZYADD(sources_watching, WEAKREF(source))
	check_proximity_state()

/datum/component/pausable_bodycam/proc/on_watch_stop(datum/source)
	prune_sources_watching(source)
	check_proximity_state()

/datum/component/pausable_bodycam/proc/prune_sources_watching(datum/source_to_remove)
	if(!LAZYLEN(sources_watching))
		return
	for(var/datum/weakref/weak_source as anything in sources_watching.Copy())
		var/datum/resolved_source = weak_source?.resolve()
		if(!resolved_source || resolved_source == source_to_remove || !source_is_live(resolved_source))
			LAZYREMOVE(sources_watching, weak_source)

/datum/component/pausable_bodycam/proc/has_live_watchers()
	prune_sources_watching()
	for(var/datum/weakref/weak_source as anything in sources_watching)
		if(weak_source?.resolve())
			return TRUE
	return FALSE

/datum/component/pausable_bodycam/proc/should_be_awake()
	if(has_live_watchers())
		return TRUE
	var/turf/my_turf = get_turf(parent)
	if(!my_turf)
		return FALSE
	for(var/mob/living/silicon/ai/AI in GLOB.ai_list)
		if(AI.stat == DEAD || !GET_CLIENT(AI))
			continue
		if(AI.viewing_camera) // watching a camera, not freelooking
			continue
		if(!AI.eyeobj || AI.eyeobj.z != my_turf.z)
			continue
		if(get_dist(AI.eyeobj, my_turf) <= 9)
			return TRUE
	return FALSE

/datum/component/pausable_bodycam/proc/check_proximity_state()
	if(!bodycam || QDELETED(bodycam) || !bodycam.camera_enabled)
		if(camera_is_awake)
			pause_camera()
		return

	var/should_wake = should_be_awake()
	if(should_wake && !camera_is_awake)
		wake_up()
	else if(!should_wake && camera_is_awake)
		pause_camera()

/datum/component/pausable_bodycam/proc/source_is_live(datum/source)
	if(QDELETED(source))
		return FALSE
	if(istype(source, /obj/machinery/computer/security))
		var/obj/machinery/computer/security/console = source
		return console.active_camera == bodycam && LAZYLEN(console.open_uis)
	if(istype(source, /mob/living/silicon/ai))
		var/mob/living/silicon/ai/ai_user = source
		return ai_user.viewing_camera == bodycam
	return TRUE

/datum/component/pausable_bodycam/proc/on_moved(datum/source, atom/old_loc, ...)
	SIGNAL_HANDLER
	if(get_turf(old_loc) == get_turf(parent))
		return
	var/was_awake = camera_is_awake
	check_proximity_state()
	if(camera_is_awake && was_awake)
		update_camera(old_loc)

/datum/component/pausable_bodycam/proc/update_camera(atom/old_loc)
	if(QDELETED(bodycam))
		return
	if(!bodycam.can_use())
		return
	SScameras.camera_moved(bodycam, get_turf(old_loc), get_turf(bodycam), camera_update_time)
	notify_watchers_refresh()

/datum/component/pausable_bodycam/proc/camera_gone(datum/source)
	SIGNAL_HANDLER
	if(!QDELETED(src))
		qdel(src)

/datum/component/pausable_bodycam/proc/set_camera_enabled(enabled)
	if(!bodycam || QDELETED(bodycam))
		return
	bodycam.camera_enabled = enabled
	check_proximity_state()

/datum/component/pausable_bodycam/proc/set_broken(broken, camera_on = TRUE)
	if(!bodycam || QDELETED(bodycam))
		return
	bodycam.camera_enabled = !broken && camera_on
	check_proximity_state()

/datum/component/pausable_bodycam/proc/notify_watchers_disconnect()
	if(QDELETED(bodycam))
		return
	for(var/datum/weakref/weak_source as anything in sources_watching)
		var/datum/source = weak_source?.resolve()
		if(!source)
			continue
		if(istype(source, /obj/machinery/computer/security))
			var/obj/machinery/computer/security/console = source
			console.on_camera_disabled(bodycam)
		else if(istype(source, /datum/computer_file/program/secureye))
			var/datum/computer_file/program/secureye/program = source
			program.on_camera_disabled(bodycam)

/datum/component/pausable_bodycam/proc/notify_watchers_refresh()
	for(var/datum/weakref/weak_source as anything in sources_watching)
		var/datum/source = weak_source?.resolve()
		if(!source)
			continue
		if(istype(source, /obj/machinery/computer/security))
			var/obj/machinery/computer/security/console = source
			console.update_active_camera_screen()
		else if(istype(source, /datum/computer_file/program/secureye))
			var/datum/computer_file/program/secureye/program = source
			program.update_active_camera_screen()

/datum/component/pausable_bodycam/proc/force_pause()
	notify_watchers_disconnect()
	LAZYNULL(sources_watching)
	pause_camera()

/datum/component/pausable_bodycam/proc/wake_up()
	if(camera_is_awake)
		return
	camera_is_awake = TRUE
	var/mob/living/host = parent
	if(istype(host))
		host.throw_alert(ALERT_BODYCAM_VIEWED, /atom/movable/screen/alert/bodycam_viewed)
	if(!QDELETED(bodycam))
		SScameras.add_camera_to_chunk(bodycam)
		update_camera(get_turf(bodycam))

/datum/component/pausable_bodycam/proc/pause_camera()
	if(!camera_is_awake)
		return
	camera_is_awake = FALSE
	var/mob/living/host = parent
	if(istype(host))
		host.clear_alert(ALERT_BODYCAM_VIEWED)
	if(!QDELETED(bodycam))
		SScameras.remove_camera_from_chunk(bodycam)

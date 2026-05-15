/// Component used by wearable bodycams that should only update while actively viewed.
/datum/component/pausable_bodycam
	dupe_mode = COMPONENT_DUPE_UNIQUE
	VAR_PRIVATE/obj/machinery/camera/bodycam/bodycam
	var/camera_update_time = 0.5 SECONDS
	var/list/sources_watching

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

	RegisterSignals(bodycam, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED), PROC_REF(camera_gone))

/datum/component/pausable_bodycam/Destroy()
	force_pause()
	if(bodycam && !QDELETED(bodycam))
		UnregisterSignal(bodycam, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
		bodycam.bodycam_component = null
		QDEL_NULL(bodycam)
	return ..()

/datum/component/pausable_bodycam/proc/on_watch_start(datum/source)
	prune_sources_watching()
	var/had_live_watchers = has_live_watchers()
	LAZYADD(sources_watching, WEAKREF(source))
	if(had_live_watchers)
		return
	if(!bodycam?.camera_enabled)
		return
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	update_camera()

/datum/component/pausable_bodycam/proc/on_watch_stop(datum/source)
	prune_sources_watching(source)
	if(has_live_watchers())
		return
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	if(bodycam && !QDELETED(bodycam))
		SScameras.remove_camera_from_chunk(bodycam)

/datum/component/pausable_bodycam/proc/prune_sources_watching(datum/source_to_remove)
	if(!LAZYLEN(sources_watching))
		return
	for(var/datum/weakref/weak_source as anything in sources_watching.Copy())
		var/datum/resolved_source = weak_source?.resolve()
		if(!resolved_source || resolved_source == source_to_remove)
			LAZYREMOVE(sources_watching, weak_source)

/datum/component/pausable_bodycam/proc/has_live_watchers()
	for(var/datum/weakref/weak_source as anything in sources_watching)
		if(weak_source?.resolve())
			return TRUE
	return FALSE

/datum/component/pausable_bodycam/proc/update_cam(datum/source, atom/old_loc, ...)
	SIGNAL_HANDLER
	if(get_turf(old_loc) != get_turf(parent))
		do_update_cam(old_loc)

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
	if(!enabled)
		force_pause()

/datum/component/pausable_bodycam/proc/set_broken(broken, camera_on = TRUE)
	if(!bodycam || QDELETED(bodycam))
		return
	bodycam.camera_enabled = !broken && camera_on
	if(broken || !bodycam.camera_enabled)
		force_pause()

/datum/component/pausable_bodycam/proc/notify_watchers_disconnect()
	if(!bodycam || QDELETED(bodycam))
		return
	var/list/to_notify = length(sources_watching) ? sources_watching.Copy() : list()
	for(var/datum/weakref/weak_source as anything in to_notify)
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
	LAZYCLEARLIST(sources_watching)
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	if(bodycam && !QDELETED(bodycam))
		bodycam.clear_watchers()
		SScameras.remove_camera_from_chunk(bodycam)

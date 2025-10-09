#define get_atom_loc(monitor, atom) (monitor.ignore_if_target_not_on_turf ? atom : get_turf(atom))
#define get_host_loc(monitor) (monitor.ignore_if_not_on_turf ? monitor.host : get_turf(monitor.host))

/datum/proximity_monitor/advanced/jukebox
	loc_connections = list(
		COMSIG_ATOM_ABSTRACT_ENTERED = PROC_REF(on_entered),
		COMSIG_ATOM_ABSTRACT_EXITED = PROC_REF(on_uncrossed),
		COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON = PROC_REF(on_initialized),
	)
	var/ignore_if_target_not_on_turf
	var/list/mobs_in_field = list()

/datum/proximity_monitor/advanced/jukebox/New(atom/host, range, ignore_if_not_on_turf = TRUE, _ignore_if_target_not_on_turf = TRUE)
	ignore_if_target_not_on_turf = _ignore_if_target_not_on_turf
	. = ..()
	recalculate_field()

/datum/proximity_monitor/advanced/jukebox/Destroy()
	for(var/mob/mob as anything in mobs_in_field)
		if(mob != host)
			UnregisterSignal(mob, COMSIG_QDELETING)
	return ..()

/datum/proximity_monitor/advanced/jukebox/recalculate_field(full_recalc = FALSE)
	. = ..()
	var/list/old_mobs = mobs_in_field.Copy()
	mobs_in_field.Cut()
	for(var/mob/mob in range(current_range - 1, get_host_loc(src)))
		if(old_mobs.Find(mob))
			mobs_in_field += mob
			SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_MOVED, mob)
		else
			mobs_in_field += mob
			SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_ENTERED, mob)
			if(mob != host)
				RegisterSignal(mob, COMSIG_QDELETING, PROC_REF(on_qdeleting))
	for(var/mob/mob in old_mobs)
		if(!mobs_in_field.Find(mob))
			SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_LEFT, mob)
			if(mob != host)
				UnregisterSignal(mob, COMSIG_QDELETING)

/datum/proximity_monitor/advanced/jukebox/on_uncrossed(turf/source, atom/movable/gone, direction)
	. = ..()
	if(ismob(gone))
		var/mob/mob = gone
		if(mobs_in_field.Find(mob))
			var/atom/gone_loc = get_atom_loc(src, mob)
			var/atom/host_loc = get_host_loc(src)
			if(get_dist(mob, host) >= current_range || gone_loc.z != host_loc.z)
				mobs_in_field -= mob
				SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_LEFT, mob)
				if(mob != host)
					UnregisterSignal(mob, COMSIG_QDELETING)
			else
				SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_MOVED, mob)

/datum/proximity_monitor/advanced/jukebox/on_entered(turf/source, atom/movable/entered)
	. = ..()
	if(ismob(entered))
		var/mob/mob = entered
		if(!mobs_in_field.Find(mob) && get_dist(mob, host) < current_range)
			mobs_in_field += mob
			SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_ENTERED, mob)
			if(mob != host)
				RegisterSignal(mob, COMSIG_QDELETING, PROC_REF(on_qdeleting))

/datum/proximity_monitor/advanced/jukebox/on_initialized(turf/source, atom/movable/created, init_flags)
	. = ..()
	if(ismob(created))
		addtimer(CALLBACK(src, PROC_REF(on_entered), source, created), 1)

/datum/proximity_monitor/advanced/jukebox/proc/on_qdeleting(datum/source)
	SIGNAL_HANDLER
	if(ismob(source))
		if(mobs_in_field.Find(source))
			mobs_in_field -= source
			SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_LEFT, source)
			UnregisterSignal(source, COMSIG_QDELETING)

#undef get_atom_loc
#undef get_host_loc

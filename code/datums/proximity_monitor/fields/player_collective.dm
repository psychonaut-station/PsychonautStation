#define COMSIG_PROXIMITY_MOB_ENTERED "proximity_mob_entered"
#define COMSIG_PROXIMITY_MOB_LEFT "proximity_mob_left"
#define COMSIG_PROXIMITY_MOB_MOVED "proximity_mob_moved"

/datum/proximity_monitor/advanced/player_collector
	loc_connections = list(
		COMSIG_ATOM_ABSTRACT_ENTERED = PROC_REF(on_entered),
		COMSIG_ATOM_ABSTRACT_EXITED = PROC_REF(on_uncrossed),
		COMSIG_ATOM_INITIALIZED_ON = PROC_REF(on_entered),
	)
	var/list/mobs_in_range = list()

/datum/proximity_monitor/advanced/player_collector/New(atom/host, range, ignore_if_not_on_turf)
	. = ..()
	for(var/mob/user in range(range, host))
		if(user.client)
			mobs_in_range += user
			SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_ENTERED, user)
			RegisterSignal(user, COMSIG_QDELETING, PROC_REF(on_qdeleting))

/datum/proximity_monitor/advanced/player_collector/Destroy()
	for(var/mob/user in mobs_in_range)
		UnregisterSignal(user, COMSIG_QDELETING)
	qdel(mobs_in_range)
	return ..()

/datum/proximity_monitor/advanced/player_collector/on_uncrossed(turf/source, atom/movable/gone, direction)
	. = ..()
	if(ismob(gone))
		var/mob/user = gone
		if(mobs_in_range.Find(user))
			if(get_dist(gone, host) >= current_range || gone.z != host.z) // get_dist z levelin farklı olduğunu fark edemiyor
				mobs_in_range -= user
				SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_LEFT, user)
				UnregisterSignal(user, COMSIG_QDELETING)
			else
				SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_MOVED, user)

/datum/proximity_monitor/advanced/player_collector/on_entered(turf/source, atom/movable/entered)
	. = ..()
	if(ismob(entered))
		var/mob/user = entered
		if(user.client && !mobs_in_range.Find(user) && get_dist(user, host) < current_range)
			mobs_in_range += user
			SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_ENTERED, user)
			RegisterSignal(user, COMSIG_QDELETING, PROC_REF(on_qdeleting))

/datum/proximity_monitor/advanced/player_collector/on_moved(atom/movable/movable, atom/old_loc)
	. = ..()
	if(movable == host)
		var/list/old_list = mobs_in_range.Copy()
		mobs_in_range.Cut()
		for(var/mob/user in range(current_range, host))
			if(old_list.Find(user))
				mobs_in_range += user
				SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_MOVED, user)
			else
				if(user.client)
					mobs_in_range += user
					SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_ENTERED, user)
					RegisterSignal(user, COMSIG_QDELETING, PROC_REF(on_qdeleting))
		for(var/mob/user in old_list)
			if(!mobs_in_range.Find(user))
				SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_LEFT, user)
				UnregisterSignal(user, COMSIG_QDELETING)
		qdel(old_list)

/datum/proximity_monitor/advanced/player_collector/proc/on_qdeleting(mob/user)
	if(ismob(user))
		if(mobs_in_range.Find(user))
			mobs_in_range -= user
			SEND_SIGNAL(host, COMSIG_PROXIMITY_MOB_LEFT, user)
			UnregisterSignal(user, COMSIG_QDELETING)

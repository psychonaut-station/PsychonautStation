// status effect eklencek

/datum/component/radio_sound_player
	dupe_mode = COMPONENT_DUPE_ALLOWED

	var/datum/proximity_monitor/advanced/mob_collector/proximity_monitor
	var/list/listeners

	var/freq
	var/range

	var/distance_multiplier = 1

/datum/component/radio_sound_player/Initialize(_range = 8, _frequency, ...)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	if(!isnum(_range) || _range < 1)
		return COMPONENT_INCOMPATIBLE

	proximity_monitor = new (parent, _range, FALSE, FALSE)

	range = _range

	freq = _frequency

	RegisterSignal(parent, COMSIG_PROXIMITY_MOB_ENTERED, PROC_REF(on_mob_entered))
	RegisterSignal(parent, COMSIG_PROXIMITY_MOB_LEFT, PROC_REF(on_mob_left))
	RegisterSignal(parent, COMSIG_PROXIMITY_MOB_MOVED, PROC_REF(on_mob_moved))

	if(ismovable(parent))
		RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_parent_moved))

	SSradio_stations.add_player(src)

/datum/component/radio_sound_player/Destroy(force, silent)
	SSradio_stations.remove_player(src)
	QDEL_NULL(proximity_monitor)
	UnregisterSignal(parent, list(COMSIG_PROXIMITY_MOB_ENTERED, COMSIG_PROXIMITY_MOB_LEFT, COMSIG_PROXIMITY_MOB_MOVED, COMSIG_MOVABLE_MOVED))
	return ..()

/datum/component/radio_sound_player/proc/get_volume(atom/listener, pressure_affected = TRUE, falloff_exponent = 3, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE)
	var/turf/player_turf = get_turf(parent)
	var/turf/listener_turf = get_turf(listener)
	var/volume = 100
	var/distance = get_dist(player_turf, listener_turf) * distance_multiplier

	volume -= CALCULATE_SOUND_VOLUME(100, distance, range, falloff_distance, falloff_exponent)

	if(pressure_affected && !isnull(listener_turf) && !isnull(player_turf))
		var/pressure_factor = 1
		var/datum/gas_mixture/hearer_env = listener_turf.return_air()
		var/datum/gas_mixture/source_env = player_turf.return_air()

		if(hearer_env && source_env)
			var/pressure = min(hearer_env.return_pressure(), source_env.return_pressure())
			if(pressure < ONE_ATMOSPHERE)
				pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
		else //space
			pressure_factor = 0

		if(distance <= 1)
			pressure_factor = max(pressure_factor, 0.15) //touching the source of the sound

		volume *= pressure_factor

	return volume

/datum/component/radio_sound_player/proc/on_mob_entered(datum/source, mob/mob)
	SIGNAL_HANDLER
	RegisterSignal(mob, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(on_mob_login))
	if(isnull(mob.client))
		return FALSE
	var/volume = get_volume(mob) ** 2
	LAZYSET(listeners, mob, volume)
	SSradio_stations.add_listener(mob, freq, WEAKREF(src), volume)

/datum/component/radio_sound_player/proc/on_mob_left(datum/source, mob/mob)
	SIGNAL_HANDLER
	UnregisterSignal(mob, COMSIG_MOB_CLIENT_LOGIN)
	if(isnull(mob.client))
		return FALSE
	var/old_volume = LAZYACCESS(listeners, mob)
	SSradio_stations.remove_listener(mob, freq, WEAKREF(src), old_volume)
	if(LAZYFIND(listeners, mob))
		LAZYREMOVE(listeners, mob)

/datum/component/radio_sound_player/proc/on_mob_moved(datum/source, mob/mob)
	SIGNAL_HANDLER
	if(isnull(mob.client))
		return FALSE
	var/old_volume = LAZYACCESS(listeners, mob)
	var/volume = get_volume(mob) ** 2
	LAZYSET(listeners, mob, volume)
	SSradio_stations.update_listener(mob, freq, WEAKREF(src), old_volume, volume)

/datum/component/radio_sound_player/proc/on_mob_login(mob/source, client/client)
	SIGNAL_HANDLER
	var/volume = get_volume(source) ** 2
	LAZYSET(listeners, source, volume)
	SSradio_stations.add_listener(source, freq, WEAKREF(src), volume)

/datum/component/radio_sound_player/proc/on_parent_moved(datum/source, old_loc, movement_dir, forced, old_locs, momentum_change)
	SIGNAL_HANDLER
	proximity_monitor.recalculate_field()

/datum/component/radio_sound_player/proc/set_frequency(old_frequency, frequency)
	SSradio_stations.tune_out_radio(player, old_freq)
	SSradio_stations.tune_in_radio(player, freq)
	freq = frequency

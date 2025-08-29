
// Time Anomaly - stops time in an area, similar to the timestop spell
/obj/effect/anomaly/time
	name = "time anomaly"
	icon_state = "time"
	density = FALSE
	anomaly_core = /obj/item/assembly/signaler/anomaly/time
	var/timestop_range = 2
	var/timestop_duration = 140
	var/list/timestop_immune = list()
	var/timestop_active = FALSE
	var/obj/effect/timestop/time_effect = null
	var/last_timestop = 0
	var/timestop_interval = 300 // 30 seconds (in ticks)

/obj/effect/anomaly/time/Initialize(mapload, new_lifespan)
	. = ..(mapload, new_lifespan)
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)
	apply_wibbly_filters(src)
	time_effect = null
	last_timestop = 0

/obj/effect/anomaly/time/anomalyEffect(seconds_per_tick)
	. = ..(seconds_per_tick)
	if(world.time - last_timestop >= timestop_interval || last_timestop == 0)
		last_timestop = world.time
		spawn() src.trigger_timestop()

/obj/effect/anomaly/time/proc/trigger_timestop()
	if(time_effect && !QDELETED(time_effect))
		return // Already active
	var/list/immune = list()
	for(var/mob/living/M in range(timestop_range, src))
		if(HAS_TRAIT(M, TRAIT_TIME_ANOMALY_IMMUNE))
			immune[M] = TRUE
	time_effect = new /obj/effect/timestop(get_turf(src), timestop_range, timestop_duration, immune, TRUE, TRUE)
	playsound(src, 'sound/effects/magic/timeparadox2.ogg', vol = 50)
	timestop_active = TRUE

/obj/effect/anomaly/time/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(ismob(AM) && !HAS_TRAIT(AM, TRAIT_TIME_ANOMALY_IMMUNE))
		var/mob/living/M = AM
		if(istype(M))
			M.Stun(20, ignore_canstun = TRUE)

/obj/effect/anomaly/time/Bump(atom/A)
	if(ismob(A) && !HAS_TRAIT(A, TRAIT_TIME_ANOMALY_IMMUNE))
		var/mob/living/M = A
		if(istype(M))
			M.Stun(20, ignore_canstun = TRUE)

/obj/effect/anomaly/time/Bumped(atom/movable/AM)
	if(ismob(AM) && !HAS_TRAIT(AM, TRAIT_TIME_ANOMALY_IMMUNE))
		var/mob/living/M = AM
		if(istype(M))
			M.Stun(20, ignore_canstun = TRUE)

/obj/effect/anomaly/time/detonate()
	if(time_effect && !QDELETED(time_effect))
		qdel(time_effect)
	time_effect = null
	timestop_active = FALSE
	playsound(src, 'sound/effects/magic/timeparadox2.ogg', 75, TRUE, frequency = -1) //reverse!
	new /obj/effect/temp_visual/circle_wave/gravity(get_turf(src))

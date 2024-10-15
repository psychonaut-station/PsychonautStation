/obj/effect/random_engine
	name = "random engine spawner"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "random_room"
	dir = NORTH
	var/room_width = 0
	var/room_height = 0

/obj/effect/spawner/deleter
	name = "All In One Deleter"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x"
	var/turf_type = null

/obj/effect/spawner/deleter/New(loc, ...)
	. = ..()
	var/turf/T = loc
	var/proc_flags = CHANGETURF_IGNORE_AIR
	T.empty(turf_type, flags = proc_flags)
	return

/obj/effect/spawner/deleter/space
	icon_state = "x2"
	turf_type = /turf/open/space

/obj/effect/spawner/deleter/iron_floor
	icon_state = "generic_event"
	turf_type = /turf/open/floor/iron

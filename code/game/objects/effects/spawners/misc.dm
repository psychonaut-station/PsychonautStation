/obj/effect/random_room
	name = "random room spawner"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "lift_id"
	dir = NORTH
	var/room_width = 0
	var/room_height = 0

/obj/effect/spawner/deleter
	name = "All In One Deleter"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x"
	var/list/ignore_list = list()

/obj/effect/spawner/deleter/New(loc, ...)
	. = ..()
	var/turf/T = loc
	for(var/atom/thing in T)
		if(is_type_in_list(thing, ignore_list))
			continue
		if(ismachinery(thing))
			SSgarbage.atoms_to_del += thing
		else
			qdel(thing, force=TRUE)
	return

/obj/effect/spawner/deleter/apc
	icon = 'icons/psychonaut/effects/landmarks_static.dmi'
	icon_state = "xapc"
	ignore_list = list(/obj/machinery/power/apc, /obj/effect/mapping_helpers/apc)

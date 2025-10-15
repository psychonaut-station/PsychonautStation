/obj/effect/landmark/random_room
	name = "random room spawner"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "lift_id"
	dir = NORTH
	var/room_width = 0
	var/room_height = 0

/obj/effect/landmark/keep
	name = "keep atom"
	icon = 'modular_psychonaut/master_files/icons/effects/landmarks_static.dmi'
	icon_state = "x"
	var/keep_type = null

/obj/effect/landmark/keep/apc
	name = "keep apc"
	icon_state = "xapc"
	keep_type = /obj/machinery/power/apc

/obj/effect/landmark/keep/duct
	name = "keep duct"
	icon_state = "xduct"
	keep_type = /obj/machinery/duct

/obj/effect/landmark/keep/plumbing
	name = "keep plumbing"
	icon_state = "xplumbing"
	keep_type = /obj/machinery/plumbing

/obj/effect/landmark/keep/lightning
	name = "keep lightning"
	icon_state = "xlight"
	keep_type = /obj/machinery/light

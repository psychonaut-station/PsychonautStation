/obj/effect/abstract/name_tag
	name = ""
	icon = null // we want nothing
	alpha = 180
	plane = PLANE_NAME_TAGS
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	maptext_y = -13 //directly below characters
	appearance_flags = PIXEL_SCALE | RESET_COLOR | RESET_TRANSFORM

/obj/effect/abstract/name_tag/Initialize(mapload)
	. = ..()
	if(!ismovable(loc) || QDELING(loc))
		return INITIALIZE_HINT_QDEL
	var/atom/movable/movable_loc = loc
	movable_loc.vis_contents += src
	var/bound_width = movable_loc.bound_width || world.icon_size
	maptext_width = NAME_TAG_WIDTH
	maptext_height = world.icon_size * 1.5
	maptext_x = ((NAME_TAG_WIDTH - bound_width) * -0.5) - loc.base_pixel_x
	maptext_y = src::maptext_y - loc.base_pixel_y
	RegisterSignal(loc, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(update_z))

/obj/effect/abstract/name_tag/Destroy(force)
	if(ismovable(loc))
		var/atom/movable/movable_loc = loc
		movable_loc.vis_contents -= src
	UnregisterSignal(loc, COMSIG_MOVABLE_Z_CHANGED)
	return ..()

/obj/effect/abstract/name_tag/forceMove(atom/destination, no_tp = FALSE, harderforce = FALSE)
	if(harderforce)
		return ..()

/obj/effect/abstract/name_tag/proc/hide()
	alpha = 0

/obj/effect/abstract/name_tag/proc/show()
	alpha = 255

/obj/effect/abstract/name_tag/proc/set_name(incoming_name)
	maptext = MAPTEXT_GRAND9K("<span style='text-align: center'>[incoming_name]</span>")

/obj/effect/abstract/name_tag/proc/update_z(datum/source, turf/old_turf, turf/new_turf, same_z_layer)
	SET_PLANE(src, PLANE_TO_TRUE(src.plane), new_turf)

/obj/effect/abstract/name_tag
	name = ""
	icon = null
	alpha = 180
	plane = PLANE_NAME_TAGS
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	maptext_y = -13 //directly below characters
	appearance_flags = PIXEL_SCALE | RESET_COLOR | RESET_TRANSFORM
	var/list/hiding_references = list()

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
	RegisterSignal(movable_loc, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(update_z))

/obj/effect/abstract/name_tag/Destroy(force)
	if(QDELETED(loc))
		return ..()
	if(ismovable(loc))
		var/atom/movable/movable_loc = loc
		movable_loc.vis_contents -= src
	UnregisterSignal(loc, COMSIG_MOVABLE_Z_CHANGED)
	return ..()

/obj/effect/abstract/name_tag/forceMove(atom/destination, no_tp = FALSE, harderforce = FALSE)
	if(harderforce)
		return ..()

/obj/effect/abstract/name_tag/proc/refresh()
	check_references()
	if(hiding_references.len)
		hide()
	else
		show()

/obj/effect/abstract/name_tag/proc/hide()
	check_references()
	if(hiding_references.len)
		alpha = 0

/obj/effect/abstract/name_tag/proc/show()
	check_references()
	if(!hiding_references.len)
		alpha = 255

/obj/effect/abstract/name_tag/proc/check_references()
	for(var/datum/weakref/weakref in hiding_references)
		var/datum/datum = weakref.resolve()
		if(isnull(datum))
			hiding_references -= weakref

/obj/effect/abstract/name_tag/proc/set_name(incoming_name)
	maptext = MAPTEXT_GRAND9K("<span style='text-align: center'>[incoming_name]</span>")

/obj/effect/abstract/name_tag/proc/update_z(datum/source, turf/old_turf, turf/new_turf, same_z_layer)
	SET_PLANE(src, PLANE_TO_TRUE(src.plane), new_turf)

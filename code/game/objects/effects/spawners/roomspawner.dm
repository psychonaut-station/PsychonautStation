/obj/effect/spawner/random_engines
	name = "random room spawner"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "random_room"
	dir = NORTH
	var/room_width = 0
	var/room_height = 0

/obj/effect/spawner/random_engines/New(loc, ...)
	. = ..()
	if(!isnull(SSmapping.random_engine_spawners))
		SSmapping.random_engine_spawners += src

/obj/effect/spawner/random_engines/LateInitialize()
	. = ..()
	if(!length(SSmapping.random_engine_templates))
		message_admins("Room spawner created with no templates available. This shouldn't happen.")
		return INITIALIZE_HINT_QDEL

	var/list/possible_engine_templates = list()
	var/datum/map_template/random_room/random_engines/engine_candidate
	shuffle_inplace(SSmapping.random_engine_templates)
	for(var/ID in SSmapping.random_engine_templates)
		engine_candidate = SSmapping.random_engine_templates[ID]
		if(engine_candidate.weight == 0 || room_height != engine_candidate.template_height || room_width != engine_candidate.template_width)
			engine_candidate = null
			continue
		possible_engine_templates[engine_candidate] = engine_candidate.weight
	if(possible_engine_templates.len)
		var/datum/map_template/random_room/random_engines/template = pick_weight(possible_engine_templates)
		template.load(get_turf(src), centered = template.centerspawner)
	return INITIALIZE_HINT_QDEL

/// MetaStation Engine Area Spawner
/obj/effect/spawner/random_engines/meta
	name = "meta engine spawner"
	room_width = 33
	room_height = 25

/obj/effect/spawner/deleter
	name = "All In One Deleter"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x"

/obj/effect/spawner/deleter/New(loc, ...)
	. = ..()
	var/turf/T = get_turf(src)
	for(var/i as anything in T.contents)
		world.log << i
		qdel(i)
	qdel(T)
	qdel(src)

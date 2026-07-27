/datum/teammatch_scenerio
	/// Scenerio Name
	var/name
	/// Scenerio Description
	var/desc = ""

	var/scenerio_key

	var/list/maps = list()

	var/list/map_templates = list()

	var/has_minimap = TRUE
	var/minimap_table_type = /obj/machinery/minimap_table/small

	var/list/teams = list()
	var/is_singular = FALSE

/datum/teammatch_scenerio/New()
	. = ..()

	for (var/datum/lazy_template/teammatch/template as anything in map_templates)
		var/map_name = initial(template.name)
		maps += map_name
	maps = sort_list(maps)

/datum/teammatch_scenerio/proc/post_start(datum/teammatch_lobby/lobby, datum/lazy_template/teammatch/source, list/atoms)
	return

/datum/teammatch_scenerio/proc/process_atoms(datum/teammatch_lobby/lobby, datum/lazy_template/teammatch/source, list/atoms)
	return

/datum/teammatch_scenerio/proc/player_spawned(datum/teammatch_lobby/lobby, mob/living/L, datum/outfit/teammatch_loadout/loadout, datum/teammatch_team/team)
	SHOULD_CALL_PARENT(TRUE)

	var/obj/item/implant/tacmap/tacmap_implant = locate() in L.implants
	if(has_minimap && tacmap_implant)
		tacmap_implant.minimap_map_id = "[lobby.uid]"
		tacmap_implant.minimap_team_id = "[team.id]"
		tacmap_implant.minimap_fixed_z_level = L.z
		tacmap_implant.update_minimap_icon(L)

/datum/teammatch_scenerio/xenomarine
	name = "Xenomorph vs Marine"
	desc = "Xenomorph versus Marine Corps"
	scenerio_key = "xm"
	map_templates = list(
		/datum/lazy_template/teammatch/lv624_1,
	)

	teams = list(
		/datum/teammatch_team/marines,
		/datum/teammatch_team/xenomorphs
	)

	minimap_table_type = /obj/machinery/minimap_table/small/marines
	is_singular = TRUE
	var/list/poddoors = list()

/datum/teammatch_scenerio/xenomarine/Destroy(force)
	. = ..()
	poddoors = null

/datum/teammatch_scenerio/xenomarine/post_start(datum/teammatch_lobby/lobby)
	addtimer(CALLBACK(src, PROC_REF(open_doors), lobby), 3 MINUTES)

/datum/teammatch_scenerio/xenomarine/process_atoms(datum/teammatch_lobby/lobby, datum/lazy_template/teammatch/source, list/atoms)
	var/list/nukedisk_generators = list(
		/obj/machinery/computer/nukedisk_generator/red,
		/obj/machinery/computer/nukedisk_generator/green,
		/obj/machinery/computer/nukedisk_generator/blue,
	)

	var/list/nuclear_locations = list()
	for(var/atom/thing in atoms)
		if(istype(thing, /obj/effect/landmark/nuke_disk_candidate))
			var/turf/T = get_turf(thing)
			var/obj/machinery/computer/nukedisk_generator/picked = pick_n_take(nukedisk_generators)
			var/obj/computer = new picked(T, lobby.uid)
			computer.setDir(thing.dir)
			qdel(thing)
		if(istype(thing, /obj/machinery/door/poddoor))
			poddoors += thing
		if(istype(thing, /obj/effect/landmark/nuke_bomb_spawner))
			nuclear_locations |= get_turf(thing)
			qdel(thing)
		CHECK_TICK

	var/turf/nuclear_turf = pick(nuclear_locations)
	if(nuclear_turf)
		var/obj/machinery/nuclearbomb/three_disked/teammatch/nuclearbomb = new (nuclear_turf)
		nuclearbomb.lobby = lobby
		nuclearbomb.armer_team = /datum/teammatch_team/marines::name
		nuclearbomb.minimap_id = lobby.uid
		remove_minimap_blip(MINIMAP_BOMB_BLIP, nuclearbomb)
		nuclearbomb.update_minimap_blip()

/datum/teammatch_scenerio/xenomarine/player_spawned(datum/teammatch_lobby/lobby, mob/living/carbon/C)
	. = ..()
	var/obj/item/organ/alien/hivenode/hivenode = C.get_organ_by_type(/obj/item/organ/alien/hivenode)
	if(!isnull(hivenode))
		hivenode.hive_id = "[scenerio_key]_hive_[lobby.uid]"

/datum/teammatch_scenerio/xenomarine/proc/open_doors(datum/teammatch_lobby/lobby)
	for(var/i in 1 to length(poddoors))
		var/obj/machinery/door/poddoor/door = poddoors[i]
		INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/machinery/door/poddoor, open))
	poddoors = null

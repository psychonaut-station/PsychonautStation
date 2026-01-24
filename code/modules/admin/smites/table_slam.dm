//Slams the target across every table on CentCom
/datum/smite/table_slam
	name = "Table Slam"

/datum/smite/table_slam/effect(client/user, mob/living/target)
	. = ..()

	var/list/tables_to_slam = list()

	//Check centcom for tables
	for(var/area/centcom/area in GLOB.areas)
		for(var/turf/turf as anything in area.get_turfs_by_zlevel(1))
			var/obj/structure/table/table = locate() in turf
			if(!isnull(table))
				tables_to_slam += table
			CHECK_TICK

	if(!tables_to_slam.len)
		to_chat(user, "No tables found to slam the target on!", confidential = TRUE)
		return

	for(var/obj/structure/table/Table as anything in tables_to_slam)
		if (!target || QDELETED(target))
			break
		if(QDELETED(Table))
			continue

		target.forceMove(Table.loc)
		target.set_resting(TRUE)

		//Had trouble calling the tablepush() proc directly, so we are replicating its effects here. This has the advantage of not breaking glass tables in the process.
		target.Knockdown(3 SECONDS)
		target.apply_damage(10, BRUTE)
		target.apply_damage(40, STAMINA)
		playsound(target, 'sound/effects/tableslam.ogg', 90, TRUE)
		sleep(0.1 SECONDS)

	to_chat(target, span_userdanger("You have been slammed across every table on CentCom! Nanotrasen wishes you a pleasent day."), confidential = TRUE)

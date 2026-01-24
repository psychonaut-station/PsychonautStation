//Slams the target across every table on CentCom
/datum/smite/table_slam
    name = "Table Slam"

/datum/smite/table_slam/effect(client/user, mob/living/target)
    . = ..()

    var/list/tables_to_slam = list()

	// Get all areas and iterate through their z-level turfs
    for(var/area/area as anything in GLOB.areas)
        for(var/list/zlevel_turfs as anything in area.get_zlevel_turf_lists())
            var/turf/first_turf = zlevel_turfs[1]
            if(first_turf.z != 1)
                continue

            for(var/turf/area_turf as anything in zlevel_turfs)
                for(var/obj/structure/table/T as anything in area_turf)
                    tables_to_slam += T
            CHECK_TICK

    if(!tables_to_slam.len)
        to_chat(user, "No tables found to slam the target on!", confidential = TRUE)
        return

    for(var/obj/structure/table/T in tables_to_slam)
        if (!target || QDELETED(target))
            break
        if(QDELETED(T))
            continue
        target.forceMove(T.loc)
        target.set_resting(TRUE)

		//Had trouble calling the tablepush() proc directly, so we are replicating its effects here. This has the advantage of not breaking glass tables in the process.
        target.Knockdown(3 SECONDS)
        target.apply_damage(10, BRUTE)
        target.apply_damage(40, STAMINA)
        playsound(target, 'sound/effects/tableslam.ogg', 90, TRUE)
        sleep(1)
    to_chat(target, span_userdanger("You have been slammed across every table on CentCom! Nanotrasen wishes you a pleasent day."), confidential = TRUE)

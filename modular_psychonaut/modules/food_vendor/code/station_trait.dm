/// Changes all the snack vendor to food vendor
/datum/station_trait/foodvend
	name = "Food Vendors"
	report_message = "While the station was under construction, we realized that we had no snack vendors left, so we placed the food vendors we had instead."
	trait_type = STATION_TRAIT_POSITIVE
	weight = 1
	show_in_report = TRUE

/datum/station_trait/foodvend/New()
	. = ..()
	RegisterSignal(SSatoms, COMSIG_SUBSYSTEM_POST_INITIALIZE, PROC_REF(replace_vendors))

/datum/station_trait/foodvend/proc/replace_vendors()
	SIGNAL_HANDLER

	for(var/obj/machinery/vending/snack/vendor as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/vending/snack))
		var/turf/T = get_turf(vendor)
		new /obj/machinery/vending/meal(T)
		qdel(vendor)

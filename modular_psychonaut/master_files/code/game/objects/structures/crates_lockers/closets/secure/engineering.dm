/obj/structure/closet/secure_closet/engineering_chief/PopulateContents()
	..()
	if(SSmapping.picked_rooms["engine"])
		var/datum/map_template/modular_room/random_engine/engine_template = SSmapping.picked_rooms["engine"]
		if(engine_template.engine_type == "singularity")
			new /obj/item/storage/toolbox/guncase/anomaly_catcher(src)

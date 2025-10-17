/obj/item/storage/toolbox/guncase/anomaly_catcher
	name = "anti singularity case"
	desc = "A weapon's case. Has a singularity amblem on the cover."
	icon = 'modular_psychonaut/master_files/icons/obj/storage/case.dmi'
	icon_state = "antisingularity_case"
	weapon_to_spawn = /obj/item/gun/ballistic/rocketlauncher/anomaly_catcher
	extra_to_spawn = /obj/item/ammo_casing/rocket/anomaly_catcher
	storage_type = /datum/storage/toolbox/guncase/anomalycatcher

/obj/item/storage/toolbox/guncase/anomaly_catcher/PopulateContents()
	new weapon_to_spawn(src)
	for(var/i in 1 to 2)
		new extra_to_spawn(src)
	new /obj/item/gun/energy/kinesis(src)

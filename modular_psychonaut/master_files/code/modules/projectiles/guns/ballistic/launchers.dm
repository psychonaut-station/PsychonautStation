/obj/item/gun/ballistic/rocketlauncher/anomaly_catcher
	name = "\improper IE-AC200 Rocket Launcher"
	desc = "A reusable rocket propelled anomaly catcher grenade launcher. An arrow pointing toward the front of the launcher \
		alongside the words \"Front Toward Anomaly \" are printed on the tube."
	icon = 'modular_psychonaut/master_files/icons/obj/weapons/guns/wide_guns.dmi'
	pin = /obj/item/firing_pin
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/rocketlauncher/anomaly_catcher
	cartridge_wording = "rocket"
	backblast = FALSE
	fire_in = 3 SECONDS

/obj/item/gun/ballistic/rocketlauncher/anomaly_catcher/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	obj_flags |= EMAGGED
	backblast = TRUE
	AddElement(/datum/element/backblast)
	balloon_alert(user, "backblast enabled")
	return TRUE

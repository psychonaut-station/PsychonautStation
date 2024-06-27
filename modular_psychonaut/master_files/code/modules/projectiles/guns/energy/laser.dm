/obj/item/gun/energy/laser/captain
	obj_flags = parent_type::obj_flags | UNIQUE_RENAME
	icon = 'modular_psychonaut/modules/antique_gun/icons/antique.dmi'
	lefthand_file = 'modular_psychonaut/modules/antique_gun/icons/antique_lefthand.dmi'
	righthand_file = 'modular_psychonaut/modules/antique_gun/icons/antique_righthand.dmi'
	unique_reskin = list(
		"Default" = "caplaser",
		"Supas 12" = "cap_moislaser",
		"KAFA 1500" = "cap_laserpistol",
		"Cadwell Pax" = "cap_smolaser",
		"Hot Iron" = "cap_laserrev",
	)

/obj/item/gun/energy/laser/captain/reskin_obj(mob/M)
	. = ..()
	if(icon_state != "caplaser")
		update_appearance()

/obj/item/gun/energy/laser/captain/scattershot
	obj_flags = parent_type::obj_flags ^ UNIQUE_RENAME
	icon = /obj/item/gun/energy/laser::icon
	lefthand_file = /obj/item/gun/energy/laser::lefthand_file
	righthand_file = /obj/item/gun/energy/laser::righthand_file
	unique_reskin = null

/obj/item/gun/energy/laser/captain
	name = "\improper antique laser gun"
	icon = 'modular_psychonaut/master_files/icons/obj/weapons/guns/energy.dmi'
	lefthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/weapons/guns_righthand.dmi'
	inhand_icon_state = "caplaser"
	obj_flags = UNIQUE_RENAME
	unique_reskin = list(
		"Default" = "caplaser",
		"Supas_12" = "cap_moislaser",
		"KAFA_1500" = "cap_laserpistol",
		"Cadwell_Pax" = "cap_smolaser",
		"Hot_Iron" = "cap_laserrev",
	)

/obj/item/gun/energy/laser/captain/reskin_obj(mob/M)
	. = ..()
	update_appearance()
	if(icon_state == "caplaser")
		return
	inhand_icon_state = icon_state

/obj/item/gun/energy/laser/captain/scattershot
	icon = 'icons/obj/weapons/guns/energy.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'

	unique_reskin = null

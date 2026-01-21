/obj/item/gun/energy/laser/captain
	name = "\improper antique laser gun"
	obj_flags = UNIQUE_RENAME

/obj/item/gun/energy/laser/captain/Initialize(mapload)
	. = ..()
	if(src.type == /obj/item/gun/energy/laser/captain)
		AddComponent(/datum/component/reskinable_item, /datum/atom_skin/captain_laser, infinite = FALSE)

/datum/atom_skin/captain_laser
	abstract_type = /datum/atom_skin/captain_laser
	change_inhand_icon_state = TRUE

/datum/atom_skin/captain_laser/default
	preview_name = "Default"
	new_icon_state = "caplaser"

/datum/atom_skin/captain_laser/supas_12
	preview_name = "Supas 12"
	new_icon = 'modular_psychonaut/master_files/icons/obj/weapons/guns/energy.dmi'
	new_lefthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/weapons/guns_lefthand.dmi'
	new_righthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/weapons/guns_righthand.dmi'
	new_icon_state = "cap_moislaser"

/datum/atom_skin/captain_laser/kafa_1500
	preview_name = "KAFA 1500"
	new_icon = 'modular_psychonaut/master_files/icons/obj/weapons/guns/energy.dmi'
	new_lefthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/weapons/guns_lefthand.dmi'
	new_righthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/weapons/guns_righthand.dmi'
	new_icon_state = "cap_laserpistol"

/datum/atom_skin/captain_laser/cadwell_pax
	preview_name = "Cadwell Pax"
	new_icon = 'modular_psychonaut/master_files/icons/obj/weapons/guns/energy.dmi'
	new_lefthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/weapons/guns_lefthand.dmi'
	new_righthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/weapons/guns_righthand.dmi'
	new_icon_state = "cap_smolaser"

/datum/atom_skin/captain_laser/hot_iron
	preview_name = "Hot Iron"
	new_icon = 'modular_psychonaut/master_files/icons/obj/weapons/guns/energy.dmi'
	new_lefthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/weapons/guns_lefthand.dmi'
	new_righthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/weapons/guns_righthand.dmi'
	new_icon_state = "cap_laserrev"

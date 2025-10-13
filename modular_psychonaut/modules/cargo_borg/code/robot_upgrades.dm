
/obj/item/borg/upgrade/uclamp
	name = "cargo cyborg clamp upgrade"
	desc = "A upgraded hydraulic clamp replacement for the cargo model's standard clamp."
	icon = 'modular_psychonaut/master_files/icons/obj/devices/circuitry_n_data.dmi'
	icon_state = "cyborg_upgrade5"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/cargo)
	model_flags = BORG_MODEL_CARGO
	var/one_time_use = FALSE

/obj/item/borg/upgrade/uclamp/action(mob/living/silicon/robot/R)
	. = ..()
	if(.)
		for(var/obj/item/borg/cyborg_clamp/C in R.model)
			if(length(C.upgrades) == 3)
				R.balloon_alert_to_viewers("there is no room for it!")
				return FALSE
			if(is_type_in_list(src, C.upgrades) && one_time_use)
				R.balloon_alert_to_viewers("already installed!")
				return FALSE
			C.upgrades += src
			C.icon_state = "uclamp"

/obj/item/borg/upgrade/uclamp/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/borg/cyborg_clamp/C in R.model)
			C.upgrades -= src
			if(!length(C.upgrades))
				C.icon_state = "clamp"

/obj/item/borg/upgrade/uclamp/cap
	name = "clamp capacity upgrade"
	desc = "A upgrade for increase clamp's capacity."

/obj/item/borg/upgrade/uclamp/cap/action(mob/living/silicon/robot/R)
	. = ..()
	if(.)
		for(var/obj/item/borg/cyborg_clamp/C in R.model)
			C.max_capacity += 2

/obj/item/borg/upgrade/uclamp/cap/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/borg/cyborg_clamp/C in R.model)
			C.max_capacity -= 2

/obj/item/borg/upgrade/uclamp/charge
	name = "clamp charge upgrade"
	desc = "A upgrade for decrease clamp's use charge."

/obj/item/borg/upgrade/uclamp/charge/action(mob/living/silicon/robot/R)
	. = ..()
	if(.)
		for(var/obj/item/borg/cyborg_clamp/C in R.model)
			C.cell_usage /= 2

/obj/item/borg/upgrade/uclamp/charge/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/borg/cyborg_clamp/C in R.model)
			C.cell_usage *= 2

/obj/item/borg/upgrade/uclamp/time
	name = "clamp time upgrade"
	desc = "A upgrade for decrease clamp's use time."

/obj/item/borg/upgrade/uclamp/time/action(mob/living/silicon/robot/R)
	. = ..()
	if(.)
		for(var/obj/item/borg/cyborg_clamp/C in R.model)
			C.load_time /= 1.5

/obj/item/borg/upgrade/uclamp/time/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/borg/cyborg_clamp/C in R.model)
			C.load_time *= 1.5

/obj/item/borg/upgrade/uclamp/carry //unique bi isim bulamadıms
	name = "clamp carry upgrade"
	desc = "A upgrade for increase what that clamp can carry."
	one_time_use = TRUE

/obj/item/borg/upgrade/uclamp/carry/action(mob/living/silicon/robot/R)
	. = ..()
	if(.)
		for(var/obj/item/borg/cyborg_clamp/C in R.model)
			C.can_carry = list(/obj/structure/closet/crate, /obj/item/delivery/big, /obj/structure/closet,  /obj/structure/reagent_dispensers)

/obj/item/borg/upgrade/uclamp/carry/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/borg/cyborg_clamp/C in R.model)
			C.can_carry = initial(C.can_carry)

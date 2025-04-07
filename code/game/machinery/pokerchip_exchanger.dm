/obj/machinery/pokerchip_exchanger
	name = "poker chip exchanger"
	desc = "A machine used to exchange poker chips and holochips."
	icon = 'icons/obj/gambling.dmi'
	icon_state = "exchanger"
	density = TRUE
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.5
	circuit = /obj/item/circuitboard/machine/pokerchip_exchanger
	layer = BELOW_OBJ_LAYER
	anchored_tabletop_offset = 1
	pass_flags = PASSTABLE

/obj/machinery/pokerchip_exchanger/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/machinery/pokerchip_exchanger/on_set_is_operational(old_value)
	. = ..()
	update_icon_state()

/obj/machinery/pokerchip_exchanger/update_icon_state()
	icon_state = "[initial(icon_state)][panel_open ? "_t" : null][!is_operational ? "-off" : null]"
	return ..()

/obj/machinery/pokerchip_exchanger/attackby(obj/item/weapon, mob/living/user, params)
	if(default_deconstruction_crowbar(weapon))
		return TRUE

	if(default_deconstruction_screwdriver(user, "[initial(icon_state)]_t", initial(icon_state), weapon))
		update_icon_state()
		return TRUE

	if(default_unfasten_wrench(user, weapon))
		return TRUE

	if(user.combat_mode)
		return ..()

	if(!is_operational)
		return FALSE

	if(panel_open)
		balloon_alert(user, "close the panel first!")
		return FALSE

	if(istype(weapon, /obj/item/holochip))
		var/obj/item/holochip/holochip = weapon
		var/obj/item/pokerchip/pokerchip = new(src)
		if(pokerchip.spread_chips_len(holochip.credits) < pokerchip.max_overlays)
			pokerchip.credits = holochip.credits
			pokerchip.update_appearance()
			pokerchip.forceMove(drop_location())
			user.visible_message(\
				span_notice("[user] exchanges [holochip] to [pokerchip]."),\
				span_notice("You exchange [holochip] to [pokerchip]."))
			playsound(src, 'sound/effects/cashregister.ogg', 40, TRUE)
			qdel(holochip)
		else
			to_chat(user, span_warning("You cannot exchange that much holochip to poker chips."))
			playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 50, TRUE)
			qdel(pokerchip)
		return TRUE

	if(istype(weapon, /obj/item/pokerchip))
		var/obj/item/pokerchip/pokerchip = weapon
		var/obj/item/holochip/holochip = new(drop_location(), pokerchip.credits)
		user.visible_message(\
			span_notice("[user] exchanges [pokerchip] to [holochip]."),\
			span_notice("You exchange [pokerchip] to [holochip]."))
		playsound(src, 'sound/effects/cashregister.ogg', 40, TRUE)
		qdel(pokerchip)
		return TRUE

	return ..()

/obj/machinery/status_display/ai_core
	name = "\improper AI core display"
	desc = "A large display that mirrors the decentralized AI's selected core avatar."
	icon = 'icons/mob/ai.dmi'
	icon_state = "ai-empty"
	current_mode = SD_PICTURE
	circuit = /obj/item/circuitboard/machine/ai_core_display
	density = TRUE

/obj/machinery/status_display/ai_core/Initialize(mapload)
	. = ..()
	refresh_from_network_ai()

/obj/machinery/status_display/ai_core/attack_ai(mob/living/silicon/ai/user)
	if(isAI(user))
		user.pick_icon()

/obj/machinery/status_display/ai_core/process()
	if(machine_stat & NOPOWER)
		set_picture(initial(icon_state), initial(icon))
		return PROCESS_KILL

	refresh_from_network_ai()
	return PROCESS_KILL

/obj/machinery/status_display/ai_core/proc/refresh_from_network_ai(mob/living/silicon/ai/target_ai)
	if(machine_stat & NOPOWER)
		set_picture(initial(icon_state), initial(icon))
		return

	if(!target_ai)
		for(var/mob/living/silicon/ai/ai_mob in GLOB.ai_list)
			if(QDELETED(ai_mob) || ai_mob.stat == DEAD)
				continue
			target_ai = ai_mob
			break

	if(!target_ai)
		set_picture(initial(icon_state), initial(icon))
		return

	if(target_ai.portrait_appearance?.icon && target_ai.portrait_appearance?.icon_state)
		set_picture(target_ai.portrait_appearance.icon_state, target_ai.portrait_appearance.icon)
		return

	var/display_name = target_ai.selected_display_name
	if(!display_name && target_ai.display_icon_override)
		for(var/option_name in GLOB.ai_core_display_screens)
			if(resolve_ai_icon_sync(option_name) == target_ai.display_icon_override)
				display_name = option_name
				break

	display_name ||= "Blue"
	var/selected_icon = GLOB.ai_core_display_screen_icons[display_name] || initial(icon)
	set_picture(resolve_ai_icon_sync(display_name), selected_icon)

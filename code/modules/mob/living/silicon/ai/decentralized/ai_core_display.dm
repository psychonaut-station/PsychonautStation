/obj/machinery/status_display/ai_core
	name = "\improper AI core display"
	desc = "A large display that mirrors the decentralized AI's selected core avatar."
	icon = 'icons/mob/silicon/ai.dmi'
	icon_state = "ai-core"
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
		set_picture("ai-empty", initial(icon))
		return PROCESS_KILL

	refresh_from_network_ai()
	return PROCESS_KILL

/obj/machinery/status_display/ai_core/update_overlays(updates)
	. = list()

	if(machine_stat & (NOPOWER|BROKEN))
		clear_display()
		return

	clear_display()
	if(current_mode != SD_PICTURE)
		return

	var/mutable_appearance/picture_overlay = mutable_appearance(current_picture_icon, current_picture)
	picture_overlay.appearance_flags |= KEEP_APART
	. += picture_overlay

/obj/machinery/status_display/ai_core/proc/refresh_from_network_ai(mob/living/silicon/ai/target_ai)
	if(machine_stat & NOPOWER)
		set_picture("ai-empty", initial(icon))
		return

	if(!target_ai)
		for(var/mob/living/silicon/ai/ai_mob in GLOB.ai_list)
			if(QDELETED(ai_mob) || ai_mob.stat == DEAD)
				continue
			target_ai = ai_mob
			break

	if(!target_ai)
		set_picture("ai-empty", initial(icon))
		return

	if(target_ai.portrait_appearance?.icon && target_ai.portrait_appearance?.icon_state)
		set_picture(target_ai.portrait_appearance.icon_state, target_ai.portrait_appearance.icon)
		return

	var/display_name = target_ai.selected_display_name
	if(!display_name && target_ai.display_icon_override)
		for(var/option_name in get_all_ai_core_display_options())
			if(get_ai_display_state(option_name) == target_ai.display_icon_override)
				display_name = option_name
				break

	display_name ||= "Blue"
	var/selected_icon = get_ai_display_icon(display_name, initial(icon))
	set_picture(get_ai_display_state(display_name), selected_icon)

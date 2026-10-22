/obj/machinery/nuclearbomb/three_disked
	var/obj/item/disk/nuclear/fake/three_disked/red/r_auth
	var/obj/item/disk/nuclear/fake/three_disked/blue/b_auth

/obj/machinery/nuclearbomb/three_disked/disk_check(obj/item/disk/nuclear/inserted_disk)
	if(!istype(inserted_disk, /obj/item/disk/nuclear/fake/three_disked))
		say("Authentication failure; disk not recognised.")
		return FALSE

	if(istype(inserted_disk, /obj/item/disk/nuclear/fake/three_disked/red) && !isnull(r_auth))
		return FALSE

	if(istype(inserted_disk, /obj/item/disk/nuclear/fake/three_disked/green) && !isnull(auth))
		return FALSE

	if(istype(inserted_disk, /obj/item/disk/nuclear/fake/three_disked/blue) && !isnull(b_auth))
		return FALSE

	return TRUE

/obj/machinery/nuclearbomb/three_disked/attackby(obj/item/weapon, mob/user, list/modifiers, list/attack_modifiers)
	if (istype(weapon, /obj/item/disk/nuclear))
		if(!disk_check(weapon))
			return TRUE
		if(!user.transferItemToLoc(weapon, src))
			return TRUE
		if(istype(weapon, /obj/item/disk/nuclear/fake/three_disked/red))
			r_auth = weapon
		else if(istype(weapon, /obj/item/disk/nuclear/fake/three_disked/green))
			auth = weapon
		else if(istype(weapon, /obj/item/disk/nuclear/fake/three_disked/blue))
			b_auth = weapon
		update_ui_mode()
		playsound(src, 'sound/machines/terminal/terminal_insert_disc.ogg', 50, FALSE)
		add_fingerprint(user)
		return TRUE

	return ..()

/obj/machinery/nuclearbomb/three_disked/update_ui_mode()
	if(exploded)
		ui_mode = NUKEUI_EXPLODED
		return

	if(!r_auth || !auth || !b_auth)
		ui_mode = NUKEUI_AWAIT_DISK
		return

	if(timing)
		ui_mode = NUKEUI_TIMING
		return

	if(!safety)
		ui_mode = NUKEUI_AWAIT_ARM
		return

	ui_mode = NUKEUI_AWAIT_TIMER

/obj/machinery/nuclearbomb/three_disked/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ThreeDiskNukeBomb", name)
		ui.open()

/obj/machinery/nuclearbomb/three_disked/ui_data(mob/user)
	var/list/data = list()
	data["r_auth"] = r_auth
	data["auth"] = auth
	data["b_auth"] = b_auth

	var/hidden_code = (numeric_input != "ERROR")

	var/current_code = ""
	if(hidden_code)
		while(length(current_code) < length(numeric_input))
			current_code = "[current_code]*"
	else
		current_code = numeric_input
	while(length(current_code) < 5)
		current_code = "[current_code]-"

	var/first_status
	var/second_status
	switch(ui_mode)
		if(NUKEUI_AWAIT_DISK)
			first_status = "DEVICE LOCKED"
			if(timing)
				second_status = "TIME: [get_time_left()]"
			else
				second_status = "AWAIT DISK"
		if(NUKEUI_AWAIT_TIMER)
			first_status = "INPUT TIME"
			second_status = "TIME: [current_code]"
		if(NUKEUI_AWAIT_ARM)
			first_status = "DEVICE READY"
			second_status = "TIME: [get_time_left()]"
		if(NUKEUI_TIMING)
			first_status = "DEVICE ARMED"
			second_status = "TIME: [get_time_left()]"
		if(NUKEUI_EXPLODED)
			first_status = "DEVICE DEPLOYED"
			second_status = "THANK YOU"

	data["status1"] = first_status
	data["status2"] = second_status
	data["anchored"] = anchored

	return data



/obj/machinery/nuclearbomb/three_disked/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("eject_disk")
			var/disk_type = params["disktype"]
			switch(disk_type)
				if("red")
					if(r_auth && r_auth.loc == src)
						r_auth.forceMove(get_turf(src))
						r_auth = null
					else
						var/obj/item/I = usr.is_holding_item_of_type(/obj/item/disk/nuclear/fake/three_disked/red)
						if(I && disk_check(I) && usr.transferItemToLoc(I, src))
							r_auth = I
							. = TRUE
				if("green")
					if(auth && auth.loc == src)
						auth.forceMove(get_turf(src))
						auth = null
					else
						var/obj/item/I = usr.is_holding_item_of_type(/obj/item/disk/nuclear/fake/three_disked/green)
						if(I && disk_check(I) && usr.transferItemToLoc(I, src))
							auth = I
							. = TRUE
				if("blue")
					if(b_auth && b_auth.loc == src)
						b_auth.forceMove(get_turf(src))
						b_auth = null
					else
						var/obj/item/I = usr.is_holding_item_of_type(/obj/item/disk/nuclear/fake/three_disked/blue)
						if(I && disk_check(I) && usr.transferItemToLoc(I, src))
							b_auth = I
							. = TRUE

			playsound(src, 'sound/machines/terminal/terminal_insert_disc.ogg', 50, FALSE)
			playsound(src, 'sound/machines/nuke/general_beep.ogg', 50, FALSE)
			update_ui_mode()
		if("keypad")
			if(r_auth && auth && b_auth)
				var/digit = params["digit"]
				switch(digit)
					if("C")
						if(ui_mode == NUKEUI_AWAIT_ARM)
							toggle_nuke_safety()
							playsound(src, 'sound/machines/nuke/confirm_beep.ogg', 50, FALSE)
							update_ui_mode()
						else
							playsound(src, 'sound/machines/nuke/general_beep.ogg', 50, FALSE)
						numeric_input = ""
						. = TRUE
					if("E")
						if(ui_mode == NUKEUI_AWAIT_TIMER)
							var/number_value = text2num(numeric_input)
							if(number_value)
								timer_set = clamp(number_value, minimum_timer_set, maximum_timer_set)
								playsound(src, 'sound/machines/nuke/general_beep.ogg', 50, FALSE)
								toggle_nuke_safety()
								. = TRUE
						else
							playsound(src, 'sound/machines/nuke/angry_beep.ogg', 50, FALSE)
						update_ui_mode()
					if("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
						if(numeric_input != "ERROR")
							numeric_input += digit
							if(length(numeric_input) > 5)
								numeric_input = "ERROR"
							else
								playsound(src, 'sound/machines/nuke/general_beep.ogg', 50, FALSE)
							. = TRUE
			else
				playsound(src, 'sound/machines/nuke/angry_beep.ogg', 50, FALSE)
		if("arm")
			if(r_auth && auth && b_auth && !safety && !exploded)
				playsound(src, 'sound/machines/nuke/confirm_beep.ogg', 50, FALSE)
				toggle_nuke_armed()
				update_ui_mode()
				. = TRUE
			else
				playsound(src, 'sound/machines/nuke/angry_beep.ogg', 50, FALSE)
		if("anchor")
			if(r_auth && auth && b_auth)
				playsound(src, 'sound/machines/nuke/general_beep.ogg', 50, FALSE)
				set_anchor(usr)
			else
				playsound(src, 'sound/machines/nuke/angry_beep.ogg', 50, FALSE)


/obj/machinery/nuclearbomb/three_disked/teammatch
	var/datum/teammatch_lobby/lobby
	var/armer_team

/obj/machinery/nuclearbomb/three_disked/teammatch/arm_nuke(mob/armer)
	detonation_timer = world.time + (timer_set * 10)
	countdown.start()
	update_appearance()

/obj/machinery/nuclearbomb/three_disked/teammatch/disarm_nuke(mob/disarmer)
	detonation_timer = null
	countdown.stop()
	update_appearance()

/obj/machinery/nuclearbomb/three_disked/teammatch/actually_explode()
	really_actually_explode()
	return

/obj/machinery/nuclearbomb/three_disked/teammatch/really_actually_explode(detonation_status)
	lobby?.end_game("[armer_team] Major Victory!!")
	qdel(src)
	return TRUE

/obj/machinery/nuclearbomb/three_disked/teammatch/nuke_effects(list/affected_z_levels)
	return

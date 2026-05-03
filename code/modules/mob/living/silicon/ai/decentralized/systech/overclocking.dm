#define OVERCLOCKING_DURATION (5 SECONDS)

/obj/machinery/computer/ai_overclocking
	name = "\improper AI overclocking workstation"
	desc = "Used for stress-testing and overclocking neural processing units."
	icon_keyboard = "tech_key"
	icon_screen = "ai-fixer"
	light_color = LIGHT_COLOR_PINK
	circuit = /obj/item/circuitboard/computer/ai_overclocking

	var/obj/item/ai_cpu/inserted_cpu
	var/overclocking = FALSE

	COOLDOWN_DECLARE(overclocking_timer)

/obj/machinery/computer/ai_overclocking/process()
	if(!..())
		if(inserted_cpu)
			reset_inserted_cpu(drop_location())
		return FALSE

	if(overclocking && COOLDOWN_FINISHED(src, overclocking_timer))
		overclocking = FALSE
		finish_overclock()
	return TRUE

/obj/machinery/computer/ai_overclocking/Destroy()
	if(inserted_cpu)
		inserted_cpu.speed = initial(inserted_cpu.speed)
		inserted_cpu.power_multiplier = initial(inserted_cpu.power_multiplier)
	return ..()

/obj/machinery/computer/ai_overclocking/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/ai_cpu))
		if(inserted_cpu)
			to_chat(user, span_warning("There is already a CPU inserted."))
			return TRUE
		inserted_cpu = item
		item.forceMove(src)
		return TRUE
	return ..()

/obj/machinery/computer/ai_overclocking/proc/push_overclock_result(valid)
	if(!inserted_cpu)
		return
	if(length(inserted_cpu.last_overclocking_values) >= 5)
		inserted_cpu.last_overclocking_values.Cut(1, 2)
	inserted_cpu.last_overclocking_values += list(list(
		"speed" = inserted_cpu.speed,
		"power" = inserted_cpu.power_multiplier,
		"valid" = valid,
	))

/obj/machinery/computer/ai_overclocking/proc/reset_inserted_cpu(atom/drop_target)
	if(!inserted_cpu)
		return
	inserted_cpu.speed = initial(inserted_cpu.speed)
	inserted_cpu.power_multiplier = initial(inserted_cpu.power_multiplier)
	inserted_cpu.forceMove(drop_target || drop_location())
	inserted_cpu = null
	overclocking = FALSE

/obj/machinery/computer/ai_overclocking/proc/finish_overclock()
	if(!inserted_cpu)
		return

	var/overclock_result = inserted_cpu.valid_overclock()
	if(overclock_result == "success")
		say("Overclock stable.")
		push_overclock_result(TRUE)
		inserted_cpu.forceMove(drop_location())
		inserted_cpu = null
		return

	say("Unstable overclock.")
	say("Possible reason: [overclock_result]")
	push_overclock_result(FALSE)
	inserted_cpu.speed = initial(inserted_cpu.speed)
	inserted_cpu.power_multiplier = initial(inserted_cpu.power_multiplier)

/obj/machinery/computer/ai_overclocking/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AiOverclocking", name)
		ui.open()

/obj/machinery/computer/ai_overclocking/ui_data(mob/user)
	var/list/data = list()
	data["has_cpu"] = !!inserted_cpu
	data["overclocking"] = overclocking

	if(inserted_cpu)
		data["speed"] = inserted_cpu.speed
		data["power_multiplier"] = inserted_cpu.power_multiplier
		data["power_usage"] = round(inserted_cpu.get_power_usage(), 0.1)
		data["overclock_progress"] = overclocking ? (COOLDOWN_TIMELEFT(src, overclocking_timer) / OVERCLOCKING_DURATION) : FALSE
		data["last_values"] = inserted_cpu.last_overclocking_values
	else
		data["overclock_progress"] = FALSE
		data["last_values"] = list()

	return data

/obj/machinery/computer/ai_overclocking/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("eject_cpu")
			if(!inserted_cpu)
				return TRUE
			reset_inserted_cpu(drop_location())
			return TRUE

		if("set_speed")
			if(!inserted_cpu || overclocking)
				return TRUE
			var/new_speed = text2num(params["new_speed"])
			if(isnull(new_speed))
				return TRUE
			inserted_cpu.speed = max(1, new_speed)
			return TRUE

		if("set_power")
			if(!inserted_cpu || overclocking)
				return TRUE
			var/new_power = text2num(params["new_power"])
			if(isnull(new_power))
				return TRUE
			inserted_cpu.power_multiplier = max(0.5, new_power)
			return TRUE

		if("test_overclock")
			if(!inserted_cpu || overclocking)
				return TRUE
			overclocking = TRUE
			COOLDOWN_START(src, overclocking_timer, OVERCLOCKING_DURATION)
			return TRUE

		if("stop_overclock")
			if(!inserted_cpu || !overclocking)
				return TRUE
			overclocking = FALSE
			inserted_cpu.speed = initial(inserted_cpu.speed)
			inserted_cpu.power_multiplier = initial(inserted_cpu.power_multiplier)
			return TRUE

	return FALSE

#undef OVERCLOCKING_DURATION

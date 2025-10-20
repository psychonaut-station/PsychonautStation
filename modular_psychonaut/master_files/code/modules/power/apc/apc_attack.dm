/// How long it takes an ipc to drain or charge APCs. Also used as a spam limiter.
#define IPC_APC_DRAIN_TIME (3 SECONDS)

#define IPC_APC_POWER_GAIN (STANDARD_CELL_CHARGE)

/// Special behavior for when an ipc interacts with an APC.
/obj/machinery/power/apc/proc/ipc_interact(mob/living/user, list/modifiers)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/ipc = user
	var/obj/item/organ/stomach/maybe_stomach = ipc.get_organ_slot(ORGAN_SLOT_STOMACH)
	var/obj/item/organ/maybe_protector = ipc.get_organ_slot(ORGAN_SLOT_VOLTPROTECT)
	var/obj/item/organ/voltage_protector/protector
	if(maybe_protector)
		if(istype(maybe_protector, /obj/item/organ/voltage_protector))
			protector = maybe_protector
	// how long we wanna wait before we show the balloon alert. don't want it to be very long in case the ipc wants to opt-out of doing that action, just long enough to where it doesn't collide with previously queued balloon alerts.
	var/alert_timer_duration = 0.75 SECONDS

	if(!istype(maybe_stomach, /obj/item/organ/stomach/ipc))
		return
	var/obj/item/organ/stomach/ipc/stomach = maybe_stomach
	if(!stomach.cell)
		return
	var/obj/item/stock_parts/power_store/cell/ipccell = stomach.cell
	var/apcpowergain = min(ipccell.maxcharge - ipccell.charge, IPC_APC_POWER_GAIN)
	var/charge_limit = ipccell.maxcharge - apcpowergain
	if(stomach.drain_time >= world.time)
		return
	if(LAZYACCESS(modifiers, LEFT_CLICK))
		if(cell.charge <= (cell.maxcharge / 2))
			addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, balloon_alert), ipc, "safeties prevent draining!"), alert_timer_duration)
			return
		if(ipccell.charge > charge_limit)
			addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, balloon_alert), ipc, "charge is full!"), alert_timer_duration)
			return
		stomach.drain_time = world.time + IPC_APC_DRAIN_TIME
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, balloon_alert), ipc, "draining power"), alert_timer_duration)
		if(!protector)
			do_sparks(4, TRUE, src)
		else
			do_sparks(1, TRUE, src)
		if(do_after(user, IPC_APC_DRAIN_TIME, target = src))
			if(cell.charge <= (cell.maxcharge / 2) || (ipccell.charge > charge_limit))
				return
			balloon_alert(ipc, "received charge")
			stomach.adjust_charge(apcpowergain)
			cell.use(apcpowergain)
			charging = APC_CHARGING
			update_appearance()
			if(!protector)
				shock(user, 75)
		return
	else if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(cell.charge >= cell.maxcharge - apcpowergain)
			addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, balloon_alert), ipc, "APC can't receive more power!"), alert_timer_duration)
			return
		if(ipccell.charge < apcpowergain)
			addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, balloon_alert), ipc, "charge is too low!"), alert_timer_duration)
			return
		stomach.drain_time = world.time + IPC_APC_DRAIN_TIME
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, balloon_alert), ipc, "transfering power"), alert_timer_duration)
		if(!do_after(user, IPC_APC_DRAIN_TIME, target = src))
			return
		if((cell.charge >= (cell.maxcharge - apcpowergain)) || (ipccell.charge < apcpowergain))
			balloon_alert(ipc, "can't transfer power!")
			return
		if(istype(stomach))
			balloon_alert(ipc, "transfered power")
			cell.give(-stomach.adjust_charge(-IPC_APC_POWER_GAIN))
		else
			balloon_alert(ipc, "can't transfer power!")
	return

#undef IPC_APC_POWER_GAIN
#undef IPC_APC_DRAIN_TIME

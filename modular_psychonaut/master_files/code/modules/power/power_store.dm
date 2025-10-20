#define IPC_CELL_DRAIN_TIME (3.5 SECONDS)
#define IPC_CELL_POWER_DRAIN (0.75 * STANDARD_CELL_CHARGE)
/// The factor by which we multiply drain to get how much we gain
#define IPC_CELL_POWER_GAIN_FACTOR 0.08

/obj/item/stock_parts/power_store/proc/ipc_drain(mob/living/carbon/human/user, obj/item/organ/stomach/ipc/used_stomach)
	if(charge() <= 0)
		balloon_alert(user, "out of charge!")
		return

	var/obj/item/stock_parts/power_store/stomach_cell = used_stomach.cell
	used_stomach.drain_time = world.time + IPC_CELL_DRAIN_TIME
	to_chat(user, span_notice("You begin clumsily channeling power from [src] into your body."))

	while(do_after(user, IPC_CELL_DRAIN_TIME, target = src))
		if(isnull(used_stomach) || (used_stomach != user.get_organ_slot(ORGAN_SLOT_STOMACH)))
			balloon_alert(user, "stomach removed!?")
			return

		var/our_charge = charge()
		var/scaled_stomach_used_charge = stomach_cell.used_charge() / IPC_CELL_POWER_GAIN_FACTOR
		var/potential_charge = min(our_charge, scaled_stomach_used_charge)
		var/to_drain = min(IPC_CELL_POWER_DRAIN, potential_charge)
		var/energy_drained = use(to_drain, force = TRUE)
		used_stomach.adjust_charge(energy_drained * IPC_CELL_POWER_GAIN_FACTOR)
		update_appearance(UPDATE_OVERLAYS)

		if(stomach_cell.used_charge() <= 0)
			balloon_alert(user, "your charge is full!")
			return
		if(charge() <= 0)
			balloon_alert(user, "out of charge!")
			return

#undef IPC_CELL_DRAIN_TIME
#undef IPC_CELL_POWER_DRAIN
#undef IPC_CELL_POWER_GAIN_FACTOR

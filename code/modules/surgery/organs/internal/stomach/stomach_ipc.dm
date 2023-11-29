/obj/item/organ/internal/stomach/ipc
	name = "cell holder"
	icon_state = "implant-power" //Welp. At least it's more unique in functionaliy.
	desc = "A holder, can hold cells for ipc's power source."
	organ_flags = ORGAN_ROBOTIC
	organ_traits = list(TRAIT_NOHUNGER) // We have our own hunger mechanic.
	var/obj/item/stock_parts/cell/cell
	var/obj/item/stock_parts/cell/cell_type = /obj/item/stock_parts/cell/high
	var/drain_time = 0
	var/backup_charge = 100

/obj/item/organ/internal/stomach/ipc/Initialize(mapload)
	. = ..()
	if(!cell && cell_type)
		cell = new cell_type

/obj/item/organ/internal/stomach/ipc/examine(mob/user)
	. = ..()
	if(cell)
		. += span_notice("A [cell] appears to be inserted.")

/obj/item/organ/internal/stomach/ipc/on_life(seconds_per_tick, times_fired)
	. = ..()
	if(cell && cell.charge > 0)
		if(backup_charge < 100)
			adjust_backup_charge(1 * seconds_per_tick)
		adjust_charge(-IPC_CHARGE_FACTOR * seconds_per_tick)
	handle_charge(owner, seconds_per_tick, times_fired)

	if(cell && cell.charge == 0)
		adjust_backup_charge(-1 * seconds_per_tick)

	if(cell && cell.charge < 0)
		cell.charge = 0

	if(backup_charge < 0)
		backup_charge = 0

	if(backup_charge > 100)
		backup_charge = 100

/obj/item/organ/internal/stomach/ipc/on_insert(mob/living/carbon/stomach_owner)
	. = ..()
	RegisterSignal(stomach_owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT, PROC_REF(charge))
	RegisterSignal(stomach_owner, COMSIG_LIVING_ELECTROCUTE_ACT, PROC_REF(on_electrocute))
	if(istype(stomach_owner.dna.species, /datum/species/ipc))
		stomach_owner.remove_status_effect(/datum/status_effect/ipc_powerissue)
		RegisterSignal(stomach_owner, COMSIG_MOB_GET_STATUS_TAB_ITEMS, PROC_REF(get_status_tab_item))

/obj/item/organ/internal/stomach/ipc/on_remove(mob/living/carbon/stomach_owner)
	. = ..()
	UnregisterSignal(stomach_owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT)
	UnregisterSignal(stomach_owner, COMSIG_LIVING_ELECTROCUTE_ACT)
	stomach_owner.clear_mood_event("charge")
	stomach_owner.clear_alert(ALERT_CHARGE)
	stomach_owner.remove_status_effect(/datum/status_effect/ipc_powerissue)
	if(istype(stomach_owner.dna.species, /datum/species/ipc))
		UnregisterSignal(stomach_owner, COMSIG_MOB_GET_STATUS_TAB_ITEMS)
		stomach_owner.apply_status_effect(/datum/status_effect/ipc_powerissue)

/obj/item/organ/internal/stomach/ipc/proc/get_status_tab_item(mob/living/carbon/source, list/items)
	SIGNAL_HANDLER
	if(cell)
		items += "Power: [cell.charge]/[cell.maxcharge]"
	else
		items += "Power: No Cell"
	items += "Backup Power: [backup_charge]/100"

/obj/item/organ/internal/stomach/ipc/proc/charge(datum/source, amount, repairs)
	SIGNAL_HANDLER
	adjust_charge(amount / 1.5)

/obj/item/organ/internal/stomach/ipc/proc/on_electrocute(datum/source, shock_damage, siemens_coeff = 1, flags = NONE)
	SIGNAL_HANDLER
	if(flags & SHOCK_ILLUSION)
		return
	adjust_charge(shock_damage * siemens_coeff * 2)
	to_chat(owner, span_notice("You absorb some of the shock into your body!"))

/obj/item/organ/internal/stomach/ipc/proc/adjust_charge(amount)
	if(cell)
		cell.give(amount)

/obj/item/organ/internal/stomach/ipc/proc/adjust_backup_charge(amount)
	backup_charge = clamp(backup_charge + amount, 0, 100)

/obj/item/organ/internal/stomach/ipc/proc/handle_charge(mob/living/carbon/carbon, seconds_per_tick, times_fired)
	if(cell)
		if (backup_charge == 0)
			carbon.apply_status_effect(/datum/status_effect/ipc_powerissue)
		else
			carbon.remove_status_effect(/datum/status_effect/ipc_powerissue)

		var/cellcharge = cell.charge/cell.maxcharge
		switch(cellcharge)
			if(0.75 to INFINITY)
				owner.clear_mood_event("charge")
				carbon.clear_alert(ALERT_CHARGE)
			if(0.5 to 0.75)
				carbon.add_mood_event("charge", /datum/mood_event/charged)
				carbon.throw_alert(ALERT_CHARGE, /atom/movable/screen/alert/lowcell, 1)
			if(0.25 to 0.5)
				carbon.add_mood_event("charge", /datum/mood_event/lowpower)
				carbon.throw_alert(ALERT_CHARGE, /atom/movable/screen/alert/lowcell, 2)
			if(0.01 to 0.25)
				carbon.add_mood_event("charge", /datum/mood_event/decharged)
				carbon.throw_alert(ALERT_CHARGE, /atom/movable/screen/alert/lowcell, 3)
			else
				carbon.add_mood_event("charge", /datum/mood_event/decharged)
				carbon.throw_alert(ALERT_CHARGE, /atom/movable/screen/alert/emptycell)
	else
		carbon.add_mood_event("charge", /datum/mood_event/decharged)
		carbon.throw_alert(ALERT_CHARGE, /atom/movable/screen/alert/emptycell)
		if(backup_charge == 0)
			carbon.apply_status_effect(/datum/status_effect/ipc_powerissue)

/obj/item/organ/internal/stomach/ipc/attack_self(mob/user)
	var/turf/drop_loc = drop_location()
	if(cell)
		user.visible_message(span_notice("[user] removes [cell] from [src]!"), span_notice("You remove [cell]."))
		cell.update_appearance()
		cell.forceMove(drop_loc)
		cell = null
		update_appearance()

/obj/item/organ/internal/stomach/ipc/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stock_parts/cell))
		if(!cell)
			if(!user.transferItemToLoc(W, src))
				return
			to_chat(user, span_notice("You insert [W] into [src]."))
			cell = W
			update_appearance()
			return
		else
			to_chat(user, span_warning("[src] already has \a [cell] installed!"))
			return

/datum/status_effect/ipc_powerissue
	id = "no_power"
	alert_type = /atom/movable/screen/alert/status_effect/ipc_powerissue

/atom/movable/screen/alert/status_effect/ipc_powerissue
	name = "No power"
	desc = "You don't have enough power to move your body!"
	icon_state = "ipc_nopower"

/datum/status_effect/ipc_powerissue/on_apply()
	. = ..()
	if (!.)
		return FALSE
	owner.visible_message(span_warning("[owner]'s joints are locked!"), span_warning("Your limbs fall still. You no longer doesn't have the power to move joints!"))
	owner.add_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED, TRAIT_INCAPACITATED), TRAIT_STATUS_EFFECT(id))
	return TRUE

/datum/status_effect/ipc_powerissue/get_examine_text()
	return span_warning("[owner.p_They()] are still doesn't seem to have power!")

/datum/status_effect/ipc_powerissue/on_remove()
	owner.visible_message(span_notice("[owner] slowly stirs back into motion!"), span_notice("You have gathered enough power to move your body once more."))
	owner.remove_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED, TRAIT_INCAPACITATED), TRAIT_STATUS_EFFECT(id))
	return ..()

/obj/item/organ/internal/stomach/ipc/empty
	cell_type = null

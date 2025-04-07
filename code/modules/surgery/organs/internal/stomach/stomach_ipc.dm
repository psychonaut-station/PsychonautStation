/obj/item/organ/stomach/ipc
	name = "cell holder"
	icon = 'icons/psychonaut/obj/medical/organs/organs.dmi'
	icon_state = "stomach-ipc" //Welp. At least it's more unique in functionaliy.
	desc = "A holder, can hold cells for ipc's power source."
	organ_flags = ORGAN_ROBOTIC
	organ_traits = list(TRAIT_NOHUNGER)
	var/mob/living/carbon/human/humanowner
	var/obj/item/stock_parts/power_store/cell/cell
	var/obj/item/stock_parts/power_store/cell/initcell = /obj/item/stock_parts/power_store/cell/high
	var/backup_charge = 100
	var/drain_time = 0

/obj/item/organ/stomach/ipc/Initialize(mapload)
	. = ..()
	if(initcell)
		cell = new initcell(src)
	update_appearance()
	register_context()

/obj/item/organ/stomach/ipc/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(!isnull(cell))
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Remove cell"
		return CONTEXTUAL_SCREENTIP_SET
	else if (istype(held_item, /obj/item/stock_parts/power_store/cell))
		context[SCREENTIP_CONTEXT_LMB] = "Insert cell"
		return CONTEXTUAL_SCREENTIP_SET

/obj/item/organ/stomach/ipc/examine(mob/user)
	. = ..()
	if(cell)
		. += span_notice("Alt-Click to remove [cell].")
	else
		. += span_notice("There is pins for a cell.")

/obj/item/organ/stomach/ipc/update_appearance()
	. = ..()
	cut_overlays()
	if(cell)
		var/mutable_appearance/celloverlay = new(cell)
		celloverlay.plane = FLOAT_PLANE
		celloverlay.layer = FLOAT_LAYER
		celloverlay.pixel_x = 0
		celloverlay.pixel_y = 0
		add_overlay(celloverlay)

/obj/item/organ/stomach/ipc/on_life(seconds_per_tick, times_fired)
	. = ..()
	if(cell && cell.charge > 0)
		if(backup_charge < 100)
			adjust_backup_charge(1 * seconds_per_tick)
		adjust_charge(-IPC_DISCHARGE_FACTOR * seconds_per_tick * (humanowner ? humanowner.physiology.hunger_mod : 1))
	handle_charge(owner, seconds_per_tick, times_fired)

	if(cell && cell.charge == 0)
		adjust_backup_charge(-1 * seconds_per_tick)

	if(cell && cell.charge < 0)
		cell.charge = 0

	if(backup_charge < 0)
		backup_charge = 0

	if(backup_charge > 100)
		backup_charge = 100

/obj/item/organ/stomach/ipc/on_mob_insert(mob/living/carbon/stomach_owner)
	. = ..()
	RegisterSignal(stomach_owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT, PROC_REF(charge))
	RegisterSignal(stomach_owner, COMSIG_LIVING_ELECTROCUTE_ACT, PROC_REF(on_electrocute))
	if(isipc(stomach_owner))
		stomach_owner.remove_status_effect(/datum/status_effect/ipc_powerissue)
		RegisterSignal(stomach_owner, COMSIG_MOB_GET_STATUS_TAB_ITEMS, PROC_REF(get_status_tab_item))
	if(ishuman(stomach_owner))
		humanowner = stomach_owner

/obj/item/organ/stomach/ipc/on_mob_remove(mob/living/carbon/stomach_owner)
	. = ..()
	UnregisterSignal(stomach_owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT)
	UnregisterSignal(stomach_owner, COMSIG_LIVING_ELECTROCUTE_ACT)
	stomach_owner.clear_mood_event("charge")
	stomach_owner.clear_alert(ALERT_CHARGE)
	if(isipc(stomach_owner))
		UnregisterSignal(stomach_owner, COMSIG_MOB_GET_STATUS_TAB_ITEMS)
		stomach_owner.apply_status_effect(/datum/status_effect/ipc_powerissue)
	humanowner = null

/obj/item/organ/stomach/ipc/proc/get_status_tab_item(mob/living/carbon/source, list/items)
	SIGNAL_HANDLER
	if(cell)
		items += "Charge Left: [display_energy(cell.charge)]/[display_energy(cell.maxcharge)]"
	else
		items += "Power: No Cell"
	items += "Backup Power: [backup_charge]/100"

/obj/item/organ/stomach/ipc/proc/charge(datum/source, datum/callback/charge_cell, seconds_per_tick)
	SIGNAL_HANDLER

	charge_cell.Invoke(cell, seconds_per_tick / 1.5)
	humanowner.diag_hud_set_humancell()

/obj/item/organ/stomach/ipc/proc/on_electrocute(datum/source, shock_damage, shock_source, siemens_coeff = 1, flags)
	SIGNAL_HANDLER
	if(flags & SHOCK_ILLUSION)
		return
	adjust_charge(shock_damage * siemens_coeff * 20)
	to_chat(owner, span_notice("You absorb some of the shock into your body!"))

/obj/item/organ/stomach/ipc/proc/adjust_charge(amount)
	if(cell)
		cell.give(amount)
	humanowner.diag_hud_set_humancell()

/obj/item/organ/stomach/ipc/proc/adjust_backup_charge(amount)
	backup_charge = clamp(backup_charge + amount, 0, 100)

/obj/item/organ/stomach/ipc/proc/handle_charge(mob/living/carbon/carbon, seconds_per_tick, times_fired)
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

/obj/item/organ/stomach/ipc/click_alt(mob/user)
	var/turf/drop_loc = drop_location()
	if(cell)
		user.visible_message(span_notice("[user] removes [cell] from [src]!"), span_notice("You remove [cell]."))
		cell.update_appearance()
		cell.forceMove(drop_loc)
		cell = null
		update_appearance()

/obj/item/organ/stomach/ipc/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stock_parts/power_store/cell))
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
	icon = 'icons/psychonaut/hud/screen_alert.dmi'
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

/obj/item/organ/stomach/ipc/empty
	initcell = null

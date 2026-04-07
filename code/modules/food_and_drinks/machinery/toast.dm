#define TOAST_IDLE 1
#define TOAST_RUNNING 2
#define TOAST_INTERRUPTED 3
#define TOAST_NOPOWER 4

/obj/machinery/toast_machine
	name = "toast machine"
	desc = "A compact press built for sujuk and cheese toasts."
	icon = 'icons/psychonaut/obj/machines/kitchen.dmi'
	icon_state = "toast_machine"
	base_icon_state = "toast_machine"
	density = TRUE
	pass_flags = PASSTABLE
	pass_flags_self = PASSMACHINE | PASSTABLE | LETPASSTHROW
	use_power = IDLE_POWER_USE
	power_channel = AREA_USAGE_EQUIP
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.05
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION
	layer = BELOW_OBJ_LAYER
	circuit = /obj/item/circuitboard/machine/toast_machine
	processing_flags = START_PROCESSING_MANUALLY
	resistance_flags = FIRE_PROOF
	anchored_tabletop_offset = 6
	anchored = FALSE
	pixel_y = 1
	var/list/toasting_objects = list()
	var/on = FALSE
	/// How many toast slots fit in the press?
	var/max_items = 2
	var/particles/cooking_particles
	var/mutable_appearance/done_overlay
	var/toast_state = TOAST_IDLE
	var/lid_open = FALSE
	var/state_transition_in_progress = FALSE
	var/datum/looping_sound/toaster/toaster_sound

/obj/machinery/toast_machine/Initialize(mapload)
	. = ..()
	toaster_sound = new(src, FALSE)
	done_overlay = mutable_appearance('icons/effects/effects.dmi', "sparkles", ABOVE_OBJ_LAYER)
	done_overlay.pixel_y = -1
	lid_open = FALSE
	toast_state = TOAST_IDLE
	refresh_machine_state()

/obj/machinery/toast_machine/Destroy()
	QDEL_NULL(toaster_sound)
	end_processing()
	QDEL_NULL(cooking_particles)
	return ..()

/obj/machinery/toast_machine/crowbar_act(mob/living/user, obj/item/I)
	if(toast_state == TOAST_RUNNING)
		to_chat(user, span_warning("You should stop [src] before prying it apart."))
		balloon_alert(user, "still cooking!")
		return TRUE
	. = ..()
	default_deconstruction_crowbar(I, ignore_panel = TRUE)

/obj/machinery/toast_machine/can_be_unfasten_wrench(mob/user, silent)
	. = ..()
	if(anchored && toast_state == TOAST_RUNNING)
		if(!silent)
			to_chat(user, span_warning("You can't unsecure [src] while it's cooking."))
		return CANT_UNFASTEN
	return .

/obj/machinery/toast_machine/IsContainedAtomAccessible(atom/contained, atom/movable/user)
	return ..() || (lid_open && toast_state != TOAST_RUNNING && (contained in toasting_objects))

/obj/machinery/toast_machine/attackby(obj/item/I, mob/user, list/modifiers, list/attack_modifiers)
	if(I.tool_behaviour == TOOL_WRENCH || I.tool_behaviour == TOOL_CROWBAR)
		return ..()

	if(!can_access_press(user))
		return TRUE

	var/slot_cost = get_item_slot_cost(I)
	if(!slot_cost)
		to_chat(user, span_warning("[src] only fits toast bread, toast sandwiches, and sujuk."))
		return TRUE
	if(get_current_slots() + slot_cost > max_items)
		to_chat(user, span_notice("[src] can't fit more toast."))
		return TRUE
	if(!LAZYACCESS(modifiers, ICON_X) || !LAZYACCESS(modifiers, ICON_Y))
		return
	if(user.transferItemToLoc(I, src, silent = FALSE))
		I.pixel_x = clamp(text2num(LAZYACCESS(modifiers, ICON_X)) - 16, -(ICON_SIZE_X / 2), ICON_SIZE_X / 2)
		I.pixel_y = clamp(text2num(LAZYACCESS(modifiers, ICON_Y)) - 16, -(ICON_SIZE_Y / 2), ICON_SIZE_Y / 2)
		to_chat(user, span_notice("You place [I] in [src]."))
		AddToPress(I, user)
		return TRUE
	return ..()

/obj/machinery/toast_machine/item_interaction_secondary(mob/living/user, obj/item/item, list/modifiers)
	if(isnull(item.atom_storage))
		return NONE

	if(!can_access_press(user))
		return ITEM_INTERACT_BLOCKING

	for(var/obj/tray_item in toasting_objects.Copy())
		item.atom_storage.attempt_insert(tray_item, user, TRUE)
	refresh_machine_state()
	return ITEM_INTERACT_SUCCESS

/obj/machinery/toast_machine/item_interaction(mob/living/user, obj/item/item, list/modifiers)
	if(isnull(item.atom_storage))
		return NONE

	if(!can_access_press(user))
		return ITEM_INTERACT_BLOCKING

	if(get_current_slots() >= max_items)
		balloon_alert(user, "it's full!")
		return ITEM_INTERACT_BLOCKING

	if(!istype(item, /obj/item/storage/bag/tray))
		to_chat(user, span_notice("You start dumping out the contents of [item] into [src]..."))
		if(!do_after(user, 2 SECONDS, target = item))
			return ITEM_INTERACT_BLOCKING

	var/loaded = 0
	for(var/obj/tray_item in item)
		var/slot_cost = get_item_slot_cost(tray_item)
		if(!slot_cost)
			continue
		if(get_current_slots() + slot_cost > max_items)
			break
		if(!IS_EDIBLE(tray_item))
			continue
		if(item.atom_storage.attempt_remove(tray_item, src))
			loaded++
			AddToPress(tray_item, user)
	if(loaded)
		to_chat(user, span_notice("You insert [loaded] item\s into [src]."))
		refresh_machine_state()
		return ITEM_INTERACT_SUCCESS
	return ITEM_INTERACT_BLOCKING

/obj/machinery/toast_machine/attack_hand(mob/user, list/modifiers)
	. = ..()
	toggle_lid(user)

/obj/machinery/toast_machine/attack_robot(mob/user)
	. = ..()
	toggle_lid(user)

/obj/machinery/toast_machine/proc/toggle_lid(mob/user)
	if(state_transition_in_progress)
		return

	if(toast_state == TOAST_RUNNING)
		set_toast_state(TOAST_INTERRUPTED, user, "manual_stop")
		return

	lid_open = !lid_open
	refresh_machine_state()

	if(lid_open)
		to_chat(user, span_notice("You open [src]."))
		return

	to_chat(user, span_notice("You close [src]."))
	if(!has_cookable_contents())
		return

	if(!can_start_toasting(user, TRUE))
		return

	set_toast_state(TOAST_RUNNING, user, "manual_start")

/obj/machinery/toast_machine/proc/can_start_toasting(mob/user, show_feedback = TRUE)
	if(state_transition_in_progress)
		if(show_feedback && user)
			balloon_alert(user, "busy!")
		return FALSE
	if(toast_state == TOAST_RUNNING)
		return FALSE
	if(!anchored)
		if(show_feedback && user)
			to_chat(user, span_warning("You need to secure [src] before you can use it."))
			balloon_alert(user, "secure first!")
		return FALSE
	if(machine_stat & BROKEN)
		if(show_feedback && user)
			to_chat(user, span_warning("[src] is broken down."))
			balloon_alert(user, "broken!")
		return FALSE
	if(machine_stat & NOPOWER)
		if(show_feedback && user)
			to_chat(user, span_warning("[src] doesn't have any power."))
			balloon_alert(user, "no power!")
		return FALSE
	if(!has_cookable_contents())
		if(show_feedback && user)
			to_chat(user, span_warning("There's nothing in [src] that can be toasted."))
			balloon_alert(user, "nothing to toast!")
		return FALSE
	return TRUE

/obj/machinery/toast_machine/proc/can_access_press(mob/user, show_feedback = TRUE)
	if(toast_state == TOAST_RUNNING)
		if(show_feedback && user)
			to_chat(user, span_warning("[src] is closed and running."))
			balloon_alert(user, "busy!")
		return FALSE
	if(!lid_open)
		if(show_feedback && user)
			to_chat(user, span_warning("You need to open [src] first."))
			balloon_alert(user, "open lid!")
		return FALSE
	return TRUE

/obj/machinery/toast_machine/proc/set_toast_state(new_state, mob/user = null, reason = null, play_transition_sound = TRUE)
	if(state_transition_in_progress)
		return FALSE
	if(new_state == toast_state && new_state != TOAST_INTERRUPTED)
		return FALSE

	state_transition_in_progress = TRUE

	var/old_state = toast_state
	var/was_running = old_state == TOAST_RUNNING
	var/final_state = new_state

	if(new_state == TOAST_RUNNING)
		lid_open = FALSE
		toast_state = TOAST_RUNNING
		sync_on_state()
		update_use_power(ACTIVE_POWER_USE)
		begin_processing()
		refresh_machine_state()
		state_transition_in_progress = FALSE
		return TRUE

	if(was_running)
		end_processing()
		toaster_sound.stop()

	if(new_state == TOAST_INTERRUPTED)
		toast_state = TOAST_INTERRUPTED
		if(reason == "power_lost")
			final_state = TOAST_NOPOWER
		else
			final_state = TOAST_IDLE
		lid_open = TRUE

	toast_state = final_state
	if(final_state != TOAST_RUNNING && (reason == "manual_stop" || reason == "power_lost" || reason == "completed" || reason == "interrupted" || reason == "item_removed" || reason == "broken"))
		lid_open = TRUE

	sync_on_state()
	update_use_power(IDLE_POWER_USE)
	refresh_machine_state()
	show_transition_feedback(user, reason)
	state_transition_in_progress = FALSE
	return TRUE

/obj/machinery/toast_machine/proc/show_transition_feedback(mob/user, reason)
	switch(reason)
		if("manual_stop")
			if(user)
				to_chat(user, span_notice("You stop [src] and open it."))
		if("power_lost")
			visible_message(span_warning("[src] powers down and pops open."))
		if("completed")
			playsound(src, 'sound/machines/ding.ogg', 50, FALSE)
			visible_message(span_notice("[src] finishes toasting with a ding."))
		if("interrupted", "item_removed", "broken")
			visible_message(span_notice("[src] pops open and stops toasting."))

/obj/machinery/toast_machine/begin_processing()
	. = ..()
	for(var/obj/item/item_to_toast as anything in toasting_objects)
		if(is_item_cookable(item_to_toast))
			SEND_SIGNAL(item_to_toast, COMSIG_ITEM_GRILL_TURNED_ON)

/obj/machinery/toast_machine/end_processing()
	. = ..()
	for(var/obj/item/item_to_toast as anything in toasting_objects)
		if(is_item_cookable(item_to_toast))
			SEND_SIGNAL(item_to_toast, COMSIG_ITEM_GRILL_TURNED_OFF)

/obj/machinery/toast_machine/proc/AddToPress(obj/item/item_to_toast, mob/user = null)
	toasting_objects += item_to_toast
	set_item_visibility(item_to_toast, lid_open && toast_state != TOAST_RUNNING)

	SEND_SIGNAL(item_to_toast, COMSIG_ITEM_GRILL_PLACED, user)
	if(toast_state == TOAST_RUNNING && is_item_cookable(item_to_toast))
		SEND_SIGNAL(item_to_toast, COMSIG_ITEM_GRILL_TURNED_ON)
	RegisterSignal(item_to_toast, COMSIG_MOVABLE_MOVED, PROC_REF(ItemMoved))
	RegisterSignal(item_to_toast, COMSIG_ITEM_GRILLED, PROC_REF(ToastCompleted))
	RegisterSignal(item_to_toast, COMSIG_QDELETING, PROC_REF(ItemRemovedFromPress))
	refresh_machine_state()

/obj/machinery/toast_machine/proc/remove_from_press(obj/item/unpress, reevaluate = TRUE, reason = "item_removed", refresh = TRUE)
	if(!(unpress in toasting_objects))
		return FALSE

	unpress.vis_flags &= ~VIS_INHERIT_PLANE
	toasting_objects -= unpress
	vis_contents -= unpress
	UnregisterSignal(unpress, list(COMSIG_ITEM_GRILLED, COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))

	if(reevaluate && toast_state == TOAST_RUNNING)
		reevaluate_cooking_state(reason)
	else if(refresh)
		refresh_machine_state()
	return TRUE

/obj/machinery/toast_machine/proc/ItemRemovedFromPress(obj/item/unpress)
	SIGNAL_HANDLER
	remove_from_press(unpress, TRUE, "item_removed", TRUE)

/obj/machinery/toast_machine/proc/ItemMoved(obj/item/I, atom/OldLoc, Dir, Forced)
	SIGNAL_HANDLER
	ItemRemovedFromPress(I)

/obj/machinery/toast_machine/proc/ToastCompleted(obj/item/source, atom/toasted_result)
	SIGNAL_HANDLER
	remove_from_press(source, FALSE, null, FALSE)
	if(isitem(toasted_result))
		var/obj/item/toasted_item = toasted_result
		AddToPress(toasted_item)
	reevaluate_cooking_state("completed")

/obj/machinery/toast_machine/proc/reevaluate_cooking_state(reason)
	if(toast_state != TOAST_RUNNING)
		refresh_machine_state()
		return

	if(has_cookable_contents())
		refresh_machine_state()
		return

	if(reason == "completed")
		set_toast_state(TOAST_IDLE, null, "completed")
	else
		set_toast_state(TOAST_INTERRUPTED, null, reason || "interrupted")

/obj/machinery/toast_machine/proc/refresh_machine_state()
	sync_on_state()
	if(toast_state == TOAST_RUNNING && has_cookable_contents())
		if(isnull(cooking_particles))
			cooking_particles = new /particles/smoke/steam/mild/center(src)
	else if(cooking_particles)
		QDEL_NULL(cooking_particles)

	update_content_visibility()
	update_toast_audio()
	update_appearance()

/obj/machinery/toast_machine/proc/update_toast_audio()
	if(toast_state == TOAST_RUNNING && has_cookable_contents())
		toaster_sound.start()
	else
		toaster_sound.stop()

/obj/machinery/toast_machine/proc/update_content_visibility()
	for(var/obj/item/pressed as anything in toasting_objects)
		set_item_visibility(pressed, lid_open && toast_state != TOAST_RUNNING)

/obj/machinery/toast_machine/proc/set_item_visibility(obj/item/target, visible)
	if(visible)
		target.vis_flags |= VIS_INHERIT_PLANE
		vis_contents |= target
	else
		target.vis_flags &= ~VIS_INHERIT_PLANE
		vis_contents -= target

/obj/machinery/toast_machine/proc/sync_on_state()
	on = (toast_state == TOAST_RUNNING)

/obj/machinery/toast_machine/proc/has_cookable_contents()
	for(var/obj/item/toasting_item as anything in toasting_objects)
		if(is_item_cookable(toasting_item))
			return TRUE
	return FALSE

/obj/machinery/toast_machine/proc/is_item_cookable(obj/item/I)
	return !isnull(I.GetComponent(/datum/component/grillable))

/obj/machinery/toast_machine/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(default_unfasten_wrench(user, tool, time = 2 SECONDS) == SUCCESSFUL_UNFASTEN)
		power_change()
		refresh_machine_state()
	return ITEM_INTERACT_SUCCESS

/obj/machinery/toast_machine/process(seconds_per_tick)
	if(toast_state != TOAST_RUNNING)
		return PROCESS_KILL
	if(machine_stat & (NOPOWER | BROKEN))
		set_toast_state(TOAST_INTERRUPTED, null, (machine_stat & NOPOWER) ? "power_lost" : "broken")
		return PROCESS_KILL
	if(!anchored)
		set_toast_state(TOAST_INTERRUPTED, null, "interrupted")
		return PROCESS_KILL

	for(var/obj/item/toasting_item as anything in toasting_objects)
		if(!is_item_cookable(toasting_item))
			continue
		if(SEND_SIGNAL(toasting_item, COMSIG_ITEM_GRILL_PROCESS, src, seconds_per_tick) & COMPONENT_HANDLED_GRILLING)
			continue
		toasting_item.fire_act(600)
		if(prob(5))
			visible_message(span_danger("[toasting_item] hisses inside [src]!"))

	var/turf/machine_loc = loc
	if(isturf(machine_loc))
		machine_loc.hotspot_expose(600, 60)

/obj/machinery/toast_machine/update_icon_state()
	icon_state = lid_open ? "[base_icon_state]-on" : base_icon_state
	return ..()

/obj/machinery/toast_machine/update_overlays()
	. = ..()
	if(toast_state != TOAST_RUNNING && toasting_objects.len && !has_cookable_contents())
		. += done_overlay

/obj/machinery/toast_machine/power_change()
	. = ..()
	if(machine_stat & NOPOWER)
		if(toast_state == TOAST_RUNNING)
			set_toast_state(TOAST_INTERRUPTED, null, "power_lost")
			return .
		if(!anchored && toast_state == TOAST_NOPOWER)
			set_toast_state(TOAST_IDLE, null, null, FALSE)
			return .
		if(anchored && toast_state != TOAST_NOPOWER)
			set_toast_state(TOAST_NOPOWER, null, null, FALSE)
			return .
	else if(toast_state == TOAST_NOPOWER)
		set_toast_state(TOAST_IDLE, null, null, FALSE)
		return .

	refresh_machine_state()
	return .

/obj/machinery/toast_machine/proc/get_current_slots()
	var/slots = 0
	for(var/obj/item/toasted as anything in toasting_objects)
		slots += get_item_slot_cost(toasted)
	return slots

/obj/machinery/toast_machine/proc/get_item_slot_cost(obj/item/I)
	if(istype(I, /obj/item/food/breadslice/turkish))
		return 1
	if(istype(I, /obj/item/food/bread/turkish))
		return 2
	if(istype(I, /obj/item/food/toast/cheese/half/raw))
		return 1
	if(istype(I, /obj/item/food/toast/cheese/raw))
		return 2
	if(istype(I, /obj/item/food/toast/cheese/half))
		return 1
	if(istype(I, /obj/item/food/toast/cheese))
		return 2
	if(istype(I, /obj/item/food/toast/sujuk/half/raw))
		return 1
	if(istype(I, /obj/item/food/toast/sujuk/raw))
		return 2
	if(istype(I, /obj/item/food/toast/sujuk/half))
		return 1
	if(istype(I, /obj/item/food/toast/sujuk))
		return 2
	if(istype(I, /obj/item/food/toast_sujuk/slice))
		return 1
	if(istype(I, /obj/item/food/toast_sujuk))
		return 1
	return 0

#undef TOAST_IDLE
#undef TOAST_RUNNING
#undef TOAST_INTERRUPTED
#undef TOAST_NOPOWER

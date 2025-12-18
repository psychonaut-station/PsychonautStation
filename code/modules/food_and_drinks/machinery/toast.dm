/obj/machinery/toast_machine
	name = "toast machine"
	desc = "A compact press built for sujuk and cheese toasts."
	icon = 'icons/psychonaut/obj/machines/kitchen.dmi'
	icon_state = "toast_machine"
	base_icon_state = "toast_machine"
	density = TRUE
	pass_flags_self = PASSMACHINE | PASSTABLE | LETPASSTHROW
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.05
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION
	layer = BELOW_OBJ_LAYER
	circuit = /obj/item/circuitboard/machine/griddle
	processing_flags = START_PROCESSING_MANUALLY
	resistance_flags = FIRE_PROOF
	anchored_tabletop_offset = 11
	///Things that are being pressed right now
	var/list/toasting_objects = list()
	///Looping sound for the grill
	var/datum/looping_sound/grill/grill_loop
	///Whether or not the machine is turned on right now
	var/on = FALSE
	///How many toast slots fit in the press?
	var/max_items = 2

/obj/machinery/toast_machine/Initialize(mapload)
	. = ..()
	grill_loop = new(src, FALSE)
	RegisterSignal(src, COMSIG_ATOM_EXPOSE_REAGENT, PROC_REF(on_expose_reagent))

/obj/machinery/toast_machine/Destroy()
	QDEL_NULL(grill_loop)
	return ..()

/obj/machinery/toast_machine/crowbar_act(mob/living/user, obj/item/I)
	. = ..()
	default_deconstruction_crowbar(I, ignore_panel = TRUE)

/obj/machinery/toast_machine/IsContainedAtomAccessible(atom/contained, atom/movable/user)
	return ..() || (contained in toasting_objects)

/obj/machinery/toast_machine/proc/on_expose_reagent(atom/parent_atom, datum/reagent/exposing_reagent, reac_volume, methods)
	SIGNAL_HANDLER
	return NONE

/obj/machinery/toast_machine/attackby(obj/item/I, mob/user, list/modifiers, list/attack_modifiers)
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
		I.pixel_x = clamp(text2num(LAZYACCESS(modifiers, ICON_X)) - 16, -(ICON_SIZE_X/2), ICON_SIZE_X/2)
		I.pixel_y = clamp(text2num(LAZYACCESS(modifiers, ICON_Y)) - 16, -(ICON_SIZE_Y/2), ICON_SIZE_Y/2)
		to_chat(user, span_notice("You place [I] in [src]."))
		AddToPress(I, user)
	else
		return ..()

/obj/machinery/toast_machine/item_interaction_secondary(mob/living/user, obj/item/item, list/modifiers)
	if(isnull(item.atom_storage))
		return NONE

	for(var/obj/tray_item in toasting_objects)
		item.atom_storage.attempt_insert(tray_item, user, TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/toast_machine/item_interaction(mob/living/user, obj/item/item, list/modifiers)
	if(isnull(item.atom_storage))
		return NONE

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
		to_chat(user, span_notice("You insert [loaded] item\\s into [src]."))
		update_appearance()
		return ITEM_INTERACT_SUCCESS
	return ITEM_INTERACT_BLOCKING

/obj/machinery/toast_machine/attack_hand(mob/user, list/modifiers)
	. = ..()
	toggle_mode()

/obj/machinery/toast_machine/attack_robot(mob/user)
	. = ..()
	toggle_mode()

/obj/machinery/toast_machine/proc/toggle_mode()
	on = !on
	if(on)
		begin_processing()
	else
		end_processing()
	update_appearance()
	update_content_visibility()
	update_toast_audio()

/obj/machinery/toast_machine/begin_processing()
	. = ..()
	for(var/obj/item/item_to_toast as anything in toasting_objects)
		SEND_SIGNAL(item_to_toast, COMSIG_ITEM_GRILL_TURNED_ON)

/obj/machinery/toast_machine/end_processing()
	. = ..()
	for(var/obj/item/item_to_toast as anything in toasting_objects)
		SEND_SIGNAL(item_to_toast, COMSIG_ITEM_GRILL_TURNED_OFF)

/obj/machinery/toast_machine/proc/AddToPress(obj/item/item_to_toast, mob/user)
	toasting_objects += item_to_toast
	set_item_visibility(item_to_toast, on)

	SEND_SIGNAL(item_to_toast, COMSIG_ITEM_GRILL_PLACED, user)
	if(on)
		SEND_SIGNAL(item_to_toast, COMSIG_ITEM_GRILL_TURNED_ON)
	RegisterSignal(item_to_toast, COMSIG_MOVABLE_MOVED, PROC_REF(ItemMoved))
	RegisterSignal(item_to_toast, COMSIG_ITEM_GRILLED, PROC_REF(ToastCompleted))
	RegisterSignal(item_to_toast, COMSIG_QDELETING, PROC_REF(ItemRemovedFromPress))
	update_toast_audio()
	update_appearance()

/obj/machinery/toast_machine/proc/ItemRemovedFromPress(obj/item/unpress)
	SIGNAL_HANDLER
	unpress.vis_flags &= ~VIS_INHERIT_PLANE
	toasting_objects -= unpress
	vis_contents -= unpress
	UnregisterSignal(unpress, list(COMSIG_ITEM_GRILLED, COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
	update_toast_audio()

/obj/machinery/toast_machine/proc/ItemMoved(obj/item/I, atom/OldLoc, Dir, Forced)
	SIGNAL_HANDLER
	ItemRemovedFromPress(I)

/obj/machinery/toast_machine/proc/ToastCompleted(obj/item/source, atom/toasted_result)
	SIGNAL_HANDLER
	AddToPress(toasted_result)

/obj/machinery/toast_machine/proc/update_toast_audio()
	if(on && toasting_objects.len)
		grill_loop.start()
	else
		grill_loop.stop()

/obj/machinery/toast_machine/proc/update_content_visibility()
	for(var/obj/item/pressed as anything in toasting_objects)
		set_item_visibility(pressed, on)

/obj/machinery/toast_machine/proc/set_item_visibility(obj/item/target, visible)
	if(visible)
		target.vis_flags |= VIS_INHERIT_PLANE
		vis_contents |= target
	else
		target.vis_flags &= ~VIS_INHERIT_PLANE
		vis_contents -= target

/obj/machinery/toast_machine/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool, time = 2 SECONDS)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/toast_machine/process(seconds_per_tick)
	for(var/obj/item/toasting_item as anything in toasting_objects)
		if(SEND_SIGNAL(toasting_item, COMSIG_ITEM_GRILL_PROCESS, src, seconds_per_tick) & COMPONENT_HANDLED_GRILLING)
			continue
		toasting_item.fire_act(600)
		if(prob(5))
			visible_message(span_danger("[toasting_item] hisses inside [src]!"))

	var/turf/machine_loc = loc
	if(isturf(machine_loc))
		machine_loc.hotspot_expose(600, 60)

/obj/machinery/toast_machine/update_icon_state()
	if(on)
		icon_state = "[base_icon_state]-on"
	else
		icon_state = base_icon_state
	return ..()

/obj/machinery/toast_machine/proc/get_current_slots()
	var/slots = 0
	for(var/obj/item/toasted as anything in toasting_objects)
		slots += get_item_slot_cost(toasted)
	return slots

/obj/machinery/toast_machine/proc/get_item_slot_cost(obj/item/I)
	if(istype(I, /obj/item/food/toast_bread/half))
		return 1
	if(istype(I, /obj/item/food/toast_bread))
		return 2
	if(istype(I, /obj/item/food/toast/cheese/half))
		return 1
	if(istype(I, /obj/item/food/toast/cheese))
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

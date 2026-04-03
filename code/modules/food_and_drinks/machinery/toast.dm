#define TOAST_IDLE 1
#define TOAST_RUNNING 2
#define TOAST_INTERRUPTED 3
#define TOAST_NOPOWER 4
#define TOAST_RUNNING_SOUND 'sound/machines/toast/toast_machine_running.ogg'
#define TOAST_RUNNING_SOUND_VOLUME 18
#define TOAST_RUNNING_SOUND_EXTRA_RANGE -8
#define TOAST_RUNNING_SOUND_FALLOFF_DISTANCE 1
#define TOAST_RUNNING_SOUND_FALLOFF_EXPONENT 5

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
	circuit = /obj/item/circuitboard/machine/griddle
	processing_flags = START_PROCESSING_MANUALLY
	resistance_flags = FIRE_PROOF
	anchored_tabletop_offset = 6
	anchored = FALSE
	pixel_y = 1
	/// Things that are being pressed right now.
	var/list/toasting_objects = list()
	/// Compatibility mirror for existing visuals.
	var/on = FALSE
	/// How many toast slots fit in the press?
	var/max_items = 2
	/// Particle effect while cooking.
	var/particles/cooking_particles
	/// Overlay key to signal done toast.
	var/mutable_appearance/done_overlay
	/// Explicit machine state for all logic decisions.
	var/toast_state = TOAST_IDLE
	/// Whether the lid is currently open.
	var/lid_open = FALSE
	/// Prevents re-entrant state changes.
	var/state_transition_in_progress = FALSE
	/// Same-tick and double-click interaction guard.
	var/next_interaction_time = 0
	/// Persistent running sound object for the active toast loop.
	var/sound/active_running_sound
	/// Machine-owned loop channel for this instance only.
	var/current_toast_loop_channel
	/// Hearers currently receiving the running sound on the owned channel.
	var/list/current_toast_loop_listeners = list()
	/// Hearers waiting to regain a client before the running loop can resume for them.
	var/list/current_toast_pending_login_listeners = list()

/obj/machinery/toast_machine/Initialize(mapload)
	. = ..()
	done_overlay = mutable_appearance('icons/effects/effects.dmi', "sparkles", ABOVE_OBJ_LAYER)
	done_overlay.pixel_y = -1
	RegisterSignal(src, COMSIG_ATOM_EXPOSE_REAGENT, PROC_REF(on_expose_reagent))
	lid_open = FALSE
	toast_state = TOAST_IDLE
	refresh_machine_state()

/obj/machinery/toast_machine/Destroy()
	stop_running_sound_immediately()
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
	return ..() || (lid_open && toast_state != TOAST_RUNNING && contained in toasting_objects)

/obj/machinery/toast_machine/proc/on_expose_reagent(atom/parent_atom, datum/reagent/exposing_reagent, reac_volume, methods)
	SIGNAL_HANDLER
	// Reserved for future reagent interactions; the press is currently inert to splashes.
	return NONE

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
	if(!can_interact_now(user))
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

/obj/machinery/toast_machine/proc/can_interact_now(mob/user, show_feedback = TRUE)
	if(state_transition_in_progress)
		apply_interaction_cooldown()
		if(show_feedback && user)
			balloon_alert(user, "busy!")
		return FALSE
	if(world.time < next_interaction_time)
		apply_interaction_cooldown()
		if(show_feedback && user)
			balloon_alert(user, "wait!")
		return FALSE
	return TRUE

/obj/machinery/toast_machine/proc/can_start_toasting(mob/user, show_feedback = TRUE)
	if(state_transition_in_progress)
		apply_interaction_cooldown()
		if(show_feedback && user)
			balloon_alert(user, "busy!")
		return FALSE
	if(toast_state == TOAST_RUNNING)
		apply_interaction_cooldown()
		return FALSE
	if(!anchored)
		apply_interaction_cooldown()
		if(show_feedback && user)
			to_chat(user, span_warning("You need to secure [src] before you can use it."))
			balloon_alert(user, "secure first!")
		return FALSE
	if(machine_stat & BROKEN)
		apply_interaction_cooldown()
		if(show_feedback && user)
			to_chat(user, span_warning("[src] is broken down."))
			balloon_alert(user, "broken!")
		return FALSE
	if(machine_stat & NOPOWER)
		apply_interaction_cooldown()
		if(show_feedback && user)
			to_chat(user, span_warning("[src] doesn't have any power."))
			balloon_alert(user, "no power!")
		return FALSE
	if(!has_cookable_contents())
		apply_interaction_cooldown()
		if(show_feedback && user)
			to_chat(user, span_warning("There's nothing in [src] that can be toasted."))
			balloon_alert(user, "nothing to toast!")
		return FALSE
	return TRUE

/obj/machinery/toast_machine/proc/can_access_press(mob/user, show_feedback = TRUE)
	if(toast_state == TOAST_RUNNING)
		apply_interaction_cooldown()
		if(show_feedback && user)
			to_chat(user, span_warning("[src] is closed and running."))
			balloon_alert(user, "busy!")
		return FALSE
	if(!lid_open)
		apply_interaction_cooldown()
		if(show_feedback && user)
			to_chat(user, span_warning("You need to open [src] first."))
			balloon_alert(user, "open lid!")
		return FALSE
	return TRUE

/obj/machinery/toast_machine/proc/apply_interaction_cooldown(delay = 1)
	next_interaction_time = max(next_interaction_time, world.time + delay)

/obj/machinery/toast_machine/proc/set_toast_state(new_state, mob/user = null, reason = null, play_transition_sound = TRUE)
	if(state_transition_in_progress)
		return FALSE
	if(new_state == toast_state && new_state != TOAST_INTERRUPTED)
		return FALSE

	state_transition_in_progress = TRUE
	apply_interaction_cooldown()

	var/old_state = toast_state
	var/was_running = old_state == TOAST_RUNNING
	var/final_state = new_state

	if(new_state == TOAST_RUNNING)
		lid_open = FALSE
		toast_state = TOAST_RUNNING
		sync_on_state()
		update_use_power(ACTIVE_POWER_USE)
		begin_processing()
		if(play_transition_sound && !was_running)
			addtimer(CALLBACK(src, PROC_REF(play_transitionsound), 'sound/machines/toast/toast_machine_closing.ogg'), 0.1 SECONDS)
		refresh_machine_state()
		state_transition_in_progress = FALSE
		return TRUE

	if(was_running)
		end_processing()
		stop_running_sound_immediately()

	if(new_state == TOAST_INTERRUPTED)
		toast_state = TOAST_INTERRUPTED
		if(reason == "power_lost")
			final_state = TOAST_NOPOWER
		else
			final_state = TOAST_IDLE
		lid_open = TRUE
		if(play_transition_sound && was_running)
			addtimer(CALLBACK(src, PROC_REF(play_transitionsound), 'sound/machines/toast/toast_machine_opening.ogg'), 0.1 SECONDS)
	else if(play_transition_sound && was_running)
		addtimer(CALLBACK(src, PROC_REF(play_transitionsound), 'sound/machines/toast/toast_machine_opening.ogg'), 0.1 SECONDS)

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

/obj/machinery/toast_machine/proc/play_transitionsound(soundfile)
	playsound(src, soundfile, 50, FALSE)

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
		ensure_running_sound_active()
		reconcile_running_sound_listeners()
	else
		stop_running_sound()

/obj/machinery/toast_machine/proc/is_toast_loop_active()
	return active_running_sound && current_toast_loop_channel

/obj/machinery/toast_machine/proc/stop_running_sound()
	stop_running_sound_immediately()

/obj/machinery/toast_machine/proc/stop_running_sound_immediately()
	var/current_channel = current_toast_loop_channel
	var/list/listeners_to_stop = current_toast_loop_listeners.Copy()
	var/list/pending_listeners_to_clear = current_toast_pending_login_listeners.Copy()
	active_running_sound = null
	current_toast_loop_channel = null
	current_toast_loop_listeners.Cut()
	current_toast_pending_login_listeners.Cut()
	if(current_channel)
		for(var/mob/hearer as anything in listeners_to_stop)
			unregister_running_sound_listener_signals(hearer)
			if(QDELETED(hearer) || !hearer.client)
				continue
			hearer.stop_sound_channel(current_channel)
		SSsounds.free_sound_channel(current_channel)
	for(var/mob/hearer as anything in pending_listeners_to_clear)
		unregister_running_sound_listener_signals(hearer)

/obj/machinery/toast_machine/proc/ensure_running_sound_active()
	if(active_running_sound && current_toast_loop_channel)
		return TRUE
	if(!current_toast_loop_channel)
		current_toast_loop_channel = SSsounds.reserve_sound_channel_datumless()
		if(!current_toast_loop_channel)
			return FALSE
	for(var/mob/hearer as anything in current_toast_loop_listeners.Copy())
		deregister_running_sound_listener(hearer)
	for(var/mob/hearer as anything in current_toast_pending_login_listeners.Copy())
		deregister_running_sound_listener(hearer)
	active_running_sound = sound(TOAST_RUNNING_SOUND)
	active_running_sound.channel = current_toast_loop_channel
	active_running_sound.repeat = TRUE
	active_running_sound.wait = 0
	active_running_sound.volume = TOAST_RUNNING_SOUND_VOLUME
	active_running_sound.falloff = get_running_sound_max_distance()
	var/area/machine_area = get_area(src)
	active_running_sound.environment = machine_area ? machine_area.sound_environment : SOUND_ENVIRONMENT_NONE
	return TRUE

/obj/machinery/toast_machine/proc/reconcile_running_sound_listeners()
	if(!active_running_sound || !current_toast_loop_channel)
		return

	var/list/hearers = get_running_sound_hearers()
	for(var/mob/old_hearer as anything in current_toast_loop_listeners.Copy())
		if(!(old_hearer in hearers))
			deregister_running_sound_listener(old_hearer)

	for(var/mob/hearer as anything in hearers)
		if(!(hearer in current_toast_loop_listeners))
			register_running_sound_listener(hearer)
		else
			update_running_sound_listener(hearer)

/obj/machinery/toast_machine/proc/register_running_sound_listener(mob/hearer)
	if(QDELETED(hearer) || !active_running_sound || !current_toast_loop_channel)
		return
	if(hearer in current_toast_loop_listeners)
		update_running_sound_listener(hearer)
		return
	if(hearer in current_toast_pending_login_listeners)
		current_toast_pending_login_listeners -= hearer
	if(!hearer.client)
		register_pending_running_sound_listener(hearer)
		return

	current_toast_loop_listeners += hearer
	register_active_running_sound_listener_signals(hearer)
	send_running_sound_to_listener(hearer, FALSE)

/obj/machinery/toast_machine/proc/deregister_running_sound_listener(mob/hearer)
	if(!(hearer in current_toast_loop_listeners) && !(hearer in current_toast_pending_login_listeners))
		return
	current_toast_loop_listeners -= hearer
	current_toast_pending_login_listeners -= hearer
	unregister_running_sound_listener_signals(hearer)
	if(current_toast_loop_channel && hearer && hearer.client)
		hearer.stop_sound_channel(current_toast_loop_channel)

/obj/machinery/toast_machine/proc/register_pending_running_sound_listener(mob/hearer)
	if(QDELETED(hearer) || hearer in current_toast_pending_login_listeners)
		return
	current_toast_pending_login_listeners += hearer
	RegisterSignal(hearer, COMSIG_QDELETING, PROC_REF(running_sound_listener_deleted))
	RegisterSignal(hearer, COMSIG_MOB_LOGIN, PROC_REF(running_sound_listener_login))

/obj/machinery/toast_machine/proc/register_active_running_sound_listener_signals(mob/hearer)
	RegisterSignal(hearer, COMSIG_QDELETING, PROC_REF(running_sound_listener_deleted))
	RegisterSignal(hearer, COMSIG_MOVABLE_MOVED, PROC_REF(running_sound_listener_moved))
	RegisterSignal(hearer, COMSIG_MOB_LOGOUT, PROC_REF(running_sound_listener_logout))
	RegisterSignals(hearer, list(SIGNAL_ADDTRAIT(TRAIT_DEAF), SIGNAL_REMOVETRAIT(TRAIT_DEAF)), PROC_REF(running_sound_listener_deafness_changed))

/obj/machinery/toast_machine/proc/unregister_running_sound_listener_signals(mob/hearer)
	UnregisterSignal(hearer, list(
		COMSIG_QDELETING,
		COMSIG_MOVABLE_MOVED,
		COMSIG_MOB_LOGIN,
		COMSIG_MOB_LOGOUT,
		SIGNAL_ADDTRAIT(TRAIT_DEAF),
		SIGNAL_REMOVETRAIT(TRAIT_DEAF),
	))

/obj/machinery/toast_machine/proc/update_running_sound_listener(mob/hearer)
	if(!(hearer in current_toast_loop_listeners))
		return
	if(!can_listener_hear_running_sound(hearer))
		deregister_running_sound_listener(hearer)
		return
	send_running_sound_to_listener(hearer, TRUE)

/obj/machinery/toast_machine/proc/running_sound_listener_deleted(mob/source)
	SIGNAL_HANDLER
	deregister_running_sound_listener(source)

/obj/machinery/toast_machine/proc/running_sound_listener_login(mob/source)
	SIGNAL_HANDLER
	current_toast_pending_login_listeners -= source
	UnregisterSignal(source, COMSIG_MOB_LOGIN)
	if(toast_state != TOAST_RUNNING || !active_running_sound || !current_toast_loop_channel || !can_listener_hear_running_sound(source))
		deregister_running_sound_listener(source)
		return
	register_running_sound_listener(source)

/obj/machinery/toast_machine/proc/running_sound_listener_logout(mob/source)
	SIGNAL_HANDLER
	if(source in current_toast_loop_listeners)
		current_toast_loop_listeners -= source
	if(current_toast_loop_channel)
		source.stop_sound_channel(current_toast_loop_channel)
	unregister_running_sound_listener_signals(source)
	register_pending_running_sound_listener(source)

/obj/machinery/toast_machine/proc/running_sound_listener_deafness_changed(mob/source)
	SIGNAL_HANDLER
	if(!(source in current_toast_loop_listeners))
		return
	if(HAS_TRAIT(source, TRAIT_DEAF))
		if(current_toast_loop_channel && source.client)
			source.stop_sound_channel(current_toast_loop_channel)
		return
	if(toast_state == TOAST_RUNNING && can_listener_hear_running_sound(source))
		send_running_sound_to_listener(source, FALSE)

/obj/machinery/toast_machine/proc/running_sound_listener_moved(mob/source)
	SIGNAL_HANDLER
	if(toast_state != TOAST_RUNNING || !active_running_sound || !current_toast_loop_channel)
		deregister_running_sound_listener(source)
		return
	update_running_sound_listener(source)

/obj/machinery/toast_machine/proc/get_running_sound_hearers()
	var/max_distance = get_running_sound_max_distance()
	var/audible_distance = CALCULATE_MAX_SOUND_AUDIBLE_DISTANCE(TOAST_RUNNING_SOUND_VOLUME, max_distance, TOAST_RUNNING_SOUND_FALLOFF_DISTANCE, TOAST_RUNNING_SOUND_FALLOFF_EXPONENT)
	var/list/hearers = get_hearers_in_view(audible_distance, src, RECURSIVE_CONTENTS_CLIENT_MOBS)
	for(var/mob/listening_ghost as anything in SSmobs.dead_players_by_zlevel[z])
		if(get_dist(listening_ghost, src) <= audible_distance)
			hearers += listening_ghost
	return hearers

/obj/machinery/toast_machine/proc/can_listener_hear_running_sound(mob/hearer)
	if(QDELETED(hearer) || !hearer.client || !active_running_sound || !current_toast_loop_channel)
		return FALSE
	if(HAS_TRAIT(hearer, TRAIT_DEAF))
		return FALSE
	return hearer in get_running_sound_hearers()

/obj/machinery/toast_machine/proc/send_running_sound_to_listener(mob/hearer, use_update = TRUE)
	if(QDELETED(hearer) || !hearer.client || !active_running_sound || !current_toast_loop_channel)
		return

	var/turf/sound_turf = get_turf(src)
	var/turf/listener_turf = get_turf(hearer)
	if(isnull(sound_turf) || isnull(listener_turf))
		return

	var/new_x = sound_turf.x - listener_turf.x
	var/new_z = sound_turf.y - listener_turf.y

	active_running_sound.status = use_update ? SOUND_UPDATE : NONE
	active_running_sound.x = new_x
	active_running_sound.z = new_z
	active_running_sound.y = (sound_turf.z - listener_turf.z) * 5
	active_running_sound.falloff = get_running_sound_max_distance()
	active_running_sound.volume = TOAST_RUNNING_SOUND_VOLUME
	var/area/machine_area = get_area(src)
	active_running_sound.environment = machine_area ? machine_area.sound_environment : SOUND_ENVIRONMENT_NONE

	SEND_SOUND(hearer, active_running_sound)

/obj/machinery/toast_machine/proc/get_running_sound_max_distance()
	return SOUND_RANGE + TOAST_RUNNING_SOUND_EXTRA_RANGE

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

	reconcile_running_sound_listeners()

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
	if(istype(I, /obj/item/food/turkish_bread/half))
		return 1
	if(istype(I, /obj/item/food/turkish_bread))
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
#undef TOAST_RUNNING_SOUND
#undef TOAST_RUNNING_SOUND_VOLUME
#undef TOAST_RUNNING_SOUND_EXTRA_RANGE
#undef TOAST_RUNNING_SOUND_FALLOFF_DISTANCE
#undef TOAST_RUNNING_SOUND_FALLOFF_EXPONENT

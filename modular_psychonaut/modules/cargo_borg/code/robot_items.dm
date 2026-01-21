/// The fabled paper plane crossbow and its hardlight paper planes.
/obj/item/paperplane/syndicate/hardlight
	name = "hardlight paper plane"
	desc = "Hard enough to hurt, fickle enough to be impossible to pick up."
	eye_dam_lower = 10
	eye_dam_higher = 10
	scrap_on_impact = TRUE
	throw_speed = 0.8
	/// Which color is the paper plane?
	var/list/paper_colors = list(COLOR_CYAN, COLOR_BLUE_LIGHT, COLOR_BLUE)
	alpha = 150 // It's hardlight, it's gotta be see-through.

/obj/item/paperplane/syndicate/hardlight/Initialize(mapload)
	. = ..()
	color = color_hex2color_matrix(pick(paper_colors))
	alpha = initial(alpha) // It's hardlight, it's gotta be see-through.

/obj/item/borg/paperplane_crossbow
	name = "paper plane crossbow"
	desc = "Be careful, don't aim for the eyes- Who am I kidding, <i>definitely</i> aim for the eyes!"
	icon = 'icons/obj/weapons/guns/energy.dmi'
	icon_state = "crossbow_halloween"
	/// Paperplane Type
	var/obj/item/paperplane/planetype = /obj/item/paperplane/syndicate/hardlight
	/// How long is the cooldown between shots?
	var/shooting_delay = 5 SECONDS
	/// Are we ready to fire again?
	COOLDOWN_DECLARE(shooting_cooldown)

/// A proc for shooting a projectile at the target, it's just that simple, really.
/obj/item/borg/paperplane_crossbow/proc/shoot(atom/target, mob/living/silicon/robot/user, params)

	var/obj/item/paperplane/plane_to_fire = new planetype(get_turf(loc))

	playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
	plane_to_fire.throw_at(target, plane_to_fire.throw_range, plane_to_fire.throw_speed, user)
	COOLDOWN_START(src, shooting_cooldown, shooting_delay)
	addtimer(CALLBACK(src, PROC_REF(charge_up), user), shooting_delay)
	user.visible_message(span_warning("[user] shoots a paper plane at [target]!"))

/obj/item/borg/paperplane_crossbow/proc/canshoot(atom/target, mob/living/silicon/robot/user)
	if(!COOLDOWN_FINISHED(src, shooting_cooldown))
		balloon_alert_to_viewers("*click*")
		playsound(src, 'sound/items/weapons/gun/general/dry_fire.ogg', 30, TRUE)
		return FALSE
	if(target == user)
		to_chat(user, span_warning("You cant shoot yourself!"))
		return FALSE
	if(!user.cell.use(50))
		to_chat(user, span_warning("Not enough power."))
		return FALSE
	return TRUE

/obj/item/borg/paperplane_crossbow/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return interact_with_atom(interacting_with, user, modifiers)

/obj/item/borg/paperplane_crossbow/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(iscyborg(user))
		if(!canshoot(interacting_with, user))
			return ITEM_INTERACT_BLOCKING
		shoot(interacting_with, user)
		return ITEM_INTERACT_SUCCESS

/obj/item/borg/paperplane_crossbow/proc/charge_up(mob/living/user)
	to_chat(user, span_warning("[src] silently charges up."))

/obj/item/borg/apparatus/Initialize(mapload)
	update_appearance()
	return ..()

/obj/item/borg/apparatus/paper_holder
	name = "integrated paper holder"
	desc = "A holder for holding papers."
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "clipboard"
	storable = list(/obj/item/paper)

/obj/item/borg/apparatus/paper_holder/update_overlays()
	. = ..()
	. += "clipboard_over"
	var/mutable_appearance/arm = mutable_appearance(icon = icon, icon_state = "clipboard_over")
	if(stored)
		stored.pixel_x = 0
		stored.pixel_y = 0
		var/mutable_appearance/stored_copy = new /mutable_appearance(stored)
		stored_copy.layer = FLOAT_LAYER
		stored_copy.plane = FLOAT_PLANE
		. += stored_copy
	. += arm

/obj/item/borg/apparatus/paper_holder/pre_attack(atom/target, mob/living/user, params)
	if(!user.Adjacent(target))
		return
	if(istype(target, /obj/item/paper_bin) && !stored)
		var/obj/item/paper_bin/paperbin = target

		if(paperbin.total_paper > 0)
			var/obj/item/paper/top_paper = pop(paperbin.paper_stack) || paperbin.generate_paper()
			paperbin.total_paper -= 1
			top_paper.forceMove(src)
			stored = top_paper
			RegisterSignal(stored, COMSIG_ATOM_UPDATED_ICON, PROC_REF(on_stored_updated_icon))
			to_chat(user, span_notice("You take [top_paper] out of [paperbin]."))
			paperbin.update_appearance()
			update_appearance()
		return TRUE
	return ..()

/obj/item/borg/apparatus/paper_holder/examine()
	. = ..()
	if(stored)
		. += "The apparatus currently has [stored] secured."
	. += span_notice(" <i>Alt-click</i> to drop the currently stored paper. ")


/obj/item/borg/cyborg_clamp
	name = "hydraulic clamp"
	desc = "Equipment for cyborgs. Lifts objects and loads them into cargo."
	icon = 'modular_psychonaut/master_files/icons/mob/silicon/robot_items.dmi'
	icon_state = "clamp"
	/// The clamps owner.
	var/mob/living/silicon/robot/host
	/// A list of the that clamp can carry.
	var/list/can_carry = list(/obj/structure/closet/crate, /obj/item/delivery/big)
	/// A list of the that clamp now carrying.
	var/list/stored_things = list()
	/// Time it takes to load a crate.
	var/load_time = 4 SECONDS
	/// The max amount of crates you can carry.
	var/max_capacity = 4
	/// A lazylist of the humans are we carrying.
	var/list/carrying_humans
	/// Cell usage.
	var/cell_usage = 50
	var/list/upgrades = list()

/obj/item/borg/cyborg_clamp/Initialize(mapload)
	host = loc
	START_PROCESSING(SSprocessing, src)
	RegisterSignal(host, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	return ..()

/obj/item/borg/cyborg_clamp/Destroy()
	drop_all_crates()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/borg/cyborg_clamp/proc/on_death(datum/source, gibbed)
	SIGNAL_HANDLER
	drop_all_crates()

/obj/item/borg/cyborg_clamp/dropped()
	host = loc
	drop_all_crates()
	return ..()

/obj/item/borg/cyborg_clamp/equipped()
	host = loc
	return ..()

/obj/item/borg/cyborg_clamp/cyborg_unequip(mob/user)
	drop_all_crates()
	return ..()

/obj/item/borg/cyborg_clamp/click_alt(mob/living/silicon/robot/user)
	drop_all_crates()
	return CLICK_ACTION_SUCCESS

/obj/item/borg/cyborg_clamp/proc/get_host()
	if(istype(host))
		return host
	else
		if(iscyborg(host.loc))
			return host.loc
	return null

/obj/item/borg/cyborg_clamp/proc/drop_all_crates()
	for(var/obj/crate as anything in stored_things)
		crate.forceMove(drop_location())
		stored_things -= crate
	LAZYNULL(carrying_humans)
	update_speedmod()

/obj/item/borg/cyborg_clamp/proc/can_pickup(obj/target)
	if(length(stored_things) >= max_capacity)
		balloon_alert(host, "no space!")
		return FALSE
	for(var/mob/living/mob in target.get_all_contents())
		if(mob.mob_size <= MOB_SIZE_SMALL)
			continue
		if(mob.mob_size == MOB_SIZE_HUMAN && host.emagged)
			continue
		balloon_alert(host, "target too heavy!")
		return FALSE
	if(target.anchored)
		balloon_alert(host, "target is anchored!")
		return FALSE
	return TRUE

/obj/item/borg/cyborg_clamp/pre_attack(atom/target, mob/user)
	var/mob/living/silicon/robot/owner = get_host()
	if(!user.Adjacent(target))
		return
	if(is_type_in_list(target, can_carry))
		var/obj/picked_crate = target
		if(!can_pickup(picked_crate))
			return
		var/obj/structure/closet/c = target
		if(istype(c))
			if(c.opened)
				balloon_alert(host, "close it first!")
				return
		if(!owner.cell.use(cell_usage))
			to_chat(user, span_warning("Not enough power."))
			return
		playsound(src, 'sound/vehicles/mecha/hydraulic.ogg', 25, TRUE)
		if(!do_after(user, load_time, target = target))
			return
		if(!can_pickup(picked_crate))
			return
		if(istype(c))
			if(c.opened)
				return
		if(!user.Adjacent(target))
			return
		stored_things += picked_crate
		picked_crate.forceMove(src)
		for(var/mob/living/mob in picked_crate.get_all_contents())
			if(mob.mob_size == MOB_SIZE_HUMAN)
				LAZYADD(carrying_humans, picked_crate)
		balloon_alert(user, "picked up [picked_crate]")
		update_speedmod()
	else if(length(stored_things))
		var/turf/target_turf = get_turf(target)
		if(isturf(target_turf) && target_turf.is_blocked_turf())
			return
		var/list/crate_radial = list()
		for(var/obj/crate as anything in stored_things)
			crate_radial[crate] = image(crate)
		var/obj/pick = show_radial_menu(user, target_turf, crate_radial, radius = 38, require_near = TRUE)
		if(!pick)
			return
		playsound(src, 'sound/vehicles/mecha/hydraulic.ogg', 25, TRUE)
		if(!do_after(user, load_time, target = target))
			return
		if(target_turf.is_blocked_turf())
			return
		if(pick.loc != src)
			return
		if(!user.Adjacent(target))
			return
		var/obj/dropped_crate = pick
		dropped_crate.forceMove(target_turf)
		stored_things -= pick
		for(var/mob/living/mob in dropped_crate.get_all_contents())
			if(mob.mob_size == MOB_SIZE_HUMAN)
				LAZYREMOVE(carrying_humans, dropped_crate)
		balloon_alert(user, "dropped [dropped_crate]")
		update_speedmod()
	else
		balloon_alert(user, "invalid target!")

/obj/item/borg/cyborg_clamp/examine()
	. = ..()
	var/st = length(stored_things)
	. += "There are [st]/[max_capacity] things were picked up here."
	if(st)
		. += "Stored:"
		for(var/obj/crate as anything in stored_things)
			. += " [crate.name]"
	if(LAZYLEN(carrying_humans))
		. += span_warning(" DANGER!! High weight detected..! ")
	. += span_notice(" <i>Alt-click</i> to drop all the crates. ")

/obj/item/borg/cyborg_clamp/proc/update_speedmod()
	var/mob/living/silicon/robot/owner = get_host()
	if(LAZYLEN(carrying_humans))
		owner?.throw_alert(ALERT_HIGHWEIGHT, /atom/movable/screen/alert/highweight)
		owner?.add_movespeed_modifier(/datum/movespeed_modifier/cyborgclamp)
	else
		owner?.clear_alert(ALERT_HIGHWEIGHT)
		owner?.remove_movespeed_modifier(/datum/movespeed_modifier/cyborgclamp)

/obj/item/borg/cyborg_clamp/process(seconds_per_tick)
	var/humans = LAZYLEN(carrying_humans)
	if(humans)
		var/mob/living/silicon/robot/owner = get_host()
		owner?.adjust_brute_loss(0.4 * seconds_per_tick * humans)
		if(!owner.cell?.use(5 * seconds_per_tick))
			owner.logevent("ERROR: NO POWER")
			drop_all_crates()

/obj/item/storage/bag/mail/borg
	resistance_flags = NONE

/obj/item/storage/bag/mail/borg/pre_attack(atom/target, mob/user)
	. = ..()
	if(.)
		return
	if(!user.Adjacent(target))
		return
	if(length(contents))
		var/turf/target_turf = get_turf(target)
		if(!isturf(target_turf))
			return
		var/obj/pick = tgui_input_list(user, "Which one will you drop?", "Mail Bag", contents)
		if(isnull(pick))
			return
		if(pick.loc != src)
			return
		if(!user.Adjacent(target))
			return
		atom_storage.attempt_remove(pick, target_turf)

/obj/item/universal_scanner/robot
	name = "integrated universal scanner"

/obj/item/universal_scanner/robot/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(scanning_mode == SCAN_SALES_TAG && isidcard(interacting_with))
		var/obj/item/card/id/potential_acc = interacting_with
		if(potential_acc.registered_account)
			if(payments_acc == potential_acc.registered_account)
				to_chat(user, span_notice("ID card already registered."))
				return ..()
			else
				payments_acc = potential_acc.registered_account
				playsound(src, 'sound/machines/ping.ogg', 40, TRUE)
				to_chat(user, span_notice("[src] registers the ID card. Tag a wrapped item to create a barcode."))
		else if(!potential_acc.registered_account)
			to_chat(user, span_warning("This ID card has no account registered!"))
			return ..()
	return ..()

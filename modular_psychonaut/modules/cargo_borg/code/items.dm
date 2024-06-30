/** Mail Bag */

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

/** Crossbow */

/obj/item/borg/paperplane_crossbow
	name = "paper plane crossbow"
	desc = "Be careful, don't aim for the eyes- Who am I kidding, <i>definitely</i> aim for the eyes!"
	icon = 'icons/obj/weapons/guns/energy.dmi'
	icon_state = "crossbow_halloween"
	/// How long is the cooldown between shots?
	var/shooting_delay = 5 SECONDS
	/// Are we ready to fire again?
	COOLDOWN_DECLARE(shooting_cooldown)

/obj/item/borg/paperplane_crossbow/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return interact_with_atom(interacting_with, user, modifiers)

/obj/item/borg/paperplane_crossbow/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(iscyborg(user))
		if(!can_shoot(interacting_with, user))
			return ITEM_INTERACT_BLOCKING
		shoot(interacting_with, user)
		return ITEM_INTERACT_SUCCESS

/// A proc for shooting a projectile at the target, it's just that simple, really.
/obj/item/borg/paperplane_crossbow/proc/shoot(atom/target, mob/living/silicon/robot/user)
	var/obj/item/paperplane/syndicate/hardlight/plane = new (get_turf(loc))

	COOLDOWN_START(src, shooting_cooldown, shooting_delay)
	addtimer(CALLBACK(src, PROC_REF(charge_up), user), shooting_delay)
	playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
	plane.throw_at(target, plane.throw_range, plane.throw_speed, user)
	user.visible_message(span_warning("[user] shoots a paper plane at [target]!"))

/obj/item/borg/paperplane_crossbow/proc/can_shoot(atom/target, mob/living/silicon/robot/user)
	if(!COOLDOWN_FINISHED(src, shooting_cooldown))
		balloon_alert_to_viewers("*click*")
		playsound(src, 'sound/weapons/gun/general/dry_fire.ogg', 30, TRUE)
		return FALSE
	if(target == user)
		to_chat(user, span_warning("You can't shoot yourself!"))
		return FALSE
	if(!user.cell.use(50))
		to_chat(user, span_warning("Not enough power."))
		return FALSE
	return TRUE

/obj/item/borg/paperplane_crossbow/proc/charge_up(mob/living/user)
	to_chat(user, span_warning("[src] silently charges up."))

/// The fabled paper plane crossbow and its hardlight paper planes.
/obj/item/paperplane/syndicate/hardlight
	name = "hardlight paper plane"
	desc = "Hard enough to hurt, fickle enough to be impossible to pick up."
	eye_damage_lower = 10
	eye_damage_higher = 10
	scrap_on_impact = TRUE
	throw_speed = 0.8
	alpha = 150 // It's hardlight, it's gotta be see-through.

/obj/item/paperplane/syndicate/hardlight/Initialize(mapload)
	. = ..()
	color = color_hex2color_matrix(pick(list(COLOR_CYAN, COLOR_BLUE_LIGHT, COLOR_BLUE)))
	alpha = initial(alpha) // It's hardlight, it's gotta be see-through.

/** Paper Holder */

/obj/item/borg/apparatus/paper_holder
	name = "integrated paper holder"
	desc = "A holder for holding papers."
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "clipboard"
	storable = list(/obj/item/paper)

/obj/item/borg/apparatus/paper_holder/Initialize(mapload)
	. = ..()
	update_appearance(UPDATE_ICON | UPDATE_OVERLAYS)

/obj/item/borg/apparatus/paper_holder/update_overlays()
	. = ..()
	. += mutable_appearance(icon, "clipboard_over")
	if(!isnull(stored))
		var/mutable_appearance/paper_overlay = new (stored)
		paper_overlay.layer = FLOAT_LAYER
		paper_overlay.plane = FLOAT_PLANE
		. += paper_overlay

/obj/item/borg/apparatus/paper_holder/pre_attack(atom/target, mob/living/user, params)
	if(!user.Adjacent(target))
		return
	if(isnull(stored) && istype(target, /obj/item/paper_bin))
		var/obj/item/paper_bin/paper_bin = target

		if(paper_bin.total_paper > 0)
			var/obj/item/paper/top_paper = pop(paper_bin.paper_stack) || paper_bin.generate_paper()
			paper_bin.total_paper -= 1
			top_paper.forceMove(src)
			stored = top_paper
			RegisterSignal(stored, COMSIG_ATOM_UPDATED_ICON, PROC_REF(on_stored_updated_icon))
			to_chat(user, span_notice("You take [top_paper] out of [paper_bin]."))
			paper_bin.update_appearance()
			update_appearance()
		return TRUE
	return ..()

/obj/item/borg/apparatus/paper_holder/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(istype(arrived, /obj/item/paper))
		arrived.pixel_x = 0
		arrived.pixel_y = 0

/obj/item/borg/apparatus/paper_holder/examine()
	. = ..()
	if(!isnull(stored))
		. += "The apparatus currently has [stored] secured."
	. += span_notice(" <i>Alt-click</i> to drop the currently stored paper. ")

/** Clamp */

/obj/item/borg/cyborg_clamp
	name = "hydraulic clamp"
	desc = "Equipment for cyborgs. Lifts objects and loads them into cargo."
	icon = 'modular_psychonaut/modules/cargo_borg/icons/items.dmi'
	icon_state = "clamp"
	/// The clamp's owner.
	var/mob/living/silicon/robot/host
	/// A list of objects that clamp can carry.
	var/list/allowed_crate_types = list(/obj/structure/closet/crate, /obj/item/delivery/big)
	/// A lazylist of the packages are we carrying.
	var/list/stored_crates
	/// A lazylist of the humans are we carrying.
	var/list/stored_humans
	/// How much time it takes to load a crate.
	var/load_time = 4 SECONDS
	/// The max amount of crates you can carry.
	var/max_capacity = 4
	/// Number of installed upgrades
	var/upgraded = 0
	/// The amount of power used when picking up a crate
	var/cell_usage = 50

/obj/item/borg/cyborg_clamp/Initialize(mapload)
	host = loc
	RegisterSignal(host, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	return ..()

/obj/item/borg/cyborg_clamp/Destroy()
	drop_all_crates()
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

/obj/item/borg/cyborg_clamp/click_alt(mob/user)
	drop_all_crates()
	return CLICK_ACTION_SUCCESS

/obj/item/borg/cyborg_clamp/proc/get_host()
	if(istype(host))
		return host
	else
		if(iscyborg(host.loc))
			return host.loc
	return

/obj/item/borg/cyborg_clamp/proc/drop_all_crates()
	if(LAZYLEN(stored_crates))
		for(var/obj/crate as anything in stored_crates)
			crate.forceMove(drop_location())
		stored_crates = null
	LAZYNULL(stored_humans)
	update_speedmod()

/obj/item/borg/cyborg_clamp/proc/can_pickup(obj/target)
	if(LAZYLEN(stored_crates) >= max_capacity)
		balloon_alert(host, "no space!")
		return FALSE

	for(var/mob/living/mob in target.get_all_contents())
		if(mob.mob_size <= MOB_SIZE_SMALL)
			continue
		if(mob.mob_size == MOB_SIZE_HUMAN && host.emagged)
			continue
		balloon_alert(host, "too heavy!")
		return FALSE

	if(target.anchored)
		balloon_alert(host, "unanchor first!")
		return FALSE

	if(istype(target, /obj/structure/closet))
		var/obj/structure/closet/closet = target
		if(closet.opened)
			balloon_alert(host, "close first!")
			return

	return TRUE

/obj/item/borg/cyborg_clamp/pre_attack(atom/target, mob/user)
	var/mob/living/silicon/robot/owner = get_host()

	if(!user.Adjacent(target))
		return

	if(is_type_in_list(target, allowed_crate_types))
		var/obj/crate = target

		if(!can_pickup(crate))
			return

		if(!owner.cell.use(cell_usage))
			to_chat(user, span_warning("Not enough power."))
			return

		playsound(src, 'sound/mecha/hydraulic.ogg', 25, TRUE)

		if(!do_after(user, load_time, crate) || !user.Adjacent(crate) || !can_pickup(crate))
			return

		crate.forceMove(src)

		LAZYADD(stored_crates, crate)
		LAZYINITLIST(stored_humans)
		for(var/mob/living/mob in crate.get_all_contents())
			if(mob.mob_size == MOB_SIZE_HUMAN)
				stored_humans += crate

		balloon_alert(user, "picked up [crate]")
		update_speedmod()
	else if(LAZYLEN(stored_crates))
		var/turf/target_turf = get_turf(target)

		if(!isturf(target_turf) || target_turf.is_blocked_turf())
			return

		var/list/choices = list()
		for(var/obj/crate as anything in stored_crates)
			choices[crate] = image(crate)

		var/obj/crate = show_radial_menu(user, target_turf, choices, radius = 38, require_near = TRUE)

		if(isnull(crate))
			return

		playsound(src, 'sound/mecha/hydraulic.ogg', 25, TRUE)

		if(!do_after(user, load_time, target) || (crate.loc != src) || !user.Adjacent(target) || target_turf.is_blocked_turf())
			return

		crate.forceMove(target_turf)

		LAZYREMOVE(stored_crates, crate)
		for(var/mob/living/mob in crate.get_all_contents())
			if(mob.mob_size == MOB_SIZE_HUMAN)
				stored_humans -= crate
		UNSETEMPTY(stored_humans)

		balloon_alert(user, "dropped [crate]")
		update_speedmod()
	else
		balloon_alert(user, "invalid target!")

/obj/item/borg/cyborg_clamp/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(LAZYLEN(stored_crates) == 1)
		START_PROCESSING(SSprocessing, src)

/obj/item/borg/cyborg_clamp/Exited(atom/movable/gone, direction)
	. = ..()
	if(!LAZYLEN(stored_crates))
		STOP_PROCESSING(SSprocessing, src)

/obj/item/borg/cyborg_clamp/process(seconds_per_tick)
	var/mob/living/silicon/robot/owner

	var/crates = LAZYLEN(stored_crates)
	var/humans = LAZYLEN(stored_humans)

	if(crates || humans)
		owner = get_host()

	if(crates)
		if(!owner.cell?.use(cell_usage / 5 * seconds_per_tick * crates))
			owner.logevent("ERROR: NO POWER")
			drop_all_crates()

	if(humans)
		owner?.adjustBruteLoss(1.2 * seconds_per_tick * humans)

/obj/item/borg/cyborg_clamp/proc/update_speedmod()
	var/mob/living/silicon/robot/owner = get_host()

	if(LAZYLEN(stored_humans))
		owner?.throw_alert(ALERT_HIGHWEIGHT, /atom/movable/screen/alert/highweight)
		owner?.add_movespeed_modifier(/datum/movespeed_modifier/cyborg_clamp)
	else
		owner?.clear_alert(ALERT_HIGHWEIGHT)
		owner?.remove_movespeed_modifier(/datum/movespeed_modifier/cyborg_clamp)

/obj/item/borg/cyborg_clamp/examine()
	. = ..()

	var/crates = LAZYLEN(stored_crates)

	. += "There are [crates]/[max_capacity] things were picked up here."

	if(crates)
		. += " They are: "
		for(var/obj/crate as anything in stored_crates)
			. += "[crate]"

	if(LAZYLEN(stored_humans))
		. += span_warning(" DANGER!! High weight detected..! ")

	. += span_notice(" <i>Alt-click</i> to drop all the crates. ")

/atom/movable/screen/alert/highweight
	name = "High Weight"
	desc = "You're getting crushed by high weight, movement will be slowed. You'll also accumulate brute damage!"
	icon_state = "paralysis"

/datum/movespeed_modifier/cyborg_clamp
	multiplicative_slowdown = 0.5

/** Stamp */

/obj/item/stamp/borg
	name = "integrated rubber stamp"
	icon = 'modular_psychonaut/master_files/icons/obj/service/bureaucracy.dmi'
	icon_state = "stamp-borg"
	dye_color = DYE_BLUE

/obj/item/paperwork/borg
	icon = 'modular_psychonaut/master_files/icons/obj/service/bureaucracy.dmi'
	stamp_requested = /obj/item/stamp/borg
	stamp_job = /datum/job/cyborg
	stamp_icon = "paper_stamp-borg"

/** Upgrades */

/obj/item/borg/upgrade/clamp
	name = "cargo cyborg clamp upgrade"
	desc = "A upgraded hydraulic clamp replacement for the cargo model's standard clamp."
	icon = 'modular_psychonaut/master_files/icons/obj/devices/circuitry_n_data.dmi'
	icon_state = "cyborg_upgrade5"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/cargo)
	model_flags = BORG_MODEL_CARGO

/obj/item/borg/upgrade/clamp/action(mob/living/silicon/robot/borg, mob/living/user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/cyborg_clamp/clamp = locate() in borg.model
		if(clamp.upgraded == 3)
			user.balloon_alert("no room!")
			return FALSE
		clamp.upgraded += 1
		if(clamp.upgraded == 1)
			clamp.icon_state = "uclamp"

/obj/item/borg/upgrade/clamp/deactivate(mob/living/silicon/robot/borg, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/cyborg_clamp/clamp = locate() in borg.model
		clamp.upgraded -= 1
		if(clamp.upgraded == 0)
			clamp.icon_state = "clamp"

/obj/item/borg/upgrade/clamp/capacity
	name = "clamp capacity upgrade"
	desc = "A upgrade for increase clamp's capacity."

/obj/item/borg/upgrade/clamp/capacity/action(mob/living/silicon/robot/borg, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/cyborg_clamp/clamp = locate() in borg.model
		clamp.max_capacity += 2

/obj/item/borg/upgrade/clamp/capacity/deactivate(mob/living/silicon/robot/borg, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/cyborg_clamp/clamp = locate() in borg.model
		clamp.max_capacity -= 2

/obj/item/borg/upgrade/clamp/charge
	name = "clamp charge upgrade"
	desc = "A upgrade for decrease clamp's use charge."

/obj/item/borg/upgrade/clamp/charge/action(mob/living/silicon/robot/borg, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/cyborg_clamp/clamp = locate() in borg.model
		clamp.cell_usage /= 2

/obj/item/borg/upgrade/clamp/charge/deactivate(mob/living/silicon/robot/borg, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/cyborg_clamp/clamp = locate() in borg.model
		clamp.cell_usage *= 2

/obj/item/borg/upgrade/clamp/speed
	name = "clamp speed upgrade"
	desc = "A upgrade for decrease clamp's use time."

/obj/item/borg/upgrade/clamp/speed/action(mob/living/silicon/robot/borg, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/cyborg_clamp/clamp = locate() in borg.model
		clamp.load_time /= 1.5

/obj/item/borg/upgrade/clamp/speed/deactivate(mob/living/silicon/robot/borg, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/cyborg_clamp/clamp = locate() in borg.model
		clamp.load_time *= 1.5

/obj/item/borg/upgrade/clamp/carry
	name = "clamp carry upgrade"
	desc = "A upgrade for increase what that clamp can carry."
	allow_duplicates = FALSE

/obj/item/borg/upgrade/clamp/carry/action(mob/living/silicon/robot/borg, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/cyborg_clamp/clamp = locate() in borg.model
		clamp.allowed_crate_types = list(/obj/structure/closet/crate, /obj/item/delivery/big, /obj/structure/closet,  /obj/structure/reagent_dispensers)

/obj/item/borg/upgrade/clamp/carry/deactivate(mob/living/silicon/robot/borg, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/cyborg_clamp/clamp = locate() in borg.model
		clamp.allowed_crate_types = clamp::allowed_crate_types

/obj/item/gun/energy/kinesis
	name = "Zero Point Energy Field Manipulator"
	desc = "A tractor beam-type weapon designed for handling hazardous anomalys."
	icon = 'icons/psychonaut/obj/weapons/guns/energy.dmi'
	base_icon_state = "kinesis_gun"
	icon_state = "kinesis_gun"
	inhand_icon_state = "smoothbore1"
	w_class = WEIGHT_CLASS_HUGE
	weapon_weight = WEAPON_MEDIUM
	automatic_charge_overlays = FALSE
	display_empty = FALSE

	/// Range of the knesis grab.
	var/grab_range = 15
	/// Atom we grabbed with kinesis.
	var/obj/grabbed_atom
	/// Ref of the beam following the grabbed atom.
	var/datum/beam/kinesis_beam
	/// Overlay we add to each grabbed atom.
	var/mutable_appearance/kinesis_icon
	/// Our mouse movement catcher.
	var/atom/movable/screen/fullscreen/cursor_catcher/kinesis/kinesis_catcher
	/// The sounds playing while we grabbed an object.
	var/datum/looping_sound/gravgen/kinesis/soundloop
	var/has_core = FALSE
	var/outline_effect = "#e47900"

	var/mob/living/owner = null
	cell_type = /obj/item/stock_parts/power_store/cell/high

/obj/item/gun/energy/kinesis/Initialize(mapload)
	. = ..()
	soundloop = new(src)
	AddComponent(/datum/component/two_handed, require_twohands = TRUE)

/obj/item/gun/energy/kinesis/Destroy(mob/user)
	clear_grab()
	QDEL_NULL(soundloop)
	return ..()

/obj/item/gun/energy/kinesis/dropped(mob/user)
	..()
	clear_grab()
	owner = null

/obj/item/gun/energy/kinesis/equipped(mob/user)
	..()
	clear_grab()
	owner = user

/obj/item/gun/energy/kinesis/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(isliving(user))
		add_fingerprint(user)
	if(grabbed_atom)
		return
	if(!range_check(target))
		balloon_alert(user, "too far!")
		return
	if(!can_grab(target))
		balloon_alert(user, "can't grab!")
		return
	if(!cell.use(STANDARD_CELL_CHARGE * 5))
		balloon_alert_to_viewers("*click*")
		playsound(src, dry_fire_sound, dry_fire_sound_volume, TRUE)
		return
	grab_atom(target)

/obj/item/gun/energy/kinesis/examine(mob/user)
	. = ..()
	. += span_notice("It glows [has_core ? "blue" : "orange"]")
	if(!has_core)
		. += span_notice("You can insert \a gravitational anomaly core for upgrade [src].")

/obj/item/gun/energy/kinesis/proc/can_grab(atom/target)
	if(owner == target)
		return FALSE
	if(!ismovable(target))
		return FALSE
	if(iseffect(target) && !istype(target, /obj/effect/anomaly))
		return FALSE
	var/atom/movable/movable_target = target
	if(movable_target.throwing)
		return FALSE
	if(check_for_containment_field(owner, target))
		return FALSE
	if(istype(target, /obj/energy_ball))
		return TRUE
	if(istype(target, /obj/singularity))
		return TRUE
	if(istype(target, /obj/effect/anomaly))
		return TRUE
	return FALSE

/obj/item/gun/energy/kinesis/proc/range_check(atom/target)
	if(!isturf(owner.loc))
		return FALSE
	if(ismovable(target) && !isturf(target.loc))
		return FALSE
	if(!can_see(owner, target, grab_range))
		return FALSE
	return TRUE

/obj/item/gun/energy/kinesis/update_icon_state()
	icon_state = "[has_core ? "super_":""][base_icon_state][grabbed_atom ? "_on":""]"
	return ..()

/obj/item/gun/energy/kinesis/singularity_pull(atom/singularity, current_size)
	if(!isloc(src) || !isliving(loc))
		return ..()
	var/mob/living/user = loc
	if(user.get_active_held_item() != src)
		return ..()
	return

/obj/item/gun/energy/kinesis/proc/on_catcher_click(atom/source, location, control, params, user)
	SIGNAL_HANDLER

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		clear_grab()

/obj/item/gun/energy/kinesis/proc/on_setanchored(atom/movable/grabbed_atom, anchorvalue)
	SIGNAL_HANDLER

	if(grabbed_atom.anchored)
		clear_grab()

/obj/item/gun/energy/kinesis/proc/clear_callback()
	SIGNAL_HANDLER
	clear_grab()

/obj/item/gun/energy/kinesis/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(istype(tool, /obj/item/assembly/signaler/anomaly))
		var/obj/item/assembly/signaler/anomaly/anomaly = tool
		if(ispath(anomaly.anomaly_type, /obj/effect/anomaly/grav))
			to_chat(user, span_notice("You brought the [anomaly] closer to the gun and the [anomaly] crumbled into dust."))
			has_core = TRUE
			outline_effect = "#008cff"
			update_icon_state()
			qdel(anomaly)
			return ITEM_INTERACT_SUCCESS

/obj/item/gun/energy/kinesis/proc/grab_atom(atom/movable/target)
	grabbed_atom = target
	grabbed_atom.add_traits(list(TRAIT_NO_FLOATING_ANIM, TRAIT_GRABBED_BY_KINESIS), REF(src))
	RegisterSignal(grabbed_atom, COMSIG_MOVABLE_SET_ANCHORED, PROC_REF(on_setanchored))
	playsound(grabbed_atom, 'sound/items/weapons/contractor_baton/contractorbatonhit.ogg', 75, TRUE)
	grabbed_atom.add_filter("zpef_glow", 2, list("type" = "outline", "color" = outline_effect, "size" = 1))
	if(has_core)
		kinesis_icon = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "kinesis", layer = grabbed_atom.layer - 0.1)
		kinesis_icon.appearance_flags = RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM
		kinesis_icon.overlays += emissive_appearance(icon = 'icons/effects/effects.dmi', icon_state = "kinesis", offset_spokesman = grabbed_atom)
		grabbed_atom.add_overlay(kinesis_icon)
		kinesis_beam = owner.Beam(grabbed_atom, "kinesis")
		kinesis_catcher = owner.overlay_fullscreen("kinesis", /atom/movable/screen/fullscreen/cursor_catcher/kinesis, 0)
		kinesis_catcher.assign_to_mob(owner)
	RegisterSignal(kinesis_catcher, COMSIG_SCREEN_ELEMENT_CLICK, PROC_REF(on_catcher_click))
	soundloop.start()
	START_PROCESSING(SSfastprocess, src)
	update_icon_state()
	addtimer(CALLBACK(src, PROC_REF(clear_callback)), 6 SECONDS)

/obj/item/gun/energy/kinesis/proc/clear_grab(playsound = TRUE)
	if(!grabbed_atom)
		return
	. = grabbed_atom
	if(playsound)
		playsound(grabbed_atom, 'sound/effects/empulse.ogg', 75, TRUE)
	STOP_PROCESSING(SSfastprocess, src)
	UnregisterSignal(grabbed_atom, list(COMSIG_MOB_STATCHANGE, COMSIG_MOVABLE_SET_ANCHORED))
	kinesis_catcher = null
	owner?.clear_fullscreen("kinesis")
	grabbed_atom.remove_filter("zpef_glow")
	grabbed_atom.cut_overlay(kinesis_icon)
	QDEL_NULL(kinesis_beam)
	grabbed_atom.remove_traits(list(TRAIT_NO_FLOATING_ANIM, TRAIT_GRABBED_BY_KINESIS), REF(src))
	if(!isitem(grabbed_atom))
		animate(grabbed_atom, 0.2 SECONDS, pixel_x = grabbed_atom.base_pixel_x, pixel_y = grabbed_atom.base_pixel_y)
	grabbed_atom = null
	update_icon_state()
	soundloop.stop()

/obj/item/gun/energy/kinesis/process(seconds_per_tick)
	if(!owner.client || INCAPACITATED_IGNORING(owner, INCAPABLE_GRAB))
		clear_grab()
		return
	if(!range_check(grabbed_atom))
		balloon_alert(owner, "out of range!")
		clear_grab()
		return
	var/turf/next_turf = get_turf(owner)
	if(has_core)
		if(kinesis_catcher.mouse_params)
			kinesis_catcher.calculate_params()
		if(!kinesis_catcher.given_turf)
			return
		owner.setDir(get_dir(owner, grabbed_atom))
		if(grabbed_atom.loc == kinesis_catcher.given_turf)
			if(grabbed_atom.pixel_x == kinesis_catcher.given_x - ICON_SIZE_X/2 && grabbed_atom.pixel_y == kinesis_catcher.given_y - ICON_SIZE_Y/2)
				return //spare us redrawing if we are standing still
			animate(grabbed_atom, 0.2 SECONDS, pixel_x = grabbed_atom.base_pixel_x + kinesis_catcher.given_x - ICON_SIZE_X/2, pixel_y = grabbed_atom.base_pixel_y + kinesis_catcher.given_y - ICON_SIZE_Y/2)
			kinesis_beam.redrawing()
			return
		animate(grabbed_atom, 0.2 SECONDS, pixel_x = grabbed_atom.base_pixel_x + kinesis_catcher.given_x - ICON_SIZE_X/2, pixel_y = grabbed_atom.base_pixel_y + kinesis_catcher.given_y - ICON_SIZE_Y/2)
		kinesis_beam.redrawing()
		next_turf = get_step_towards(grabbed_atom, kinesis_catcher.given_turf)
		grabbed_atom.Move(next_turf, get_dir(grabbed_atom, next_turf), 8)
		var/pixel_x_change = 0
		var/pixel_y_change = 0
		var/direction = get_dir(grabbed_atom, next_turf)
		if(direction & NORTH)
			pixel_y_change = ICON_SIZE_Y/2
		else if(direction & SOUTH)
			pixel_y_change = -ICON_SIZE_Y/2
		if(direction & EAST)
			pixel_x_change = ICON_SIZE_X/2
		else if(direction & WEST)
			pixel_x_change = -ICON_SIZE_X/2
		animate(grabbed_atom, 0.2 SECONDS, pixel_x = grabbed_atom.base_pixel_x + pixel_x_change, pixel_y = grabbed_atom.base_pixel_y + pixel_y_change)
		kinesis_beam.redrawing()
	else
		for(var/i in 1 to (3 + grabbed_atom.pixel_x / (grabbed_atom.pixel_x < 0 ? -32:32)))
			next_turf = get_step(next_turf, owner.dir)
		grabbed_atom.forceMove(next_turf)

/obj/item/gun/energy/kinesis/proc/check_for_containment_field(atom/source, atom/target)
	var/result = FALSE
	var/turf/current = get_turf(source)
	var/turf/target_turf = get_turf(target)
	current = get_step_towards(current, target_turf)
	while(current != target_turf)
		if(HAS_TRAIT(current, TRAIT_CONTAINMENT_FIELD))
			result = TRUE
		current = get_step_towards(current, target_turf)
	return result

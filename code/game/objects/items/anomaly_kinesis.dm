/obj/item/gun/energy/kinesis
	name = "Zero Point Energy Field Manipulator"
	desc = "A tractor beam-type weapon designed for handling hazardous anomalys."
	icon = 'icons/psychonaut/obj/device.dmi'
	icon_state = "kinesis_gun"
	inhand_icon_state = "smoothbore1"
	w_class = WEIGHT_CLASS_HUGE
	weapon_weight = WEAPON_HEAVY

	/// Range of the knesis grab.
	var/grab_range = 8
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

	var/mob/living/owner = null
	cell_type = /obj/item/stock_parts/power_store/cell/high

/obj/item/gun/energy/kinesis/Initialize(mapload)
	. = ..()
	soundloop = new(src)

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

/obj/item/gun/energy/kinesis/proc/grab_atom(atom/movable/target)
	grabbed_atom = target
	grabbed_atom.add_traits(list(TRAIT_NO_FLOATING_ANIM, TRAIT_GRABBED_BY_KINESIS), REF(src))
	RegisterSignal(grabbed_atom, COMSIG_MOVABLE_SET_ANCHORED, PROC_REF(on_setanchored))
	playsound(grabbed_atom, 'sound/items/weapons/contractor_baton/contractorbatonhit.ogg', 75, TRUE)
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
	addtimer(CALLBACK(src, PROC_REF(clear_callback)), 7 SECONDS)

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
	grabbed_atom.cut_overlay(kinesis_icon)
	QDEL_NULL(kinesis_beam)
	grabbed_atom.remove_traits(list(TRAIT_NO_FLOATING_ANIM, TRAIT_GRABBED_BY_KINESIS), REF(src))
	if(!isitem(grabbed_atom))
		animate(grabbed_atom, 0.2 SECONDS, pixel_x = grabbed_atom.base_pixel_x, pixel_y = grabbed_atom.base_pixel_y)
	grabbed_atom = null
	soundloop.stop()

/obj/item/gun/energy/kinesis/proc/on_catcher_click(atom/source, location, control, params, user)
	SIGNAL_HANDLER

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		clear_grab()

/obj/item/gun/energy/kinesis/proc/on_setanchored(atom/movable/grabbed_atom, anchorvalue)
	SIGNAL_HANDLER

	if(grabbed_atom.anchored)
		clear_grab()

/obj/item/gun/energy/kinesis/process(seconds_per_tick)
	if(!owner.client || INCAPACITATED_IGNORING(owner, INCAPABLE_GRAB))
		clear_grab()
		return
	if(!range_check(grabbed_atom))
		balloon_alert(owner, "out of range!")
		clear_grab()
		return
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
	var/turf/next_turf = get_step_towards(grabbed_atom, kinesis_catcher.given_turf)
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

/obj/item/gun/energy/kinesis/proc/clear_callback()
	SIGNAL_HANDLER
	clear_grab()

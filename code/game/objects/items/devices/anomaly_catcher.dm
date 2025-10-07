/obj/item/anomaly_catcher
	name = "anomaly catcher"
	desc = "A one-use device capable of capturing an anomaly and keeping it safe for a certain period of time."
	icon = 'icons/psychonaut/obj/device.dmi'
	icon_state = "anomaly_catcher"
	inhand_icon_state = "electronic"
	worn_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	var/obj/catched
	var/mutable_appearance/lightning_overlay
	var/release_timer
	var/is_catched_processing = FALSE

/obj/item/anomaly_catcher/Destroy()
	release()
	return ..()

/obj/item/anomaly_catcher/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	obj_flags |= EMAGGED
	release_timer = addtimer(CALLBACK(src, PROC_REF(release)), 3 MINUTES, (TIMER_UNIQUE|TIMER_OVERRIDE))
	if(istype(catched, /obj/energy_ball) || istype(catched, /obj/singularity))
		var/obj/singularity/singuloose = catched
		singuloose.energy *= 1.5
	return TRUE

/obj/item/anomaly_catcher/update_overlays()
	. = ..()
	if(!isnull(catched))
		var/mutable_appearance/appearance = new (catched)
		var/list/dimensions = get_icon_dimensions(catched.icon)

		appearance.transform = matrix().Scale((1 / (dimensions["width"] / 16)), 1 / (dimensions["height"] / 16))
		appearance.pixel_x = catched.pixel_x
		appearance.pixel_y = catched.pixel_y
		appearance.plane = FLOAT_PLANE
		appearance.layer = FLOAT_LAYER

		. += appearance
		. += "anomaly_catcher_glass"

/obj/item/anomaly_catcher/proc/catch_anomaly(obj/O)
	catched = O
	catched.forceMove(src)
	update_appearance()
	name = "[catched.name] globe"
	if(catched.datum_flags & DF_ISPROCESSING)
		catched.datum_flags &= ~DF_ISPROCESSING
		is_catched_processing = TRUE
	lightning_overlay = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "lightning")
	add_overlay(lightning_overlay)
	release_timer = addtimer(CALLBACK(src, PROC_REF(release)), 2 MINUTES, (TIMER_UNIQUE|TIMER_OVERRIDE))

/obj/item/anomaly_catcher/proc/release()
	SIGNAL_HANDLER
	if(isnull(catched))
		return
	if(is_catched_processing)
		catched.datum_flags |= DF_ISPROCESSING
	catched.forceMove(get_turf(src))
	catched = null
	is_catched_processing = FALSE
	cut_overlay(lightning_overlay)
	lightning_overlay = null
	if(!QDELING(src))
		qdel(src)

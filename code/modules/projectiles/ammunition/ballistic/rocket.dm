/obj/item/ammo_casing/rocket
	name = "\improper Dardo HE rocket"
	desc = "An 84mm High Explosive rocket. Fire at people and pray."
	caliber = CALIBER_84MM
	icon_state = "srm-8"
	base_icon_state = "srm-8"
	projectile_type = /obj/projectile/bullet/rocket
	newtonian_force = 2

/obj/item/ammo_casing/rocket/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)

/obj/item/ammo_casing/rocket/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]"

/obj/item/ammo_casing/rocket/heap
	name = "\improper Dardo HE-AP rocket"
	desc = "An 84mm High Explosive All Purpose rocket. For when you just need something to not exist anymore."
	icon_state = "84mm-heap"
	base_icon_state = "84mm-heap"
	projectile_type = /obj/projectile/bullet/rocket/heap

/obj/item/ammo_casing/rocket/weak
	name = "\improper Dardo HE Low-Yield rocket"
	desc = "An 84mm High Explosive rocket. This one isn't quite as devastating."
	icon_state = "low_yield_rocket"
	base_icon_state = "low_yield_rocket"
	projectile_type = /obj/projectile/bullet/rocket/weak

/obj/item/ammo_casing/rocket/reverse
	projectile_type = /obj/projectile/bullet/rocket/reverse

/obj/item/ammo_casing/a75
	desc = "A .75 bullet casing."
	caliber = CALIBER_75
	icon_state = "s-casing-live"
	base_icon_state = "s-casing-live"
	projectile_type = /obj/projectile/bullet/gyro

/obj/item/ammo_casing/a75/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)

/obj/item/ammo_casing/a75/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]"

/obj/item/ammo_casing/rocket/anomaly_catcher
	icon = 'icons/psychonaut/obj/weapons/guns/ammo.dmi'
	icon_state = "anom-catcher"
	base_icon_state = "anom-catcher"
	projectile_type = /obj/projectile/bullet/anomaly_catcher
	var/atom/movable/catched
	var/mutable_appearance/lightning_overlay
	var/is_catched_processing = FALSE

/obj/item/ammo_casing/rocket/anomaly_catcher/proc/catch_anomaly(obj/O)
	catched = O
	O.forceMove(src)
	if(O.datum_flags & DF_ISPROCESSING)
		O.datum_flags &= ~DF_ISPROCESSING
		is_catched_processing = TRUE
	lightning_overlay = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "lightning")
	add_overlay(lightning_overlay)
	addtimer(CALLBACK(src, PROC_REF(release)), 5 MINUTES)

/obj/item/ammo_casing/rocket/anomaly_catcher/proc/release()
	SIGNAL_HANDLER
	if(isnull(catched))
		return
	if(is_catched_processing)
		datum_flags |= DF_ISPROCESSING
	catched.forceMove(get_turf(src))
	catched = null
	is_catched_processing = FALSE
	cut_overlay(lightning_overlay)
	lightning_overlay = null

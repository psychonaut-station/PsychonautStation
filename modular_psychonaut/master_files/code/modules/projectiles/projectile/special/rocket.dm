/obj/projectile/bullet/anomaly_catcher
	name = "\improper AC200 rocket"
	desc = "Woink."
	icon = 'modular_psychonaut/master_files/icons/obj/weapons/guns/projectiles.dmi'
	icon_state= "anom-catcher"
	damage = 20
	sharpness = NONE
	embed_type = null
	shrapnel_type = null
	ricochets_max = 0
	var/static/list/catchable = list(/obj/energy_ball, /obj/singularity, /obj/effect/anomaly, /mob/living)

/obj/projectile/bullet/anomaly_catcher/impact(atom/target)
	if(!is_type_in_list(target, catchable))
		return ..()

	var/obj/item/anomaly_catcher/catcher = new (get_turf(src))
	var/obj/target_object = target
	catcher.catch_anomaly(target_object)
	deletion_queued = PROJECTILE_IMPACT_DELETE
	return

/obj/projectile/bullet/anomaly_catcher/singularity_act()
	return

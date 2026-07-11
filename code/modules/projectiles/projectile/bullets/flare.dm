/obj/projectile/bullet/a25mm
	name = "\improper RG-915 flare"
	desc = "Woink."
	icon = 'icons/psychonaut/obj/weapons/guns/projectiles.dmi'
	icon_state= "flare-on"
	damage = 5
	sharpness = NONE
	embed_type = null
	shrapnel_type = null
	ricochets_max = 0
	can_hit_turfs = TRUE

/obj/projectile/bullet/a25mm/impact(atom/target)
	var/obj/item/flashlight/flare/flare = new (get_turf(target))
	flare.toggle_light()
	if(isliving(target))
		var/mob/living/living_target = target
		if(flare.get_temperature())
			living_target.ignite_mob()

	deletion_queued = PROJECTILE_IMPACT_DELETE
	return

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

/obj/projectile/bullet/a25mm/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	var/obj/item/flashlight/flare/flare = new (get_turf(src))
	flare.toggle_light()

	if(isliving(target))
		var/mob/living/living_target = target
		living_target.ignite_mob()

	if(istype(target, /obj/structure/alien/weeds))
		. = BULLET_ACT_BLOCK
		qdel(target)

	deletion_queued = PROJECTILE_IMPACT_DELETE

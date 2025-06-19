/obj/projectile/accelerated_particle
	name = "accelerated particles"
	desc = "Small things moving very fast."
	icon = 'icons/psychonaut/obj/machines/engine/particle_accelerator.dmi'
	icon_state = "particle"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	reflectable = TRUE
	range = 20
	speed = 1
	damage = 15
	damage_type = TOX

/obj/projectile/accelerated_particle/weak
	damage = 5

/obj/projectile/accelerated_particle/strong
	damage = 20

/obj/projectile/accelerated_particle/powerful
	damage = 35

/obj/projectile/accelerated_particle/ex_act(severity, target)
	qdel(src)

/obj/projectile/accelerated_particle/singularity_pull()
	return

/obj/projectile/accelerated_particle/impact(atom/A)
	if(QDELETED(A))
		return
	if(istype(A, /obj/machinery/the_singularitygen))
		var/obj/machinery/the_singularitygen/generator = A
		generator.energy += damage
	else if(istype(A, /obj/singularity))
		var/obj/singularity/singuloth = A
		singuloth.energy += damage
	else if(istype(A, /obj/energy_ball))
		var/obj/energy_ball/tesloose = A
		tesloose.energy += damage
		tesloose.external_power_immediate += damage * tesloose.particle_energy
	else if(istype(A, /obj/structure/blob))
		var/obj/structure/blob/blob = A
		blob.take_damage(damage * 0.6)
	return ..()

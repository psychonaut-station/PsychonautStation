/obj/projectile/accelerated_particle
	name = "Accelerated Particles"
	desc = "Small things moving very fast."
	icon = 'icons/psychonaut/obj/machines/engine/particle_accelerator.dmi'
	icon_state = "particle"
	anchored = TRUE
	density = FALSE
	range = 10
	speed = 0.5
	damage = 10
	damage_type = TOX

/obj/projectile/accelerated_particle/weak
	range = 8
	damage = 5

/obj/projectile/accelerated_particle/strong
	range = 15
	damage = 15

/obj/projectile/accelerated_particle/powerful
	range = 20
	damage = 50

/obj/projectile/accelerated_particle/ex_act(severity, target)
	qdel(src)

/obj/projectile/accelerated_particle/singularity_pull()
	return

/obj/projectile/accelerated_particle/Impact(atom/A)
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
	else if(istype(A, /obj/structure/blob))
		var/obj/structure/blob/blob = A
		blob.take_damage(damage * 0.6)
	return ..()

/obj/projectile/energy/accelerated_particle
	name = "Accelerated Particles"
	icon = 'icons/obj/machines/particle_accelerator.dmi'
	icon_state = "particle"
	range = 10
	speed = 1
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	suppressed = FALSE
	hitsound = null
	var/energy = 10
	var/stop_dissipate = FALSE

/obj/projectile/energy/accelerated_particle/on_hit(atom/A, blocked, pierce_hit)
	if(A)
		if(isliving(A))
			var/mob/living/M = A
			M.adjustToxLoss(energy*2)
		else if(istype(A, /obj/machinery/the_singularitygen))
			var/obj/machinery/the_singularitygen/S = A
			if(S.energy <= 0) // we want to first add the energy then start processing so we do not immidiatly stop processing again
				S.energy += energy
				S.begin_processing()
				return
			S.energy += energy
		else if(istype(A, /obj/singularity))
			var/obj/singularity/S = A
			S.energy += energy
		else if(istype(A, /obj/structure/blob))
			var/obj/structure/blob/B = A
			B.take_damage(energy*0.6)
			range = 0

/obj/projectile/energy/accelerated_particle/singularity_pull()
	return

/obj/projectile/energy/accelerated_particle/weak
	range = 8
	energy = 5
	stop_dissipate = TRUE //because its supposed to keep the singu/tesla stable at the same size

/obj/projectile/energy/accelerated_particle/strong
	range = 15
	energy = 15

/obj/projectile/energy/accelerated_particle/powerful
	range = 20
	energy = 50

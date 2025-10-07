/////SINGULARITY SPAWNER
/obj/machinery/the_singularitygen
	name = "gravitational singularity generator"
	desc = "An odd device which produces a Gravitational Singularity when set up."
	icon = 'icons/psychonaut/obj/machines/engine/singularity.dmi'
	icon_state = "TheSingGen"
	anchored = FALSE
	density = TRUE
	use_power = NO_POWER_USE
	resistance_flags = FIRE_PROOF
	max_integrity = 400
	// You can buckle someone to the singularity generator, then start the engine. Fun!
	can_buckle = TRUE
	buckle_lying = FALSE
	buckle_requires_restraints = TRUE

	var/energy = 0
	var/creation_type = /obj/singularity/stationary

/obj/machinery/the_singularitygen/Initialize(mapload)
	. = ..()
	register_context()

/obj/machinery/the_singularitygen/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = NONE
	if(isnull(held_item))
		return

	if(held_item.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_LMB] = "[anchored ? "Uns" : "S"]ecure"
		return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/the_singularitygen/wrench_act(mob/living/user, obj/item/item)
	return default_unfasten_wrench(user, item)

/obj/machinery/the_singularitygen/process()
	if(energy > 0)
		if(energy >= 200)
			var/turf/T = get_turf(src)
			SSblackbox.record_feedback("tally", "engine_started", 1, type)
			var/obj/singularity/S = new creation_type(T, 50)
			transfer_fingerprints_to(S)
			qdel(src)
		else
			energy -= 1

/obj/machinery/the_singularitygen/tesla
	name = "energy ball generator"
	desc = "An odd device which produces a Energy Ball when set up."
	icon = 'icons/obj/machines/engine/tesla_generator.dmi'
	creation_type = /obj/energy_ball/stationary

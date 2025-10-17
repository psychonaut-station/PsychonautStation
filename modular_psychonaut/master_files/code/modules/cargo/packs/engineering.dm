/datum/supply_pack/engine/particle_accelerator
	name = "Particle Accelerator Parts"
	desc = "A supermassive black hole or hyper-powered tesla ball are the perfect way to spice up any party! This \"My First Apocalypse\" kit contains everything you need to build your own Particle Accelerator! Ages 10 and up."
	cost = 3000
	contains = list(
		/obj/item/paper/guides/jobs/engineering/pa = 1,
		/obj/item/circuitboard/machine/pa/control_box = 1,
		/obj/item/circuitboard/machine/pa/end_cap = 1,
		/obj/item/circuitboard/machine/pa/power_box = 1,
		/obj/item/circuitboard/machine/pa/fuel_chamber = 1,
		/obj/item/circuitboard/machine/pa/particle_emitter = 3)
	crate_name = "particle accelerator parts crate"
	dangerous = TRUE

/datum/supply_pack/engine/singulo_gen
	name = "Singularity Generator Crate"
	desc = "The key to unlocking the power of Lord Singuloth. Particle Accelerator not included."
	cost = 5000
	contains = list(/obj/machinery/the_singularitygen = 1)
	crate_name = "singularity generator crate"
	dangerous = TRUE

/datum/supply_pack/engine/tesla_gen
	name = "Tesla Generator Crate"
	desc = "The key to unlocking the power of the Tesla energy ball. Particle Accelerator not included."
	cost = 5000
	contains = list(/obj/machinery/the_singularitygen/tesla = 1)
	crate_name = "tesla generator crate"
	dangerous = TRUE

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
	order_flags = ORDER_DANGEROUS

/datum/supply_pack/engine/singulo_gen
	name = "Singularity Generator Crate"
	desc = "The key to unlocking the power of Lord Singuloth. Particle Accelerator not included."
	cost = 5000
	contains = list(/obj/machinery/the_singularitygen = 1)
	crate_name = "singularity generator crate"
	order_flags = ORDER_DANGEROUS

/datum/supply_pack/engine/tesla_gen
	name = "Tesla Generator Crate"
	desc = "The key to unlocking the power of the Tesla energy ball. Particle Accelerator not included."
	cost = 5000
	contains = list(/obj/machinery/the_singularitygen/tesla = 1)
	crate_name = "tesla generator crate"
	order_flags = ORDER_DANGEROUS

/datum/supply_pack/engineering/anomaly_catcher
	name = "Anomaly Catcher Crate"
	desc = "Contains some tools for containing anomalies"
	cost = CARGO_CRATE_VALUE * 30
	contains = list(/obj/item/storage/toolbox/guncase/anomaly_catcher = 1)
	crate_name = "anomaly catcher crate"

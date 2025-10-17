/obj/item/circuitboard/machine/rad_collector
	name = "Particle Capture Array (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/energy_accumulator/rad_collector
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/datum/stock_part/matter_bin = 1,
		/obj/item/stack/sheet/plasmarglass = 2,
		/datum/stock_part/capacitor = 1,
		/datum/stock_part/servo = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/pa/control_box
	name = "Particle Accelerator Control Box (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/particle_accelerator/control_box
	req_components = list(
		/obj/item/stack/sheet/glass = 10
	)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/pa/end_cap
	name = "Alpha Particle Generation Array (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/particle_accelerator/end_cap
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/datum/stock_part/capacitor/tier4 = 1,
		/obj/item/stack/sheet/iron = 5,
		/datum/stock_part/micro_laser/tier4 = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/pa/power_box
	name = "Particle Focusing EM Lens (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/particle_accelerator/power_box
	req_components = list(
		/obj/item/stack/cable_coil = 3,
		/datum/stock_part/capacitor/tier4 = 1,
		/obj/item/stack/sheet/iron = 2)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/pa/fuel_chamber
	name = "EM Acceleration Chamber (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/particle_accelerator/fuel_chamber
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/datum/stock_part/capacitor/tier4 = 1,
		/obj/item/stack/sheet/iron = 2)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/pa/particle_emitter
	name = "EM Containment Grid (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/particle_accelerator/particle_emitter
	req_components = list(
		/obj/item/stack/cable_coil = 1,
		/datum/stock_part/capacitor/tier4 = 1,
		/obj/item/stack/sheet/plasmaglass = 2,
		/obj/item/stack/sheet/iron = 2,
		/datum/stock_part/micro_laser/tier4 = 2)
	needs_anchored = FALSE

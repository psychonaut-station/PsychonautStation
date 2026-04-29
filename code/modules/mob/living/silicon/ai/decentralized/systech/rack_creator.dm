/obj/machinery/rack_creator
	name = "rack creator"
	desc = "Combines RAM modules and CPUs to create stand-alone racks for decentralized AI systems."
	icon = 'icons/obj/machines/lithography.dmi'
	icon_state = "lithography"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 1000
	active_power_usage = 5000
	circuit = /obj/item/circuitboard/machine/rack_creator

	var/list/obj/item/ai_cpu/inserted_cpus = list()
	var/list/ram_expansions = list()
	var/datum/remote_materials/materials
	var/efficiency_coeff = 1

/obj/machinery/rack_creator/Initialize(mapload)
	materials = new(src, mapload)
	. = ..()
	RefreshParts()

/obj/machinery/rack_creator/Destroy()
	for(var/obj/item/ai_cpu/cpu as anything in inserted_cpus)
		cpu.forceMove(drop_location())
	QDEL_NULL(materials)
	inserted_cpus = null
	ram_expansions = null
	return ..()

/obj/machinery/rack_creator/RefreshParts()
	. = ..()
	calculate_efficiency()

/obj/machinery/rack_creator/proc/calculate_efficiency()
	efficiency_coeff = 1
	var/total_rating = 1.2
	for(var/datum/stock_part/servo/servo in component_parts)
		total_rating = clamp(total_rating - (servo.tier * 0.1), 0, 1)
	if(total_rating == 0)
		efficiency_coeff = INFINITY
	else
		efficiency_coeff = 1 / total_rating

/obj/machinery/rack_creator/proc/get_science_techweb()
	return locate(/datum/techweb/science) in SSresearch.techwebs

/obj/machinery/rack_creator/proc/is_design_unlocked(datum/design/design_ref, datum/techweb/science/science_tech)
	if(!design_ref || !science_tech)
		return FALSE
	if(science_tech.isDesignResearchedID(design_ref.id))
		return TRUE
	for(var/datum/techweb_node/unlocking_node as anything in design_ref.unlocked_by)
		if(science_tech.isNodeResearchedID(unlocking_node.id))
			return TRUE
	return FALSE

/obj/machinery/rack_creator/proc/slot_unlocked_cpu(slot_number)
	var/datum/techweb/science/science_tech = get_science_techweb()
	switch(slot_number)
		if(1)
			return TRUE
		if(2)
			return science_tech?.isNodeResearchedID("ai_cpu_2")
		if(3)
			return science_tech?.isNodeResearchedID("ai_cpu_3")
		if(4)
			return science_tech?.isNodeResearchedID("ai_cpu_4")
	return FALSE

/obj/machinery/rack_creator/proc/slot_unlocked_ram(slot_number)
	var/datum/techweb/science/science_tech = get_science_techweb()
	switch(slot_number)
		if(1)
			return TRUE
		if(2)
			return science_tech?.isNodeResearchedID("ai_ram_2")
		if(3)
			return science_tech?.isNodeResearchedID("ai_ram_3")
		if(4)
			return science_tech?.isNodeResearchedID("ai_ram_4")
	return FALSE

/obj/machinery/rack_creator/proc/output_available_resources()
	var/list/material_data = list()
	if(!materials?.mat_container)
		return material_data

	for(var/datum/material/material_ref as anything in materials.mat_container.materials)
		var/amount = materials.mat_container.materials[material_ref]
		material_data += list(list(
			"name" = material_ref.name,
			"amount" = amount,
		))

	return material_data

/obj/machinery/rack_creator/proc/add_material_cost(list/total_cost, list/cost_to_add, multiplier = 1)
	if(!islist(total_cost) || !islist(cost_to_add))
		return total_cost

	for(var/material_entry in cost_to_add)
		var/datum/material/material_ref = SSmaterials.get_material(material_entry)
		if(!material_ref)
			continue
		total_cost[material_ref] += cost_to_add[material_entry] * multiplier

	return total_cost

/obj/machinery/rack_creator/proc/get_rack_shell_cost()
	var/list/rack_shell_cost = list()
	var/obj/item/server_rack/rack_path = /obj/item/server_rack
	add_material_cost(rack_shell_cost, initial(rack_path.custom_materials), 1 / efficiency_coeff)
	return rack_shell_cost

/obj/machinery/rack_creator/proc/get_total_material_cost()
	var/list/total_cost = get_rack_shell_cost()
	for(var/list/ram_data as anything in ram_expansions)
		add_material_cost(total_cost, ram_data["cost"], 1 / efficiency_coeff)
	return total_cost

/obj/machinery/rack_creator/proc/format_material_cost(list/material_cost)
	var/list/cost_parts = list()
	for(var/datum/material/material_ref as anything in material_cost)
		cost_parts += "[material_ref.name]: [round(material_cost[material_ref], 1)]"
	return english_list(cost_parts)

/obj/machinery/rack_creator/proc/check_resources()
	var/list/total_cost = get_total_material_cost()

	if(materials?.mat_container?.has_materials(total_cost))
		return total_cost
	return FALSE

/obj/machinery/rack_creator/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(isstack(tool))
		var/amount_inserted = materials?.insert_item(tool, user_data = ID_DATA(user))
		if(amount_inserted > 0)
			to_chat(user, span_notice("[tool] worth [round(amount_inserted / SHEET_MATERIAL_AMOUNT, 0.1)] sheets of material was consumed by [src]."))
			return ITEM_INTERACT_SUCCESS

		to_chat(user, span_warning("[tool] was rejected by [src]."))
		return ITEM_INTERACT_FAILURE

	return ..()

/obj/machinery/rack_creator/multitool_act(mob/living/user, obj/item/multitool/tool)
	var/link_result = materials?.OnMultitool(src, user, tool)
	if(link_result)
		return link_result
	return ..()

/obj/machinery/rack_creator/attackby(obj/item/item, mob/living/user, params)
	if(istype(item, /obj/item/ai_cpu))
		if(inserted_cpus.len >= AI_MAX_CPUS_PER_RACK)
			to_chat(user, span_warning("This rack cannot fit any more CPUs!"))
			return ..()
		if(!slot_unlocked_cpu(inserted_cpus.len + 1))
			to_chat(user, span_warning("This CPU socket has not been researched yet."))
			return ..()

		var/obj/item/ai_cpu/cpu = item
		inserted_cpus += cpu
		cpu.forceMove(src)
		update_static_data_for_all_viewers()
		return FALSE

	if(default_deconstruction_screwdriver(user, "[initial(icon_state)]_o", initial(icon_state), item))
		return TRUE
	if(default_deconstruction_crowbar(item))
		return TRUE

	return ..()

/obj/machinery/rack_creator/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet_batched/sheetmaterials),
	)

/obj/machinery/rack_creator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AiRackCreator", name)
		ui.open()

/obj/machinery/rack_creator/ui_data(mob/user)
	var/list/data = list()
	var/datum/techweb/science/science_tech = get_science_techweb()
	var/list/total_material_cost = get_total_material_cost()

	data["materials"] = output_available_resources()
	data["can_finalize"] = (check_resources() != FALSE) && (inserted_cpus.len || ram_expansions.len)
	data["rack_shell_cost"] = format_material_cost(get_rack_shell_cost())
	data["total_material_cost"] = format_material_cost(total_material_cost)

	var/list/cpus = list()
	var/total_cpu = 0
	var/total_power = 0
	var/weighted_efficiency = 0

	for(var/obj/item/ai_cpu/cpu as anything in inserted_cpus)
		var/power_usage = cpu.get_power_usage()
		var/efficiency = cpu.get_efficiency()
		cpus += list(list(
			"speed" = cpu.speed,
			"power_usage" = power_usage,
			"efficiency" = efficiency,
		))
		total_cpu += cpu.speed
		total_power += power_usage
		if(total_power)
			weighted_efficiency += power_usage * efficiency

	data["cpus"] = cpus
	data["total_cpu"] = total_cpu

	var/list/installed_ram = list()
	var/total_ram = 0
	for(var/list/ram_data as anything in ram_expansions)
		installed_ram += list(list(
			"name" = ram_data["name"],
			"capacity" = ram_data["capacity"],
			"cost" = format_material_cost(add_material_cost(list(), ram_data["cost"], 1 / efficiency_coeff)),
		))
		total_ram += ram_data["capacity"]

	total_power += total_ram * AI_RAM_POWER_USAGE

	data["ram"] = installed_ram
	data["total_ram"] = total_ram
	data["power_usage"] = total_power
	data["efficiency"] = total_power ? round(weighted_efficiency / total_power, 0.1) : 100

	var/list/possible_ram = list()
	for(var/ram_design_path in subtypesof(/datum/design/ram))
		var/datum/design/ram/ram_design = ram_design_path
		ram_design = SSresearch.techweb_design_by_id(initial(ram_design.id))
		if(!ram_design)
			continue
		possible_ram += list(list(
			"id" = ram_design.id,
			"name" = ram_design.name,
			"capacity" = ram_design.capacity,
			"cost" = format_material_cost(add_material_cost(list(), ram_design.materials, 1 / efficiency_coeff)),
			"unlocked" = is_design_unlocked(ram_design, science_tech),
		))

	data["possible_ram"] = possible_ram
	data["unlocked_ram"] = 1
	data["unlocked_cpu"] = 1
	for(var/i in 2 to 4)
		if(slot_unlocked_ram(i))
			data["unlocked_ram"] = i
		if(slot_unlocked_cpu(i))
			data["unlocked_cpu"] = i

	return data

/obj/machinery/rack_creator/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("insert_cpu")
			if(inserted_cpus.len >= AI_MAX_CPUS_PER_RACK)
				to_chat(usr, span_warning("This rack cannot fit any more CPUs!"))
				return TRUE
			var/obj/item/held_item = usr.get_active_held_item()
			if(!istype(held_item, /obj/item/ai_cpu))
				to_chat(usr, span_warning("You're not holding a neural processing unit."))
				return TRUE
			if(!slot_unlocked_cpu(inserted_cpus.len + 1))
				to_chat(usr, span_warning("This CPU socket has not been researched yet."))
				return TRUE
			var/obj/item/ai_cpu/cpu = held_item
			inserted_cpus += cpu
			cpu.forceMove(src)
			return TRUE

		if("remove_cpu")
			var/index = text2num(params["cpu_index"])
			if(!index || index < 1 || index > inserted_cpus.len)
				return TRUE
			var/obj/item/ai_cpu/cpu = inserted_cpus[index]
			inserted_cpus -= cpu
			cpu.forceMove(drop_location())
			return TRUE

		if("insert_ram")
			var/datum/techweb/science/science_tech = get_science_techweb()
			if(ram_expansions.len >= AI_MAX_RAM_PER_RACK)
				to_chat(usr, span_warning("This rack cannot fit any more RAM sticks!"))
				return TRUE
			if(!slot_unlocked_ram(ram_expansions.len + 1))
				to_chat(usr, span_warning("This RAM socket has not been researched yet."))
				return TRUE
			var/ram_id = params["ram_type"]
			if(!ram_id)
				return TRUE
			var/datum/design/ram/ram_design = SSresearch.techweb_design_by_id(ram_id)
			if(!istype(ram_design) || !is_design_unlocked(ram_design, science_tech))
				return TRUE
			ram_expansions += list(list(
				"name" = ram_design.name,
				"capacity" = ram_design.capacity,
				"cost" = ram_design.materials.Copy(),
			))
			return TRUE

		if("remove_ram")
			var/index = text2num(params["ram_index"])
			if(!index || index < 1 || index > ram_expansions.len)
				return TRUE
			ram_expansions.Cut(index, index + 1)
			return TRUE

		if("finalize")
			if(!ram_expansions.len && !inserted_cpus.len)
				say("No RAM or CPUs inserted. Process aborted.")
				return TRUE

			var/total_cost = check_resources()
			if(total_cost == FALSE)
				say("Not enough materials to finalize.")
				return TRUE

			if(islist(total_cost))
				materials.use_materials(total_cost, 1, 1, "built", "server rack", ID_DATA(usr))

			var/obj/item/server_rack/new_rack = new(drop_location())
			for(var/obj/item/ai_cpu/cpu as anything in inserted_cpus)
				cpu.forceMove(new_rack)
				new_rack.contained_cpus += cpu
			inserted_cpus.Cut()

			var/total_ram = 0
			for(var/list/ram_data as anything in ram_expansions)
				total_ram += ram_data["capacity"]
			new_rack.contained_ram = total_ram
			ram_expansions.Cut()

			say("Rack fabrication complete.")
			return TRUE

	return FALSE

/obj/structure/ethernet_cable
	name = "ethernet cable"
	desc = "A rigid, shielded cable used by advanced AI hardware."
	icon = 'icons/obj/power_cond/power_local.dmi'
	icon_state = "0-1"
	plane = FLOOR_PLANE
	layer = WIRE_LAYER + 0.001
	anchored = TRUE
	obj_flags = CAN_BE_HIT
	max_integrity = 50
	var/d1 = 0
	var/d2 = 1
	var/datum/ai_network/network

/obj/structure/ethernet_cable/Initialize(mapload)
	. = ..()

	var/dash = findtext(icon_state, "-")
	if(dash)
		d1 = text2num(copytext(icon_state, 1, dash))
		d2 = text2num(copytext(icon_state, dash + 1))

	GLOB.ethernet_cable_list += src
	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE)
	if(isturf(loc))
		var/turf/turf_loc = loc
		turf_loc.add_blueprints_preround(src)

	update_icon()
	// Map-placed ethernet cables often use default state and need a post-init pass
	// to orient themselves like normal cable placement.
	addtimer(CALLBACK(src, PROC_REF(post_spawn_autoconfigure)), mapload ? 1 SECONDS : 0.2 SECONDS)

/obj/structure/ethernet_cable/Destroy()
	if(network)
		cut_cable_from_ainet()
	GLOB.ethernet_cable_list -= src
	return ..()

/obj/structure/ethernet_cable/handle_deconstruct(disassembled = TRUE)
	var/turf/source_turf = loc
	var/cable_amount = (d1 && d2) ? 2 : 1
	var/obj/item/stack/ethernet_coil/new_coil = new(source_turf, cable_amount)
	TransferComponents(new_coil)

/obj/structure/ethernet_cable/update_icon_state()
	. = ..()
	icon_state = "[d1]-[d2]"

/obj/structure/ethernet_cable/proc/post_spawn_autoconfigure()
	if(QDELETED(src))
		return
	auto_configure_from_neighbors()

	if(!network)
		var/datum/ai_network/new_ai_network = new()
		new_ai_network.add_cable(src)
	if(d1)
		mergeConnectedNetworks(d1)
	if(d2)
		mergeConnectedNetworks(d2)
	mergeConnectedNetworksOnTurf()

	var/turf/source_turf = get_turf(src)
	if(!source_turf)
		return

	for(var/direction in GLOB.cardinals)
		var/turf/adjacent_turf = get_step(source_turf, direction)
		if(!adjacent_turf)
			continue
		for(var/obj/structure/ethernet_cable/adjacent_cable in adjacent_turf)
			adjacent_cable.auto_configure_from_neighbors()

/obj/structure/ethernet_cable/proc/auto_configure_from_neighbors(force = FALSE)
	if(QDELETED(src))
		return
	if(!force && (d1 != 0 || d2 != initial(d2)))
		return

	var/turf/source_turf = get_turf(src)
	if(!source_turf)
		return

	var/list/adjacent_dirs = list()
	var/list/local_dirs = list()
	var/has_ai_machine = FALSE

	for(var/obj/machinery/ai/machine in source_turf)
		has_ai_machine = TRUE
		break

	for(var/obj/structure/ethernet_cable/local_cable in source_turf)
		if(local_cable == src)
			continue

		var/local_d1 = local_cable.d1
		var/local_d2 = local_cable.d2

		if(local_d1 in GLOB.cardinals)
			local_dirs |= local_d1
		if(local_d2 in GLOB.cardinals)
			local_dirs |= local_d2

	for(var/direction in GLOB.cardinals)
		var/turf/adjacent_turf = get_step(source_turf, direction)
		if(!adjacent_turf)
			continue

		var/found_connection = FALSE
		for(var/obj/structure/ethernet_cable/adjacent_cable in adjacent_turf)
			found_connection = TRUE
			break
		if(!found_connection)
			for(var/obj/machinery/ai/machine in adjacent_turf)
				found_connection = TRUE
				break
		if(found_connection)
			adjacent_dirs |= direction

	var/list/candidate_dirs = adjacent_dirs.Copy()
	candidate_dirs |= local_dirs

	if(!length(candidate_dirs))
		return

	// If this turf is acting as a bridge between opposite sides, prefer a through-cable.
	// AI machines on the same turf can still connect because they now accept any cable on their tile.
	if((NORTH in candidate_dirs) && (SOUTH in candidate_dirs))
		d1 = NORTH
		d2 = SOUTH
	else if((EAST in candidate_dirs) && (WEST in candidate_dirs))
		d1 = EAST
		d2 = WEST
	else if(has_ai_machine || length(candidate_dirs) == 1)
		d1 = 0
		d2 = candidate_dirs[1]
	else
		// Prefer an elbow when two non-opposite neighbors are present.
		var/first_dir = candidate_dirs[1]
		var/second_dir
		for(var/candidate_dir in candidate_dirs)
			if(candidate_dir == first_dir)
				continue
			second_dir = candidate_dir
			break
		if(!second_dir)
			d1 = 0
			d2 = first_dir
		else
			d1 = min(first_dir, second_dir)
			d2 = max(first_dir, second_dir)

	update_icon()

	if(!network)
		var/datum/ai_network/new_ai_network = new()
		new_ai_network.add_cable(src)

	if(d1)
		mergeConnectedNetworks(d1)
	if(d2)
		mergeConnectedNetworks(d2)
	mergeConnectedNetworksOnTurf()

/obj/structure/ethernet_cable/proc/handlecable(obj/item/tool, mob/user, params)
	var/turf/source_turf = get_turf(src)
	if(!source_turf)
		return
	if(source_turf.underfloor_accessibility < UNDERFLOOR_INTERACTABLE)
		return

	if(tool.tool_behaviour == TOOL_WIRECUTTER)
		user.visible_message("[user] cuts the ethernet cable.", span_notice("You cut the ethernet cable."))
		add_fingerprint(user)
		deconstruct()
		return

	if(istype(tool, /obj/item/stack/ethernet_coil))
		var/obj/item/stack/ethernet_coil/coil = tool
		if(coil.get_amount() < 1)
			to_chat(user, span_warning("Not enough cable!"))
			return
		coil.cable_join(src, user)
		return

	if(tool.tool_behaviour == TOOL_MULTITOOL)
		to_chat(user, span_notice(network ? "Connected nodes: [length(network.nodes)]" : "This cable is not connected to an AI network."))
		return

	add_fingerprint(user)

/obj/structure/ethernet_cable/attackby(obj/item/tool, mob/user, params)
	handlecable(tool, user, params)

/obj/structure/ethernet_cable/singularity_pull(singularity, current_size)
	..()
	if(current_size >= STAGE_FIVE)
		deconstruct()

/obj/structure/ethernet_cable/proc/mergeDiagonalsNetworks(direction)
	var/turf/target_turf = get_step(src, direction & 3)
	for(var/obj/structure/ethernet_cable/cable in target_turf)
		if(cable == src)
			continue
		if(cable.d1 == (direction ^ 3) || cable.d2 == (direction ^ 3))
			if(!cable.network)
				var/datum/ai_network/new_ai_network = new()
				new_ai_network.add_cable(cable)
			if(network)
				merge_ainets(network, cable.network)
			else
				cable.network.add_cable(src)

	target_turf = get_step(src, direction & 12)
	for(var/obj/structure/ethernet_cable/cable in target_turf)
		if(cable == src)
			continue
		if(cable.d1 == (direction ^ 12) || cable.d2 == (direction ^ 12))
			if(!cable.network)
				var/datum/ai_network/new_ai_network = new()
				new_ai_network.add_cable(cable)
			if(network)
				merge_ainets(network, cable.network)
			else
				cable.network.add_cable(src)

/obj/structure/ethernet_cable/proc/mergeConnectedNetworks(direction)
	var/flipped_direction = direction ? turn(direction, 180) : 0
	if(!(d1 == direction || d2 == direction))
		return

	var/turf/target_turf = get_step(src, direction)
	for(var/obj/structure/ethernet_cable/cable in target_turf)
		if(cable == src)
			continue
		if(cable.d1 == flipped_direction || cable.d2 == flipped_direction)
			if(!cable.network)
				var/datum/ai_network/new_ai_network = new()
				new_ai_network.add_cable(cable)
			if(network)
				merge_ainets(network, cable.network)
			else
				cable.network.add_cable(src)

/obj/structure/ethernet_cable/proc/mergeConnectedNetworksOnTurf()
	var/list/to_connect = list()

	if(!network)
		var/datum/ai_network/new_ai_network = new()
		new_ai_network.add_cable(src)

	for(var/atom/movable/thing as anything in loc)
		if(istype(thing, /obj/structure/ethernet_cable))
			var/obj/structure/ethernet_cable/cable = thing
			if(cable.network == network)
				continue
			if(cable.network)
				merge_ainets(network, cable.network)
			else
				network.add_cable(cable)
			continue

		if(istype(thing, /obj/machinery/ai))
			var/obj/machinery/ai/machine = thing
			if(machine.network == network)
				continue
			to_connect += machine

	// Treat cardinally adjacent ethernet segments as connected, matching
	// expected "easy cable" behavior for mapping and in-game placement.
	for(var/direction in GLOB.cardinals)
		var/turf/adjacent_turf = get_step(src, direction)
		if(!adjacent_turf)
			continue
		for(var/obj/structure/ethernet_cable/adjacent_cable in adjacent_turf)
			if(adjacent_cable.network == network)
				continue
			if(adjacent_cable.network)
				merge_ainets(network, adjacent_cable.network)
			else
				network.add_cable(adjacent_cable)

	for(var/obj/machinery/ai/machine as anything in to_connect)
		if(!machine.connect_to_ai_network())
			machine.disconnect_from_ai_network()

/obj/structure/ethernet_cable/proc/get_connections(ai_networkless_only = FALSE)
	. = list()
	. += ai_list(loc, src, 0, ai_networkless_only)
	for(var/direction in GLOB.cardinals)
		var/turf/adjacent_turf = get_step(src, direction)
		if(!adjacent_turf)
			continue
		. += ai_list(adjacent_turf, src, 0, ai_networkless_only)

/obj/structure/ethernet_cable/proc/denode()
	var/turf/source_turf = loc
	if(!source_turf)
		return

	var/list/network_objects = ai_list(source_turf, src, 0, FALSE)
	if(length(network_objects))
		var/datum/ai_network/new_ai_network = new()
		propagate_ai_network(network_objects[1], new_ai_network)
		if(new_ai_network.is_empty())
			qdel(new_ai_network)

/obj/structure/ethernet_cable/proc/auto_propogate_cut_cable(obj/thing)
	if(!thing || QDELETED(thing))
		return

	var/datum/ai_network/new_ai_network = new()
	propagate_ai_network(thing, new_ai_network)

/obj/structure/ethernet_cable/proc/cut_cable_from_ainet(remove = TRUE)
	var/turf/source_turf = loc
	var/list/connected_cables = list()
	if(!source_turf)
		return

	if(d1)
		source_turf = get_step(source_turf, d1)
		connected_cables = ai_list(source_turf, src, turn(d1, 180), FALSE, TRUE)

	connected_cables += ai_list(loc, src, d1, FALSE, TRUE)

	if(!length(connected_cables))
		network.remove_cable(src)
		for(var/obj/machinery/ai/machine in source_turf)
			if(!machine.connect_to_ai_network())
				machine.disconnect_from_ai_network()
		return

	var/obj/seed = connected_cables[1]
	if(remove)
		moveToNullspace()

	network.remove_cable(src)
	addtimer(CALLBACK(src, PROC_REF(auto_propogate_cut_cable), seed), 0)

	if(d1 == 0)
		for(var/obj/machinery/ai/machine in source_turf)
			if(!machine.connect_to_ai_network())
				machine.disconnect_from_ai_network()

/obj/item/stack/ethernet_coil
	name = "ethernet cable coil"
	desc = "A coil of shielded ethernet cable."
	custom_price = 25
	gender = NEUTER
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "wire"
	inhand_icon_state = "coil_yellow"
	worn_icon_state = "coil"
	base_icon_state = "wire"
	novariants = FALSE
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	max_amount = MAXCOIL
	amount = MAXCOIL
	merge_type = /obj/item/stack/ethernet_coil
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 5
	mats_per_unit = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.1, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.1)
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	attack_verb_continuous = list("whips", "lashes", "disciplines", "flogs")
	attack_verb_simple = list("whip", "lash", "discipline", "flog")
	singular_name = "ethernet cable piece"
	full_w_class = WEIGHT_CLASS_SMALL
	usesound = 'sound/items/deconstruct.ogg'
	cost = 1

/obj/item/stack/ethernet_coil/cyborg
	is_cyborg = TRUE
	custom_materials = list()
	cost = 1

/obj/item/stack/ethernet_coil/suicide_act(mob/user)
	if(locate(/obj/structure/chair/stool) in get_turf(user))
		user.visible_message(span_suicide("[user] is making a noose with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	else
		user.visible_message(span_suicide("[user] is trying to upload [user.p_them()]selves to the afterlife with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return OXYLOSS

/obj/item/stack/ethernet_coil/Initialize(mapload, new_amount, merge = TRUE, list/mat_override = null, mat_amt = 1)
	. = ..()
	pixel_x = rand(-2, 2)
	pixel_y = rand(-2, 2)
	update_icon()

/obj/item/stack/ethernet_coil/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][amount < 3 ? amount : ""]"
	inhand_icon_state = "coil_yellow"
	name = "ethernet cable [amount < 3 ? "piece" : "coil"]"

/obj/item/stack/ethernet_coil/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	var/obj/item/stack/ethernet_coil/new_cable = ..()
	if(istype(new_cable))
		new_cable.update_icon()

/obj/item/stack/ethernet_coil/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(istype(interacting_with, /obj/structure/ethernet_cable))
		var/obj/structure/ethernet_cable/target_cable = interacting_with
		cable_join(target_cable, user)
		return ITEM_INTERACT_SUCCESS

	if(istype(interacting_with, /obj/machinery/ai))
		var/obj/machinery/ai/target_machine = interacting_with
		var/turf/machine_turf = get_turf(target_machine)
		if(machine_turf?.can_have_cabling())
			var/obj/structure/ethernet_cable/first_cable_on_turf
			for(var/obj/structure/ethernet_cable/existing_cable in machine_turf)
				if(!first_cable_on_turf)
					first_cable_on_turf = existing_cable
				if(!existing_cable.d1 || !existing_cable.d2)
					cable_join(existing_cable, user)
					return ITEM_INTERACT_SUCCESS
			if(first_cable_on_turf)
				place_turf(machine_turf, user)
			else
				place_turf(machine_turf, user)
			return ITEM_INTERACT_SUCCESS

	if(isturf(interacting_with))
		var/turf/target_turf = interacting_with
		if(target_turf.can_lay_cable())
			for(var/obj/structure/ethernet_cable/existing_cable in target_turf)
				if(!existing_cable.d1 || !existing_cable.d2)
					cable_join(existing_cable, user)
					return ITEM_INTERACT_SUCCESS
			place_turf(target_turf, user)
			return ITEM_INTERACT_SUCCESS

	return NONE

/obj/item/stack/ethernet_coil/proc/give(extra)
	if(amount + extra > max_amount)
		amount = max_amount
	else
		amount += extra
	update_icon()

/obj/item/stack/ethernet_coil/proc/get_new_cable(location)
	return new /obj/structure/ethernet_cable(location)

/obj/item/stack/ethernet_coil/proc/place_turf(turf/target_turf, mob/user, dirnew)
	if(!isturf(user.loc))
		return

	var/has_ai_machine = FALSE
	if(isturf(target_turf))
		for(var/obj/machinery/ai/machine in target_turf)
			has_ai_machine = TRUE
			break

	if(!isturf(target_turf) || !target_turf.can_have_cabling() || (target_turf.underfloor_accessibility < UNDERFLOOR_INTERACTABLE && !has_ai_machine))
		to_chat(user, span_warning("You can only lay cables on top of exterior catwalks and plating!"))
		return

	if(get_amount() < 1)
		to_chat(user, span_warning("There is no cable left!"))
		return

	if(get_dist(target_turf, user) > 1)
		to_chat(user, span_warning("You can't lay cable at a place that far away!"))
		return

	var/dirn
	if(!dirnew)
		if(user.loc == target_turf)
			dirn = user.dir
		else
			dirn = get_dir(target_turf, user)
	else
		dirn = dirnew

	if(!dirnew)
		var/list/candidate_dirs = list()
		for(var/obj/structure/ethernet_cable/existing_cable in target_turf)
			if(existing_cable.d1 in GLOB.cardinals)
				candidate_dirs |= existing_cable.d1
			if(existing_cable.d2 in GLOB.cardinals)
				candidate_dirs |= existing_cable.d2

		if(!length(candidate_dirs))
			for(var/direction in GLOB.cardinals)
				var/turf/adjacent_turf = get_step(target_turf, direction)
				if(!adjacent_turf)
					continue

				var/found_connection = FALSE
				for(var/obj/structure/ethernet_cable/adjacent_cable in adjacent_turf)
					found_connection = TRUE
					break
				if(!found_connection)
					for(var/obj/machinery/ai/adjacent_machine in adjacent_turf)
						found_connection = TRUE
						break
				if(found_connection)
					candidate_dirs |= direction

		if(length(candidate_dirs) && !(dirn in candidate_dirs))
			var/user_preferred_dir = get_dir(target_turf, user)
			if(user_preferred_dir in candidate_dirs)
				dirn = user_preferred_dir
			else
				dirn = candidate_dirs[1]

	for(var/obj/structure/ethernet_cable/cable in target_turf)
		if(cable.d2 == dirn && cable.d1 == 0)
			to_chat(user, span_warning("There's already a cable at that position!"))
			return

	var/obj/structure/ethernet_cable/new_cable = get_new_cable(target_turf)
	new_cable.d1 = 0
	new_cable.d2 = dirn
	new_cable.add_fingerprint(user)
	new_cable.update_icon()

	var/datum/ai_network/new_ai_network = new()
	new_ai_network.add_cable(new_cable)

	new_cable.mergeConnectedNetworks(new_cable.d2)
	new_cable.mergeConnectedNetworksOnTurf()

	if(new_cable.d2 & (new_cable.d2 - 1))
		new_cable.mergeDiagonalsNetworks(new_cable.d2)

	// Make manual placement as forgiving as normal cable coils by
	// snapping to nearby valid neighbors after creation.
	new_cable.auto_configure_from_neighbors(TRUE)

	use(1)
	return new_cable

/obj/item/stack/ethernet_coil/proc/cable_join(obj/structure/ethernet_cable/cable, mob/user, showerror = TRUE, forceddir)
	var/turf/user_turf = user.loc
	if(!isturf(user_turf))
		return

	var/turf/cable_turf = cable.loc
	var/cable_turf_has_ai_machine = FALSE
	if(isturf(cable_turf))
		for(var/obj/machinery/ai/machine in cable_turf)
			cable_turf_has_ai_machine = TRUE
			break
	if(!isturf(cable_turf) || (cable_turf.underfloor_accessibility < UNDERFLOOR_INTERACTABLE && !cable_turf_has_ai_machine))
		return

	if(get_dist(cable, user) > 1)
		to_chat(user, span_warning("You can't lay cable at a place that far away!"))
		return

	if(user_turf == cable_turf && !forceddir)
		place_turf(cable_turf, user)
		return

	var/dirn = forceddir || get_dir(cable, user)
	if((cable.d1 == dirn || cable.d2 == dirn) && !forceddir)
		if(!user_turf.can_have_cabling())
			if(showerror)
				to_chat(user, span_warning("You can only lay cables on catwalks and plating!"))
			return
		if(cable_turf.underfloor_accessibility < UNDERFLOOR_INTERACTABLE && !cable_turf_has_ai_machine)
			to_chat(user, span_warning("You can't lay cable there unless the floor tiles are removed!"))
			return

		var/flipped_dir = turn(dirn, 180)
		for(var/obj/structure/ethernet_cable/existing_cable in user_turf)
			if(existing_cable.d1 == flipped_dir || existing_cable.d2 == flipped_dir)
				if(showerror)
					to_chat(user, span_warning("There's already a cable at that position!"))
				return

		var/obj/structure/ethernet_cable/new_cable = get_new_cable(user_turf)
		new_cable.d1 = 0
		new_cable.d2 = flipped_dir
		new_cable.add_fingerprint(user)
		new_cable.update_icon()

		var/datum/ai_network/new_ai_network = new()
		new_ai_network.add_cable(new_cable)

		new_cable.mergeConnectedNetworks(new_cable.d2)
		new_cable.mergeConnectedNetworksOnTurf()

		if(new_cable.d2 & (new_cable.d2 - 1))
			new_cable.mergeDiagonalsNetworks(new_cable.d2)

		new_cable.auto_configure_from_neighbors(TRUE)

		use(1)
		return

	if(cable.d1 != 0)
		return

	var/new_d1 = cable.d2
	var/new_d2 = dirn
	if(new_d1 > new_d2)
		new_d1 = dirn
		new_d2 = cable.d2

	for(var/obj/structure/ethernet_cable/existing_cable in cable_turf)
		if(existing_cable == cable)
			continue
		if((existing_cable.d1 == new_d1 && existing_cable.d2 == new_d2) || (existing_cable.d1 == new_d2 && existing_cable.d2 == new_d1))
			if(showerror)
				to_chat(user, span_warning("There's already a cable at that position!"))
			return

	cable.d1 = new_d1
	cable.d2 = new_d2
	cable.add_fingerprint(user)
	cable.update_icon()

	cable.mergeConnectedNetworks(cable.d1)
	cable.mergeConnectedNetworks(cable.d2)
	cable.mergeConnectedNetworksOnTurf()

	if(cable.d1 & (cable.d1 - 1))
		cable.mergeDiagonalsNetworks(cable.d1)
	if(cable.d2 & (cable.d2 - 1))
		cable.mergeDiagonalsNetworks(cable.d2)

	use(1)
	cable.denode()

/turf/proc/get_ai_cable_node()
	if(!can_have_cabling())
		return null
	for(var/obj/structure/ethernet_cable/cable in src)
		if(cable.d1 == 0)
			return cable
	return null

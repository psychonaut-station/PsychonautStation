#define PKBORG_DAMPEN_CYCLE_DELAY (2 SECONDS)
#define POWER_RECHARGE_CYBORG_DRAIN_MULTIPLIER (0.0004 * STANDARD_CELL_RATE)
#define NO_TOOL "deactivated"
#define TOOL_DRAPES "surgical_drapes"

/obj/item/cautery/prt //it's a subtype of cauteries so that it inherits the cautery sprites and behavior and stuff, because I'm too lazy to make sprites for this thing
	name = "plating repair tool"
	desc = "A tiny heating device that's powered by a cyborg's excess heat. Its intended purpose is to repair burnt or damaged hull platings, but it can also be used as a crude lighter or cautery."
	toolspeed = 1.5 //it's not designed to be used as a cautery (although it's close enough to one to be considered to be a proper cautery instead of just a hot object for the purposes of surgery)
	heat = 3800 //this thing is intended for metal-shaping, so it's the same temperature as a lit welder
	resistance_flags = FIRE_PROOF //if it's channeling a cyborg's excess heat, it's probably fireproof
	force = 5
	damtype = BURN
	usesound = list('sound/items/welder.ogg', 'sound/items/welder2.ogg') //the usesounds of a lit welder
	hitsound = 'sound/items/welder.ogg' //the hitsound of a lit welder

//Peacekeeper Cyborg Projectile Dampenening Field
/obj/item/borg/projectile_dampen
	name = "\improper Hyperkinetic Dampening projector"
	desc = "A device that projects a dampening field that weakens kinetic energy above a certain threshold. <span class='boldnotice'>Projects a field that drains power per second while active, that will weaken and slow damaging projectiles inside its field.</span> Still being a prototype, it tends to induce a charge on ungrounded metallic surfaces."
	icon = 'icons/obj/devices/syndie_gadget.dmi'
	icon_state = "shield0"
	base_icon_state = "shield"
	/// Max energy this dampener can hold
	var/maxenergy = 1500
	/// Current energy level
	var/energy = 1500
	/// Recharging rate in energy per second
	var/energy_recharge = 37.5
	/// Critical power level percentage
	var/cyborg_cell_critical_percentage = 0.05
	/// The owner of the dampener
	var/mob/living/silicon/robot/host = null
	/// The field
	var/datum/proximity_monitor/advanced/projectile_dampener/peaceborg/dampening_field
	var/projectile_damage_coefficient = 0.5
	/// Energy cost per tracked projectile damage amount per second
	var/projectile_damage_tick_ecost_coefficient = 10
	/**
	 * Speed coefficient
	 * Higher the coefficient slower the projectile.
	*/
	var/projectile_speed_coefficient = 1.5
	/// Energy cost per tracked projectile per second
	var/projectile_tick_speed_ecost = 75
	/// Projectile sent out by the dampener
	var/list/obj/projectile/tracked
	var/image/projectile_effect
	var/field_radius = 3
	var/active = FALSE
	/// activation cooldown
	COOLDOWN_DECLARE(cycle_cooldown)

/obj/item/borg/projectile_dampen/debug
	maxenergy = 50000
	energy = 50000
	energy_recharge = 5000

/obj/item/borg/projectile_dampen/Initialize(mapload)
	projectile_effect = image('icons/effects/fields.dmi', "projectile_dampen_effect")
	tracked = list()
	START_PROCESSING(SSfastprocess, src)
	host = loc
	RegisterSignal(host, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	return ..()

/obj/item/borg/projectile_dampen/proc/on_death(datum/source, gibbed)
	SIGNAL_HANDLER

	deactivate_field()

/obj/item/borg/projectile_dampen/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/item/borg/projectile_dampen/attack_self(mob/user)
	if (!COOLDOWN_FINISHED(src, cycle_cooldown))
		to_chat(user, span_boldwarning("[src] is still recycling its projectors!"))
		return
	COOLDOWN_START(src, cycle_cooldown, PKBORG_DAMPEN_CYCLE_DELAY)
	if(!active)
		if(!user.has_buckled_mobs())
			activate_field()
		else
			to_chat(user, span_warning("[src]'s safety cutoff prevents you from activating it due to living beings being ontop of you!"))
	else
		deactivate_field()
	update_appearance()
	to_chat(user, span_boldnotice("You [active ? "activate":"deactivate"] [src]."))

/obj/item/borg/projectile_dampen/update_icon_state()
	icon_state = "[base_icon_state][active]"
	return ..()

/obj/item/borg/projectile_dampen/proc/activate_field()
	if(istype(dampening_field))
		QDEL_NULL(dampening_field)
	var/mob/living/silicon/robot/owner = get_host()
	dampening_field = new(owner, field_radius, TRUE, src)
	RegisterSignal(dampening_field, COMSIG_DAMPENER_CAPTURE, PROC_REF(dampen_projectile))
	RegisterSignal(dampening_field, COMSIG_DAMPENER_RELEASE, PROC_REF(restore_projectile))
	owner?.model.allow_riding = FALSE
	active = TRUE

/obj/item/borg/projectile_dampen/proc/deactivate_field()
	QDEL_NULL(dampening_field)
	visible_message(span_warning("\The [src] shuts off!"))
	for(var/projectile in tracked)
		restore_projectile(projectile = projectile)
	active = FALSE

	var/mob/living/silicon/robot/owner = get_host()
	if(owner)
		owner.model.allow_riding = TRUE

/obj/item/borg/projectile_dampen/proc/get_host()
	if(istype(host))
		return host
	else
		if(iscyborg(host.loc))
			return host.loc
	return null

/obj/item/borg/projectile_dampen/dropped()
	host = loc
	return ..()

/obj/item/borg/projectile_dampen/equipped()
	host = loc
	return ..()

/obj/item/borg/projectile_dampen/cyborg_unequip(mob/user)
	deactivate_field()
	return ..()

/obj/item/borg/projectile_dampen/process(seconds_per_tick)
	process_recharge(seconds_per_tick)
	process_usage(seconds_per_tick)

/obj/item/borg/projectile_dampen/proc/process_usage(seconds_per_tick)
	var/usage = 0
	for(var/obj/projectile/inner_projectile as anything in tracked)
		if(!inner_projectile.is_hostile_projectile())
			continue
		usage += projectile_tick_speed_ecost * seconds_per_tick
		usage += tracked[inner_projectile] * projectile_damage_tick_ecost_coefficient * seconds_per_tick
	energy = clamp(energy - usage, 0, maxenergy)
	if(energy <= 0)
		deactivate_field()
		visible_message(span_warning("[src] blinks \"ENERGY DEPLETED\"."))

/obj/item/borg/projectile_dampen/proc/process_recharge(seconds_per_tick)
	if(!istype(host))
		if(iscyborg(host.loc))
			host = host.loc
		else
			energy = clamp(energy + energy_recharge * seconds_per_tick, 0, maxenergy)
			return
	if(host.cell && (host.cell.charge >= (host.cell.maxcharge * cyborg_cell_critical_percentage)) && (energy < maxenergy))
		host.cell.use(energy_recharge * seconds_per_tick * POWER_RECHARGE_CYBORG_DRAIN_MULTIPLIER)
		energy += energy_recharge * seconds_per_tick

/obj/item/borg/projectile_dampen/proc/dampen_projectile(datum/source, obj/projectile/projectile)
	SIGNAL_HANDLER

	tracked[projectile] = projectile.damage
	projectile.damage *= projectile_damage_coefficient
	projectile.speed *= projectile_speed_coefficient
	projectile.add_overlay(projectile_effect)

/obj/item/borg/projectile_dampen/proc/restore_projectile(datum/source, obj/projectile/projectile)
	SIGNAL_HANDLER

	tracked -= projectile
	projectile.damage *= (1 / projectile_damage_coefficient)
	projectile.speed *= (1 / projectile_speed_coefficient)
	projectile.cut_overlay(projectile_effect)

//bare minimum omni-toolset for modularity
/obj/item/borg/cyborg_omnitool
	name = "cyborg omni-toolset"
	desc = "You shouldn't see this in-game normally."
	icon = 'icons/mob/silicon/robot_items.dmi'
	icon_state = "toolkit_medborg"
	///our tools
	var/list/radial_menu_options = list()
	///object we are referencing to for force, sharpness and sound
	var/obj/item/reference
	//is the toolset upgraded or not
	var/upgraded = FALSE
	///how much faster should the toolspeed be?
	var/upgraded_toolspeed = 0.7

/obj/item/borg/cyborg_omnitool/get_all_tool_behaviours()
	return list(TOOL_SCALPEL, TOOL_HEMOSTAT)

/obj/item/borg/cyborg_omnitool/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
	speed = 8 SECONDS, \
	effectiveness = 100, \
	disabled = TRUE, \
	)
	radial_menu_options = list(
		NO_TOOL = image(icon = 'icons/mob/silicon/robot_items.dmi', icon_state = initial(icon_state)),
		TOOL_SCALPEL = image(icon = 'icons/obj/medical/surgery_tools.dmi', icon_state = "[TOOL_SCALPEL]"),
		TOOL_HEMOSTAT = image(icon = 'icons/obj/medical/surgery_tools.dmi', icon_state = "[TOOL_HEMOSTAT]"),
	)

/obj/item/borg/cyborg_omnitool/attack_self(mob/user)
	var/new_tool_behaviour = show_radial_menu(user, src, radial_menu_options, require_near = TRUE, tooltips = TRUE)

	if(isnull(new_tool_behaviour) || new_tool_behaviour == tool_behaviour)
		return
	if(new_tool_behaviour == NO_TOOL)
		tool_behaviour = null
	else
		tool_behaviour = new_tool_behaviour

	reference_item_for_parameters()
	update_tool_parameters(reference)
	update_appearance(UPDATE_ICON_STATE)
	playsound(src, 'sound/items/change_jaws.ogg', 50, TRUE)

/// Used to get reference item for the tools
/obj/item/borg/cyborg_omnitool/proc/reference_item_for_parameters()
	SHOULD_CALL_PARENT(FALSE)
	switch(tool_behaviour)
		if(TOOL_SCALPEL)
			reference = /obj/item/scalpel
		if(TOOL_HEMOSTAT)
			reference = /obj/item/hemostat

/// Used to update sounds and tool parameters during switching
/obj/item/borg/cyborg_omnitool/proc/update_tool_parameters(/obj/item/reference)
	if(isnull(reference))
		sharpness = NONE
		force = initial(force)
		hitsound = initial(hitsound)
		usesound = initial(usesound)
	else
		force = initial(reference.force)
		sharpness = initial(reference.sharpness)
		hitsound = initial(reference.hitsound)
		usesound = initial(reference.usesound)

/obj/item/borg/cyborg_omnitool/update_icon_state()
	icon_state = initial(icon_state)

	if (tool_behaviour)
		icon_state += "_[sanitize_css_class_name(tool_behaviour)]"

	if(tool_behaviour)
		inhand_icon_state = initial(inhand_icon_state) + "_deactivated"
	else
		inhand_icon_state = initial(inhand_icon_state)

	return ..()

/**
 * proc that's used when cyborg is upgraded with an omnitool upgrade board
 *
 * adds name and desc changes. also changes tools to default configuration to indicate it's been sucessfully upgraded
 * changes the toolspeed to the upgraded_toolspeed variable
 */
/obj/item/borg/cyborg_omnitool/proc/upgrade_omnitool()
	name = "advanced [name]"
	desc += "\nIt seems that this one has been upgraded to perform tasks faster."
	toolspeed = upgraded_toolspeed
	upgraded = TRUE
	tool_behaviour = null
	reference_item_for_parameters()
	update_tool_parameters(reference)
	update_appearance(UPDATE_ICON_STATE)
	playsound(src, 'sound/items/change_jaws.ogg', 50, TRUE)

/**
 * proc that's used when a cyborg with an upgraded omnitool is downgraded
 *
 * reverts all name and desc changes to it's initial variables. also changes tools to default configuration to indicate it's been downgraded
 * changes the toolspeed to default variable
 */
/obj/item/borg/cyborg_omnitool/proc/downgrade_omnitool()
	name = initial(name)
	desc = initial(desc)
	toolspeed = initial(toolspeed)
	upgraded = FALSE
	tool_behaviour = null
	reference_item_for_parameters()
	update_tool_parameters(reference)
	update_appearance(UPDATE_ICON_STATE)
	playsound(src, 'sound/items/change_jaws.ogg', 50, TRUE)

/obj/item/borg/cyborg_omnitool/medical
	name = "surgical omni-toolset"
	desc = "A set of surgical tools used by cyborgs to operate on various surgical operations."
	item_flags = SURGICAL_TOOL

/obj/item/borg/cyborg_omnitool/medical/get_all_tool_behaviours()
	return list(TOOL_SCALPEL, TOOL_HEMOSTAT, TOOL_RETRACTOR, TOOL_SAW, TOOL_DRILL, TOOL_CAUTERY, TOOL_BONESET)

/obj/item/borg/cyborg_omnitool/medical/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
	speed = 8 SECONDS, \
	effectiveness = 100, \
	disabled = TRUE, \
	)
	radial_menu_options = list(
		TOOL_SCALPEL = image(icon = 'icons/obj/medical/surgery_tools.dmi', icon_state = "[TOOL_SCALPEL]"),
		TOOL_HEMOSTAT = image(icon = 'icons/obj/medical/surgery_tools.dmi', icon_state = "[TOOL_HEMOSTAT]"),
		TOOL_RETRACTOR = image(icon = 'icons/obj/medical/surgery_tools.dmi', icon_state = "[TOOL_RETRACTOR]"),
		TOOL_SAW = image(icon = 'icons/obj/medical/surgery_tools.dmi', icon_state = "[TOOL_SAW]"),
		TOOL_DRILL = image(icon = 'icons/obj/medical/surgery_tools.dmi', icon_state = "[TOOL_DRILL]"),
		TOOL_CAUTERY = image(icon = 'icons/obj/medical/surgery_tools.dmi', icon_state = "[TOOL_CAUTERY]"),
		TOOL_BONESET = image(icon = 'icons/obj/medical/surgery_tools.dmi', icon_state = "[TOOL_BONESET]"),
		TOOL_DRAPES = image(icon = 'icons/obj/medical/surgery_tools.dmi', icon_state = "[TOOL_DRAPES]"),
	)

/obj/item/borg/cyborg_omnitool/medical/reference_item_for_parameters()
	var/datum/component/butchering/butchering = src.GetComponent(/datum/component/butchering)
	butchering.butchering_enabled = tool_behaviour == (TOOL_SCALPEL && TOOL_SAW)
	RemoveElement(/datum/element/eyestab)
	RemoveComponentSource(/datum/component/surgery_initiator)
	item_flags = SURGICAL_TOOL
	switch(tool_behaviour)
		if(TOOL_SCALPEL)
			reference = /obj/item/scalpel
			AddElement(/datum/element/eyestab)
		if(TOOL_DRILL)
			reference = /obj/item/surgicaldrill
			AddElement(/datum/element/eyestab)
		if(TOOL_HEMOSTAT)
			reference = /obj/item/hemostat
		if(TOOL_RETRACTOR)
			reference = /obj/item/retractor
		if(TOOL_CAUTERY)
			reference = /obj/item/cautery
		if(TOOL_SAW)
			reference = /obj/item/circular_saw
		if(TOOL_BONESET)
			reference = /obj/item/bonesetter
		if(TOOL_DRAPES)
			reference = /obj/item/surgical_drapes
			AddComponent(/datum/component/surgery_initiator)
			item_flags = null

//Toolset for engineering cyborgs, this is all of the tools except for the welding tool. since it's quite hard to implement (read:can't be arsed to)
/obj/item/borg/cyborg_omnitool/engineering
	name = "engineering omni-toolset"
	desc = "A set of engineering tools used by cyborgs to conduct various engineering tasks."
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "toolkit_engiborg"
	item_flags = null
	toolspeed = 0.5
	upgraded_toolspeed = 0.3

/obj/item/borg/cyborg_omnitool/engineering/get_all_tool_behaviours()
	return list(TOOL_SCREWDRIVER, TOOL_CROWBAR, TOOL_WRENCH, TOOL_WIRECUTTER, TOOL_MULTITOOL)

/obj/item/borg/cyborg_omnitool/engineering/Initialize(mapload)
	. = ..()
	radial_menu_options = list(
		TOOL_SCREWDRIVER = image(icon = 'icons/obj/tools.dmi', icon_state = "[TOOL_SCREWDRIVER]_map"),
		TOOL_CROWBAR = image(icon = 'icons/obj/tools.dmi', icon_state = "[TOOL_CROWBAR]"),
		TOOL_WRENCH = image(icon = 'icons/obj/tools.dmi', icon_state = "[TOOL_WRENCH]"),
		TOOL_WIRECUTTER = image(icon = 'icons/obj/tools.dmi', icon_state = "[TOOL_WIRECUTTER]_map"),
		TOOL_MULTITOOL = image(icon = 'icons/obj/devices/tool.dmi', icon_state = "[TOOL_MULTITOOL]"),
	)

/obj/item/borg/cyborg_omnitool/engineering/reference_item_for_parameters()
	RemoveElement(/datum/element/eyestab)
	switch(tool_behaviour)
		if(TOOL_SCREWDRIVER)
			reference = /obj/item/crowbar
			AddElement(/datum/element/eyestab)
		if(TOOL_CROWBAR)
			reference = /obj/item/surgicaldrill
		if(TOOL_WRENCH)
			reference = /obj/item/wrench
		if(TOOL_WIRECUTTER)
			reference = /obj/item/wirecutters
		if(TOOL_MULTITOOL)
			reference = /obj/item/multitool

#undef PKBORG_DAMPEN_CYCLE_DELAY
#undef POWER_RECHARGE_CYBORG_DRAIN_MULTIPLIER
#undef NO_TOOL
#undef TOOL_DRAPES

/obj/item/borg/cyborg_clamp
	name = "hydraulic clamp"
	desc = "Equipment for cyborgs. Lifts objects and loads them into cargo."
	icon = 'icons/psychonaut/mob/silicon/robot_items.dmi'
	icon_state = "clamp"
	/// The clamps owner.
	var/mob/living/silicon/robot/host
	/// A list of the that clamp can carry.
	var/list/can_carry = list(/obj/structure/closet/crate, /obj/item/delivery/big)
	/// A list of the that clamp now carrying.
	var/list/stored_things = list()
	/// Time it takes to load a crate.
	var/load_time = 4 SECONDS
	/// The max amount of crates you can carry.
	var/max_capacity = 4
	/// A lazylist of the humans are we carrying.
	var/list/carrying_humans
	/// Cell usage.
	var/cell_usage = 50
	var/list/upgrades = list()

/obj/item/borg/cyborg_clamp/Initialize(mapload)
	host = loc
	START_PROCESSING(SSprocessing, src)
	RegisterSignal(host, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	return ..()

/obj/item/borg/cyborg_clamp/Destroy()
	drop_all_crates()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/borg/cyborg_clamp/proc/on_death(datum/source, gibbed)
	SIGNAL_HANDLER
	drop_all_crates()

/obj/item/borg/cyborg_clamp/dropped()
	host = loc
	drop_all_crates()
	return ..()

/obj/item/borg/cyborg_clamp/equipped()
	host = loc
	return ..()

/obj/item/borg/cyborg_clamp/cyborg_unequip(mob/user)
	drop_all_crates()
	return ..()

/obj/item/borg/cyborg_clamp/AltClick(mob/living/silicon/robot/user)
	drop_all_crates()

/obj/item/borg/cyborg_clamp/proc/get_host()
	if(istype(host))
		return host
	else
		if(iscyborg(host.loc))
			return host.loc
	return null

/obj/item/borg/cyborg_clamp/proc/drop_all_crates()
	for(var/obj/crate as anything in stored_things)
		crate.forceMove(drop_location())
		stored_things -= crate
	LAZYNULL(carrying_humans)
	update_speedmod()

/obj/item/borg/cyborg_clamp/proc/can_pickup(obj/target)
	if(length(stored_things) >= max_capacity)
		balloon_alert(host, "no space!")
		return FALSE
	for(var/mob/living/mob in target.get_all_contents())
		if(mob.mob_size <= MOB_SIZE_SMALL)
			continue
		if(mob.mob_size == MOB_SIZE_HUMAN && host.emagged)
			continue
		balloon_alert(host, "target too heavy!")
		return FALSE
	if(target.anchored)
		balloon_alert(host, "target is anchored!")
		return FALSE
	return TRUE

/obj/item/borg/cyborg_clamp/pre_attack(atom/target, mob/user)
	var/mob/living/silicon/robot/owner = get_host()
	if(!user.Adjacent(target))
		return
	if(is_type_in_list(target, can_carry))
		var/obj/picked_crate = target
		if(!can_pickup(picked_crate))
			return
		var/obj/structure/closet/c = target
		if(istype(c))
			if(c.opened)
				balloon_alert(host, "close it first!")
				return
		if(!owner.cell.use(cell_usage))
			to_chat(user, span_warning("Not enough power."))
			return
		playsound(src, 'sound/mecha/hydraulic.ogg', 25, TRUE)
		if(!do_after(user, load_time, target = target))
			return
		if(!can_pickup(picked_crate))
			return
		if(istype(c))
			if(c.opened)
				return
		if(!user.Adjacent(target))
			return
		stored_things += picked_crate
		picked_crate.forceMove(src)
		for(var/mob/living/mob in picked_crate.get_all_contents())
			if(mob.mob_size == MOB_SIZE_HUMAN)
				LAZYADD(carrying_humans, picked_crate)
		balloon_alert(user, "picked up [picked_crate]")
		update_speedmod()
	else if(length(stored_things))
		var/turf/target_turf = get_turf(target)
		if(isturf(target_turf) && target_turf.is_blocked_turf())
			return
		var/list/crate_radial = list()
		for(var/obj/crate as anything in stored_things)
			crate_radial[crate] = image(crate)
		var/obj/pick = show_radial_menu(user, target_turf, crate_radial, radius = 38, require_near = TRUE)
		if(!pick)
			return
		playsound(src, 'sound/mecha/hydraulic.ogg', 25, TRUE)
		if(!do_after(user, load_time, target = target))
			return
		if(target_turf.is_blocked_turf())
			return
		if(pick.loc != src)
			return
		if(!user.Adjacent(target))
			return
		var/obj/dropped_crate = pick
		dropped_crate.forceMove(target_turf)
		stored_things -= pick
		for(var/mob/living/mob in dropped_crate.get_all_contents())
			if(mob.mob_size == MOB_SIZE_HUMAN)
				LAZYREMOVE(carrying_humans, dropped_crate)
		balloon_alert(user, "dropped [dropped_crate]")
		update_speedmod()
	else
		balloon_alert(user, "invalid target!")

/obj/item/borg/cyborg_clamp/examine()
	. = ..()
	var/st = length(stored_things)
	. += "There are [st]/[max_capacity] things were picked up here."
	if(st)
		. += "Stored:"
		for(var/obj/crate as anything in stored_things)
			. += " [crate.name]"
	if(LAZYLEN(carrying_humans))
		. += span_warning(" DANGER!! High weight detected..! ")
	. += span_notice(" <i>Alt-click</i> to drop all the crates. ")

/obj/item/borg/cyborg_clamp/proc/update_speedmod()
	var/mob/living/silicon/robot/owner = get_host()
	if(LAZYLEN(carrying_humans))
		owner?.throw_alert(ALERT_HIGHWEIGHT, /atom/movable/screen/alert/highweight)
		owner?.add_movespeed_modifier(/datum/movespeed_modifier/cyborgclamp)
	else
		owner?.clear_alert(ALERT_HIGHWEIGHT)
		owner?.remove_movespeed_modifier(/datum/movespeed_modifier/cyborgclamp)

/obj/item/borg/cyborg_clamp/process(seconds_per_tick)
	var/humans = LAZYLEN(carrying_humans)
	if(humans)
		var/mob/living/silicon/robot/owner = get_host()
		owner?.adjustBruteLoss(0.4 * seconds_per_tick * humans)
		if(!owner.cell?.use(5 * seconds_per_tick))
			owner.logevent("ERROR: NO POWER")
			drop_all_crates()

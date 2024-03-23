#define PKBORG_DAMPEN_CYCLE_DELAY (2 SECONDS)

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
	/// Charge draining right
	var/energy_recharge_cyborg_drain_coefficient = 0.4
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
		host.cell.use(energy_recharge * seconds_per_tick * energy_recharge_cyborg_drain_coefficient)
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

#undef PKBORG_DAMPEN_CYCLE_DELAY

/obj/item/borg/cyborg_clamp
	name = "hydraulic clamp"
	desc = "Equipment for cyborgs. Lifts objects and loads them into cargo."
	icon = 'icons/psychonaut/mob/silicon/robot_items.dmi'
	icon_state = "clamp"
	var/mob/living/silicon/robot/host = null
	var/list/stored_crates = list()
	/// Time it takes to load a crate.
	var/load_time = 3 SECONDS
	/// The max amount of crates you can carry.
	var/max_crates = 5
	/// The humans are we carrying
	var/list/carrying_humans = list()

/obj/item/borg/cyborg_clamp/Initialize(mapload)
	host = loc
	RegisterSignal(host, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	return ..()

/obj/item/borg/cyborg_clamp/Destroy()
	drop_all_crates()
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

/obj/item/borg/cyborg_clamp/proc/drop_all_crates()
	for(var/obj/crate as anything in stored_crates)
		crate.forceMove(drop_location())
		stored_crates -= crate
	carrying_humans = list()

/obj/item/borg/cyborg_clamp/proc/can_pickup(obj/target)
	if(length(stored_crates) >= max_crates)
		balloon_alert(host, "too many crates!")
		return FALSE
	for(var/mob/living/mob in target.get_all_contents())
		if(mob.mob_size <= MOB_SIZE_SMALL)
			continue
		if(mob.mob_size == MOB_SIZE_HUMAN && host.emagged)
			continue
		balloon_alert(host, "crate too heavy!")
		return FALSE
	if(target.anchored)
		balloon_alert(host, "crate is anchored!")
		return FALSE
	return TRUE

/obj/item/borg/cyborg_clamp/pre_attack(atom/target, mob/user)
	if(!user.Adjacent(target))
		return
	if(istype(target, /obj/structure/closet/crate) || istype(target, /obj/item/delivery/big))
		var/obj/picked_crate = target
		if(!can_pickup(picked_crate))
			return
		playsound(src, 'sound/mecha/hydraulic.ogg', 25, TRUE)
		if(!do_after(user, load_time, target = target))
			return
		if(!can_pickup(picked_crate))
			return
		if(!user.Adjacent(target))
			return
		stored_crates += picked_crate
		picked_crate.forceMove(src)
		for(var/mob/living/mob in picked_crate.get_all_contents())
			if(mob.mob_size == MOB_SIZE_HUMAN)
				carrying_humans += mob
		balloon_alert(user, "picked up [picked_crate]")
	else if(length(stored_crates))
		var/turf/target_turf = get_turf(target)
		if(isturf(target_turf) && target_turf.is_blocked_turf())
			return
		var/list/crate_radial = list()
		for(var/obj/crate as anything in stored_crates)
			crate_radial[crate] = image(icon = initial(crate.icon), icon_state = initial(crate.icon_state))
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
		stored_crates -= pick
		for(var/mob/living/mob in dropped_crate.get_all_contents())
			if(mob.mob_size == MOB_SIZE_HUMAN)
				carrying_humans -= mob
		balloon_alert(user, "dropped [dropped_crate]")
	else
		balloon_alert(user, "invalid target!")

/obj/item/borg/cyborg_clamp/examine()
	. = ..()
	if(length(stored_crates))
		. += "There are [length(stored_crates)] things were picked up here."
	. += span_notice(" <i>Alt-click</i> to drop all the crates. ")

/obj/item/borg/cyborg_clamp/proc/update_speedmod()
	if(length(carrying_humans) > 0)
		host.add_movespeed_modifier(/datum/movespeed_modifier/cyborgclamp)
	else
		host.remove_movespeed_modifier(/datum/movespeed_modifier/cyborgclamp)

/obj/item/borg/cyborg_clamp/process(seconds_per_tick)
	host.adjustBruteLoss(2 * seconds_per_tick * length(carrying_humans))

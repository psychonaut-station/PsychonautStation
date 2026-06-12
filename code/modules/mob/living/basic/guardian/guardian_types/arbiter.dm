/mob/living/basic/guardian/arbiter
	guardian_type = GUARDIAN_ARBITER
	speed = 0
	damage_coeff = list(BRUTE=0.7, BURN=0.7, TOX=0.7, STAMINA=0, OXY=0.7)
	melee_damage_lower = 1
	melee_damage_upper = 1
	attack_verb_continuous = "shocks"
	attack_verb_simple = "shock"
	playstyle_string = span_holoparasite("The Arbiter Guardian cannot deal damage. It specializes in stunning and cuffing targets.")
	creator_name = "Arbiter"
	creator_desc = "Does no damage but can stun and cuff targets."
	creator_icon = "arbiter"
	var/cuff_delay = 6 SECONDS

/mob/living/basic/guardian/arbiter/Initialize(mapload, datum/guardian_fluff/theme)
	. = ..()
	var/datum/action/cooldown/guardian_energy_net/net_action = new(src)
	net_action.Grant(src)
	ADD_TRAIT(src, TRAIT_SECURITY_HUD, INNATE_TRAIT)

/mob/living/basic/guardian/arbiter/early_melee_attack(atom/target, list/modifiers, ignore_cooldown)
	if(target == summoner || target == src)
		return BASIC_MOB_END_ATTACK_CHAIN
	return ..()

/mob/living/basic/guardian/arbiter/melee_attack(atom/target, list/modifiers, ignore_cooldown)
	. = ..()
	if(!.)
		return
	if(target == summoner || target == src)
		return
	var/mob/living/living_target = astype(target)
	living_target?.adjust_stamina_loss(20)

/mob/living/basic/guardian/arbiter/resolve_right_click_attack(atom/target)
	if(target == src || target == summoner)
		return
	if(!iscarbon(target))
		return ..()

	var/mob/living/carbon/hedef = target

	if(hedef.handcuffed)
		return

	visible_message(span_warning("[src] begins restraining [hedef]!"), span_notice("You start cuffing [hedef]..."))

	if(!do_after(src, cuff_delay, hedef, timed_action_flags = IGNORE_SLOWDOWNS))
		return

	var/obj/item/restraints/handcuffs/cuffs = new /obj/item/restraints/handcuffs/cult()
	cuffs.apply_cuffs(hedef, src)

/datum/action/cooldown/guardian_energy_net
	name = "Energy Net"
	desc = "Throw a hardlight energy net at a target."
	button_icon = 'icons/psychonaut/hud/guardian.dmi'
	button_icon_state = "net"
	cooldown_time = 30 SECONDS
	click_to_activate = TRUE


/obj/structure/energy_net/arbiter
	name = "Arbiter energy net"
	icon = 'icons/psychonaut/effects/effects.dmi'
	icon_state = "arbiter_net"


/obj/projectile/guardian_energy_net
	name = "energy net"
	icon_state = "net_projectile"
	icon = 'icons/obj/clothing/modsuit/mod_modules.dmi'
	damage = 0
	range = 9
	hitsound = 'sound/items/fulton/fultext_deploy.ogg'
	hitsound_wall = 'sound/items/fulton/fultext_deploy.ogg'
	var/line
	var/datum/weakref/net_module
	var/guardian_colour


/obj/projectile/guardian_energy_net/fire(setAngle)
	if(firer)
		var/mob/living/basic/guardian/guardianbeam = firer

		line = firer.Beam(src, "net_beam", 'icons/obj/clothing/modsuit/mod_modules.dmi', beam_color = guardianbeam.guardian_colour)

	return ..()


/datum/action/cooldown/guardian_energy_net/Activate(atom/target)
	var/mob/living/user = owner

	if(!istype(user))
		return FALSE

	var/mob/living/target_mob = target

	if(!IN_GIVEN_RANGE(user, target_mob, 6))
		target_mob.balloon_alert(user, "too far!")
		return FALSE

	var/obj/projectile/guardian_energy_net/net_projectile = new(get_turf(user))

	net_projectile.firer = user
	net_projectile.original = target_mob

	var/mob/living/basic/guardian/guardianrenk = user
	if(guardianrenk)
		net_projectile.guardian_colour = guardianrenk.guardian_colour
		net_projectile.add_atom_colour(guardianrenk.guardian_colour, FIXED_COLOUR_PRIORITY)

	net_projectile.set_angle(get_angle(user, target_mob))
	INVOKE_ASYNC(net_projectile, TYPE_PROC_REF(/obj/projectile, fire))

	StartCooldown()
	return TRUE


/obj/projectile/guardian_energy_net/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()

	if(!isliving(target))
		return

	var/mob/living/hit_mob = target
	var/mob/living/basic/guardian/guardian_firer = firer

	if(istype(guardian_firer))
		if(hit_mob == guardian_firer.summoner)
			return

		if(guardian_firer.shares_summoner(hit_mob))
			return

	if(locate(/obj/structure/energy_net) in get_turf(hit_mob))
		return

	var/obj/structure/energy_net/arbiter/net = new(hit_mob.drop_location())

	if(guardian_firer)
		net.add_atom_colour(guardian_firer.guardian_colour, FIXED_COLOUR_PRIORITY)

	firer?.visible_message(
		span_danger("[firer] traps [hit_mob] in an energy net!"),
		span_notice("You trap [hit_mob] in an energy net!")
	)

	if(hit_mob.buckled)
		hit_mob.buckled.unbuckle_mob(hit_mob, force = TRUE)

	net.buckle_mob(hit_mob, force = TRUE)

	qdel(src)

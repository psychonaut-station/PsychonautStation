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


/mob/living/basic/guardian/arbiter/Initialize(mapload, datum/guardian_fluff/theme)
	. = ..()
	var/datum/action/cooldown/guardian_energy_net/net_action = new(src)
	net_action.Grant(src)
	ADD_TRAIT(src, TRAIT_SECURITY_HUD, INNATE_TRAIT)

/mob/living/basic/guardian/arbiter/early_melee_attack(atom/target, list/modifiers, ignore_cooldown)
	if(target == summoner || target == src)
		return BASIC_MOB_END_ATTACK_CHAIN
	return ..()

/mob/living/basic/guardian/arbiter/melee_attack(atom/target, list/modifiers)
	. = ..()
	if(!isliving(target))
		return

	if(!istype(target, /mob/living/carbon))
		return

	if(target == summoner || target == src)
		return

	var/mob/living/staminahedef = target
	staminahedef.adjust_stamina_loss(30)
	return .

/mob/living/basic/guardian/arbiter/resolve_right_click_attack(atom/target, list/modifiers)
	if(!istype(target, /mob/living/carbon/human))
		return ..()

	var/mob/living/carbon/human/hedef = target

	if(hedef.handcuffed)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	hedef.set_handcuffed(new /obj/item/restraints/handcuffs/cult(hedef))
	hedef.update_handcuffed()

	visible_message(
		span_warning("[src] cuffs [hedef]!"),
		span_notice("You cuff [hedef].")
	)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

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

/datum/action/cooldown/guardian_energy_net
	name = "Energy Net"
	desc = "Throw a hardlight energy net at a target."
	button_icon = 'icons/hud/guardian.dmi'
	button_icon_state = "net"
	cooldown_time = 30 SECONDS
	click_to_activate = TRUE

/obj/projectile/guardian_energy_net/fire(setAngle)
	if(firer)
		line = firer.Beam(src, "net_beam", 'icons/obj/clothing/modsuit/mod_modules.dmi')
	return ..()

/datum/action/cooldown/guardian_energy_net/Activate(atom/target)
	var/mob/living/user = owner

	if(!istype(user))
		return FALSE

	var/atom/aim_target = target

	if(!aim_target)
		return FALSE

	if(!isliving(aim_target))
		return FALSE

	var/mob/living/target_mob = aim_target

	if(!IN_GIVEN_RANGE(user, target_mob, 6))
		target_mob.balloon_alert(user, "too far!")
		return FALSE
	var/obj/projectile/guardian_energy_net/net_projectile = new(get_turf(user))
	net_projectile.firer = user
	net_projectile.original = target_mob
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

	var/obj/structure/energy_net/net = new /obj/structure/energy_net(hit_mob.drop_location())

	firer?.visible_message(
		span_danger("[firer] traps [hit_mob] in an energy net!"),
		span_notice("You trap [hit_mob] in an energy net!")
	)

	if(hit_mob.buckled)
		hit_mob.buckled.unbuckle_mob(hit_mob, force = TRUE)

	net.buckle_mob(hit_mob, force = TRUE)

	qdel(src)

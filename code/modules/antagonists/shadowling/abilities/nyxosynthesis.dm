/datum/status_effect/grouped/bodypart_effect/nyxosynthesis/shadowling
	id = "nyxosynthesis_shadowling"
	tick_interval = 1 SECONDS
	var/applied_speed = FALSE
	var/next_burn_sfx_time = 0
	var/static/sfx_burn = 'sound/items/weapons/sear.ogg'
	var/corpse_light_ticks = 0

/datum/status_effect/grouped/bodypart_effect/nyxosynthesis/shadowling/on_apply()
	. = ..()
	if(!.)
		return FALSE
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(on_owner_death))

/datum/status_effect/grouped/bodypart_effect/nyxosynthesis/shadowling/proc/on_owner_death(mob/living/source, gibbed)
	SIGNAL_HANDLER
	ADD_TRAIT(owner, TRAIT_DEATHCOMA, SHADOWLING_DEATHCOMA_TRAIT)
	ADD_TRAIT(owner, TRAIT_STASIS, SHADOWLING_DEATHCOMA_TRAIT)

/datum/status_effect/grouped/bodypart_effect/nyxosynthesis/shadowling/tick(seconds_between_ticks)
	var/turf/T = get_turf(owner)
	if(!isturf(T))
		return

	var/light = T.get_lumcount()
	var/coef = GET_BODYPART_COEFFICIENT(bodyparts)

	if(light >= SHADOWLING_LIGHT_THRESHOLD)
		if(coef > 0)
			owner.take_overall_damage(
				burn = SHADOWLING_BRIGHT_BURN_PER_LIMB * coef * (owner.stat == DEAD ? 1.5 : 1),
				brute = (owner.stat == DEAD ? 0 : SHADOWLING_BRIGHT_BRUTE_PER_LIMB * coef),
				required_bodytype = BODYTYPE_SHADOW
			)

			if(world.time >= next_burn_sfx_time)
				playsound(T, sfx_burn, (owner.stat == DEAD ? 20 : 10), TRUE)
				next_burn_sfx_time = world.time + 1 SECONDS

		if(applied_speed)
			owner.remove_movespeed_modifier(/datum/movespeed_modifier/shadowling/dark)
			applied_speed = FALSE

		if(owner.stat == DEAD)
			corpse_light_ticks++
			if(corpse_light_ticks >= 15 && !HAS_TRAIT(owner, TRAIT_HUSK))
				owner.become_husk()
				owner.visible_message(span_danger("[owner]'s dark corpse shrivels and withers into a charred husk under the searing light!"))
				playsound(T, 'sound/effects/magic/fireball.ogg', 50, TRUE)
			else if(corpse_light_ticks >= 30 && HAS_TRAIT(owner, TRAIT_HUSK))
				owner.visible_message(span_danger("[owner]'s charred husk crumbles into an ethereal cloud of fading shadow dust!"))
				playsound(T, 'sound/effects/magic/disintegrate.ogg', 70, TRUE)
				owner.dust()
				return
		return

	corpse_light_ticks = max(0, corpse_light_ticks - 1)

	var/is_dead = owner.stat == DEAD
	if(is_dead && HAS_TRAIT(owner, TRAIT_HUSK))
		return

	var/heal_per = (light < SHADOWLING_DIM_THRESHOLD) \
		? SHADOWLING_DARK_HEAL_PER_LIMB_DEEP \
		: SHADOWLING_DARK_HEAL_PER_LIMB_DIM

	if(is_dead)
		heal_per *= SHADOWLING_DEAD_HEAL_MULTIPLIER

	owner.heal_overall_damage(
		brute = heal_per * coef,
		burn = heal_per * coef,
		required_bodytype = BODYTYPE_SHADOW
	)

	regenerate_organs(heal_per * coef)

	if(is_dead)
		if(owner.get_brute_loss() <= 0 && owner.get_fire_loss() <= 0)
			try_revive()
		return

	var/stam_regen = (light < SHADOWLING_DIM_THRESHOLD) \
		? SHADOWLING_DARK_STAMINA_PER_LIMB_DEEP \
		: SHADOWLING_DARK_STAMINA_PER_LIMB_DIM

	if(stam_regen > 0 && coef > 0)
		owner.adjust_stamina_loss(-(stam_regen * coef))

	if(!owner.has_status_effect(/datum/status_effect/shadow/nightmare))
		owner.apply_status_effect(/datum/status_effect/shadow)

	if(!applied_speed)
		owner.add_movespeed_modifier(/datum/movespeed_modifier/shadowling/dark)
		applied_speed = TRUE

/datum/status_effect/grouped/bodypart_effect/nyxosynthesis/shadowling/proc/try_revive()
	if(!owner || owner.stat != DEAD)
		return FALSE
	if(owner.get_brute_loss() > 0 || owner.get_fire_loss() > 0)
		return FALSE
	REMOVE_TRAIT(owner, TRAIT_DEATHCOMA, SHADOWLING_DEATHCOMA_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_STASIS, SHADOWLING_DEATHCOMA_TRAIT)
	owner.revive(HEAL_DAMAGE|HEAL_BODY|HEAL_STATUS|HEAL_CC_STATUS, force_grab_ghost = TRUE)
	to_chat(owner, span_notice("The darkness has restored your body. You return to life."))
	notify_ghosts("The shadowling [owner.real_name] has reformed in the darkness!", source = owner)

	return TRUE

/datum/status_effect/grouped/bodypart_effect/nyxosynthesis/shadowling/proc/regenerate_organs(heal_amount)
	if(!iscarbon(owner) || heal_amount <= 0)
		return
	var/mob/living/carbon/carbon_owner = owner
	for(var/obj/item/organ/organ as anything in carbon_owner.organs)
		if(QDELETED(organ))
			continue
		if(organ.damage <= 0)
			continue
		organ.set_organ_damage(max(0, organ.damage - heal_amount))

/datum/status_effect/grouped/bodypart_effect/nyxosynthesis/shadowling/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_DEATH)
	if(applied_speed && owner)
		owner.remove_movespeed_modifier(/datum/movespeed_modifier/shadowling/dark)
	return ..()

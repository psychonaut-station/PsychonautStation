/mob/living/basic/guardian/engineer
	guardian_type = GUARDIAN_ENGINEER
	speed = 0
	damage_coeff = list(BRUTE=0.5, BURN=0.5, TOX=0.5, STAMINA=0, OXY=0.5)
	melee_damage_lower = 10
	melee_damage_upper = 10
	playstyle_string = span_holoparasite("The Engineer Guardian can toggle Turret Mode. While in Turret Mode, it becomes immobile and fires randomized junk ammunition.")
	creator_name = "Engineer"
	creator_desc = "Deals very low damage, but can enter Turret Mode. While in Turret Mode, it becomes immobile and takes increased damage, but gains a ranged attack that fires randomized junk ammunition."
	creator_icon = "engineer"
	toggle_button_type = /datum/action/cooldown/guardian/toggle_mode
	var/turret_mode_enabled = FALSE

/mob/living/basic/guardian/engineer/toggle_modes()
	if (turret_mode_enabled)
		disable_turret_mode()
	else
		enable_turret_mode()

/mob/living/basic/guardian/engineer/proc/enable_turret_mode()
	turret_mode_enabled = TRUE
	mobility_flags &= ~MOBILITY_MOVE
	density = TRUE
	layer = MOB_LAYER + 1
	damage_coeff = list(BRUTE=0.7, BURN=0.7, TOX=0.7, STAMINA=0, OXY=0.7)

	AddComponent(\
		/datum/component/ranged_attacks,\
		projectile_type = /obj/projectile/bullet/junk,\
		projectile_sound = 'sound/items/weapons/gun/pistol/shot.ogg',\
		cooldown_time = 0.8 SECONDS,\
	)

	if(pulledby)
		pulledby.stop_pulling()

	unleash()

	to_chat(src, span_notice("Turret mode enabled."))
	return TRUE

/mob/living/basic/guardian/engineer/proc/disable_turret_mode()
	turret_mode_enabled = FALSE
	mobility_flags |= MOBILITY_MOVE
	density = FALSE
	layer = MOB_LAYER

	damage_coeff = list(BRUTE=0.7, BURN=0.7, TOX=0.7, STAMINA=0, OXY=0.7)

	qdel(GetComponent(/datum/component/ranged_attacks))

	if(summoner)
		leash_to(src, summoner)

	to_chat(src, span_notice("Turret mode disabled."))
	return TRUE

/mob/living/basic/guardian/engineer/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	if(turret_mode_enabled)
		return TRUE
	return ..()

/mob/living/basic/guardian/engineer/recall(forced)
	if(turret_mode_enabled)
		balloon_alert(src, "cannot recall in turret mode!")
		if(summoner)
			summoner.balloon_alert(summoner, "[src] is in turret mode!")
		return FALSE
	return ..()

/mob/living/basic/guardian/engineer/can_be_pulled(user, force)
	if(turret_mode_enabled)
		return FALSE
	return ..()

/mob/living/basic/guardian/engineer/fire_projectile(projectile_type, atom/target, sound, firer, list/ignore_targets)
	if (!turret_mode_enabled)
		return FALSE

	if (!isnull(sound))
		playsound(src, sound, vol = 100, vary = TRUE)

	var/list/projectile_weighted_table = list(
		/obj/projectile/bullet/engineer_junk = 50,
		/obj/projectile/bullet/incendiary/fire/engineer_junk = 20,
		/obj/projectile/bullet/junk/engineer_shock = 20,
		/obj/projectile/bullet/junk/engineer_hunter = 20,
		/obj/projectile/bullet/junk/engineer_phasic = 5,
		/obj/projectile/bullet/junk/engineer_ripper = 5,
		/obj/projectile/bullet/junk/engineer_reaper = 1
	)

	var/total_weight = 0
	for(var/p_type in projectile_weighted_table)
		total_weight += projectile_weighted_table[p_type]

	var/weight_pick = rand(total_weight)
	var/obj/projectile/chosen_projectile_type
	for(var/p_type in projectile_weighted_table)
		if(weight_pick <= projectile_weighted_table[p_type])
			chosen_projectile_type = p_type
			break
		else
			weight_pick -= projectile_weighted_table[p_type]

	var/obj/projectile/spawned_projectile = new chosen_projectile_type(get_turf(src))
	spawned_projectile.firer = firer || src
	spawned_projectile.fired_from = src
	spawned_projectile.original = target
	for(var/atom/thing as anything in ignore_targets)
		spawned_projectile.impacted[WEAKREF(thing)] = TRUE
	if (target)
		spawned_projectile.fire(get_angle(src, target))
	else
		spawned_projectile.fire()

	return TRUE


/obj/projectile/bullet/engineer_junk
	name = "junk bullet"
	damage = 15
	var/stamina_damage = 10

/obj/projectile/bullet/incendiary/fire/engineer_junk
	name = "burning oil projectile"
	damage = 30
	fire_stacks = 5
	suppressed = SUPPRESSED_NONE

/obj/projectile/bullet/junk/engineer_shock
	name = "electrical junk projectile"
	icon_state = "tesla_projectile"
	damage = 15
	extra_damage_added_damage = 30
	extra_damage_type = BURN

/obj/projectile/bullet/junk/engineer_hunter
	name = "hunter junk projectile"
	icon_state = "gauss"
	extra_damage_added_damage = 50

/obj/projectile/bullet/junk/engineer_phasic
	name = "phasic junk projectile"
	icon_state = "gaussphase"
	projectile_phasing = PASSTABLE | PASSGLASS | PASSGRILLE | PASSCLOSEDTURF | PASSMACHINE | PASSSTRUCTURE | PASSDOORS

/obj/projectile/bullet/junk/engineer_ripper
	name = "ripper junk projectile"
	icon_state = "redtrac"
	damage = 30
	embed_type = /datum/embedding/bullet/junk/ripper
	wound_bonus = 10
	exposed_wound_bonus = 30

/datum/embedding/bullet/junk/engineer_ripper
	embed_chance = 100
	fall_chance = 3
	jostle_chance = 4
	ignore_throwspeed_threshold = TRUE
	pain_stam_pct = 0.4
	pain_mult = 5
	jostle_pain_mult = 6
	rip_time = 1 SECONDS

/obj/projectile/bullet/junk/engineer_reaper
	name = "reaper junk projectile"
	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/sniper
	impact_type = /obj/effect/projectile/impact/sniper
	muzzle_type = /obj/effect/projectile/muzzle/sniper
	hitscan_light_intensity = 3
	muzzle_flash_intensity = 5

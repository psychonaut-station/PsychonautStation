/obj/item/organ/cyberimp/chest
	name = "cybernetic torso implant"
	desc = "Implants for the organs in your torso."
	abstract_type = /obj/item/organ/cyberimp/chest
	zone = BODY_ZONE_CHEST

/obj/item/organ/cyberimp/chest/nutriment
	name = "nutriment pump implant"
	desc = "This implant will synthesize and pump into your bloodstream a small amount of nutriment when you are starving."
	icon_state = "nutriment_implant"
	aug_overlay = "nutripump"
	var/hunger_threshold = NUTRITION_LEVEL_STARVING
	var/synthesizing = 0
	var/poison_amount = 5
	slot = ORGAN_SLOT_STOMACH_AID

/obj/item/organ/cyberimp/chest/nutriment/on_life(seconds_per_tick, times_fired)
	if(synthesizing)
		return

	if(owner.nutrition <= hunger_threshold)
		synthesizing = TRUE
		to_chat(owner, span_notice("You feel less hungry..."))
		owner.adjust_nutrition(25 * seconds_per_tick)
		addtimer(CALLBACK(src, PROC_REF(synth_cool)), 5 SECONDS)

/obj/item/organ/cyberimp/chest/nutriment/proc/synth_cool()
	synthesizing = FALSE

/obj/item/organ/cyberimp/chest/nutriment/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return
	owner.reagents.add_reagent(/datum/reagent/toxin/bad_food, poison_amount / severity)
	to_chat(owner, span_warning("You feel like your insides are burning."))


/obj/item/organ/cyberimp/chest/nutriment/plus
	name = "nutriment pump implant PLUS"
	desc = "This implant will synthesize and pump into your bloodstream a small amount of nutriment when you are hungry."
	icon_state = "adv_nutriment_implant"
	aug_overlay = "nutripump_adv"
	hunger_threshold = NUTRITION_LEVEL_HUNGRY
	poison_amount = 10

/obj/item/organ/cyberimp/chest/reviver
	name = "reviver implant"
	desc = "This implant will attempt to revive and heal you if you lose consciousness. For the faint of heart!"
	icon_state = "reviver_implant"
	aug_overlay = "reviver"
	emissive_overlay = TRUE
	slot = ORGAN_SLOT_HEART_AID
	var/revive_cost = 0
	var/reviving = FALSE
	COOLDOWN_DECLARE(reviver_cooldown)
	COOLDOWN_DECLARE(defib_cooldown)

/obj/item/organ/cyberimp/chest/reviver/on_death(seconds_per_tick, times_fired)
	if(isnull(owner)) // owner can be null, on_death() gets called by /obj/item/organ/process() for decay
		return
	try_heal() // Allows implant to work even on dead people

/obj/item/organ/cyberimp/chest/reviver/on_life(seconds_per_tick, times_fired)
	try_heal()

/obj/item/organ/cyberimp/chest/reviver/proc/try_heal()
	if(reviving)
		if(owner.stat == CONSCIOUS)
			COOLDOWN_START(src, reviver_cooldown, revive_cost)
			reviving = FALSE
			to_chat(owner, span_notice("Your reviver implant shuts down and starts recharging. It will be ready again in [DisplayTimeText(revive_cost)]."))
		else
			addtimer(CALLBACK(src, PROC_REF(heal)), 3 SECONDS)
		return

	if(!COOLDOWN_FINISHED(src, reviver_cooldown) || HAS_TRAIT(owner, TRAIT_SUICIDED))
		return

	if(owner.stat != CONSCIOUS)
		revive_cost = 0
		reviving = TRUE
		to_chat(owner, span_notice("You feel a faint buzzing as your reviver implant starts patching your wounds..."))
		COOLDOWN_START(src, defib_cooldown, 8 SECONDS) // 5 seconds after heal proc delay


/obj/item/organ/cyberimp/chest/reviver/proc/heal()
	if(COOLDOWN_FINISHED(src, defib_cooldown))
		revive_dead()

	/// boolean that stands for if PHYSICAL damage being patched
	var/body_damage_patched = FALSE
	var/need_mob_update = FALSE
	if(owner.get_oxy_loss())
		need_mob_update += owner.adjust_oxy_loss(-5, updating_health = FALSE)
		revive_cost += 5
	if(owner.get_brute_loss())
		need_mob_update += owner.adjust_brute_loss(-2, updating_health = FALSE)
		revive_cost += 40
		body_damage_patched = TRUE
	if(owner.get_fire_loss())
		need_mob_update += owner.adjust_fire_loss(-2, updating_health = FALSE)
		revive_cost += 40
		body_damage_patched = TRUE
	if(owner.get_tox_loss())
		need_mob_update += owner.adjust_tox_loss(-1, updating_health = FALSE)
		revive_cost += 40
	if(need_mob_update)
		owner.updatehealth()

	if(body_damage_patched && prob(35)) // healing is called every few seconds, not every tick
		owner.visible_message(span_warning("[owner]'s body twitches a bit."), span_notice("You feel like something is patching your injured body."))


/obj/item/organ/cyberimp/chest/reviver/proc/revive_dead()
	if(!COOLDOWN_FINISHED(src, defib_cooldown) || owner.stat != DEAD || owner.can_defib() != DEFIB_POSSIBLE)
		return
	owner.notify_revival("You are being revived by [src]!")
	revive_cost += 10 MINUTES // Additional 10 minutes cooldown after revival.
	owner.grab_ghost()

	defib_cooldown += 16 SECONDS // delay so it doesn't spam

	owner.visible_message(span_warning("[owner]'s body convulses a bit."))
	playsound(owner, SFX_BODYFALL, 50, TRUE)
	playsound(owner, 'sound/machines/defib/defib_zap.ogg', 75, TRUE, -1)
	owner.set_heartattack(FALSE)
	owner.revive()
	owner.emote("gasp")
	owner.set_jitter_if_lower(200 SECONDS)
	SEND_SIGNAL(owner, COMSIG_LIVING_MINOR_SHOCK)
	log_game("[owner] been revived by [src]")


/obj/item/organ/cyberimp/chest/reviver/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return

	if(reviving)
		revive_cost += 200
	else
		reviver_cooldown += 20 SECONDS

	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		if(human_owner.stat != DEAD && prob(50 / severity) && human_owner.can_heartattack())
			human_owner.set_heartattack(TRUE)
			to_chat(human_owner, span_userdanger("You feel a horrible agony in your chest!"))
			addtimer(CALLBACK(src, PROC_REF(undo_heart_attack)), 600 / severity)

/obj/item/organ/cyberimp/chest/reviver/proc/undo_heart_attack()
	var/mob/living/carbon/human/human_owner = owner
	if(!istype(human_owner))
		return
	human_owner.set_heartattack(FALSE)
	if(human_owner.stat == CONSCIOUS)
		to_chat(human_owner, span_notice("You feel your heart beating again!"))


/obj/item/organ/cyberimp/chest/thrusters
	name = "implantable thrusters set"
	desc = "An implantable set of thruster ports. They use the gas from environment or subject's internals for propulsion in zero-gravity areas. \
	Unlike regular jetpacks, this device has no stabilization system."
	slot = ORGAN_SLOT_THRUSTERS
	icon_state = "imp_jetpack"
	base_icon_state = "imp_jetpack"
	aug_overlay = "imp_jetpack"
	emissive_overlay = TRUE
	actions_types = list(/datum/action/item_action/organ_action/toggle)
	w_class = WEIGHT_CLASS_NORMAL
	var/on = FALSE

/obj/item/organ/cyberimp/chest/thrusters/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/jetpack, \
		FALSE, \
		1.5 NEWTONS, \
		1.2 NEWTONS, \
		COMSIG_THRUSTER_ACTIVATED, \
		COMSIG_THRUSTER_DEACTIVATED, \
		THRUSTER_ACTIVATION_FAILED, \
		CALLBACK(src, PROC_REF(allow_thrust), 0.01), \
		CALLBACK(src, PROC_REF(allow_thrust), 0.01), \
		/datum/effect_system/trail_follow/ion, \
	)

/obj/item/organ/cyberimp/chest/thrusters/Remove(mob/living/carbon/thruster_owner, special, movement_flags)
	if(on)
		deactivate(silent = TRUE)
	..()

/obj/item/organ/cyberimp/chest/thrusters/ui_action_click()
	toggle()

/obj/item/organ/cyberimp/chest/thrusters/proc/toggle(silent = FALSE)
	if(on)
		deactivate()
	else
		activate()

/obj/item/organ/cyberimp/chest/thrusters/proc/activate(silent = FALSE)
	if(on)
		return
	if(organ_flags & ORGAN_FAILING)
		if(!silent)
			to_chat(owner, span_warning("Your thrusters set seems to be broken!"))
		return
	if(SEND_SIGNAL(src, COMSIG_THRUSTER_ACTIVATED, owner) & THRUSTER_ACTIVATION_FAILED)
		return

	on = TRUE
	owner.add_movespeed_modifier(/datum/movespeed_modifier/jetpack/cybernetic)
	if(!silent)
		to_chat(owner, span_notice("You turn your thrusters set on."))
	update_appearance()
	owner.update_body_parts()

/obj/item/organ/cyberimp/chest/thrusters/proc/deactivate(silent = FALSE)
	if(!on)
		return
	SEND_SIGNAL(src, COMSIG_THRUSTER_DEACTIVATED, owner)
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/jetpack/cybernetic)
	if(!silent)
		to_chat(owner, span_notice("You turn your thrusters set off."))
	on = FALSE
	update_appearance()
	owner.update_body_parts()

/obj/item/organ/cyberimp/chest/thrusters/update_icon_state()
	icon_state = "[base_icon_state][on ? "-on" : null]"
	return ..()

/obj/item/organ/cyberimp/chest/thrusters/proc/allow_thrust(num, use_fuel = TRUE)
	if(!owner)
		return FALSE

	var/turf/owner_turf = get_turf(owner)
	if(!owner_turf) // No more runtimes from being stuck in nullspace.
		return FALSE

	// Priority 1: use air from environment.
	var/datum/gas_mixture/environment = owner_turf.return_air()
	if(environment && environment.return_pressure() > 30)
		return TRUE

	// Priority 2: use plasma from internal plasma storage.
	// (just in case someone would ever use this implant system to make cyber-alien ops with jetpacks and taser arms)
	if(owner.getPlasma() >= num * 100)
		if(use_fuel)
			owner.adjustPlasma(-num * 100)
		return TRUE

	// Priority 3: use internals tank.
	var/datum/gas_mixture/internal_mix = owner.internal?.return_air()
	if(internal_mix && internal_mix.total_moles() > num)
		if(!use_fuel)
			return TRUE
		var/datum/gas_mixture/removed = internal_mix.remove(num)
		if(removed.total_moles() > 0.005)
			owner_turf.assume_air(removed)
			return TRUE
		else
			owner_turf.assume_air(removed)

	deactivate(silent = TRUE)
	return FALSE

/obj/item/organ/cyberimp/chest/thrusters/get_overlay_state(image_layer, obj/item/bodypart/limb)
	return "[aug_overlay][on ? "_on" : ""]"

/obj/item/organ/cyberimp/chest/thrusters/get_overlay(image_layer, obj/item/bodypart/limb)
	. = ..()
	for (var/image/overlay as anything in .)
		overlay.layer = -BODYPARTS_HIGH_LAYER // makes absolutely zero sense why it would layer ontop of jumpsuits but it looks cool

/obj/item/organ/cyberimp/chest/spine
	name = "\improper Herculean gravitronic spinal implant"
	desc = "This gravitronic spinal interface is able to improve the athletics of a user, allowing them greater physical ability. \
		Contains a slot which can be upgraded with a gravity anomaly core, improving its performance."
	icon_state = "herculean_implant"
	slot = ORGAN_SLOT_SPINE
	/// How much faster does the spinal implant improve our lifting speed, workout ability, reducing falling damage and improving climbing and standing speed
	var/athletics_boost_multiplier = 0.8
	/// How much additional throwing speed does our spinal implant grant us.
	var/added_throw_speed = 1
	/// How much additional throwing range does our spinal implant grant us.
	var/added_throw_range = 4
	/// How much additional boxing damage and tackling power do we add?
	var/strength_bonus = 4
	/// Whether or not a gravity anomaly core has been installed, improving the effectiveness of the spinal implant.
	var/core_applied = FALSE
	/// The overlay for our implant to indicate that, yes, this person has an implant inserted.
	var/mutable_appearance/stone_overlay

/obj/item/organ/cyberimp/chest/spine/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return
	to_chat(owner, span_warning("You feel sheering pain as your body is crushed like a soda can!"))
	owner.apply_damage(20/severity, BRUTE, def_zone = BODY_ZONE_CHEST)

/obj/item/organ/cyberimp/chest/spine/on_mob_insert(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	stone_overlay = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "stone")
	organ_owner.add_overlay(stone_overlay)
	add_organ_trait(TRAIT_BOULDER_BREAKER)
	if(core_applied)
		organ_owner.AddElement(/datum/element/forced_gravity, 1)
		add_organ_trait(TRAIT_STURDY_FRAME)

/obj/item/organ/cyberimp/chest/spine/on_mob_remove(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	remove_organ_trait(TRAIT_BOULDER_BREAKER)
	if(stone_overlay)
		organ_owner.cut_overlay(stone_overlay)
		stone_overlay = null
	if(core_applied)
		organ_owner.RemoveElement(/datum/element/forced_gravity, 1)
		remove_organ_trait(TRAIT_STURDY_FRAME)

/obj/item/organ/cyberimp/chest/spine/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/assembly/signaler/anomaly/grav))
		return NONE

	if(core_applied)
		user.balloon_alert(user, "core already installed!")
		return ITEM_INTERACT_BLOCKING

	user.balloon_alert(user, "core installed")
	name = /obj/item/organ/cyberimp/chest/spine/atlas::name
	desc = /obj/item/organ/cyberimp/chest/spine/atlas::desc
	athletics_boost_multiplier = /obj/item/organ/cyberimp/chest/spine/atlas::athletics_boost_multiplier
	added_throw_range = /obj/item/organ/cyberimp/chest/spine/atlas::added_throw_range
	added_throw_speed = /obj/item/organ/cyberimp/chest/spine/atlas::added_throw_speed
	strength_bonus = /obj/item/organ/cyberimp/chest/spine/atlas::strength_bonus
	core_applied = TRUE
	icon_state = "herculean_implant_core"
	update_appearance()
	qdel(tool)
	return ITEM_INTERACT_SUCCESS

/obj/item/organ/cyberimp/chest/spine/atlas
	name = "\improper Atlas gravitonic spinal implant"
	desc = "This gravitronic spinal interface is able to improve the athletics of a user, allowing them greater physical ability. \
		This one has been improved through the installation of a gravity anomaly core, allowing for personal gravity manipulation. \
		Not only can you walk with your feet planted firmly on the ground even during a loss of environmental gravity, but you also \
		carry heavier loads with relative ease."
	icon_state = "herculean_implant_core"
	athletics_boost_multiplier = 0.25
	added_throw_speed = 6
	added_throw_range = 8
	strength_bonus = 8
	core_applied = TRUE

/datum/action/item_action/organ_action/sandy
	name = "Sandevistan Activation"

/obj/item/organ/cyberimp/chest/sandevistan
	name = "Militech Apogee Sandevistan"
	desc = "This model of Sandevistan doesn't exist, at least officially. Off the record, there's gossip of secret Militech Lunar labs producing covert cyberware. It was never meant to be mass produced, but an army would only really need a few pieces like this one to dominate their enemy."
	icon = 'icons/psychonaut/obj/medical/organs/organs.dmi'
	icon_state = "sandy"

	aug_icon = 'icons/psychonaut/mob/human/species/misc/bodypart_overlay_augmentations.dmi'
	aug_overlay = "sandy"
	slot = ORGAN_SLOT_SPINE
	organ_flags = parent_type::organ_flags | ORGAN_HIDDEN
	actions_types = list(/datum/action/item_action/organ_action/sandy)

	var/active = FALSE

	var/exit_zone_timer

	var/active_for = 0
	var/cooldown_multiplier = 2 // Cooldown = active_for * cooldown_multiplier

	var/emp_vulnerability = 30 //Chance of permanent effects if emp-ed.
	var/emp_speed_multiplier = 1

	COOLDOWN_DECLARE(in_the_zone)

/obj/item/organ/cyberimp/chest/sandevistan/on_mob_remove(mob/living/carbon/organ_owner, special = FALSE, movement_flags)
	. = ..()
	clear_effects(organ_owner, TRUE)

/obj/item/organ/cyberimp/chest/sandevistan/ui_action_click()

	if((organ_flags & ORGAN_FAILING))
		to_chat(owner, span_warning("The implant doesn't respond. It seems to be broken..."))
		return
	if(!active)
		if(!COOLDOWN_FINISHED(src, in_the_zone))
			to_chat(owner, span_warning("The implant doesn't respond. It seems to be recharging..."))
			return
		active_for = 0
		active = TRUE
		owner.AddComponent(/datum/component/after_image, 16, 0.5, TRUE)
		owner.AddComponent(/datum/component/slowing_field, 0.1, 5, 1, 3)
		owner.add_movespeed_modifier(/datum/movespeed_modifier/status_effect/sandevistan)
		owner.add_actionspeed_modifier(/datum/actionspeed_modifier/status_effect/sandevistan)

		exit_zone_timer = addtimer(CALLBACK(src, PROC_REF(exit_the_zone)), 15 SECONDS, TIMER_STOPPABLE)
	else
		exit_the_zone()

/obj/item/organ/cyberimp/chest/sandevistan/on_life(seconds_per_tick)
	if(!active)
		return
	active_for += seconds_per_tick

/obj/item/organ/cyberimp/chest/sandevistan/proc/exit_the_zone()
	if(!active)
		return

	deltimer(exit_zone_timer)
	exit_zone_timer = null

	active = FALSE
	COOLDOWN_START(src, in_the_zone, (active_for * cooldown_multiplier) SECONDS)

	clear_effects(owner)

	if(organ_flags & ORGAN_EMP)
		owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/status_effect/slowing_field, TRUE, emp_speed_multiplier)
		owner.add_or_update_variable_actionspeed_modifier(/datum/actionspeed_modifier/status_effect/slowing_field, TRUE, emp_speed_multiplier)
		addtimer(CALLBACK(src, PROC_REF(end_emp_effect), owner), active_for SECONDS)

/obj/item/organ/cyberimp/chest/sandevistan/proc/clear_effects(mob/living/organ_owner, force = FALSE)
	if(isnull(organ_owner))
		return FALSE
	var/datum/component/after_image = organ_owner.GetComponent(/datum/component/after_image)
	qdel(after_image)
	var/datum/component/slowing_field = organ_owner.GetComponent(/datum/component/slowing_field)
	qdel(slowing_field)

	organ_owner.remove_movespeed_modifier(/datum/movespeed_modifier/status_effect/sandevistan)
	organ_owner.remove_actionspeed_modifier(/datum/actionspeed_modifier/status_effect/sandevistan)
	if(force)
		end_emp_effect(organ_owner)

/obj/item/organ/cyberimp/chest/sandevistan/proc/end_emp_effect(mob/living/organ_owner)
	organ_owner.remove_movespeed_modifier(/datum/movespeed_modifier/status_effect/slowing_field)
	organ_owner.remove_actionspeed_modifier(/datum/actionspeed_modifier/status_effect/slowing_field)

/obj/item/organ/cyberimp/chest/sandevistan/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(prob(emp_vulnerability/severity))
		organ_flags |= ORGAN_EMP

/obj/item/organ/cyberimp/chest/sandevistan/hasty
	name = "hasty sandevistan"
	desc = "The branding has been scratched off of these and it looks hastily put together."
	organ_flags = parent_type::organ_flags & ~ORGAN_HIDDEN
	cooldown_multiplier = 3
	emp_vulnerability = 50
	emp_speed_multiplier = 1.25

/obj/item/organ/cyberimp/chest/sandevistan/hasty/ui_action_click(mob/user, actiontype)
	if(prob(45))
		if(iscarbon(user))
			var/mob/living/carbon/carbon = user
			carbon.adjust_organ_loss(ORGAN_SLOT_BRAIN, 10)
			to_chat(user, span_warning("You are overloaded with information and suffer some backlash."))
	. = ..()

/obj/item/organ/cyberimp/chest/sandevistan/hasty/exit_the_zone(mob/living/exiter)
	. = ..()
	if(prob(45))
		exiter.adjust_brute_loss(10)
		to_chat(exiter, span_warning("Your body was not able to handle the strain of [src] causing you to experience some minor bruising."))

/obj/item/organ/cyberimp/chest/chemvat
	name = "R.A.G.E. chemical system"
	desc = "Extremely dangerous system that fills the user with a mix of potent drugs."
	icon = 'icons/psychonaut/obj/clothing/back.dmi'

	icon_state = "chemvat_back"
	organ_flags = parent_type::organ_flags | ORGAN_HIDDEN
	slot = ORGAN_SLOT_SPINE

	var/obj/item/clothing/mask/chemvat/forced
	var/obj/item/chemvat_tank/forced_tank

	var/max_ticks_cooldown = 20 SECONDS
	var/current_ticks_cooldown = 0

	var/emp_vulnerability = 40

	var/list/reagent_list = list(
		/datum/reagent/determination = 2,
		/datum/reagent/medicine/c2/penthrite = 3 ,
		/datum/reagent/drug/bath_salts = 3 ,
		/datum/reagent/medicine/omnizine = 3,
		/datum/reagent/medicine/brain_healer = 5,
	)

	var/mutable_appearance/overlay

/obj/item/organ/cyberimp/chest/chemvat/on_mob_insert(mob/living/carbon/receiver, special = FALSE, movement_flags)
	. = ..()

	forced = new
	forced_tank = new

	if(receiver.wear_mask && !istype(receiver.wear_mask,/obj/item/clothing/mask/chemvat))
		receiver.dropItemToGround(receiver.wear_mask, TRUE)
		receiver.equip_to_slot(forced, ITEM_SLOT_MASK)
	if(!receiver.wear_mask)
		receiver.equip_to_slot(forced, ITEM_SLOT_MASK)

	if(receiver.back && !istype(receiver.back,/obj/item/chemvat_tank))
		receiver.dropItemToGround(receiver.back, TRUE)
		receiver.equip_to_slot(forced_tank, ITEM_SLOT_BACK)
	if(!receiver.back)
		receiver.equip_to_slot(forced_tank, ITEM_SLOT_BACK)

/obj/item/organ/cyberimp/chest/chemvat/on_mob_remove(mob/living/carbon/organ_owner, special = FALSE, movement_flags)
	. = ..()
	organ_owner.dropItemToGround(organ_owner.wear_mask, TRUE)
	organ_owner.dropItemToGround(organ_owner.back, TRUE)
	QDEL_NULL(forced)
	QDEL_NULL(forced_tank)


/obj/item/organ/cyberimp/chest/chemvat/on_life()
		//Cost of refilling is a little bit of nutrition, some blood and getting jittery
	if(owner.nutrition > NUTRITION_LEVEL_STARVING && owner.blood_volume > BLOOD_VOLUME_SURVIVE && current_ticks_cooldown > 0)

		owner.nutrition -= 5
		owner.blood_volume--
		owner.adjust_jitter(1)
		owner.adjust_dizzy(1)

		current_ticks_cooldown -= SSmobs.wait

		return

	if(current_ticks_cooldown <= 0)
		current_ticks_cooldown = max_ticks_cooldown
		on_effect()

/obj/item/organ/cyberimp/chest/chemvat/proc/on_effect()
	var/obj/effect/temp_visual/chempunk/punk = new /obj/effect/temp_visual/chempunk(get_turf(owner))
	punk.color = "#77BD5D"
	owner.reagents.add_reagent_list(reagent_list)

	overlay = mutable_appearance('icons/effects/effects.dmi', "biogas", ABOVE_MOB_LAYER)
	overlay.color = "#77BD5D"

	RegisterSignal(owner,COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(update_owner_overlay))

	addtimer(CALLBACK(src, PROC_REF(remove_overlay)),max_ticks_cooldown/2)

	to_chat(owner,"<span class = 'notice'> You feel a sharp pain as the cocktail of chemicals is injected into your bloodstream!</span>")
	return

/obj/item/organ/cyberimp/chest/chemvat/proc/update_owner_overlay(atom/source, list/overlays)
	SIGNAL_HANDLER

	if(overlay)
		overlays += overlay

/obj/item/organ/cyberimp/chest/chemvat/proc/remove_overlay()
	QDEL_NULL(overlay)

	UnregisterSignal(owner,COMSIG_ATOM_UPDATE_OVERLAYS)

/obj/item/organ/cyberimp/chest/chemvat/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(prob(emp_vulnerability/severity) && !(organ_flags & ORGAN_EMP))
		organ_flags |= ORGAN_EMP
		reagent_list += list(/datum/reagent/toxin/histamine = 10, /datum/reagent/toxin/mutetoxin = 5)

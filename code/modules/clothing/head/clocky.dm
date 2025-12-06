/obj/item/clothing/head/helmet/clocky
	name = "clock head"
	desc = "A special clock head that can rewind time for the people, but at a cost."
	icon_state = "clocky_head_iconise"
	icon = 'icons/psychonaut/mob/clothing/head/clocky.dmi'
	worn_icon = 'icons/psychonaut/mob/clothing/head/clocky.dmi'
	lefthand_file = 'icons/psychonaut/mob/inhands/clothing/dante_lefthand.dmi'
	righthand_file = 'icons/psychonaut/mob/inhands/clothing/dante_righthand.dmi'
	worn_icon_state = "clocky_head_inactive"
	base_icon_state = "clocky_head"
	inhand_icon_state = "dante_inactive"

	force = 10
	dog_fashion = null
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	equip_delay_self = 5 SECONDS
	equip_delay_other = 20 SECONDS
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | SNUG_FIT | STACKABLE_HELMET_EXEMPT | HEADINTERNALS
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACE|HIDESNOUT|HIDEANTENNAE|HIDEFACIALHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	resistance_flags = FIRE_PROOF | ACID_PROOF
	equip_sound = 'sound/items/handling/helmet/helmet_equip1.ogg'
	pickup_sound = 'sound/items/handling/helmet/helmet_pickup1.ogg'
	drop_sound = 'sound/items/handling/helmet/helmet_drop1.ogg'
	armor_type = /datum/armor/head_helmet_clocky

	var/modifies_speech = TRUE // enables speech modification
	var/list/clock_sounds = list("Tick Tock!!","Tick Tick","Tick Tock?","Tick Tack","Tick Tick Tock...") // phrases to be said when the player attempts to talk when speech modification is enabled

	/// If we have a core or not
	var/core_installed = FALSE
	/// List of additonal clothing traits to apply when the core is inserted
	var/list/additional_clothing_traits = list(
		TRAIT_NOFLASH,
		TRAIT_GOOD_HEARING,
	)


/datum/armor/head_helmet_clocky
	bomb = 15
	fire = 50
	acid = 50
	melee = 10
	bullet = 10
	laser = 10
	energy = 10



/obj/item/clothing/head/helmet/clocky/Initialize(mapload)
	. = ..()
	update_appearance(UPDATE_ICON_STATE)
	update_anomaly_state()

/obj/item/clothing/head/helmet/clocky/equipped(mob/living/user, slot)
	. = ..()
	if(!iscarbon(user))
		return
	if(slot & ITEM_SLOT_HEAD)
		user.update_sight()
		if(!core_installed)
			to_chat(user, span_warning("You can't wear this without a bioscrambler anomaly core!"))
			user.dropItemToGround(src, force=TRUE)
			return
		if(core_installed)
			if(user.stat == DEAD) // helmet cannot be worn by dead players
				user.dropItemToGround(src, force=TRUE)
				return
			if(user.has_status_effect(/datum/status_effect/hippocratic_oath) || user.has_status_effect(/datum/status_effect/clock_rewind))
				to_chat(user, span_warning("You can't possibly handle more aura!"))
				user.dropItemToGround(src, force=TRUE)
				return
			make_cursed()
		user.apply_status_effect(/datum/status_effect/clock_rewind)
		// Register death signal when helmet is equipped, so when user is dead helmet will drop in the following function
		RegisterSignal(user, COMSIG_LIVING_DEATH, PROC_REF(on_user_death))

/obj/item/clothing/head/helmet/clocky/dropped(mob/living/user, silent)
	user.update_sight()
	clear_curse()
	user.remove_status_effect(/datum/status_effect/clock_rewind)
	return ..()

/obj/item/clothing/head/helmet/clocky/proc/update_anomaly_state()
	// If the core isn't installed, or it's temporarily deactivated, disable special functions.
	if(!core_installed)
		detach_clothing_traits(additional_clothing_traits)
		clear_curse()
		if(ismob(loc))
			var/mob/living/M = loc
			M.remove_status_effect(/datum/status_effect/clock_rewind)
		return
	attach_clothing_traits(additional_clothing_traits)
	if(ismob(loc))
		var/mob/living/M = loc
		if(M.get_item_by_slot(ITEM_SLOT_HEAD) == src)
			if(!M.has_status_effect(/datum/status_effect/clock_rewind))
				M.apply_status_effect(/datum/status_effect/clock_rewind)

/obj/item/clothing/head/helmet/clocky/examine(mob/user)
	. = ..()
	if (!core_installed)
		. += span_warning("It requires a bioscrambler anomaly core in order to function.")
	else
		. += span_warning("Once you go clocky, there is no going back...")


/obj/item/clothing/head/helmet/clocky/update_icon_state()
	icon_state = base_icon_state + (core_installed ? "" : "_inactive")
	worn_icon_state = base_icon_state + (core_installed ? "" : "_inactive")
	return ..()

/obj/item/clothing/head/helmet/clocky/item_interaction(mob/user, obj/item/weapon, params)
	if (!istype(weapon, /obj/item/assembly/signaler/anomaly/bioscrambler))
		return NONE
	balloon_alert(user, "inserting...")
	if (!do_after(user, delay = 3 SECONDS, target = src))
		return ITEM_INTERACT_BLOCKING
	qdel(weapon)
	core_installed = TRUE
	update_anomaly_state()
	update_appearance(UPDATE_ICON_STATE)
	playsound(src, 'sound/machines/crate/crate_open.ogg', 50, FALSE)
	return ITEM_INTERACT_SUCCESS

/obj/item/clothing/head/helmet/clocky/functioning
	core_installed = TRUE

/obj/item/clothing/head/helmet/clocky/proc/on_user_death(mob/living/user)
	SIGNAL_HANDLER
	user.remove_status_effect(/datum/status_effect/clock_rewind)
	RegisterSignal(user, COMSIG_LIVING_REVIVE, PROC_REF(on_user_revive))
	UnregisterSignal(user, COMSIG_LIVING_DEATH)

/obj/item/clothing/head/helmet/clocky/proc/on_user_revive(mob/living/user)
	SIGNAL_HANDLER
	if(user.get_item_by_slot(ITEM_SLOT_HEAD) == src)
		user.apply_status_effect(/datum/status_effect/clock_rewind)
		RegisterSignal(user, COMSIG_LIVING_DEATH, PROC_REF(on_user_death))
		UnregisterSignal(user, COMSIG_LIVING_REVIVE)

/obj/item/clothing/head/helmet/clocky/proc/make_cursed() //apply cursed effects.
	ADD_TRAIT(src, TRAIT_NODROP, HELMET_TRAIT)
	var/update_speech_mod = modifies_speech && LAZYLEN(clock_sounds)
	if(update_speech_mod)
		modifies_speech = TRUE
	if(ismob(loc))
		var/mob/M = loc
		if(M.get_item_by_slot(ITEM_SLOT_HEAD) == src)
			if(update_speech_mod)
				RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
			to_chat(M, span_userdanger("[src] was cursed!"))

/obj/item/clothing/head/helmet/clocky/proc/clear_curse()
	REMOVE_TRAIT(src, TRAIT_NODROP, HELMET_TRAIT)
	flags_inv = initial(flags_inv)
	name = initial(name)
	desc = initial(desc)
	var/update_speech_mod = modifies_speech && !initial(modifies_speech)
	if(update_speech_mod)
		modifies_speech = FALSE
	if(ismob(loc))
		var/mob/M = loc
		if(M.get_item_by_slot(ITEM_SLOT_HEAD) == src)
			to_chat(M, span_notice("[src]'s curse has been lifted!"))
			if(update_speech_mod)
				UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/clothing/head/helmet/clocky/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	if(clothing_flags & VOICEBOX_DISABLED)
		return
	if(!modifies_speech || !LAZYLEN(clock_sounds))
		return
	var/selected_sound = pick(clock_sounds)
	if(selected_sound == "Tick Tock!!")
		playsound(src, 'sound/_psychonaut/dante_panic.ogg', 75, FALSE)
	speech_args[SPEECH_MESSAGE] = selected_sound

/datum/status_effect/clock_rewind
	id = "Clock Rewind"
	status_type = STATUS_EFFECT_UNIQUE
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = 3 SECONDS
	alert_type = null

	var/datum/component/aura_healing/aura_healing
	var/death_tick = 0

/datum/status_effect/clock_rewind/on_apply()
	. = ..()
	if(!.)
		return FALSE
	var/static/list/organ_healing = list(
		ORGAN_SLOT_BRAIN = 1.4,
	)
	aura_healing = owner.AddComponent( \
		/datum/component/aura_healing, \
		range = 7, \
		brute_heal = 1.3, \
		burn_heal = 1.3, \
		toxin_heal = 1.3, \
		suffocation_heal = 1.3, \
		stamina_heal = 1.3, \
		simple_heal = 1.3, \
		organ_healing = organ_healing, \
		healing_color = "#375637", \
	)
	return TRUE

/datum/status_effect/clock_rewind/on_remove()
	QDEL_NULL(aura_healing)
	return ..()



/datum/component/aura_healing/process(seconds_per_tick)

	var/should_show_effect = COOLDOWN_FINISHED(src, last_heal_effect_time)
	if (should_show_effect)
		COOLDOWN_START(src, last_heal_effect_time, 1 SECONDS)

	var/list/to_heal = list()
	var/alert_category = "aura_healing_[REF(src)]"

	if(requires_visibility)
		for(var/mob/living/candidate in view(range, parent))
			if (!isnull(limit_to_trait) && !HAS_TRAIT(candidate, limit_to_trait))
				continue
			to_heal[candidate] = TRUE
	else
		for(var/mob/living/candidate in range(range, parent))
			if (!isnull(limit_to_trait) && !HAS_TRAIT(candidate, limit_to_trait))
				continue
			to_heal[candidate] = TRUE

	for (var/mob/living/candidate as anything in to_heal)
		if (!current_alerts[candidate])
			var/atom/movable/screen/alert/aura_healing/alert = candidate.throw_alert(alert_category, /atom/movable/screen/alert/aura_healing, new_master = parent)
			alert.desc = "You are being healed by [parent]."
			current_alerts[candidate] = TRUE

		if (should_show_effect && candidate.health < candidate.maxHealth)
			new /obj/effect/temp_visual/heal(get_turf(candidate), healing_color)

		if (iscarbon(candidate) || issilicon(candidate) || isbasicmob(candidate))
			candidate.adjust_brute_loss(-brute_heal * seconds_per_tick, updating_health = FALSE)
			candidate.adjust_fire_loss(-burn_heal * seconds_per_tick, updating_health = FALSE)

		if (iscarbon(candidate))
			candidate.adjust_tox_loss(-toxin_heal * seconds_per_tick, updating_health = FALSE, forced = TRUE)
			candidate.adjust_oxy_loss(-suffocation_heal * seconds_per_tick, updating_health = FALSE)
			candidate.adjust_stamina_loss(-stamina_heal * seconds_per_tick, updating_stamina = FALSE)

			for (var/organ in organ_healing)
				candidate.adjust_organ_loss(organ, -organ_healing[organ] * seconds_per_tick)

			var/mob/living/carbon/carbidate = candidate
			for(var/datum/wound/iter_wound as anything in carbidate.all_wounds)
				iter_wound.adjust_blood_flow(-wound_clotting * seconds_per_tick)

		else if (isanimal(candidate))
			var/mob/living/simple_animal/animal_candidate = candidate
			animal_candidate.adjustHealth(-simple_heal * seconds_per_tick, updating_health = FALSE)
		else if (isbasicmob(candidate))
			var/mob/living/basic/basic_candidate = candidate
			basic_candidate.adjust_health(-simple_heal * seconds_per_tick, updating_health = FALSE)

		if (candidate.blood_volume < BLOOD_VOLUME_NORMAL)
			candidate.blood_volume += blood_heal * seconds_per_tick

		candidate.updatehealth()

	for (var/mob/living/remove_alert_from as anything in current_alerts - to_heal)
		remove_alert_from.clear_alert(alert_category)
		current_alerts -= remove_alert_from

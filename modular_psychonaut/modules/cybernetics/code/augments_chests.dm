
/datum/action/item_action/organ_action/sandy
	name = "Sandevistan Activation"

/obj/item/organ/cyberimp/chest/sandevistan
	name = "Militech Apogee Sandevistan"
	desc = "This model of Sandevistan doesn't exist, at least officially. Off the record, there's gossip of secret Militech Lunar labs producing covert cyberware. It was never meant to be mass produced, but an army would only really need a few pieces like this one to dominate their enemy."
	icon = 'modular_psychonaut/master_files/icons/obj/medical/organs/organs.dmi'
	icon_state = "sandy"

	aug_icon = 'modular_psychonaut/master_files/icons/mob/human/species/misc/bodypart_overlay_augmentations.dmi'
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
	. = ..()
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
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/back.dmi'

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
	. = ..()
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

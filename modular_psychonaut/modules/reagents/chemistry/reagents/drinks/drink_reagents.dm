/datum/reagent/consumable/ayran
	name = "Ayran"
	description = "Yoğurt, su ve tuzun karıştırılmasıyla elde edilen, serinletici ve ferahlatıcı geleneksel bir Türk içeceği."
	color = "#DFDFDF" // rgb: 223, 223, 223
	taste_description = "ayran"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/condiment/ayran

/datum/reagent/consumable/ayran/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(affected_mob.getFireLoss() && SPT_PROB(10, seconds_per_tick))
		if(affected_mob.heal_bodypart_damage(brute = 0, burn = 1 * REM * seconds_per_tick, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/turk_coffee
	name = "Türk kahvesi"
	description = "A strong and tasty beverage."
	color = "#3c2f2f"
	quality = DRINK_NICE
	taste_description = "Intense and aromatic"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/turk_coffee/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_dizzy(-15 SECONDS * REM * seconds_per_tick)
	affected_mob.adjust_drowsiness(-15 SECONDS * REM * seconds_per_tick)
	var/need_mob_update
	need_mob_update = affected_mob.SetSleeping(0)
	affected_mob.adjust_bodytemperature(5 * REM * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, 0, affected_mob.get_body_temp_normal())
	affected_mob.set_jitter_if_lower(10 SECONDS * REM * seconds_per_tick)
	if(affected_mob.getBruteLoss() && SPT_PROB(10, seconds_per_tick))
		need_mob_update += affected_mob.heal_bodypart_damage(brute = 1 * REM * seconds_per_tick, burn = 0, updating_health = FALSE)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

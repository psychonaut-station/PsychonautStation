/datum/reagent/medicine/brain_healer
	name = "Brain Healer"
	description = "Efficiently restores brain damage."
	taste_description = "pleasant sweetness"
	color = "#A0A0A0" //mannitol is light grey, neurine is lighter grey
	ph = 10.4
	purity = REAGENT_STANDARD_PURITY

/datum/reagent/medicine/brain_healer/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, -5 * REM * seconds_per_tick * normalise_creation_purity(), required_organ_flag = affected_organ_flags)
	..()

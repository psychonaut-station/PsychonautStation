/datum/reagent/consumable/ethanol/raki
	name = "Rakia"
	description = "A potent mixture of distilled grapes and strong alcohol."
	color = "#ebffff"
	boozepwr = 70
	overdose_threshold = 25
	taste_description = "bitterness"
	ph = 7.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/raki/overdose_process(mob/living/drinker, seconds_per_tick, times_fired)
	. = ..()

	if(SPT_PROB(3.5, seconds_per_tick))
		drinker.add_mood_event("toxic_food", /datum/mood_event/efkar, name)

/obj/item/food/popsicle/panda
	name = "panda ice cream"
	w_class = WEIGHT_CLASS_SMALL
	icon = 'modular_psychonaut/master_files/icons/obj/food/frozen_treats.dmi'
	icon_state = "popsicle_stick"
	desc = "A classic panda-looking ice cream filled with candy and chocolate."
	food_reagents = list(
		/datum/reagent/consumable/hot_coco = 2,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/sugar = 2,
	)
	overlay_state = "panda"
	foodtypes = DAIRY|SUGAR|JUNKFOOD
	crafting_complexity = FOOD_COMPLEXITY_3

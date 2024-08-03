/datum/crafting_recipe/food/cig_kofte
	name = "Cig Kofte"
	reqs = list(
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/wheat = 1,
		/datum/reagent/consumable/lemonjuice = 1,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 2,
	)
	result = /obj/item/food/cig_kofte
	category = CAT_TURKISH

/datum/crafting_recipe/food/cacik
	name = "Cacik"
	reqs = list(
		/datum/reagent/consumable/ayran = 1,
		/obj/item/food/grown/cucumber = 1,
	)
	result = /obj/item/food/cacik
	category = CAT_TURKISH

/datum/crafting_recipe/food/lahmacun
	name = "Pişmemiş Lahmacun"
	reqs = list(
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/doughslice = 1,
		/obj/item/food/raw_patty = 1,
	)
	result = /obj/item/food/raw_lahmacun
	category = CAT_TURKISH

/datum/crafting_recipe/food/raw_beyti
	name = "Pişmemiş Beyti"
	reqs = list(
		/obj/item/food/grown/tomato = 2,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 2,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/doughslice = 1,
		/obj/item/food/raw_patty = 1,
	)
	result = /obj/item/food/raw_beyti
	category = CAT_TURKISH

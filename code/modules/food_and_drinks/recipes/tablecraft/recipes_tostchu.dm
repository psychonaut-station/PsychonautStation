/datum/crafting_recipe/food/turkish_bread
	name = "Turkish Bread"
	reqs = list(
		/obj/item/food/breadslice/plain = 3,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 1,
	)
	result = /obj/item/food/turkish_bread
	category = CAT_BREAD

/datum/crafting_recipe/food/sujuk
	name = "Sucuk"
	reqs = list(
		/obj/item/food/raw_patty = 2,
		/obj/item/food/grown/chili = 1,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 2,
	)
	result = /obj/item/food/toast_sujuk
	category = CAT_TOSTCHU

/datum/crafting_recipe/food/toast_cheese
	name = "Kaşarlı Toast"
	reqs = list(
		/obj/item/food/turkish_bread = 1,
		/obj/item/food/cheese/wedge = 2,
		/obj/item/food/butterslice = 2,
	)
	result = /obj/item/food/toast/cheese/raw
	category = CAT_TOSTCHU

/datum/crafting_recipe/food/toast_cheese_half
	name = "Yarım Kaşarlı Toast"
	reqs = list(
		/obj/item/food/turkish_bread/half = 1,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/butterslice = 1,
	)
	result = /obj/item/food/toast/cheese/half/raw
	category = CAT_TOSTCHU

/datum/crafting_recipe/food/toast_sujuk
	name = "Sucuklu Toast"
	reqs = list(
		/obj/item/food/turkish_bread = 1,
		/obj/item/food/toast_sujuk/slice = 4,
		/obj/item/food/cheese/wedge = 2,
		/obj/item/food/butterslice = 2,
	)
	result = /obj/item/food/toast/sujuk/raw
	category = CAT_TOSTCHU

/datum/crafting_recipe/food/toast_sujuk_half
	name = "Yarım Sucuklu Toast"
	reqs = list(
		/obj/item/food/turkish_bread/half = 1,
		/obj/item/food/toast_sujuk/slice = 2,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/butterslice = 1,
	)
	result = /obj/item/food/toast/sujuk/half/raw
	category = CAT_TOSTCHU

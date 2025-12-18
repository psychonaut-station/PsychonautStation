/datum/crafting_recipe/food/tost_bread
	name = "Tost Bread"
	reqs = list(
		/obj/item/food/breadslice/plain = 3,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 1,
	)
	result = /obj/item/food/tost_bread
	category = CAT_TOSTCHU

/datum/crafting_recipe/food/sujuk
	name = "Sucuk"
	reqs = list(
		/obj/item/food/raw_patty = 2,
		/obj/item/food/grown/chili = 1,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 2,
	)
	result = /obj/item/food/sujuk
	category = CAT_TOSTCHU

/datum/crafting_recipe/food/tost_cheese
	name = "Kaşarlı Tost"
	reqs = list(
		/obj/item/food/tost_bread = 1,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/butterslice = 1,
	)
	result = /obj/item/food/tost/cheese/raw
	category = CAT_TOSTCHU

/datum/crafting_recipe/food/tost_cheese_half
	name = "Yarım Kaşarlı Tost"
	reqs = list(
		/obj/item/food/tost_bread/half = 1,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/butterslice = 1,
	)
	result = /obj/item/food/tost/cheese/half/raw
	category = CAT_TOSTCHU

/datum/crafting_recipe/food/tost_sujuk
	name = "Sucuklu Tost"
	reqs = list(
		/obj/item/food/tost_bread = 1,
		/obj/item/food/sujuk/slice = 3,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/butterslice = 1,
	)
	result = /obj/item/food/tost/sujuk/raw
	category = CAT_TOSTCHU

/datum/crafting_recipe/food/tost_sujuk_half
	name = "Yarım Sucuklu Tost"
	reqs = list(
		/obj/item/food/tost_bread/half = 1,
		/obj/item/food/sujuk/slice = 2,
		/obj/item/food/cheese/wedge = 1,
		/obj/item/food/butterslice = 1,
	)
	result = /obj/item/food/tost/sujuk/half/raw
	category = CAT_TOSTCHU

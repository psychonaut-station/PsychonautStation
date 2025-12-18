/obj/item/food/tost_bread
	name = "tost bread"
	desc = "Soft bread made for pressing into a tosta."
	icon = 'icons/psychonaut/obj/food/tostchu.dmi'
	icon_state = "bread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("bread" = 2)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/tost_bread/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/tost_bread/half, 2, 3 SECONDS, table_required = TRUE, screentip_verb = "Halve", sound_to_play = SFX_KNIFE_SLICE)

/obj/item/food/tost_bread/half
	name = "half tost bread"
	desc = "Half of a tosta loaf, ready to be packed with fillings."
	icon = 'icons/psychonaut/obj/food/tostchu.dmi'
	icon_state = "half_bread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("bread" = 2)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_TINY
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/sujuk
	name = "raw sujuk"
	desc = "A garlicky cured sausage that tastes best hot off the grill."
	icon = 'icons/psychonaut/obj/food/tostchu.dmi'
	icon_state = "ungrilled_sujuk"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/fat = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("meat" = 2, "spice" = 1, "garlic" = 1)
	foodtypes = MEAT | RAW
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/sujuk/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/sujuk/grilled, rand(20 SECONDS, 30 SECONDS), TRUE, TRUE)

/obj/item/food/sujuk/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/sujuk/slice, 6, 2 SECONDS, table_required = TRUE, screentip_verb = "Slice", sound_to_play = SFX_KNIFE_SLICE)

/obj/item/food/sujuk/grilled
	name = "grilled sujuk"
	desc = "A sujuk sausage, sizzling and crispy."
	icon = 'icons/psychonaut/obj/food/tostchu.dmi'
	icon_state = "grilled_sujuk"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/fat = 2,
	)
	tastes = list("meat" = 2, "spice" = 1, "smoke" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/sujuk/grilled/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/sujuk/slice/grilled, 6, 2 SECONDS, table_required = TRUE, screentip_verb = "Slice", sound_to_play = SFX_KNIFE_SLICE)

/obj/item/food/sujuk/slice
	name = "raw sujuk slice"
	desc = "A thick slice of raw sujuk."
	icon = 'icons/psychonaut/obj/food/tostchu.dmi'
	icon_state = "ungrilled_sujuk_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/nutriment/fat = 1,
	)
	tastes = list("meat" = 1, "garlic" = 1)
	foodtypes = MEAT | RAW
	w_class = WEIGHT_CLASS_TINY
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/sujuk/slice/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/sujuk/slice/grilled, rand(6 SECONDS, 10 SECONDS), TRUE, TRUE)

/obj/item/food/sujuk/slice/grilled
	name = "grilled sujuk slice"
	desc = "A sizzling slice of sujuk."
	icon = 'icons/psychonaut/obj/food/tostchu.dmi'
	icon_state = "grilled_sujuk_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/nutriment/fat = 1,
	)
	tastes = list("meat" = 1, "spice" = 1, "smoke" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_TINY
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/tost
	icon = 'icons/psychonaut/obj/food/tostchu.dmi'
	foodtypes = GRAIN
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/tost/cheese/raw
	name = "raw cheese tost"
	desc = "Bread packed with cheese, waiting to be pressed."
	icon_state = "ungrilled_cheese_toast"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("cheese" = 2, "bread" = 1)
	foodtypes = GRAIN | DAIRY | RAW

/obj/item/food/tost/cheese/raw/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/tost/cheese, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/tost/cheese
	name = "cheese tost"
	desc = "Golden, melty kaşarlı tost."
	icon_state = "grilled_cheese_toast"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("cheese" = 2, "bread" = 2, "toasted butter" = 1)
	foodtypes = GRAIN | DAIRY

/obj/item/food/tost/cheese/half/raw
	name = "raw half cheese tost"
	desc = "A half portion of cheese tost ready to grill."
	icon_state = "ungrilled_halfbread_cheese_toast"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("cheese" = 2, "bread" = 1)
	foodtypes = GRAIN | DAIRY | RAW

/obj/item/food/tost/cheese/half/raw/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/tost/cheese/half, rand(12 SECONDS, 18 SECONDS), TRUE, TRUE)

/obj/item/food/tost/cheese/half
	name = "half cheese tost"
	desc = "A half-portion of grilled cheese tost."
	icon_state = "grilled_halfbread_cheese_toast"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("cheese" = 2, "bread" = 1, "toasted butter" = 1)
	foodtypes = GRAIN | DAIRY

/obj/item/food/tost/sujuk/raw
	name = "raw sujuk tost"
	desc = "Bread stuffed with sujuk slices that still needs grilling."
	icon_state = "ungrilled_sujuk_toast"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 3,
	)
	tastes = list("meat" = 2, "bread" = 1, "spice" = 1)
	foodtypes = GRAIN | MEAT | RAW

/obj/item/food/tost/sujuk/raw/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/tost/sujuk, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/tost/sujuk
	name = "sujuk tost"
	desc = "A pressed tost packed with sujuk."
	icon_state = "grilled_sujuk_toast"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 3,
	)
	tastes = list("meat" = 2, "bread" = 2, "spice" = 1, "toasted butter" = 1)
	foodtypes = GRAIN | MEAT

/obj/item/food/tost/sujuk/half/raw
	name = "raw half sujuk tost"
	desc = "Half a sujuk tost, ready to go into the press."
	icon_state = "ungrilled_halfbread_sujuk_toast"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	tastes = list("meat" = 1, "bread" = 1, "spice" = 1)
	foodtypes = GRAIN | MEAT | RAW

/obj/item/food/tost/sujuk/half/raw/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/tost/sujuk/half, rand(12 SECONDS, 18 SECONDS), TRUE, TRUE)

/obj/item/food/tost/sujuk/half
	name = "half sujuk tost"
	desc = "A half-portion sujuk tost hot from the press."
	icon_state = "grilled_halfbread_sujuk_toast"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	tastes = list("meat" = 1, "bread" = 2, "spice" = 1, "toasted butter" = 1)
	foodtypes = GRAIN | MEAT

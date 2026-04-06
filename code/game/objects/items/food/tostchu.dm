/obj/item/food/turkish_bread
	name = "turkish bread"
	desc = "Soft bread made for pressing into a toast."
	icon = 'icons/psychonaut/obj/food/tostchu.dmi'
	icon_state = "bread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("bread" = 2)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/turkish_bread/Initialize(mapload)
	. = ..()
	transform = matrix(0.9, 0, 0, 0, 0.9, 0)

/obj/item/food/turkish_bread/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/turkish_bread/half, 2, 3 SECONDS, table_required = TRUE, screentip_verb = "Halve", sound_to_play = SFX_KNIFE_SLICE)

/obj/item/food/turkish_bread/half
	name = "half turkish bread"
	desc = "Half of a Turkish loaf, ready to be packed with fillings."
	icon = 'icons/psychonaut/obj/food/tostchu.dmi'
	icon_state = "half_bread"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 0.5,
	)
	tastes = list("bread" = 2)
	foodtypes = GRAIN
	w_class = WEIGHT_CLASS_TINY
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/turkish_bread/half/Initialize(mapload)
	. = ..()
	transform = matrix(0.9, 0, 0, 0, 0.9, 0)

/obj/item/food/turkish_bread/half/make_processable()
	return

/obj/item/food/toast_sujuk
	name = "raw sujuk"
	desc = "A garlicky cured sausage that tastes best hot off the grill."
	icon = 'icons/psychonaut/obj/food/tostchu.dmi'
	icon_state = "ungrilled_sujuk"
	custom_materials = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT * 2.65)
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/fat = 2,
	)
	tastes = list("meat" = 2, "spice" = 1, "garlic" = 1)
	foodtypes = MEAT | RAW
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/toast_sujuk/Initialize(mapload)
	. = ..()
	transform = matrix(0.9, 0, 0, 0, 0.9, 0)

/obj/item/food/toast_sujuk/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/toast_sujuk/grilled, rand(20 SECONDS, 30 SECONDS), TRUE, TRUE)

/obj/item/food/toast_sujuk/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/toast_sujuk/slice, 6, 2 SECONDS, table_required = TRUE, screentip_verb = "Slice", sound_to_play = SFX_KNIFE_SLICE)

/obj/item/food/toast_sujuk/grilled
	name = "grilled sujuk"
	desc = "A sujuk sausage, sizzling and crispy."
	icon = 'icons/psychonaut/obj/food/tostchu.dmi'
	icon_state = "grilled_sujuk"
	custom_materials = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT * 2.65)
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/fat = 2,
	)
	tastes = list("meat" = 2, "spice" = 1, "smoke" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/toast_sujuk/grilled/make_grillable()
	return

/obj/item/food/toast_sujuk/grilled/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/toast_sujuk/slice/grilled, 6, 2 SECONDS, table_required = TRUE, screentip_verb = "Slice", sound_to_play = SFX_KNIFE_SLICE)

/obj/item/food/toast_sujuk/slice
	name = "raw sujuk slice"
	desc = "A thick slice of raw sujuk."
	icon = 'icons/psychonaut/obj/food/tostchu.dmi'
	icon_state = "ungrilled_sujuk_slice"
	custom_materials = list(/datum/material/meat = (SHEET_MATERIAL_AMOUNT * 2.65) / 6)
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 0.67,
		/datum/reagent/consumable/nutriment/fat = 0.33,
	)
	tastes = list("meat" = 1, "garlic" = 1)
	foodtypes = MEAT | RAW
	w_class = WEIGHT_CLASS_TINY
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/toast_sujuk/slice/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/toast_sujuk/slice/grilled, rand(6 SECONDS, 10 SECONDS), TRUE, TRUE)

/obj/item/food/toast_sujuk/slice/make_processable()
	return

/obj/item/food/toast_sujuk/slice/grilled
	name = "grilled sujuk slice"
	desc = "A sizzling slice of sujuk."
	icon = 'icons/psychonaut/obj/food/tostchu.dmi'
	icon_state = "grilled_sujuk_slice"
	custom_materials = list(/datum/material/meat = (SHEET_MATERIAL_AMOUNT * 2.65) / 6)
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 0.67,
		/datum/reagent/consumable/nutriment/fat = 0.33,
	)
	tastes = list("meat" = 1, "spice" = 1, "smoke" = 1)
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_TINY
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/toast_sujuk/slice/grilled/make_grillable()
	return

/obj/item/food/toast_sujuk/slice/grilled/make_processable()
	return

/obj/item/food/toast
	icon = 'icons/psychonaut/obj/food/tostchu.dmi'
	foodtypes = GRAIN
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/toast/Initialize(mapload)
	. = ..()
	transform = matrix(0.9, 0, 0, 0, 0.9, 0)

/obj/item/food/toast/cheese/raw
	name = "raw cheese toast"
	desc = "Bread packed with cheese, waiting to be pressed."
	icon_state = "ungrilled_cheese_toast"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 7,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("cheese" = 2, "bread" = 1)
	foodtypes = GRAIN | DAIRY

/obj/item/food/toast/cheese/raw/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/toast/cheese, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/toast/cheese
	name = "cheese toast"
	desc = "Golden, melty kaşarlı toast."
	icon_state = "grilled_cheese_toast"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("cheese" = 2, "bread" = 2, "toasted butter" = 1)
	foodtypes = GRAIN | DAIRY

/obj/item/food/toast/cheese/make_grillable()
	return

/obj/item/food/toast/cheese/half/raw
	name = "raw half cheese toast"
	desc = "A half portion of cheese toast ready to grill."
	icon_state = "ungrilled_halfbread_cheese_toast"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3.5,
		/datum/reagent/consumable/nutriment/protein = 1.5,
		/datum/reagent/consumable/nutriment/vitamin = 0.5,
	)
	tastes = list("cheese" = 2, "bread" = 1)
	foodtypes = GRAIN | DAIRY

/obj/item/food/toast/cheese/half/raw/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/toast/cheese/half, rand(12 SECONDS, 18 SECONDS), TRUE, TRUE)

/obj/item/food/toast/cheese/half
	name = "half cheese toast"
	desc = "A half-portion of grilled cheese toast."
	icon_state = "grilled_halfbread_cheese_toast"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2.5,
		/datum/reagent/consumable/nutriment/vitamin = 0.5,
	)
	tastes = list("cheese" = 2, "bread" = 1, "toasted butter" = 1)
	foodtypes = GRAIN | DAIRY

/obj/item/food/toast/cheese/half/make_grillable()
	return

/obj/item/food/toast/sujuk/raw
	name = "raw sujuk toast"
	desc = "Bread stuffed with sujuk slices that still needs grilling."
	icon_state = "ungrilled_sujuk_toast"
	custom_materials = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT * 1.75)
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 7,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("meat" = 2, "bread" = 1, "spice" = 1)
	foodtypes = GRAIN | MEAT | RAW | DAIRY

/obj/item/food/toast/sujuk/raw/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/toast/sujuk, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/toast/sujuk
	name = "sujuk toast"
	desc = "A pressed toast packed with sujuk."
	icon_state = "grilled_sujuk_toast"
	custom_materials = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT * 1.75)
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 7,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("meat" = 2, "bread" = 2, "spice" = 1, "toasted butter" = 1)
	foodtypes = GRAIN | MEAT

/obj/item/food/toast/sujuk/make_grillable()
	return

/obj/item/food/toast/sujuk/half/raw
	name = "raw half sujuk toast"
	desc = "Half a sujuk toast, ready to go into the press."
	icon_state = "ungrilled_halfbread_sujuk_toast"
	custom_materials = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT * 0.88)
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3.5,
		/datum/reagent/consumable/nutriment/protein = 2.5,
		/datum/reagent/consumable/nutriment/vitamin = 0.5,
	)
	tastes = list("meat" = 1, "bread" = 1, "spice" = 1)
	foodtypes = GRAIN | MEAT | RAW | DAIRY

/obj/item/food/toast/sujuk/half/raw/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/toast/sujuk/half, rand(12 SECONDS, 18 SECONDS), TRUE, TRUE)

/obj/item/food/toast/sujuk/half
	name = "half sujuk toast"
	desc = "A half-portion sujuk toast hot from the press."
	icon_state = "grilled_halfbread_sujuk_toast"
	custom_materials = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT * 0.88)
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 3.5,
		/datum/reagent/consumable/nutriment/vitamin = 0.5,
	)
	tastes = list("meat" = 1, "bread" = 2, "spice" = 1, "toasted butter" = 1)
	foodtypes = GRAIN | MEAT

/obj/item/food/toast/sujuk/half/make_grillable()
	return

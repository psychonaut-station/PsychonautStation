/datum/crafting_recipe/food/cig_kofte_recipe
    name = "Çiğ Köfte"
    reqs = list(
        /obj/item/food/grown/onion = 1,
        /obj/item/food/grown/tomato = 1,
        /obj/item/food/grown/wheat = 1,
        /datum/reagent/consumable/lemonjuice = 1,
        /datum/reagent/consumable/nutriment/fat/oil/olive = 2
    )
    result = /obj/item/food/cig_kofte
    category = CAT_TURKISH

/datum/crafting_recipe/food/cacik_recipe
    name = "Cacık"
    reqs = list(
        /datum/reagent/consumable/ayran = 1,
        /obj/item/food/grown/cucumber = 1
    )
    result = /obj/item/food/cacik
    category = CAT_TURKISH

/datum/crafting_recipe/food/lahmacun_recipe
    name = "Lahmacun"
    reqs = list(
        /obj/item/food/grown/tomato = 1,
        /obj/item/food/grown/onion = 1,
        /obj/item/food/doughslice = 1,
        /obj/item/food/patty/plain = 1
    )
    result = /obj/item/food/lahmacun
    category = CAT_TURKISH

/datum/crafting_recipe/food/beyti_recipe
    name = "Beyti"
    reqs = list(
        /obj/item/food/grown/tomato = 2,
        /datum/reagent/consumable/nutriment/fat/oil/olive = 2,
        /obj/item/food/grown/onion = 1,
        /obj/item/food/doughslice = 1,
        /obj/item/food/patty/plain = 1
    )
    result = /obj/item/food/beyti
    category = CAT_TURKISH

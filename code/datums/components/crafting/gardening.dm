/datum/crafting_recipe/gardening_outdoor
    tool_paths = list(/obj/item/secateurs, /obj/item/shovel/spade)
    time = 2 SECONDS
    category = CAT_GARDENING
    crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF

/datum/crafting_recipe/gardening_outdoor/check_requirements(mob/user, list/collected_requirements)
    if(!istype(get_turf(user), /turf/open/floor/grass))
        return FALSE
    return ..()

/datum/crafting_recipe/ppflowers
	parent_type = /datum/crafting_recipe/gardening_outdoor
	name = "Purple and pink flower patch"
	result = /obj/structure/flora/bush/flowers_pp/style_random
	reqs = list(
		/obj/item/food/grown/grass = 2,
	)

/datum/crafting_recipe/ywflowers
	parent_type = /datum/crafting_recipe/gardening_outdoor
	name = "Yellow and white flower patch"
	result = /obj/structure/flora/bush/flowers_yw/style_random
	reqs = list(
		/obj/item/food/grown/grass = 2,
	)

/datum/crafting_recipe/brflowers
	parent_type = /datum/crafting_recipe/gardening_outdoor
	name = "Blue and red flower patch"
	result = /obj/structure/flora/bush/flowers_br/style_random
	reqs = list(
		/obj/item/food/grown/grass = 2,
	)

/datum/crafting_recipe/jggrass
	parent_type = /datum/crafting_recipe/gardening_outdoor
	name = "Jungle Grass"
	result = /obj/structure/flora/grass/jungle/a/style_random
	reqs = list(
		/obj/item/food/grown/grass = 3,
	)

/datum/crafting_recipe/tgrass
	parent_type = /datum/crafting_recipe/gardening_outdoor
	name = "Tall Grass"
	result = /obj/structure/flora/bush/fullgrass/style_random
	reqs = list(
		/obj/item/food/grown/grass = 3,
	)

/datum/crafting_recipe/lavgrass
	parent_type = /datum/crafting_recipe/gardening_outdoor
	name = "Lavender Tufts"
	result = /obj/structure/flora/bush/lavendergrass/style_random
	reqs = list(
		/obj/item/food/grown/grass = 3,
	)

/datum/crafting_recipe/leafbush
	parent_type = /datum/crafting_recipe/gardening_outdoor
	name = "Leafy Bush"
	result = /obj/structure/flora/bush/leavy/style_random
	reqs = list(
		/obj/item/food/grown/grass = 4,
	)

/datum/crafting_recipe/fernbush
	parent_type = /datum/crafting_recipe/gardening_outdoor
	name = "Fern"
	result = /obj/structure/flora/bush/ferny/style_random
	reqs = list(
		/obj/item/food/grown/grass = 4,
	)

/datum/crafting_recipe/rbush
	parent_type = /datum/crafting_recipe/gardening_outdoor
	name = "Round Bush"
	result = /obj/structure/flora/bush/grassy/style_random
	reqs = list(
		/obj/item/food/grown/grass = 4,
		/obj/item/grown/log = 1,
	)

/datum/crafting_recipe/sflatbush
	parent_type = /datum/crafting_recipe/gardening_outdoor
	name = "Small Flatleaf Bush"
	result = /obj/structure/flora/bush/jungle/a/style_random
	reqs = list(
		/obj/item/food/grown/grass = 4,
		/obj/item/grown/log = 1,
	)

/datum/crafting_recipe/lflatbush
	parent_type = /datum/crafting_recipe/gardening_outdoor
	name = "Large Flatleaf Bush"
	result = /obj/structure/flora/bush/large/style_random
	reqs = list(
		/obj/item/food/grown/grass = 8,
		/obj/item/grown/log = 3,
	)
	time = 10 SECONDS

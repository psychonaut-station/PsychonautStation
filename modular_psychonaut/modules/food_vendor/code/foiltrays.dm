
// Foil Tray
/obj/item/food/foiltray
	name = "Trayed Air"
	desc = "It has meal inside it."
	food_reagents = list(
		/datum/reagent/oxygen = 4,
		/datum/reagent/nitrogen = 16,
	)
	trash_type = /obj/item/trash/foiltray
	icon = 'modular_psychonaut/master_files/icons/obj/food/canned.dmi'
	icon_state = "closed_foiltray"
	base_icon_state = "foiltray"
	food_flags = FOOD_IN_CONTAINER
	max_volume = 15
	w_class = WEIGHT_CLASS_SMALL
	preserved_food = TRUE
	var/foiled_food = "empty"

/obj/item/food/foiltray/make_germ_sensitive(mapload)
	return // It's in a foiltray

/obj/item/food/foiltray/proc/open_can(mob/user)
	to_chat(user, span_notice("You pull back the tab of \the [src]."))
	playsound(user.loc, 'sound/items/box_cut.ogg', 50)
	reagents.flags |= OPENCONTAINER
	preserved_food = FALSE

/obj/item/food/foiltray/attack_self(mob/user)
	if(!is_drainable())
		open_can(user)
		icon_state = "[foiled_food]_[base_icon_state]"
	return ..()

/obj/item/food/foiltray/attack(mob/living/target, mob/user, def_zone)
	if (!is_drainable())
		to_chat(user, span_warning("[src]'s lid hasn't been opened!"))
		return FALSE
	return ..()

/obj/item/food/foiltray/rice
	name = "rice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 7,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("rice" = 19, "salt" = 1)
	foodtypes = GRAIN
	foiled_food = "rice"

/obj/item/food/foiltray/beans
	name = "beans"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/ketchup = 2,
	)
	tastes = list("beans" = 1)
	foodtypes = VEGETABLES
	foiled_food = "bean"

/obj/item/food/foiltray/potatofry
	name = "potato fries"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/fat/oil = 2,
	)
	tastes = list("fries" = 7, "salt" = 1)
	foodtypes = FRIED | VEGETABLES
	foiled_food = "fries"

/obj/item/food/foiltray/ricenbean
	name = "beans and rice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 7,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/consumable/nutriment/protein = 1,
		/datum/reagent/consumable/ketchup = 1,
	)
	tastes = list("beans" = 5, "rice" = 5, "salt" = 1)
	foodtypes = VEGETABLES | GRAIN
	foiled_food = "ricenbean"

/obj/item/food/foiltray/noodle
	name = "noodle"
	food_reagents = list(
		/datum/reagent/consumable/hot_ramen = 11,
		/datum/reagent/consumable/nutriment/fat/oil/corn = 1,
	)
	tastes = list("salt" = 1, "pasta" = 1)
	foodtypes = GRAIN
	foiled_food = "noodle"

/obj/item/food/foiltray/sushi
	name = "sushi"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/protein = 2,
	)
	tastes = list("boiled rice" = 7, "fish fillet" = 1, "soy sauce" = 2)
	foodtypes = SEAFOOD
	foiled_food = "sushi"

/obj/item/food/foiltray/chickenburger
	name = "chicken sandwich"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/mayonnaise = 2,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/fat/oil = 1,
	)
	tastes = list("bun" = 7, "chicken" = 1)
	foodtypes = GRAIN | MEAT | FRIED
	foiled_food = "chickenburger"

/obj/item/food/foiltray/beefnfries
	name = "beef and fries"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("meat" = 7, "potato" = 3, "oil" = 1)
	foodtypes = MEAT | FRIED | VEGETABLES
	foiled_food = "beefnfry"

/obj/item/food/foiltray/doner
	name = "doner"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("meat" = 1)
	foodtypes = MEAT
	foiled_food = "doner"

/obj/item/food/foiltray/donernrice
	name = "doner and rice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("meat" = 7, "rice" = 3)
	foodtypes = MEAT | GRAIN
	foiled_food = "donernrice"

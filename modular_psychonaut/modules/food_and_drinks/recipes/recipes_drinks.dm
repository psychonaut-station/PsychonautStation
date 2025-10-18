/datum/crafting_recipe/rakibottle
	name = "Rakia Bottle"
	time = 10
	reqs = list(
		/obj/item/reagent_containers/cup/glass/bottle = 1,
		/datum/reagent/consumable/ethanol/raki = 100
	)
	result = /obj/item/reagent_containers/cup/glass/bottle/raki
	category = CAT_DRINK

/datum/chemical_reaction/drink/raki
	results = list(/datum/reagent/consumable/ethanol/raki = 10)
	required_reagents = list(/datum/reagent/consumable/enzyme = 5, /datum/reagent/consumable/grapejuice = 10, /datum/reagent/consumable/sugar = 5)

/datum/chemical_reaction/drink/ayran
	results = list(/datum/reagent/consumable/ayran = 2)
	required_reagents = list(/datum/reagent/water/salt = 1, /datum/reagent/consumable/yoghurt = 1)
	reaction_flags = REACTION_TAG_EASY | REACTION_TAG_DRINK

/datum/crafting_recipe/food/cig_kofte
	name = "Çiğ Köfte"
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
	name = "Cacık"
	reqs = list(
		/datum/reagent/consumable/ayran = 1,
		/obj/item/food/grown/cucumber = 1,
		/obj/item/reagent_containers/cup/bowl = 1
	)
	result = /obj/item/food/cacik
	category = CAT_TURKISH

/datum/crafting_recipe/food/lahmacun
	name = "Lahmacun"
	reqs = list(
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/doughslice = 1,
		/obj/item/food/raw_patty = 1,
	)
	result = /obj/item/food/raw_lahmacun
	category = CAT_TURKISH

/datum/crafting_recipe/food/raw_beyti
	name = "Beyti"
	reqs = list(
		/obj/item/food/grown/tomato = 2,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 2,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/doughslice = 1,
		/obj/item/food/raw_patty = 1,
	)
	result = /obj/item/food/raw_beyti
	category = CAT_TURKISH

/datum/crafting_recipe/food/reaction/ayran
	reaction = /datum/chemical_reaction/drink/ayran
	category = CAT_TURKISH

/datum/crafting_recipe/food/kiymali_pide
	name = "Kıymalı Pide"
	reqs = list(
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/doughslice = 1,
		/obj/item/food/raw_patty = 1,
	)
	result = /obj/item/food/raw_kiymali_pide
	category = CAT_TURKISH

/datum/crafting_recipe/food/etdoner
	name = "Et Döner"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/obj/item/food/doner/yaprak/et = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/onion = 1,
	)
	result = /obj/item/food/doner/et
	category = CAT_TURKISH

/datum/crafting_recipe/food/etdoner_sade
	name = "Sade Et Döner"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/obj/item/food/doner/yaprak/et = 1
	)
	result = /obj/item/food/doner/et/sade
	category = CAT_TURKISH

/datum/crafting_recipe/food/tavukdoner
	name = "Tavuk Döner"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/obj/item/food/doner/yaprak/tavuk = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/onion = 1,
	)
	result = /obj/item/food/doner/tavuk
	category = CAT_TURKISH

/datum/crafting_recipe/food/tavukdoner_sade
	name = "Sade Tavuk Döner"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/obj/item/food/doner/yaprak/tavuk = 1
	)
	result = /obj/item/food/doner/tavuk/sade
	category = CAT_TURKISH

/datum/crafting_recipe/food/kisir
	name = "Kısır"
	reqs = list(
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/wheat = 2,
		/datum/reagent/consumable/lemonjuice = 1,
		/obj/item/reagent_containers/cup/bowl = 1
	)
	result = /obj/item/food/kisir
	category = CAT_TURKISH

/datum/crafting_recipe/food/tavton
	name = "Tavuk Tonbalığı Pilav"
	reqs = list(
		/obj/item/food/boiledrice = 2,
		/obj/item/food/meat/steak/chicken = 1,
		/obj/item/food/fishmeat = 1,
		/obj/item/reagent_containers/cup/bowl = 1
	)
	result = /obj/item/food/tavton
	removed_foodtypes = BREAKFAST
	category = CAT_TURKISH

/datum/crafting_recipe/food/menemen
	name = "Menemen"
	reqs = list(
		/obj/item/food/grown/tomato = 3,
		/obj/item/food/grown/bell_pepper = 2,
		/obj/item/food/egg = 2,
		/obj/item/plate = 1,
	)
	result = /obj/item/food/raw_menemen
	added_foodtypes = BREAKFAST
	category = CAT_TURKISH

/datum/crafting_recipe/food/menemen/onion
	name = "Soğanlı Menemen"
	reqs = list(
		/obj/item/food/grown/tomato = 3,
		/obj/item/food/grown/bell_pepper = 2,
		/obj/item/food/egg = 2,
		/obj/item/food/grown/onion = 1,
		/obj/item/plate = 1,
	)
	result = /obj/item/food/raw_menemen/onion
	added_foodtypes = BREAKFAST
	category = CAT_TURKISH

/datum/crafting_recipe/food/iskender
	name = "İskender"
	reqs = list(
		/obj/item/food/griddle_toast = 1,
		/obj/item/food/doner/yaprak/et = 2,
		/obj/item/food/grown/tomato = 1,
		/datum/reagent/consumable/yoghurt = 10,
		/obj/item/plate = 1,
	)
	result = /obj/item/food/iskender
	category = CAT_TURKISH

/datum/crafting_recipe/food/dolma
	name = "Dolma"
	reqs = list(
		/obj/item/food/grown/bell_pepper/green = 1,
		/obj/item/food/boiledrice = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/onion = 1,
	)
	result = /obj/item/food/raw_dolma
	removed_foodtypes = BREAKFAST
	added_foodtypes = RAW
	category = CAT_TURKISH

/datum/crafting_recipe/food/etdoner_pilav
	name = "Pilav Üstü Et Döner"
	reqs = list(
		/obj/item/food/grown/bell_pepper/green = 1,
		/obj/item/food/boiledrice = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/doner/yaprak/et = 1,
		/obj/item/plate = 1,
	)
	result = /obj/item/food/etdoner_pilav
	removed_foodtypes = BREAKFAST
	category = CAT_TURKISH

/datum/crafting_recipe/food/tavukdoner_pilav
	name = "Pilav Üstü Tavuk Döner"
	reqs = list(
		/obj/item/food/grown/bell_pepper/green = 1,
		/obj/item/food/boiledrice = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/doner/yaprak/tavuk = 1,
		/obj/item/plate = 1,
	)
	result = /obj/item/food/tavukdoner_pilav
	removed_foodtypes = BREAKFAST
	category = CAT_TURKISH

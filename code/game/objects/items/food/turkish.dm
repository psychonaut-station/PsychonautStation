/obj/item/food/cig_kofte
	name = "cig kofte"
	desc = "İnce bulgur, domates salçası ve çeşitli baharatlarla yoğrularak hazırlanan, acılı ve lezzetli bir Türk mezesidir. Genellikle marul yaprağına sarılarak tüketilir."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "cig_kofte"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("tomato" = 1, "onion" = 1, "wheat" = 1, "pepper" = 1)
	foodtypes = VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/cacik
	name = "cacik"
	desc = "Yoğurt, rendelenmiş salatalık, sarımsak ve nane ile hazırlanan, serinletici ve ferahlatıcı bir Türk mezesi."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "cacik"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 7
	)
	tastes = list("yoghurt" = 2, "salt" = 1, "cucumber" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_1
	trash_type = /obj/item/reagent_containers/cup/bowl

/obj/item/food/raw_lahmacun
	name = "raw lahmacun"
	desc = "İnce hamur üzerine kıyma, domates, biber ve baharatlarla hazırlanan Türk mutfağına özgü, fırında pişirilmesi gerekilen lezzetli bir yemektir."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "raw_lahmacun"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("meat" = 1, "onion" = 1, "tomato" = 1)
	foodtypes = MEAT | VEGETABLES | RAW
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/raw_lahmacun/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/lahmacun, rand(30 SECONDS, 40 SECONDS), TRUE, TRUE)

/obj/item/food/lahmacun
	name = "lahmacun"
	desc = "İnce hamur üzerine kıyma, domates, biber ve baharatlarla hazırlanan Türk mutfağına özgü, fırında pişirilen lezzetli bir yemektir."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "lahmacun"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("meat" = 1, "onion" = 1, "tomato" = 1)
	foodtypes = MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/raw_beyti
	name = "raw beyti"
	desc = "Beyti, kıyma veya kuzu etinden oluşan, bir Türk yemeğidir. Bu sanki pişmemiş ?"
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "raw_beyti"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("meat" = 1, "onion" = 1, "tomato" = 1)
	foodtypes = MEAT | VEGETABLES | RAW
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/raw_beyti/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/beyti, rand(30 SECONDS, 40 SECONDS), TRUE, TRUE)

/obj/item/food/beyti
	name = "beyti"
	desc = "Beyti, kıyma veya kuzu etinden oluşan, bir Türk yemeğidir."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "beyti"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("meat" = 1, "onion" = 1, "tomato" = 1)
	foodtypes = MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

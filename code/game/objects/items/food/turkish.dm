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
	foodtypes = MEAT | VEGETABLES | RAW | GRAIN
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT)

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
	foodtypes = MEAT | VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/raw_beyti
	name = "raw beyti"
	desc = "Beyti, kıyma veya kuzu etinden oluşan, bir Türk yemeğidir. Bu sanki pişmemiş?"
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "raw_beyti"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("meat" = 1, "onion" = 1, "tomato" = 1)
	foodtypes = MEAT | VEGETABLES | RAW | GRAIN
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT)

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
	foodtypes = MEAT | VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/raw_kiymali_pide
	name = "raw kiymali pide"
	desc = "İnce hamur üzerine kıyma, domates, biber ve baharatlarla hazırlanan, Türk mutfağına özgü, fırında pişirilmesi gerekilen lezzetli bir pide çeşididir."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "raw_kiymali_pide"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("meat" = 1, "pepper" = 1, "tomato" = 1)
	foodtypes = MEAT | VEGETABLES | RAW | GRAIN
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT)

/obj/item/food/raw_kiymali_pide/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/kiymali_pide, rand(30 SECONDS, 40 SECONDS), TRUE, TRUE)

/obj/item/food/kiymali_pide
	name = "kiymali pide"
	desc = "İnce hamur üzerine kıyma, domates, biber ve baharatlarla hazırlanan, Türk mutfağına özgü, fırında pişirilen lezzetli bir pide çeşididir."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "kiymali_pide"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("meat" = 1, "pepper" = 1, "tomato" = 1)
	foodtypes = MEAT | VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/doner/yaprak/et
	name = "yaprak et doner"
	desc = "Yaprak et döner, etin dikey şişte pişirilerek hazırlanan bir döner çeşididir."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "yaprakdoner_et"
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/doner/yaprak/tavuk
	name = "yaprak tavuk doner"
	desc = "Yaprak tavuk döner, tavuk göğsünün dikey şişte pişirilerek hazırlanan bir döner çeşididir."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "yaprakdoner_tavuk"
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/doner/et
	name = "et doner"
	desc = "Somun ekmek arası et döner, içerisindeki yaprak döner dışarıya taşmak üzere."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "etdoner"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("meat" = 2, "tomato" = 1, , "onions" = 1, "lettuce" = 1)
	foodtypes = MEAT | VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/doner/et/sade
	name = "sade et doner"
	desc = "Somun ekmek arası et döner, içerisindeki yaprak döner dışarıya taşmak üzere."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "etdoner_sade"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("meat" = 1)
	foodtypes = MEAT | GRAIN
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/doner/tavuk
	name = "tavuk doner"
	desc = "Somun ekmek arası et döner, içerisindeki yaprak döner dışarıya taşmak üzere."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "tavukdoner"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("chicken" = 2, "tomato" = 1, , "onions" = 1, "lettuce" = 1)
	foodtypes = MEAT | VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/doner/tavuk/sade
	name = "sade tavuk doner"
	desc = "Somun ekmek arası tavuk döner, içerisindeki yaprak döner dışarıya taşmak üzere."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "tavukdoner_sade"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("chicken" = 1)
	foodtypes = MEAT | GRAIN
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/kisir
	name = "kisir"
	desc = "İnce bulgur, domates salçası, soğan ve çeşitli baharatlarla karıştırarak hazırlanan lezzetli bir Türk yemeğidir."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "kisir"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("tomato" = 1, "onion" = 1, "wheat" = 1, "pepper" = 1)
	foodtypes = VEGETABLES | GRAIN
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2
	trash_type = /obj/item/reagent_containers/cup/bowl

/obj/item/food/tavton
	name = "tavuklu tonbalikli pilav"
	desc = "adamın biri bir gün tavuklu pilav yiyormuş, sonra kendi kendine düşünüp ulan bunun içine ton balığı koysam ne güzel olur demiş ton balıklı ve tavuklu pilav olmuş hahaha"
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "tavton"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/protein  = 4,
	)
	tastes = list("rice" = 1, "chicken" = 1, "tuna" = 1)
	foodtypes = MEAT | GRAIN | SEAFOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2
	trash_type = /obj/item/reagent_containers/cup/bowl
	custom_materials = list(/datum/material/meat = MEATSLAB_MATERIAL_AMOUNT)

/obj/item/food/raw_menemen
	name = "raw menemen"
	desc = "Menemen, yumurta, biber, domates ve isteğe bağlı olarak soğan kullanılarak yapılan bir Türk yemeğidir."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "raw_menemen"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("tomato" = 1, "egg" = 1, "pepper" = 1)
	foodtypes = MEAT | VEGETABLES | RAW | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2
	trash_type = /obj/item/plate

/obj/item/food/raw_menemen/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/menemen, rand(30 SECONDS, 40 SECONDS), TRUE, TRUE)

/obj/item/food/raw_menemen/onion
	name = "raw soganli menemen"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/vitamin = 3,
	)
	tastes = list("tomato" = 1, "egg" = 1, "pepper" = 1, "onion" = 1)

/obj/item/food/raw_menemen/onion/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/menemen/onion, rand(30 SECONDS, 40 SECONDS), TRUE, TRUE)

/obj/item/food/menemen
	name = "menemen"
	desc = "Menemen, yumurta, biber, domates ve isteğe bağlı olarak soğan kullanılarak yapılan bir Türk yemeğidir."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "menemen"
	tastes = list("tomato" = 1, "egg" = 1, "pepper" = 1)
	foodtypes = VEGETABLES | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2
	trash_type = /obj/item/plate

/obj/item/food/menemen/onion
	name = "soganli menemen"
	tastes = list("tomato" = 1, "egg" = 1, "pepper" = 1, "onion" = 1)

/obj/item/food/iskender
	name = "iskender"
	desc = "Altında küçük küçük dilimlenmiş pide bulunan, üzerine salça ve kızgın tereyağı dökülen, istenirse yoğurtlu da olabilen, yaprak yaprak kesilmiş döner kebabı; iskender kebap da denir."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "iskender"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("meat" = 2, "tomato" = 1, "pepper" = 1)
	foodtypes = VEGETABLES | GRAIN | MEAT
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_4
	trash_type = /obj/item/plate

/obj/item/food/raw_dolma
	name = "raw dolma"
	desc = "Dolma, Balkan, Güney Kafkasya, Orta Asya, Akdeniz, Ege ve Orta Doğu mutfaklarında yeri olan bir yemek çeşididir."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "raw_dolma"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("rice" = 1, "tomato" = 1, "pepper" = 1, "onion" = 1)
	foodtypes = VEGETABLES | RAW | GRAIN
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/raw_dolma/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/dolma, rand(30 SECONDS, 40 SECONDS), TRUE, TRUE)

/obj/item/food/dolma
	name = "dolma"
	desc = "Dolma, Balkan, Güney Kafkasya, Orta Asya, Akdeniz, Ege ve Orta Doğu mutfaklarında yeri olan bir yemek çeşididir."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "dolma"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("rice" = 1, "tomato" = 1, "pepper" = 1, "onion" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/etdoner_pilav
	name = "pilav ustu et doner"
	desc = "Pilav üstü et döner, en sevilen sokak lezzetlerinden biridir. Yaprak şeklinde ince ince kesilen et döner, kızartıldıktan sonra pirinç pilavı ile birlikte servis edilir."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "etdoner_pilav"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("rice" = 1, "tomato" = 1, "pepper" = 1, "meat" = 1)
	foodtypes = VEGETABLES | MEAT | GRAIN
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2
	trash_type = /obj/item/plate

/obj/item/food/tavukdoner_pilav
	name = "pilav ustu tavuk doner"
	desc = "Pilav üstü tavuk döner, en sevilen sokak lezzetlerinden biridir. Yaprak şeklinde ince ince kesilen tavuk döner, kızartıldıktan sonra pirinç pilavı ile birlikte servis edilir."
	icon = 'icons/psychonaut/obj/food/turkish.dmi'
	icon_state = "tavukdoner_pilav"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("rice" = 1, "tomato" = 1, "pepper" = 1, "chicken" = 1)
	foodtypes = VEGETABLES | MEAT | GRAIN
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2
	trash_type = /obj/item/plate

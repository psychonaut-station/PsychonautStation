/obj/machinery/vending/meal
	name = "\improper Befat's Convenience Meals"
	desc = "An old food machine made by an anonymous company."
	product_slogans = "Acıktınmı, neyseki biz varız!;Ayın en lezzetli yemekleri burda!"
	product_ads = "Çok sağlıklı gözüküyor!;Biz varken şefe gerek varmı?;Mmm, çok iyi!;Afiyet olsun!;Farkımız tarzımız!!;1875'den beri!;Tarihin en iyisi!!;"
	icon_state = "snack"
	panel_type = "panel2"
	light_mask = "snack-light-mask"
	products = list(
		/obj/item/food/foiltray/rice = 4,
		/obj/item/food/foiltray/beans = 4,
		/obj/item/food/foiltray/potatofry = 4,
		/obj/item/food/foiltray/ricenbean = 4,
		/obj/item/food/foiltray/noodle = 4,
		/obj/item/food/foiltray/sushi = 4,
		/obj/item/food/foiltray/chickenburger = 4,
		/obj/item/food/foiltray/beef = 4,
		/obj/item/food/foiltray/beefnrice = 4,
		/obj/item/food/foiltray/doner = 4,
		/obj/item/food/foiltray/donernrice = 4,
	)
	refill_canister = /obj/item/vending_refill/meal
	default_price = PAYCHECK_CREW * 0.6
	extra_price = PAYCHECK_CREW
	payment_department = ACCOUNT_SRV

/obj/item/vending_refill/meal
	machine_name = "Befat's Convenience Meals"

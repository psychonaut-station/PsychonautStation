/// Doner Machine.
/datum/supply_pack/service/doner_grill
	name = "Doner Grill Crate"
	desc = "Otomatik döner makinesi, etin dönerken ısı kaynağına yakın bir şekilde pişirilmesi için tasarlanmış mutfak ekipmanı."
	cost = CARGO_CRATE_VALUE * 7
	contains = list(
		/obj/machinery/doner_grill = 1,
		/obj/item/doner_stick = 2,
		/obj/item/knife/doner = 1
	)
	crate_name = "doner grill crate"

/obj/item/storage/box/survival/wardrobe_removal()
	if(!isipc(loc)) //We need to specially fill the box with plasmaman gear, since it's intended for one
		return ..()
	var/obj/item/mask = locate(mask_type) in src
	var/obj/item/internals = locate(internal_type) in src
	new /obj/item/stock_parts/power_store/cell/high(src)
	qdel(mask) // Get rid of the items that shouldn't be
	qdel(internals)

/obj/item/storage/box/survival/worker
	name = "extended-capacity survival box"
	desc = "A box with the bare essentials of ensuring the survival of you and others. This one is labelled to contain an extended-capacity tank."
	illustration = "extendedtank"
	internal_type = /obj/item/tank/internals/emergency_oxygen/engi

/obj/item/storage/box/survival/worker/PopulateContents()
	new /obj/item/reagent_containers/cup/soda_cans/cola(src)

/obj/item/storage/box/survival/worker
	name = "extended-capacity survival box"
	desc = "A box with the bare essentials of ensuring the survival of you and others. This one is labelled to contain an extended-capacity tank."
	illustration = "extendedtank"
	internal_type = /obj/item/tank/internals/emergency_oxygen/engi

/obj/item/storage/box/survival/worker/PopulateContents()
	..()
	new /obj/item/reagent_containers/cup/soda_cans/cola(src)

/obj/item/construction/rtd
	max_secondary_matter = 50
	secondary_matter_types = list(
		/obj/item/stack/sheet/cloth = 4,
		/obj/item/stack/tile/carpet = 1,
	)

/datum/tile_info
	var/secondary

/obj/item/construction/rtd/loaded
	secondary_matter = 50

/obj/item/construction/rtd/admin
	secondary_matter = INFINITY
	max_secondary_matter = INFINITY

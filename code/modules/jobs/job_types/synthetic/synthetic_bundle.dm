/datum/synthetic_bundle
	var/name = ""
	var/crate_type = /obj/structure/closet/crate
	var/list/crate_contents = null

/datum/synthetic_bundle/proc/fill_crate()
	var/obj/structure/closet/crate/bundle_crate = new crate_type()
	if(!istype(bundle_crate))
		CRASH("crate_type is not a crate")

	if (crate_contents)
		for(var/item in crate_contents)
			if(!crate_contents[item])
				crate_contents[item] = 1
			for(var/iteration = 1 to crate_contents[item])
				new item(bundle_crate)

	return bundle_crate

/datum/synthetic_bundle/engineering
	name = "Engineering Synthetic Kit"
	crate_type = /obj/structure/closet/crate/engineering
	crate_contents = list(
		/obj/item/clothing/gloves/chief_engineer = 1,
		/obj/item/pipe_dispenser = 1,
		/obj/item/construction/rcd/loaded = 1,
		/obj/item/stack/sheet/glass/fifty = 1,
		/obj/item/stack/sheet/iron/fifty = 1,
		/obj/item/holosign_creator/atmos = 1,
		/obj/item/clothing/head/utility/hardhat/welding = 1,
		/obj/item/analyzer/ranged = 1,
		/obj/item/construction/rtd/loaded = 1,
	)

/datum/synthetic_bundle/medical
	name = "Medical Synthetic Kit"
	crate_type = /obj/structure/closet/crate/medical
	crate_contents = list(
		/obj/item/clothing/gloves/latex/nitrile = 1,
		/obj/item/storage/backpack/duffelbag/med/surgery = 1,
		/obj/item/defibrillator/compact/loaded = 1,
		/obj/item/roller = 1,
		/obj/item/storage/medkit/advanced = 1,
		/obj/item/healthanalyzer = 1,
		/obj/item/storage/box/beakers = 1,
	)

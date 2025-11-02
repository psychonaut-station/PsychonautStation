/datum/design/clocky
	name = "Clock Head"
	id = "clocky"
	desc = "An anomaly clock created by bioscrambler anomaly."
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/clothing/head/helmet/clocky
	materials = list(
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 1,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 0.5,
		/datum/material/plasma = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/uranium = SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace = SHEET_MATERIAL_AMOUNT * 0.5
	)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

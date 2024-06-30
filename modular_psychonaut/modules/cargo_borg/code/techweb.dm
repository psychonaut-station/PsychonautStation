/** Techweb Node */

/datum/techweb_node/borg_cargo
	id = "borg_cargo"
	display_name = "Cargo Cyborg Upgrades"
	description = "Let them carry crates like a coolie."
	prereq_ids = list("cybernetics")
	design_ids = list(
		"borg_upgrade_clamp_capacity",
		"borg_upgrade_clamp_speed",
		"borg_upgrade_clamp_charge",
		"borg_upgrade_clamp_carry",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)

/** Designs */

/datum/design/borg_upgrade_clamp_capacity
	name = "clamp capacity upgrade"
	id = "borg_upgrade_clamp_capacity"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/clamp/capacity
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 10,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 7.5,
	)
	construction_time = 5 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_CARGO
	)

/datum/design/borg_upgrade_clamp_speed
	name = "clamp speed upgrade"
	id = "borg_upgrade_clamp_speed"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/clamp/speed
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 10,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 7.5,
	)
	construction_time = 5 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_CARGO
	)

/datum/design/borg_upgrade_clamp_charge
	name = "clamp charge upgrade"
	id = "borg_upgrade_clamp_charge"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/clamp/charge
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 10,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 7.5,
	)
	construction_time = 5 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_CARGO
	)

/datum/design/borg_upgrade_clamp_carry
	name = "clamp carry upgrade"
	id = "borg_upgrade_clamp_carry"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/clamp/carry
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 10,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 7.5,
	)
	construction_time = 5 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_CARGO
	)

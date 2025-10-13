/datum/techweb_node/borg_cargo
	id = "borg_cargo"
	display_name = "Cargo Cyborg Upgrades"
	description = "Let them carry crates like a coolie."
	prereq_ids = list("cybernetics")
	design_ids = list(
		"borg_upgrade_clampcap",
		"borg_upgrade_clamptime",
		"borg_upgrade_clampcharge",
		"borg_upgrade_clampcarry",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)

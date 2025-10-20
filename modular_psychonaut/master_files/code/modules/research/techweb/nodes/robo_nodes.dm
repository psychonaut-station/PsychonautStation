
/datum/techweb_node/ipc
	id = TECHWEB_NODE_IPC
	display_name = "IPC Construction"
	description = "Humanoid robotic creatures with monitors in their heads."
	prereq_ids = list(TECHWEB_NODE_ROBOTICS)
	design_ids = list(
		"ipc_head",
		"ipc_chest",
		"ipc_l_arm",
		"ipc_r_arm",
		"ipc_l_leg",
		"ipc_r_leg",
		"ipc_stomach",
		"ipc_voltprotector",
		"ipc_power_cord",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

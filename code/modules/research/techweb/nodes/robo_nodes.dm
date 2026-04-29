/datum/techweb_node/robotics
	id = TECHWEB_NODE_ROBOTICS
	starting_node = TRUE
	display_name = "Robotics"
	description = "Programmable machines that make our lives lazier."
	design_ids = list(
		"botnavbeacon",
		"mechfab",
		"paicard",
	)

/datum/techweb_node/exodrone
	id = TECHWEB_NODE_EXODRONE
	display_name = "Exploration Drones"
	description = "Adapted arcade machines to covertly harness gamers' skills in controlling real drones for practical purposes."
	prereq_ids = list(TECHWEB_NODE_ROBOTICS)
	design_ids = list(
		"exodrone_console",
		"exodrone_launcher",
		"exoscanner",
		"exoscanner_console",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)

// AI root node
/datum/techweb_node/ai
	id = TECHWEB_NODE_AI
	display_name = "Artificial Intelligence"
	description = "Exploration of AI systems, more intelligent than the entire crew put together."
	prereq_ids = list(TECHWEB_NODE_ROBOTICS)
	design_ids = list(
		"aicore",
		"aifixer",
		"aiupload",
		"ai_core_display",
		"ai_data_core",
		"ai_overclocking",
		"ai_server_overview",
		"asimov_module",
		"basic_ai_cpu",
		"borg_ai_control",
		"corporate_module",
		"default_module",
		"drone_module",
		"freeform_module",
		"intellicard",
		"mecha_tracking_ai_control",
		"networking_machine",
		"nutimov_module",
		"oxygen_module",
		"paladin_module",
		"protectstation_module",
		"quarantine_module",
		"rack_creator",
		"remove_module",
		"ram1",
		"reset_module",
		"robocop_module",
		"safeguard_module",
		"server_cabinet",
		"subcontroller",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/ai/New()
	. = ..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_HUMAN_AI))
		design_ids -= list(
			"aicore",
			"aifixer",
			"aiupload",
			"borg_ai_control",
			"intellicard",
			"mecha_tracking_ai_control",
		)
	else if(HAS_TRAIT(SSstation, STATION_TRAIT_UNIQUE_AI))
		research_costs[TECHWEB_POINT_TYPE_GENERIC] *= 3

/datum/techweb_node/ai_laws
	id = TECHWEB_NODE_AI_LAWS
	display_name = "Advanced AI Upgrades"
	description = "Delving into sophisticated AI directives, with hopes that they won't lead to humanity's extinction."
	prereq_ids = list(TECHWEB_NODE_AI)
	design_ids = list(
		"ai_cam_upgrade",
		"ai_power_upgrade",
		"antimov_module",
		"asimovpp_module",
		"balance_module",
		"damaged_module",
		"dungeon_master_module",
		"freeformcore_module",
		"hippocratic_module",
		"hulkamania_module",
		"liveandletlive_module",
		"maintain_module",
		"onehuman_module",
		"overlord_module",
		"painter_module",
		"paladin_devotion_module",
		"peacekeeper_module",
		"purge_module",
		"reporter_module",
		"ten_commandments_module",
		"thermurderdynamic_module",
		"thinkermov_module",
		"tyrant_module",
		"yesman_module",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_COMMAND)

/datum/techweb_node/ai_cpu_advanced
	id = "ai_cpu_advanced"
	display_name = "Advanced Neural Processing"
	description = "Higher throughput neural processors with improved but less efficient operation."
	design_ids = list(
		"advanced_ai_cpu",
	)
	prereq_ids = list(TECHWEB_NODE_AI, TECHWEB_NODE_PARTS_ADV)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/ai_cpu_experimental
	id = "ai_cpu_experimental"
	display_name = "Experimental Neural Processing"
	description = "Repurposed neural processors with unstable but promising characteristics."
	design_ids = list(
		"experimental_ai_cpu",
	)
	prereq_ids = list("ai_cpu_advanced")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/ai_cpu_bluespace
	id = "ai_cpu_bluespace"
	display_name = "Bluespace Neural Processing"
	description = "Bluespace miniaturization pushes decentralized AI processors to their extreme."
	design_ids = list(
		"bluespace_ai_cpu",
	)
	prereq_ids = list("ai_cpu_advanced", TECHWEB_NODE_APPLIED_BLUESPACE)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/ai_ram_high_cap
	id = "ai_ram_high_cap"
	display_name = "High Capacity Memory"
	description = "Denser memory modules for larger decentralized AI server racks."
	design_ids = list(
		"ram2",
	)
	prereq_ids = list(TECHWEB_NODE_AI, TECHWEB_NODE_PARTS_ADV)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/ai_ram_hyper
	id = "ai_ram_hyper"
	display_name = "Hyper Capacity Memory"
	description = "Tighter memory fabrication for heavier decentralized AI workloads."
	design_ids = list(
		"ram3",
	)
	prereq_ids = list("ai_ram_high_cap")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/ai_ram_bluespace
	id = "ai_ram_bluespace"
	display_name = "Bluespace Memory"
	description = "Bluespace-assisted memory storage for top-end decentralized AI hardware."
	design_ids = list(
		"ram4",
	)
	prereq_ids = list("ai_ram_hyper", TECHWEB_NODE_APPLIED_BLUESPACE)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/ai_cpu_1
	id = "ai_cpu_2"
	display_name = "Improved CPU Sockets"
	description = "Allows an extra CPU core to be mounted in each AI server rack."
	prereq_ids = list(TECHWEB_NODE_AI)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/ai_ram_1
	id = "ai_ram_2"
	display_name = "Improved Memory Bus"
	description = "Allows an additional memory stick to be mounted in each AI server rack."
	prereq_ids = list(TECHWEB_NODE_AI)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/ai_architecture_256
	id = "ai_arch_256"
	display_name = "256-bit Computing"
	description = "Broader rack data paths unlock the next tier of decentralized AI hardware."
	prereq_ids = list("ai_ram_2", "ai_cpu_2")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/ai_architecture_bluespace
	id = "ai_arch_bluespace"
	display_name = "Bluespace Computing"
	description = "Bluespace data transport removes the final bottlenecks from AI server racks."
	prereq_ids = list("ai_arch_256", TECHWEB_NODE_APPLIED_BLUESPACE)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/ai_cpu_2
	id = "ai_cpu_3"
	display_name = "Advanced CPU Sockets"
	description = "Allows a third CPU core to be installed in decentralized AI server racks."
	prereq_ids = list("ai_arch_256", "ai_cpu_2")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/ai_cpu_3
	id = "ai_cpu_4"
	display_name = "Bluespace CPU Sockets"
	description = "Allows a fourth CPU core to be installed in decentralized AI server racks."
	prereq_ids = list("ai_arch_bluespace", "ai_cpu_3")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/ai_ram_2
	id = "ai_ram_3"
	display_name = "Advanced Memory Bus"
	description = "Allows a third memory module to be installed in decentralized AI server racks."
	prereq_ids = list("ai_arch_256", "ai_ram_2")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/ai_ram_3
	id = "ai_ram_4"
	display_name = "Bluespace Memory Bus"
	description = "Allows a fourth memory module to be installed in decentralized AI server racks."
	prereq_ids = list("ai_ram_3", "ai_arch_bluespace")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

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

/datum/design/ram
	name = "RAM design"
	desc = "A hidden RAM design used by decentralized AI hardware."
	id = DESIGN_ID_IGNORE
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_MISC,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE
	research_icon = 'icons/obj/module.dmi'
	research_icon_state = "server_rack"
	var/capacity = 0
	materials = list(/datum/material/glass = 1000)

/datum/design/ram/ram1
	name = "standard memory"
	desc = "A basic memory module suitable for decentralized AI racks."
	id = "ram1"
	capacity = 1
	materials = list(/datum/material/glass = 1000, /datum/material/iron = 1000)

/datum/design/ram/ram2
	name = "high-capacity memory"
	desc = "A denser memory module with improved capacity at standard performance."
	id = "ram2"
	capacity = 2
	materials = list(/datum/material/glass = 2000, /datum/material/iron = 2000, /datum/material/silver = 1000)

/datum/design/ram/ram3
	name = "hyper-capacity memory"
	desc = "A tightly packed memory module built for heavier AI workloads."
	id = "ram3"
	capacity = 3
	materials = list(/datum/material/glass = 4000, /datum/material/iron = 4000, /datum/material/silver = 2000, /datum/material/gold = 1000)

/datum/design/ram/ram4
	name = "bluespace memory"
	desc = "A bleeding-edge memory module that leverages bluespace compression."
	id = "ram4"
	capacity = 4
	materials = list(/datum/material/glass = 8000, /datum/material/iron = 8000, /datum/material/silver = 4000, /datum/material/gold = 2000, /datum/material/bluespace = 1000)

/datum/design/cpu_basic
	name = "neural processing unit"
	desc = "A processor specialized for decentralized AI workloads."
	id = "basic_ai_cpu"
	build_type = IMPRINTER
	materials = list(/datum/material/glass = 2000, /datum/material/iron = 2000)
	build_path = /obj/item/ai_cpu
	construction_time = 5 SECONDS
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_MISC,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/cpu_advanced
	name = "advanced neural processing unit"
	desc = "A higher-throughput processor for heavier decentralized AI loads."
	id = "advanced_ai_cpu"
	build_type = IMPRINTER
	materials = list(/datum/material/glass = 4000, /datum/material/iron = 4000, /datum/material/gold = 2000)
	build_path = /obj/item/ai_cpu/advanced
	construction_time = 7.5 SECONDS
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_MISC,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/cpu_bluespace
	name = "bluespace neural processing unit"
	desc = "A miniaturized processor that trades efficiency for raw decentralized AI throughput."
	id = "bluespace_ai_cpu"
	build_type = IMPRINTER
	materials = list(/datum/material/glass = 8000, /datum/material/iron = 4000, /datum/material/gold = 4000, /datum/material/bluespace = 2000)
	build_path = /obj/item/ai_cpu/bluespace
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_MISC,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/cpu_experimental
	name = "experimental neural processing unit"
	desc = "A volatile processor variant with unstable but promising overclocking potential."
	id = "experimental_ai_cpu"
	build_type = IMPRINTER
	materials = list(/datum/material/glass = 6000, /datum/material/iron = 4000, /datum/material/gold = 6000)
	build_path = /obj/item/ai_cpu/experimental
	construction_time = 7.5 SECONDS
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_MISC,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

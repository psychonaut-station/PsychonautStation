//IPC

/datum/design/ipc_chest
	name = "IPC Chest"
	id = "ipc_chest"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/chest/ipc
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*20, /datum/material/plasma = SHEET_MATERIAL_AMOUNT*20)
	construction_time = 350
	category = list(
		RND_CATEGORY_MECHFAB_IPC + RND_SUBCATEGORY_MECHFAB_IPC_BODYPARTS
	)

/datum/design/ipc_head
	name = "IPC Head"
	id = "ipc_head"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/head/ipc
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*3.5, /datum/material/plasma = SHEET_MATERIAL_AMOUNT*3.5, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 3.5)
	construction_time = 350
	category = list(
		RND_CATEGORY_MECHFAB_IPC + RND_SUBCATEGORY_MECHFAB_IPC_BODYPARTS
	)

/datum/design/ipc_l_arm
	name = "IPC Left Arm"
	id = "ipc_l_arm"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/arm/left/ipc
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*5, /datum/material/plasma = SHEET_MATERIAL_AMOUNT*5)
	construction_time = 350
	category = list(
		RND_CATEGORY_MECHFAB_IPC + RND_SUBCATEGORY_MECHFAB_IPC_BODYPARTS
	)

/datum/design/ipc_r_arm
	name = "IPC Right Arm"
	id = "ipc_r_arm"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/arm/right/ipc
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*5, /datum/material/plasma = SHEET_MATERIAL_AMOUNT*5)
	construction_time = 350
	category = list(
		RND_CATEGORY_MECHFAB_IPC + RND_SUBCATEGORY_MECHFAB_IPC_BODYPARTS
	)

/datum/design/ipc_l_leg
	name = "IPC Left Leg"
	id = "ipc_l_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/leg/left/ipc
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*5, /datum/material/plasma = SHEET_MATERIAL_AMOUNT*5)
	construction_time = 350
	category = list(
		RND_CATEGORY_MECHFAB_IPC + RND_SUBCATEGORY_MECHFAB_IPC_BODYPARTS
	)

/datum/design/ipc_r_leg
	name = "IPC Right Leg"
	id = "ipc_r_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/leg/right/ipc
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*5, /datum/material/plasma = SHEET_MATERIAL_AMOUNT*5)
	construction_time = 350
	category = list(
		RND_CATEGORY_MECHFAB_IPC + RND_SUBCATEGORY_MECHFAB_IPC_BODYPARTS
	)

/datum/design/ipc_stomach
	name = "IPC Cell Holder"
	id = "ipc_stomach"
	build_type = MECHFAB
	build_path = /obj/item/organ/stomach/ipc/empty
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*5)
	construction_time = 100
	category = list(
		RND_CATEGORY_MECHFAB_IPC + RND_SUBCATEGORY_MECHFAB_IPC_ORGANS
	)

/datum/design/ipc_voltprotector
	name = "IPC High Voltage Protector"
	id = "ipc_voltprotector"
	build_type = MECHFAB
	build_path = /obj/item/organ/voltage_protector
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*5)
	construction_time = 100
	category = list(
		RND_CATEGORY_MECHFAB_IPC + RND_SUBCATEGORY_MECHFAB_IPC_ORGANS
	)

/datum/design/ipc_power_cord
	name = "IPC Power Cord"
	id = "ipc_power_cord"
	build_type = MECHFAB
	build_path = /obj/item/organ/cyberimp/arm/toolkit/power_cord
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*5)
	construction_time = 100
	category = list(
		RND_CATEGORY_MECHFAB_IPC + RND_SUBCATEGORY_MECHFAB_IPC_ORGANS
	)

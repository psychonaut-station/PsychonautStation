/datum/job/worker
	title = JOB_WORKER
	description = "Amelelik yap, mürettabatın istedigi inşaat işlerini yap, sarma tütün iç, mühendislere racon kes."
	department_head = list(JOB_CHIEF_ENGINEER)
	faction = FACTION_STATION
	total_positions = 3
	spawn_positions = 3
	supervisors = SUPERVISOR_CE
	exp_requirements = 30
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "WORKER"

	outfit = /datum/outfit/job/worker
	plasmaman_outfit = /datum/outfit/plasmaman/engineering

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_ENG

	liver_traits = list(TRAIT_ENGINEER_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_WORKER
	bounty_types = CIV_JOB_ENG
	departments_list = list(
		/datum/job_department/engineering,
	)

	family_heirlooms = list(/obj/item/clothing/head/utility/hardhat, /obj/item/screwdriver, /obj/item/wrench, /obj/item/weldingtool, /obj/item/crowbar, /obj/item/wirecutters)

	mail_goodies = list(
		/obj/item/storage/box/lights/mixed = 20,
		/obj/item/lightreplacer = 10,
		/obj/item/holosign_creator/engineering = 8,
		/obj/item/wrench/bolter = 8,
		/obj/item/clothing/head/utility/hardhat/red/upgraded = 1,
	)

	rpg_title = "Hobo"
	job_flags = STATION_JOB_FLAGS

/datum/outfit/job/worker
	name = "Worker"
	jobtype = /datum/job/worker

	id_trim = /datum/id_trim/job/worker
	uniform = /obj/item/clothing/under/pants/jeans
	suit = /obj/item/clothing/suit/hazardvest
	belt = /obj/item/storage/belt/utility/full/engi
	ears = /obj/item/radio/headset/headset_eng
	head = /obj/item/clothing/head/utility/hardhat
	shoes = /obj/item/clothing/shoes/workboots
	l_pocket = /obj/item/modular_computer/pda/engineering
	r_pocket = /obj/item/storage/fancy/cigarettes/cigpack_mindbreaker

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	messenger = /obj/item/storage/backpack/messenger/eng

	backpack_contents = list(
		/obj/item/stack/sheet/iron/fifty,
		/obj/item/stack/sheet/glass/fifty,
		/obj/item/stack/sheet/plasteel/twenty,
		/obj/item/stack/sheet/mineral/wood/thirty,
		/obj/item/construction/rcd/loaded,
		/obj/item/construction/rtd/loaded,
	)

	box = /obj/item/storage/box/survival/worker
	pda_slot = ITEM_SLOT_LPOCKET

/datum/outfit/job/worker/gloved
	name = "Worker (Gloves)"

	gloves = /obj/item/clothing/gloves/color/yellow

/obj/item/stack/sheet/mineral/wood/thirty
	amount = 30

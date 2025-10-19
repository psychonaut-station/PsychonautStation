/datum/job/worker
	title = JOB_WORKER
	description = "Amelelik yap, murettebatin istedigi yapi islerini yap, adiyaman tutun sarma ic, muhendislere racon kes."
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

	display_order = JOB_DISPLAY_ORDER_STATION_ENGINEER
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
		/obj/item/clothing/head/utility/hardhat/red/upgraded = 1
	)
	rpg_title = "Amele"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN

	alt_titles = list(
		"Worker",
		"Amele",
		"Workman",
		"Prole"
	)

	roundstart_spawn_point = /obj/effect/landmark/start/station_engineer

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
		/obj/item/stack/sheet/cloth/thirty,
		/obj/item/construction/rcd/loaded,
		/obj/item/construction/rtd/loaded,
	)

	box = /obj/item/storage/box/survival/worker
	pda_slot = ITEM_SLOT_LPOCKET

/datum/outfit/job/worker/gloved
	name = "Worker (Gloves)"

	gloves = /obj/item/clothing/gloves/color/yellow

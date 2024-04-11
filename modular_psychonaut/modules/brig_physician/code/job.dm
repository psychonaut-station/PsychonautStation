/datum/job/brig_physician
	title = JOB_BRIG_PHYSICIAN
	description = "Brig'deki mahkumların veya iş arkadaşlarının tıbbi ihtiyaçlarınn karşlayacak olan kişisin."
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list(JOB_HEAD_OF_SECURITY)
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_HOS
	minimal_player_age = 7
	exp_requirements = 150
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "BRIG_PHYSICIAN"

	outfit = /datum/outfit/job/brig_physician
	plasmaman_outfit = /datum/outfit/plasmaman/security

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_BRIG_PHYSICIAN
	bounty_types = CIV_JOB_SEC
	departments_list = list(
		/datum/job_department/security,
	)

	family_heirlooms = list(/obj/item/book/manual/wiki/security_space_law, /obj/item/storage/medkit/ancient/heirloom, /obj/item/scalpel, /obj/item/hemostat, /obj/item/circular_saw, /obj/item/retractor, /obj/item/cautery, /obj/item/statuebust/hippocratic)

	mail_goodies = list(
		/obj/item/food/donut/caramel = 10,
		/obj/item/food/donut/matcha = 10,
		/obj/item/healthanalyzer/advanced = 15,
		/obj/item/scalpel/advanced = 6,
		/obj/item/retractor/advanced = 6,
		/obj/item/cautery/advanced = 6,
		/obj/item/melee/baton/security/boomerang/loaded = 1
	)

	rpg_title = "Combat Medic"
	job_flags = STATION_JOB_FLAGS

/datum/outfit/job/brig_physician
	name = "Brig Physician"
	jobtype = /datum/job/brig_physician

	id_trim = /datum/id_trim/job/brig_physician
	uniform = /obj/item/clothing/under/rank/medical/paramedic
	suit = /obj/item/clothing/suit/armor/vest/brig_physician
	belt = /obj/item/defibrillator/compact/loaded
	ears = /obj/item/radio/headset/headset_sec/alt/department/med
	glasses = /obj/item/clothing/glasses/hud/health
	gloves = /obj/item/clothing/gloves/latex/nitrile
	head = /obj/item/clothing/head/helmet/brig_physician
	shoes = /obj/item/clothing/shoes/jackboots/sec
	l_pocket = /obj/item/modular_computer/pda/security
	r_pocket = /obj/item/assembly/flash/handheld

	r_hand = /obj/item/storage/backpack/duffelbag/sec/surgery

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	messenger = /obj/item/storage/backpack/messenger/sec

	backpack_contents = list(
		/obj/item/emergency_bed = 1,
		/obj/item/flashlight/pen/paramedic,
	)

	box = /obj/item/storage/box/survival/medical
	pda_slot = ITEM_SLOT_LPOCKET

	skillchips = list(/obj/item/skillchip/entrails_reader)
	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/brig_physician/mod
	name = "Brig Physician (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/medical
	suit = null
	head = null
	mask = /obj/item/clothing/mask/breath/medical
	r_pocket = /obj/item/flashlight/pen/paramedic
	internals_slot = ITEM_SLOT_SUITSTORE

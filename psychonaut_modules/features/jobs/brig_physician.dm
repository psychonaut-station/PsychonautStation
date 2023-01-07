/datum/id_trim/job/brig_physician
	assignment = "Brig Physician"
	trim_state = "trim_brig_physician"
	department_color = COLOR_SECURITY_RED
	subdepartment_color = COLOR_SECURITY_RED
	sechud_icon_state = SECHUD_BRIG_PHYSICIAN
	extra_access = list(ACCESS_DETECTIVE, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE)
	minimal_access = list(
		ACCESS_BRIG,
		ACCESS_COURT,
		ACCESS_SECURITY,
		ACCESS_BRIG_ENTRANCE,
		ACCESS_MECH_SECURITY,
		ACCESS_MINERAL_STOREROOM,
		ACCESS_WEAPONS,
		ACCESS_MEDICAL,
		)
	/// List of bonus departmental accesses that departmental sec officers get.
	var/department_access = list()
	template_access = list(ACCESS_CAPTAIN, ACCESS_HOS, ACCESS_CHANGE_IDS)
	job = /datum/job/brig_physician


/datum/job/brig_physician
	title = JOB_BRIG_PHYSICIAN
	description = "Brig'deki mahkumlarin veya is arkadaslarinin tibbi ihtiyaclarini karsilayacak olan kisisin. "
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "Head of Security"
	selection_color = "#ffeeee"
	exp_granted_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/brig_physician
	plasmaman_outfit = /datum/outfit/plasmaman/security

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_SECURITY_OFFICER
	bounty_types = CIV_JOB_SEC
	departments_list = list(
		/datum/job_department/security,
		)

	family_heirlooms = list(/obj/item/book/manual/wiki/security_space_law, /obj/item/clothing/head/beret/sec)

	mail_goodies = list(
		/obj/item/food/donut/caramel = 10,
		/obj/item/food/donut/matcha = 10,
		/obj/item/healthanalyzer/advanced = 15,
		/obj/item/scalpel/advanced = 6,
		/obj/item/retractor/advanced = 6,
		/obj/item/cautery/advanced = 6,
		/obj/item/melee/baton/security/boomerang/loaded = 1
	)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN
	rpg_title = "Combat Medic"
	config_tag = "BRIG_PHYSICIAN"

/datum/outfit/job/brig_physician
	name = "Brig Physician"
	jobtype = /datum/job/brig_physician

	id_trim = /datum/id_trim/job/brig_physician
	uniform = /obj/item/clothing/under/rank/medical/paramedic
	suit = /obj/item/clothing/suit/armor/vest/alt/brig_physician
	backpack_contents = list(
		/obj/item/roller = 1,
		)
	belt = /obj/item/defibrillator/compact/loaded
	ears = /obj/item/radio/headset/headset_sec/alt/department/med
	glasses = /obj/item/clothing/glasses/hud/health
	gloves = /obj/item/clothing/gloves/color/latex/nitrile
	head = /obj/item/clothing/head/helmet/brig_physician
	shoes = /obj/item/clothing/shoes/jackboots
	r_pocket = /obj/item/assembly/flash/handheld
	l_pocket = /obj/item/modular_computer/pda/security


	duffelbag = /obj/item/storage/backpack/duffelbag/sec/surgery

	box = /obj/item/storage/box/survival/medical
	skillchips = list(/obj/item/skillchip/entrails_reader)

	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/brig_physician/mod
	name = "Brig Physician (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/medical
	suit = null
	mask = /obj/item/clothing/mask/breath/medical
	r_pocket = /obj/item/flashlight/pen
	internals_slot = ITEM_SLOT_SUITSTORE

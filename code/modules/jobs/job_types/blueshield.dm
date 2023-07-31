/datum/job/blueshield
	title = "Blueshield"
	description = "Protect and serve command members at all cost. "
	department_head = list(JOB_CAPTAIN)
	faction = "Station"
	supervisors = "Command Members"
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_COMMAND
	exp_granted_type = EXP_TYPE_COMMAND

	outfit = /datum/outfit/job/blueshield
	plasmaman_outfit = /datum/outfit/plasmaman/blueshield

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC
	config_tag = "BLUESHIELD"

	department_for_prefs = /datum/job_department/security
	display_order = JOB_DISPLAY_ORDER_SECURITY_OFFICER
	total_positions = 1
	spawn_positions = 1

	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM, TRAIT_ROYAL_METABOLISM)
	bounty_types = CIV_JOB_SEC

	family_heirlooms = list(/obj/item/book/manual/wiki/security_space_law, /obj/item/toy/captainsaid/collector)
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN
	rpg_title = "Blueshit"
	departments_list = list(
		/datum/job_department/command,
		)

	mail_goodies = list(
		/obj/item/clothing/mask/cigarette/cigar/havana = 20,
		/obj/item/storage/fancy/cigarettes/cigars/havana = 15,
		/obj/item/reagent_containers/cup/glass/bottle/champagne = 5,
		/obj/effect/spawner/random/food_or_drink/donkpockets = 5,
		/obj/item/gun/ballistic/revolver/mateba/blueshield = 5,
	)


/datum/outfit/job/blueshield
	name = "Blueshield"
	jobtype = /datum/job/blueshield
	id = /obj/item/card/id/advanced/white
	id_trim = /datum/id_trim/job/blueshield
	uniform = /obj/item/clothing/under/rank/security/officer/formal
	suit = /obj/item/clothing/suit/armor/vest
	belt = /obj/item/modular_computer/pda/security
	ears = /obj/item/radio/headset/headset_blueshield
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/beret/sec/navyofficer
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/assembly/flash/handheld

	backpack_contents = list(/obj/item/reagent_containers/spray/pepper, /obj/item/melee/baton/telescopic,/obj/item/pinpointer/crew)
	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec

	box = /obj/item/storage/box/survival/security

	implants = list(/obj/item/implant/mindshield,/obj/item/implant/blueshield)
	skillchips = list(/obj/item/skillchip/disk_verifier)






/datum/job/survivor
	title = JOB_SURVIVOR
	description = "You are one of the last remaining survivors, keep going strong!"
	faction = FACTION_STATION
	total_positions = 0
	spawn_positions = 5
	supervisors = "absolutely everyone"
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "SURVIVOR"
	outfit = /datum/outfit/job/survivor
	plasmaman_outfit = /datum/outfit/plasmaman
	paycheck = PAYCHECK_LOWER // Get a job. Job reassignment changes your paycheck now. Get over it.

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT

	department_for_prefs = /datum/job_department/assistant

	liver_traits = list(TRAIT_MAINTENANCE_METABOLISM)

	family_heirlooms = list(/obj/item/storage/toolbox/mechanical/old/heirloom, /obj/item/clothing/gloves/cut/heirloom)

	mail_goodies = list(
		/obj/effect/spawner/random/food_or_drink/donkpockets = 10,
		/obj/item/clothing/mask/gas = 10,
		/obj/item/clothing/gloves/color/fyellow = 7,
		/obj/item/choice_beacon/music = 5,
		/obj/item/toy/sprayoncan = 3,
		/obj/item/crowbar/large = 1
	)

	job_flags = STATION_JOB_FLAGS
	rpg_title = "Hayata"

/datum/outfit/job/survivor
	name = JOB_SURVIVOR
	jobtype = /datum/job/survivor
	id_trim = /datum/id_trim/job/assistant
	uniform = /obj/item/clothing/under/misc/bouncer
	suit = /obj/item/clothing/suit/hazardvest
	belt = /obj/item/storage/belt/utility
	head = /obj/item/clothing/head/costume/pirate/bandana
	shoes = /obj/item/clothing/shoes/workboots
	l_pocket = /obj/item/modular_computer/pda/assistant
	r_pocket = /obj/item/storage/fancy/cigarettes/cigpack_mindbreaker

	backpack_contents = list(
		/obj/item/storage/medkit/emergency,
		/obj/item/food/canned/tomatoes,
		/obj/item/radio,
	)

	box = /obj/item/storage/box/survival
	pda_slot = ITEM_SLOT_LPOCKET
/datum/job/nt_secretary
	title = JOB_NT_SECRETARY
	description = "Commandin ayak islerini hallet, mürettebat ve yönetim arasinda bir kopru ol, \
		kaptanin odasina kimlerin girip ciktigini tüm istasyona duyur, \
		ofisinde kahveni iç ve hayatini sorgula... Simdi centcom a neden istasyonun \
		yedi koli puroya ihtiyaci oldugu ile ilgili bir rapor yaz!"
	faction = FACTION_STATION
	supervisors = SUPERVISOR_CAPTAIN
	outfit = /datum/outfit/job/nt_secretary
	plasmaman_outfit = /datum/outfit/plasmaman/nt_secretary
	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_CIV
	total_positions = 1
	spawn_positions = 1
	minimal_player_age = 10
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_SERVICE
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "NT_SECRETARY"
	bounty_types = CIV_JOB_RANDOM
	display_order = JOB_DISPLAY_ORDER_HEAD_OF_PERSONNEL
	departments_list = list(
		/datum/job_department/service,
		)

	mail_goodies = list(
		/obj/item/storage/box/coffeepack = 20,
		/obj/item/coffee_cartridge/fancy = 20,
		/obj/item/reagent_containers/cup/glass/mug = 20,
		/obj/item/reagent_containers/cup/glass/mug/nanotrasen = 10,
		/obj/item/pen/fountain/captain = 1,
		/obj/item/reagent_containers/cup/coffeepot/bluespace = 1
		)

	family_heirlooms = list(
		/obj/item/pen/fountain,
		/obj/item/clipboard,
		/obj/item/clothing/glasses/regular,
		/obj/item/reagent_containers/cup/glass/mug/nanotrasen,
		/obj/item/documents/photocopy
		)

	rpg_title = "servant"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS

	//mind_traits = list(TRAIT_SECRETARY)

/datum/outfit/job/nt_secretary
	name = JOB_NT_SECRETARY
	jobtype = /datum/job/nt_secretary
	id = /obj/item/card/id/advanced/white
	id_trim = /datum/id_trim/job/nt_secretary
	uniform = /obj/item/clothing/under/rank/centcom/nt_secretary
	backpack_contents = list(
		/obj/item/storage/box/nt_secretary = 1,
		/obj/item/storage/box/nt_secretary/coffee = 1,
		/obj/item/folder/blue = 1,
		/obj/item/paper_bin/bundlenatural = 1,
		/obj/item/stamp/secretary = 1,
		)
	belt = /obj/item/modular_computer/pda/nt_secretary
	ears = /obj/item/radio/headset/headset_com/nt_secretary
	head = /obj/item/clothing/head/hats/nt_secretary
	neck = /obj/item/clothing/neck/tie/blue/secretary/tied
	shoes = /obj/item/clothing/shoes/laceup

	r_pocket = /obj/item/reagent_containers/spray/pepper
	l_pocket = /obj/item/door_remote/secretary
	l_hand = /obj/item/clipboard

	accessory = /obj/item/clothing/accessory/pocketprotector/full

	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/nt_secretary/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	if(H.mind)
		H.mind.secretary = TRUE

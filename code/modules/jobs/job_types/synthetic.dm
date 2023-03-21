/datum/job/synthetic
	title = JOB_SYNTHETIC
	whitelisted = TRUE
	description = "Nanotrasen'in en pahalı projelerinden birisin. İstasyona yardım etmek için gönderiliyorsun. Yapabileceğinin en iyisini yapmak zorundasın, mürettebat ise zaten senden bunu bekliyor."
	auto_deadmin_role_flags = DEADMIN_POSITION_SILICON
	display_order = JOB_DISPLAY_ORDER_SYNTHETIC
	job_flags = JOB_NEW_PLAYER_JOINABLE | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "Centcom ve insanlar"
	spawn_type = /mob/living/carbon/human/species/synthetic
	outfit = /datum/outfit/job/synthetic
	config_tag = "SYNTHETIC"
	allow_bureaucratic_error = TRUE
	random_spawns_possible = FALSE
	rpg_title = "slave"
	departments_list = list(
		/datum/job_department/silicon,
		)

/datum/job/synthetic/announce_job(mob/living/joining_mob)
	. = ..()
	if(SSticker.HasRoundStarted())
		minor_announce("Synthetic [joining_mob] has been sent to station for assistance.")

/datum/job/synthetic/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	spawned.apply_pref_name(/datum/preference/name/synthetic, player_client)
	spawned.AddComponent(/datum/component/simple_access, SSid_access.get_region_access_list(list(REGION_ALL_GLOBAL)), src)
	var/datum/antagonist/synthetic/antagstats = new
	spawned.mind.add_antag_datum(antagstats)

/datum/outfit/job/synthetic
	name = JOB_SYNTHETIC
	jobtype = /datum/job/synthetic
	skip_backpack = TRUE

	uniform = /obj/item/clothing/under/rank/security/detective/noir
	suit = /obj/item/clothing/suit/jacket/synthetic
	neck = /obj/item/clothing/neck/tie/black/tied
	back = /obj/item/storage/backpack/holding
	gloves = /obj/item/clothing/gloves/chief_engineer
	belt = /obj/item/storage/belt/utility/full/powertools/rcd
	ears = /obj/item/radio/headset/heads/captain/alt
	l_pocket = /obj/item/healthanalyzer/advanced

	head = null
	id = null

	backpack_contents = list(
		/obj/item/defibrillator/compact/loaded = 1,
		/obj/item/roller = 1,
		/obj/item/storage/medkit/toxin = 1,
		/obj/item/storage/medkit/o2 = 1,
		/obj/item/storage/part_replacer/bluespace/tier2 = 1,
		/obj/item/stack/sheet/iron/fifty = 1,
		/obj/item/stack/sheet/glass/fifty = 1,
		/obj/item/analyzer/ranged = 1,
		)

	implants = list(/obj/item/implant/mindshield)

/datum/job/pet
	title = JOB_PET
	description = "Evcil hayvan olarak hiç bir sorumluluğunun olmamasinin keyfini yaşa."
	faction = FACTION_STATION
	total_positions = 5
	spawn_positions = 5
	supervisors = "your canine desires."
	display_order = JOB_DISPLAY_ORDER_PSYCHOLOGIST
	living_thing_type = "Pet"
	departments_list = list(
		/datum/job_department/service,
		)
	random_spawns_possible = FALSE
	job_flags = JOB_NEW_PLAYER_JOINABLE
	rpg_title = "Evcil Hayvan"
	config_tag = "PET"

/datum/job/pet/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	spawned.apply_pref_name(/datum/preference/name/pet, player_client)

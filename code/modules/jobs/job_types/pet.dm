/datum/job/pet
	title = JOB_PET
	description = "Köpek olarak hiç bir sorumluluğunun olmamasinin keyfini yaşa."
	faction = FACTION_STATION
	total_positions = 5
	spawn_positions = 5
	supervisors = "your canine desires."
	spawn_type = /mob/living/basic/pet/dog/pug
	display_order = JOB_DISPLAY_ORDER_PSYCHOLOGIST

	departments_list = list(
		/datum/job_department/service,
		)
	random_spawns_possible = FALSE
	job_flags = JOB_NEW_PLAYER_JOINABLE
	rpg_title = "Evcil Hayvan"
	config_tag = "PET"

/datum/job/pet/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	var/pettype = player_client.prefs.read_preference(/datum/preference/choiced/pettype)
	if(pettype == "Pug") {
		spawn_type = /mob/living/basic/pet/dog/pug
	} else if(pettype == "Cat")
	{
		spawn_type = /mob/living/simple_animal/pet/cat
	}
	spawned.apply_pref_name(/datum/preference/name/pet, player_client)

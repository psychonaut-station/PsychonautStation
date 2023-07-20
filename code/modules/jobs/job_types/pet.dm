/datum/job/pet
	title = JOB_PET
	description = "Evcil hayvan olarak hiç bir sorumluluğunun olmamasinin keyfini yaşa."
	faction = FACTION_STATION
	total_positions = 5
	spawn_positions = 5
	supervisors = "your canine desires."
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
	spawned.apply_pref_name(/datum/preference/name/pet, player_client)

/datum/job/pet/get_spawn_mob(client/player_client, atom/spawn_point)
	var/pettype = player_client.prefs.read_preference(/datum/preference/choiced/pettype)
	switch(pettype)
		if(PUG)
			spawn_type = /mob/living/basic/pet/dog/pug
		if(BULLTERRIER)
			spawn_type = /mob/living/basic/pet/dog/bullterrier
		if(CAT)
			spawn_type = /mob/living/simple_animal/pet/cat
		if(BLACK_CAT)
			spawn_type = /mob/living/simple_animal/pet/cat/runtime
	return ..()

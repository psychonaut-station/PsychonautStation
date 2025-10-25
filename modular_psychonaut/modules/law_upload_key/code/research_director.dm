/datum/job/research_director/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	spawned.add_mob_memory(/datum/memory/key/silicon_decrypt_key, upload_key = GLOB.upload_key)

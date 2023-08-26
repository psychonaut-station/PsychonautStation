/datum/job/animal
	title = JOB_ANIMAL
	description = "Hayvan olarak özgürce takıl. Tercihlerden hangi hayvan olmak istediğini seçmeyi unutma!"
	faction = FACTION_STATION
	total_positions = -1
	spawn_positions = -1
	supervisors = "your zoic desires."
	exp_granted_type = EXP_TYPE_CREW

	spawn_type = /mob/living/basic/pet/fox

	display_order = JOB_DISPLAY_ORDER_CAPTAIN

	department_for_prefs = /datum/job_department/assistant

	job_flags = JOB_NEW_PLAYER_JOINABLE
	config_tag = "ANIMAL"

/datum/job/animal/proc/apply_prefs_job_animal(mob/living/spawned, client/player_client)
	spawned.job = title
	if(GLOB.current_anonymous_theme || CONFIG_GET(flag/force_random_names))
		spawned.fully_replace_character_name(null, pick(GLOB.pug_names))
		return
	spawned.apply_pref_name(/datum/preference/name/animal, player_client)

/datum/job/animal/proc/remove_ai(mob/living/spawned)
	var/static/list/restricted_components = list(/datum/component/tameable, /datum/component/obeys_commands)
	if(istype(spawned, /mob/living/simple_animal))
		var/mob/living/simple_animal/simple_animal = spawned
		simple_animal.toggle_ai(AI_OFF)
		simple_animal.can_have_ai = FALSE
	for(var/component_type in restricted_components)
		for(var/datum/component/component in spawned.GetComponents(component_type))
			qdel(component)
	if(spawned.ai_controller)
		qdel(spawned.ai_controller)

/datum/job/animal/proc/set_max_health(mob/living/spawned)
	if(spawned.maxHealth < 100)
		spawned.setMaxHealth(100)
		spawned.updatehealth()

/datum/job/animal/proc/register_signals(mob/living/spawn_instance)
	RegisterSignal(spawn_instance, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/job/animal/get_spawn_mob(client/player_client, atom/spawn_point)
	var/animal_name = player_client?.prefs?.read_preference(/datum/preference/choiced/animal_type)
	var/mob/living/spawn_type_ = GLOB.animal_job_types[animal_name] || spawn_type
	var/mob/living/spawn_instance = new spawn_type_(player_client.mob.loc)
	spawn_point.JoinPlayerHere(spawn_instance, TRUE)
	apply_prefs_job_animal(spawn_instance, player_client)
	remove_ai(spawn_instance)
	set_max_health(spawn_instance)
	register_signals(spawn_instance)
	if(!player_client)
		qdel(spawn_instance)
		return
	return spawn_instance

/datum/job/animal/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	var/mob/living/mob = source
	if(!mob.key)
		examine_list += span_deadsay("It totally catatonic. The stresses of life in deep-space must have been too much for it. Any recovery is unlikely.")
	else if(!mob.client)
		examine_list += "It has a blank, absent-minded stare and appears completely unresponsive to anything. It may snap out of it soon."

/datum/job/animal/announce_job(mob/living/joining_mob)
	. = ..()
	if(SSticker.HasRoundStarted())
		var/animal_type_name = joining_mob.client?.prefs?.read_preference(/datum/preference/choiced/animal_type)
		announce_arrival(joining_mob, animal_type_name)

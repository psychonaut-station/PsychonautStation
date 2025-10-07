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

	alt_titles = list(
		"Animal",
		"Spirit Animal",
		"Emotional Support Animal"
	)

/datum/job/animal/proc/apply_prefs_job_animal(mob/living/spawned, client/player_client)
	spawned.job = title
	if(GLOB.current_anonymous_theme || CONFIG_GET(flag/force_random_names))
		spawned.fully_replace_character_name(null, pick(GLOB.pug_names))
		return
	spawned.apply_pref_name(/datum/preference/name/animal, player_client)

/datum/job/animal/proc/override_mob(mob/living/spawned)
	var/static/list/banned_components = list(/datum/component/tameable, /datum/component/obeys_commands)
	var/static/list/banned_elements = list(/datum/element/venomous)
	var/static/list/banned_traits = list(TRAIT_VENTCRAWLER_ALWAYS, TRAIT_SPACEWALK)

	if(istype(spawned, /mob/living/simple_animal))
		var/mob/living/simple_animal/simple_animal = spawned
		simple_animal.toggle_ai(AI_OFF)
		simple_animal.can_have_ai = FALSE

	for(var/datum/component/component_type as anything in banned_components)
		for(var/datum/component/component in spawned.GetComponents(component_type))
			qdel(component)

	for(var/datum/element/element as anything in banned_elements)
		spawned.RemoveElement(element)

	spawned.remove_traits(banned_traits)
	spawned.remove_traits(banned_traits, ROUNDSTART_TRAIT)

	if(spawned.ai_controller)
		qdel(spawned.ai_controller)

	spawned.setMaxHealth(100)
	spawned.updatehealth()

	if(spawned.melee_damage_lower > 5)
		spawned.melee_damage_lower = 5

	if(spawned.melee_damage_upper > 5)
		spawned.melee_damage_upper = 5

	if(istype(spawned, /mob/living/basic))
		var/mob/living/basic/spawned_basic = spawned

		if(!(spawned_basic.unsuitable_atmos_damage > 0))
			spawned_basic.unsuitable_atmos_damage = 1
			spawned_basic.AddElement( \
				/datum/element/atmos_requirements, \
				string_assoc_list(spawned_basic.habitable_atmos), \
				spawned_basic.unsuitable_atmos_damage \
			)

		spawned_basic.obj_damage = -1
		spawned_basic.environment_smash = NONE
		spawned_basic.sharpness = NONE
		spawned_basic.wound_bonus = CANT_WOUND
		spawned_basic.exposed_wound_bonus = 0

	if(istype(spawned, /mob/living/simple_animal))
		var/mob/living/simple_animal/spawned_simple = spawned

		if(!(spawned_simple.unsuitable_atmos_damage > 0))
			spawned_simple.unsuitable_atmos_damage = 1
			spawned_simple.AddElement( \
				/datum/element/atmos_requirements, \
				string_assoc_list(spawned_simple.atmos_requirements), \
				spawned_simple.unsuitable_atmos_damage \
			)

		spawned_simple.obj_damage = -1
		spawned_simple.environment_smash = NONE
		spawned_simple.sharpness = NONE
		spawned_simple.wound_bonus = CANT_WOUND
		spawned_simple.exposed_wound_bonus = 0

	var/datum/language_holder/language_holder = spawned.get_language_holder()

	switch(spawned.type)
		if(/mob/living/basic/parrot)
			if(prob(1))
				spawned.desc = "Doomed to squawk the Earth."
				spawned.color = "#FFFFFF77"
				spawned.fully_replace_character_name(spawned.real_name, "The Ghost of [spawned.real_name]")
		if(/mob/living/basic/mothroach)
			language_holder.grant_language(/datum/language/moffic, source = LANGUAGE_ATOM)

	language_holder.remove_blocked_language(/datum/language/common, source = LANGUAGE_ATOM)
	language_holder.grant_language(/datum/language/common, source = LANGUAGE_ATOM)
	language_holder.selected_language = /datum/language/common

/datum/job/animal/proc/register_signals(mob/living/spawn_instance)
	RegisterSignal(spawn_instance, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/job/animal/get_spawn_mob(client/player_client, atom/spawn_point)
	var/animal_type = player_client?.prefs?.read_preference(/datum/preference/choiced/animal_type)
	var/mob/living/spawn_type_ = GLOB.animal_job_types[animal_type] || spawn_type
	var/mob/living/spawn_instance = new spawn_type_(player_client.mob.loc)

	spawn_point.JoinPlayerHere(spawn_instance, TRUE)
	apply_prefs_job_animal(spawn_instance, player_client)
	override_mob(spawn_instance)
	register_signals(spawn_instance)

	if(!player_client)
		qdel(spawn_instance)
		return

	return spawn_instance

/datum/job/animal/proc/on_examine(mob/living/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(!source.key)
		examine_list += span_deadsay("It is totally catatonic. The stresses of life in deep-space must have been too much for it. Any recovery is unlikely.")
	else if(!source.client)
		examine_list += "It has a blank, absent-minded stare and appears completely unresponsive to anything. It may snap out of it soon."

/mob/living/get_exp_list(minutes)
	. = ..()
	if(mind?.assigned_role?.title == JOB_ANIMAL)
		.[JOB_ANIMAL] = minutes

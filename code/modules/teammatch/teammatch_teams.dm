/datum/teammatch_team
	/// ID of the team
	var/id

	/// Name of the team
	var/name

	/// Color of the team, used in tgui
	var/color

	/// Assoc list of loadouts of team. (loadout = amount, -1 = infinity)
	var/list/loadouts = list()

	/// Default loadout of the team
	var/datum/outfit/teammatch_loadout/default_loadout

	/// Is this team is important on the teammatch. Game ends when only 1 important team is left standing, ignoring others.
	var/important_team = TRUE

	/// Minimum players for this team
	var/min_players = 0
	/// Maximum players for this team, -1 is infinity
	var/max_players = -1

	var/is_prototype = FALSE

	var/respawn_time = 1 MINUTES

	var/team_radio_freq = null

	/// Can we add players to this team
	var/active = TRUE

	var/list/players = list()

	COOLDOWN_DECLARE(respawn_cooldown)

/datum/teammatch_team/New(is_prototype)
	. = ..()
	src.is_prototype = is_prototype

/datum/teammatch_team/Destroy(force)
	. = ..()
	players = null

/datum/teammatch_team/proc/add_player(ckey)
	if(is_prototype || !active)
		return FALSE
	players |= ckey
	return TRUE

/datum/teammatch_team/proc/remove_player(ckey)
	if(is_prototype)
		return FALSE
	players -= ckey
	return TRUE

/datum/teammatch_team/proc/can_respawn()
	if(is_prototype)
		return FALSE
	if(!active)
		return FALSE
	if(respawn_time == -1)
		return TRUE
	return COOLDOWN_FINISHED(src, respawn_cooldown)

/datum/teammatch_team/proc/start_respawn_timer()
	if(is_prototype)
		return FALSE
	if(respawn_time == -1)
		return TRUE
	COOLDOWN_START(src, respawn_cooldown, respawn_time)
	return TRUE

/datum/teammatch_team/proc/pre_mind_init(datum/teammatch_lobby/lobby, datum/teammatch_scenerio/scenerio, mob/living/L, datum/outfit/teammatch_loadout/loadout)
	return

/datum/teammatch_team/proc/after_spawn(datum/teammatch_lobby/lobby, datum/teammatch_scenerio/scenerio, mob/living/L, datum/outfit/teammatch_loadout/loadout)
	return

/datum/teammatch_team/marines
	id = "marines"
	name = "Marines"
	color = "blue"
	loadouts = list(
		/datum/outfit/teammatch_loadout/marine = -1,
		/datum/outfit/teammatch_loadout/marine/fc = 1,
		/datum/outfit/teammatch_loadout/marine/engineer = 7,
		/datum/outfit/teammatch_loadout/marine/medic = 7,
	)

	default_loadout = /datum/outfit/teammatch_loadout/marine
	min_players = 1

/datum/teammatch_team/marines/after_spawn(datum/teammatch_lobby/lobby, datum/teammatch_scenerio/scenerio, mob/living/L, datum/outfit/teammatch_loadout/loadout)
	L.set_faction(list(FACTION_MARINE))
	L?.mind?.teach_crafting_recipe(/datum/crafting_recipe/foldable_barricade)

/datum/teammatch_team/xenomorphs
	id = "xenomorphs"
	name = "Xenomorphs"
	color = "purple"
	loadouts = list(/datum/outfit/teammatch_loadout/xenomorph = -1)
	default_loadout = /datum/outfit/teammatch_loadout/xenomorph
	min_players = 1
	respawn_time = 30 SECONDS

/datum/teammatch_team/xenomorphs/pre_mind_init(datum/teammatch_lobby/lobby, datum/teammatch_scenerio/scenerio, mob/living/carbon/alien/alien, datum/outfit/teammatch_loadout/loadout)
	if(istype(alien))
		alien.non_antagonist = TRUE

/datum/teammatch_team/xenomorphs/after_spawn(datum/teammatch_lobby/lobby, datum/teammatch_scenerio/scenerio, mob/living/L, datum/outfit/teammatch_loadout/loadout)
	var/mob/living/carbon/alien/A = L
	if(!istype(A))
		return
	A.multiply_alien_health(1.5)

/datum/ai_project
	/// Name of the project. Keep this unique until the system is refactored to use IDs.
	var/name = "DEBUG"
	var/description = "DEBUG"
	var/research_progress = 0
	var/category = AI_PROJECT_MISC
	/// Research cost in effective THz-seconds.
	var/research_cost = 0
	var/ram_required = 0
	var/running = FALSE
	var/research_requirements_text = "None"
	/// List of required completed project type paths.
	var/list/research_requirements
	/// Whether this project can be run after completion.
	var/can_be_run = TRUE
	/// Optional action granted when the project finishes.
	var/ability_path
	/// Cost to recharge the granted action by 1 use.
	var/ability_recharge_cost = 0
	/// Current recharge progress for the granted action.
	var/ability_recharge_invested = 0

	var/mob/living/silicon/ai/ai
	var/datum/ai_dashboard/dashboard

/datum/ai_project/New(mob/living/silicon/ai/new_owner, datum/ai_dashboard/new_dash)
	ai = new_owner
	dashboard = new_dash
	if(!ai || !dashboard)
		qdel(src)
		return
	..()

/datum/ai_project/proc/canResearch()
	if(!research_requirements)
		return TRUE
	for(var/required_project in research_requirements)
		if(!dashboard.has_completed_project(required_project))
			return FALSE
	return TRUE

/datum/ai_project/proc/run_project(force_run = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if(!can_be_run)
		return FALSE
	if(!force_run && !canRun())
		return FALSE
	running = TRUE
	dashboard.running_projects += src
	return TRUE

/datum/ai_project/proc/switch_network(datum/ai_network/old_net, datum/ai_network/new_net)
	return TRUE

/datum/ai_project/proc/stop()
	SHOULD_CALL_PARENT(TRUE)
	running = FALSE
	dashboard.running_projects -= src
	return TRUE

/datum/ai_project/proc/canRun()
	SHOULD_CALL_PARENT(TRUE)
	return !running

/datum/ai_project/proc/finish()
	return

/datum/ai_project/proc/add_ability(ability_type)
	if(!ability_type || !ai)
		return

	var/datum/action/innate/ai/existing = locate(ability_type) in ai.actions
	if(existing)
		return existing

	var/datum/action/innate/ai/new_ability = new ability_type()
	new_ability.Grant(ai)
	return new_ability

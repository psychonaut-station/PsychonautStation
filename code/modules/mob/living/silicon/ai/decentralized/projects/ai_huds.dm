/proc/refresh_ai_sensor_huds(mob/living/silicon/ai/ai, datum/ai_dashboard/dashboard)
	if(!ai || !dashboard)
		return

	var/datum/ai_project/security_hud/security_project = dashboard.get_project_by_name("Advanced Security HUD")
	var/datum/ai_project/diag_med_hud/diag_med_project = dashboard.get_project_by_name("Advanced Medical & Diagnostic HUD")
	var/list/new_huds = list(
		diag_med_project?.running ? TRAIT_MEDICAL_HUD : TRAIT_MEDICAL_HUD_SENSOR_ONLY,
		security_project?.running ? TRAIT_SECURITY_HUD : TRAIT_SECURITY_HUD_ID_ONLY,
		TRAIT_DIAGNOSTIC_HUD,
		TRAIT_BOT_PATH_HUD,
	)
	var/should_restore = ai.sensors_on

	ai.remove_sensors()
	ai.silicon_huds = new_huds
	if(should_restore)
		ai.add_sensors()

/datum/ai_project/security_hud
	name = "Advanced Security HUD"
	description = "Long-range passive sensor tuning upgrades your security readout with full implant and status data while active."
	research_cost = 1250
	ram_required = 2
	research_requirements_text = "None"
	category = AI_PROJECT_HUDS

/datum/ai_project/security_hud/run_project(force_run = FALSE)
	. = ..(force_run)
	if(!.)
		return .
	refresh_ai_sensor_huds(ai, dashboard)

/datum/ai_project/security_hud/stop()
	refresh_ai_sensor_huds(ai, dashboard)
	return ..()

/datum/ai_project/diag_med_hud
	name = "Advanced Medical & Diagnostic HUD"
	description = "Medical pipeline optimizations provide detailed medical readouts while preserving the standard diagnostic overlay."
	research_cost = 1000
	ram_required = 1
	research_requirements_text = "None"
	category = AI_PROJECT_HUDS

/datum/ai_project/diag_med_hud/run_project(force_run = FALSE)
	. = ..(force_run)
	if(!.)
		return .
	refresh_ai_sensor_huds(ai, dashboard)

/datum/ai_project/diag_med_hud/stop()
	refresh_ai_sensor_huds(ai, dashboard)
	return ..()

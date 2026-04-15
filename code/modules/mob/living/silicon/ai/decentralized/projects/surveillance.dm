/datum/ai_project/camera_tracker
	name = "Camera Memory Tracker"
	description = "Uses memory tagging to alert you when a named individual re-enters camera visibility."
	research_cost = 2500
	ram_required = 3
	research_requirements_text = "Examination Upgrade"
	research_requirements = list(/datum/ai_project/examine_humans)
	category = AI_PROJECT_SURVEILLANCE

/datum/ai_project/camera_tracker/run_project(force_run = FALSE)
	. = ..(force_run)
	if(!.)
		return .
	ai.canCameraMemoryTrack = TRUE
	if(!(/mob/living/silicon/ai/proc/choose_camera_target in ai.verbs))
		add_verb(ai, /mob/living/silicon/ai/proc/choose_camera_target)

/datum/ai_project/camera_tracker/stop()
	ai.canCameraMemoryTrack = FALSE
	ai.cameraMemoryTarget = null
	remove_verb(ai, /mob/living/silicon/ai/proc/choose_camera_target)
	return ..()

/mob/living/silicon/ai/proc/choose_camera_target()
	set name = "Choose Camera Memory Target"
	set category = "AI Commands"
	set desc = "Select a target name to be notified about when they become camera-visible."

	var/target_name = stripped_input(src, "Enter the target name. Leave blank to cancel tracking.", "Camera Memory Tracker", "", MAX_NAME_LEN)
	if(isnull(target_name))
		return
	if(!length(target_name))
		cameraMemoryTarget = null
		to_chat(src, span_notice("Camera memory tracker cleared."))
		return

	if(cameraMemoryTarget)
		to_chat(src, span_warning("Old target discarded. Exclusively tracking [target_name]."))
	else
		to_chat(src, span_notice("Now tracking [target_name]."))

	cameraMemoryTarget = target_name
	cameraMemoryTickCount = 0

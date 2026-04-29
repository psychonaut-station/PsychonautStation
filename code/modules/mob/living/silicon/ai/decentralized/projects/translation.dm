#define HEARD_MESSAGES_TO_UNDERSTAND 8
#define HEARD_MESSAGES_TO_SPEAK 16

/datum/ai_project/translation
	name = "Heuristic Language Translation"
	description = "While running, analyzes unknown languages you hear. After 8 messages you can understand the language, and after 16 you can speak it. Requires 10% free CPU."
	research_cost = 1500
	ram_required = 2
	research_requirements_text = "None"
	category = AI_PROJECT_MISC

	var/list/heard_languages = list()

/datum/ai_project/translation/run_project(force_run = FALSE)
	. = ..(force_run)
	if(!.)
		return .
	RegisterSignal(ai, COMSIG_MOVABLE_HEAR, PROC_REF(heard_message))
	dashboard.cpu_usage[name] = 0.1

/datum/ai_project/translation/proc/heard_message(datum/source, list/hearing_args)
	SIGNAL_HANDLER
	var/datum/language/heard_language = hearing_args[HEARING_LANGUAGE]
	if(ai.has_language(heard_language, SPOKEN_LANGUAGE))
		return

	var/list/blacklisted_languages = list(
		/datum/language/narsie,
		/datum/language/codespeak,
		/datum/language/xenocommon,
	)
	if(is_type_in_list(heard_language, blacklisted_languages))
		return

	var/heard_count = (heard_languages[heard_language] || 0) + 1
	heard_languages[heard_language] = heard_count

	if(heard_count >= HEARD_MESSAGES_TO_UNDERSTAND && !ai.has_language(heard_language, UNDERSTOOD_LANGUAGE))
		ai.grant_language(heard_language, UNDERSTOOD_LANGUAGE)

	if(heard_count >= HEARD_MESSAGES_TO_SPEAK && !ai.has_language(heard_language, SPOKEN_LANGUAGE))
		ai.grant_language(heard_language, UNDERSTOOD_LANGUAGE | SPOKEN_LANGUAGE)

/datum/ai_project/translation/stop()
	UnregisterSignal(ai, COMSIG_MOVABLE_HEAR)
	dashboard.cpu_usage[name] = 0
	return ..()

/datum/ai_project/translation/canRun()
	. = ..()
	if(!.)
		return FALSE

	var/total_cpu_used = 0
	for(var/project_name in dashboard.cpu_usage)
		total_cpu_used += dashboard.cpu_usage[project_name]

	if(total_cpu_used < 0.9)
		return TRUE

	to_chat(ai, span_warning("Unable to run this program. You require 10% free CPU."))
	return FALSE

#undef HEARD_MESSAGES_TO_UNDERSTAND
#undef HEARD_MESSAGES_TO_SPEAK

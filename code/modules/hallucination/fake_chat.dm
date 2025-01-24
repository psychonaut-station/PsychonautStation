/// Sends a fake chat message to the hallucinator.
/datum/hallucination/chat
	random_hallucination_weight = 100

	/// If TRUE, we force the message to be hallucinated from common radio. Only set in New()
	var/force_radio
	/// If set, a message we force to be picked, rather than an auto-generated message. Only set in New()
	var/specific_message

/datum/hallucination/chat/New(mob/living/hallucinator, force_radio = FALSE, specific_message)
	src.force_radio = force_radio
	src.specific_message = specific_message
	return ..()

/datum/hallucination/chat/start()
	var/mob/living/carbon/human/speaker
	var/datum/language/understood_language = hallucinator.get_random_understood_language()
	for(var/mob/living/carbon/nearby_human in view(hallucinator))
		if(nearby_human == hallucinator)
			continue

		if(!speaker)
			speaker = nearby_human
		else if(get_dist(hallucinator, nearby_human) < get_dist(hallucinator, speaker))
			speaker = nearby_human

	// Get person to affect if radio hallucination
	var/is_radio = !speaker || force_radio
	var/radio_channel = FREQ_COMMON
	var/list/target_dept = null
	
	// Contents of our message
	var/chosen = specific_message

	if(is_radio)
		if (prob(50))
			if (SSjob.is_occupation_of(hallucinator.job, DEPARTMENT_BITFLAG_ENGINEERING))
				radio_channel = FREQ_ENGINEERING
				target_dept = SSjob.get_department_crew(DEPARTMENT_BITFLAG_ENGINEERING)
				chosen = pick_list_replacements(HALLUCINATION_FILE, "eng_radio")
			if (SSjob.is_occupation_of(hallucinator.job, DEPARTMENT_BITFLAG_SECURITY))
				radio_channel = FREQ_SECURITY
				target_dept = SSjob.get_department_crew(DEPARTMENT_BITFLAG_SECURITY)
				chosen = pick_list_replacements(HALLUCINATION_FILE, "sec_radio")
			if (SSjob.is_occupation_of(hallucinator.job, DEPARTMENT_BITFLAG_SCIENCE))
				radio_channel = FREQ_SCIENCE
				target_dept = SSjob.get_department_crew(DEPARTMENT_BITFLAG_SCIENCE)
				chosen = pick_list_replacements(HALLUCINATION_FILE, "sci_radio")

		if (target_dept)
			/// Pick from our department radio
			target_dept -= hallucinator.mind
			var/datum/mind/chosen_mind = pick(target_dept)
			speaker = chosen_mind.current
		else
			/// Pick from common radio
			var/list/humans = list()
			for(var/datum/mind/crew_mind in get_crewmember_minds())
				if(crew_mind.current && crew_mind.current != hallucinator)
					humans += crew_mind.current
			if(humans.len)
				speaker = pick(humans)

	if(!speaker)
		return

	// Time to generate a message.
	// Spans of our message
	var/spans = list(speaker.speech_span)

	// If we didn't have a preset one, let's make one up.
	if(!chosen)
		if(is_radio)
<<<<<<< HEAD
			chosen = pick(list("Yardım!",
				"[pick_list_replacements(HALLUCINATION_FILE, "people")] [pick_list_replacements(HALLUCINATION_FILE, "accusations")]!",
				"[pick_list_replacements(HALLUCINATION_FILE, "location")] [pick_list_replacements(HALLUCINATION_FILE, "threat")] var[prob(50)?"!":"!!"]",
				"[pick("[hallucinator.first_name()]'i gördün mü?", "[hallucinator.first_name()] isimli kişiyi arrestleyin")]",
				"AI[pick(" MALF", "'İ ÖLDÜRMÜŞLER")]!!",
				"BORGLAR MALF",
=======
			chosen = pick(list("Help!",
				"[pick_list_replacements(HALLUCINATION_FILE, "people")] is [pick_list_replacements(HALLUCINATION_FILE, "accusations")]!",
				"[pick_list_replacements(HALLUCINATION_FILE, "threat")] in [pick_list_replacements(HALLUCINATION_FILE, "location")][prob(50)?"!":"!!"]",
				"[pick("Where's [first_name(hallucinator.name)]?", "Set [first_name(hallucinator.name)] to arrest!")]",
				"[pick("C","Ai, c","Someone c","Rec")]all the shuttle!",
				"AI [pick("rogue", "is dead")]!!",
				"Borgs rogue!",
>>>>>>> bf0bbaed64b62a9e32895319620768e517759d89
			))
		else
			chosen = pick(list("[pick_list_replacements(HALLUCINATION_FILE, "suspicion")]",
				"[pick_list_replacements(HALLUCINATION_FILE, "conversation")]",
				"[pick_list_replacements(HALLUCINATION_FILE, "greetings")][first_name(hallucinator.name)]!",
				"[pick_list_replacements(HALLUCINATION_FILE, "getout")]",
				"[pick_list_replacements(HALLUCINATION_FILE, "weird")]",
				"[pick_list_replacements(HALLUCINATION_FILE, "didyouhearthat")]",
				"[pick_list_replacements(HALLUCINATION_FILE, "doubt")]",
				"[pick_list_replacements(HALLUCINATION_FILE, "aggressive")]",
				"[pick_list_replacements(HALLUCINATION_FILE, "help")]!!",
				"[pick_list_replacements(HALLUCINATION_FILE, "escape")]",
				"Hasta oldum, [pick_list_replacements(HALLUCINATION_FILE, "infection_advice")]!",
			))

		chosen = capitalize(chosen)

<<<<<<< HEAD
	chosen = replacetext(chosen, "%TARGETNAME%", hallucinator.first_name())
	chosen = replacetext(chosen, "%TARGETNAME_CAP%", uppertext(hallucinator.first_name()))
=======
	chosen = replacetext(chosen, "%TARGETNAME%", first_name(hallucinator.name))
>>>>>>> bf0bbaed64b62a9e32895319620768e517759d89

	// Log the message
	feedback_details += "Type: [is_radio ? "Radio" : "Talk"], Source: [speaker.real_name], Message: [chosen]"

	var/plus_runechat = hallucinator.client?.prefs.read_preference(/datum/preference/toggle/enable_runechat)

	// Display the message
	if(!is_radio && !plus_runechat)
		var/image/speech_overlay = image('icons/mob/effects/talk.dmi', speaker, "default0", layer = ABOVE_MOB_LAYER)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flick_overlay_global), speech_overlay, list(hallucinator.client), 30)

	if(plus_runechat)
		hallucinator.create_chat_message(speaker, understood_language, chosen, spans)

	// And actually show them the message, for real.
	var/message = hallucinator.compose_message(speaker, understood_language, chosen, is_radio ? "[radio_channel]" : null, spans, visible_name = TRUE)
	to_chat(hallucinator, message)
	hallucinator.log_message("Fake chatter [speaker]: '[chosen]'", LOG_HALLUCINATION)

	// Then clean up.
	qdel(src)
	return TRUE

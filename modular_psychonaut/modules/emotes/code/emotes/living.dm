
/datum/emote/living/fart
	key = "fart"
	key_third_person = "farts"
	message = "farts."
	message_mime = "farts silently!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	specific_emote_audio_cooldown = 25 SECONDS
	vary = TRUE

/datum/emote/living/fart/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	return ..() && user.can_speak(allow_mimes = TRUE)

/datum/emote/living/fart/get_sound(mob/living/user)
	if(ishuman(user))
		user.add_mood_event("farted", /datum/mood_event/farted)
		return pick('modular_psychonaut/master_files/sound/misc/fart1.ogg', 'modular_psychonaut/master_files/sound/misc/fart2.ogg', 'modular_psychonaut/master_files/sound/misc/fart3.ogg',
					'modular_psychonaut/master_files/sound/misc/fart4.ogg', 'modular_psychonaut/master_files/sound/misc/fart5.ogg', 'modular_psychonaut/master_files/sound/misc/fart6.ogg')

/datum/emote/living/pose
	key = "pose"
	key_third_person = "poses"
	message = "poses."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/pose/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	var/image/emote_animation = image('modular_psychonaut/master_files/icons/mob/human/emote_visuals.dmi', user, "jojoeffect")
	flick_overlay_global(emote_animation, GLOB.clients, 5 SECONDS)
	var/list/guardians = user.get_all_linked_holoparasites()
	for(var/mob/living/basic/guardian/guardian as anything in guardians)
		guardian.emote(key, intentional = FALSE)

/datum/emote/living/pose/can_run_emote(mob/living/user, status_check = TRUE, intentional, params)
	. = ..()
	if(!.)
		return FALSE
	if(istype(user, /mob/living/basic/guardian) ||length(user.get_all_linked_holoparasites()))
		return TRUE
	return FALSE

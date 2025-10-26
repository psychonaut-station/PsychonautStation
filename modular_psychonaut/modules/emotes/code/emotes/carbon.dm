/datum/emote/living/carbon/thumbsup
	key = "thumbsup"
	key_third_person = "thumbsup"
	message = "flashes a thumbs up."
	hands_use_check = TRUE

/datum/emote/living/carbon/thumbsdown
	key = "thumbsdown"
	key_third_person = "thumbsdown"
	message = "flashes a thumbs down."
	hands_use_check = TRUE

/datum/emote/living/carbon/sweatdrop
	key = "sweatdrop"
	key_third_person = "sweatdrops"
	message = "sweats."
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	vary = TRUE
	sound = 'modular_psychonaut/master_files/sound/effects/sweatdrop.ogg'

/datum/emote/living/carbon/sweatdrop/run_emote(mob/living/carbon/user, params, type_override, intentional)
	. = ..()
	var/image/emote_animation = image('modular_psychonaut/master_files/icons/mob/human/emote_visuals.dmi', user, "sweatdrop", pixel_x = 10, pixel_y = 10)
	flick_overlay_global(emote_animation, GLOB.clients, 5 SECONDS)

/datum/emote/living/carbon/sweatdrop/sweat //This is entirely the same as sweatdrop, however people might use either, so I'm adding this one instead of editing the other one.
	key = "sweat"

/datum/emote/living/carbon/annoyed
	key = "annoyed"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/carbon/annoyed/run_emote(mob/living/carbon/user, params, type_override, intentional)
	. = ..()
	var/image/emote_animation = image('modular_psychonaut/master_files/icons/mob/human/emote_visuals.dmi', user, "annoyed", pixel_x = 10, pixel_y = 10)
	flick_overlay_global(emote_animation, GLOB.clients, 5 SECONDS)
	// as this emote has no message, it won't play a sound due to the parent proc, so we play it manually here
	playsound(user,'modular_psychonaut/master_files/sound/effects/annoyed.ogg',50,TRUE)

/datum/emote/living/laugh/get_sound(mob/living/user)
	if(HAS_TRAIT(user, TRAIT_CLOWNING))
		return 'modular_psychonaut/modules/clown_emotes/sound/clown_laugh1.ogg'

	return ..()

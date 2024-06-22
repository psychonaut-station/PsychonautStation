/datum/emote/living/carbon/cry/get_sound(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, TRAIT_CLOWNING))
		return 'modular_psychonaut/modules/clown_emotes/sound/clown_cry1.ogg'

	return ..()

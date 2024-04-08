/datum/emote/living/laugh/get_sound(mob/living/user)
	if(HAS_TRAIT(user, TRAIT_CLOWNING))
		return pick('modular_psychonaut/modules/hihiha/sound/hihiha.ogg', 'modular_psychonaut/modules/hihiha/sound/hihiha_2.ogg')

	return ..()

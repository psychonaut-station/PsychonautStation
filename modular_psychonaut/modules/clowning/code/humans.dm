/datum/species/human/get_cry_sound(mob/living/carbon/human/human)
	if(HAS_TRAIT(human, TRAIT_CLOWNING))
		return 'modular_psychonaut/master_files/sound/voice/human/clown_cry1.ogg'
	return ..()

/datum/species/human/get_laugh_sound(mob/living/carbon/human/human)
	if(HAS_TRAIT(human, TRAIT_CLOWNING))
		return 'modular_psychonaut/master_files/sound/voice/human/clown_laugh1.ogg'
	return ..()

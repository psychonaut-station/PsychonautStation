/mob/living/carbon/human/prepare_data_huds()
	..()
	//...battery hud...
	if(isipc(src))
		diag_hud_set_humancell()
/**
 * Called when this human should be washed
 */
/mob/living/carbon/human/wash(clean_types)
	. = ..()
	if(dna.species.wash(src))
		. |= COMPONENT_CLEANED

/mob/living/carbon/human/species/arachnid
	race = /datum/species/arachnid

/mob/living/carbon/human/species/ipc
	race = /datum/species/ipc

/obj/item/organ/eyes/on_mob_insert(mob/living/carbon/receiver, special, movement_flags)
	. = ..()
	if(!no_glasses)
		return

	var/mob/living/carbon/human/human_receiver = receiver
	if(!human_receiver.can_mutate())
		return
	var/datum/species/rec_species = human_receiver.dna.species
	rec_species.update_no_equip_flags(human_receiver, rec_species.no_equip_flags | ITEM_SLOT_EYES)

/obj/effect/abstract/eyelid_effect/Initialize(mapload, new_state, new_icon)
	. = ..()
	icon = new_icon

/obj/item/organ/eyes/arachnid
	name = "arachnid eyes"
	desc = "So many eyes!"
	eye_icon = 'modular_psychonaut/master_files/icons/mob/human/species/arachnid/bodyparts.dmi'
	eye_icon_state = "arachnideyes"
	organ_traits = list(TRAIT_LUMINESCENT_EYES)
	no_glasses = TRUE

/obj/item/organ/eyes/night_vision/arachnid
	name = "arachnid eyes"
	desc = "So many eyes!"
	eye_icon = 'modular_psychonaut/master_files/icons/mob/human/species/arachnid/bodyparts.dmi'
	eye_icon_state = "arachnideyes"
	organ_traits = list(TRAIT_LUMINESCENT_EYES)
	no_glasses = TRUE
	low_light_cutoff = list(20, 15, 0)
	medium_light_cutoff = list(35, 30, 0)
	high_light_cutoff = list(50, 40, 0)

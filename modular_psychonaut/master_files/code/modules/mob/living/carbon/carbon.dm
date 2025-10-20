/mob/living/carbon/get_cell()
	var/obj/item/organ/stomach/ethereal/stomach = get_organ_slot(ORGAN_SLOT_STOMACH)
	if(istype(stomach) || istype(stomach, /obj/item/organ/stomach/ipc))
		return stomach.cell
	else
		return ..()

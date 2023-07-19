/datum/strippable_item/pet_collar
	key = STRIPPABLE_ITEM_PET_COLLAR

/datum/strippable_item/pet_collar/get_item(atom/source)
	var/mob/living/living_source = source
	if(!issimplepet_or_basicpet(living_source))
		return

	if(issimplepet(living_source))
		var/mob/living/simple_animal/pet/pet_source = living_source
		return pet_source.collar
	else if(isbasicpet(living_source))
		var/mob/living/basic/pet/pet_source = living_source
		return pet_source.collar



/datum/strippable_item/pet_collar/try_equip(atom/source, obj/item/equipping, mob/user)
	. = ..()
	if (!.)
		return FALSE

	if (!istype(equipping, /obj/item/clothing/neck/petcollar))
		to_chat(user, span_warning("That's not a collar."))
		return FALSE

	return TRUE

/datum/strippable_item/pet_collar/finish_equip(atom/source, obj/item/equipping, mob/user)
	var/mob/living/living_source = source
	if(!issimplepet_or_basicpet(living_source))
		return

	if(issimplepet(living_source))
		var/mob/living/simple_animal/pet/pet_source = living_source
		pet_source.add_collar(equipping, user)
	else if(isbasicpet(living_source))
		var/mob/living/basic/pet/pet_source = living_source
		pet_source.add_collar(equipping, user)


/datum/strippable_item/pet_collar/finish_unequip(atom/source, mob/user)
	var/mob/living/living_source = source
	if(!issimplepet_or_basicpet(living_source))
		return

	if(issimplepet(living_source))
		var/mob/living/simple_animal/pet/pet_source = living_source
		var/obj/collar = pet_source.remove_collar(user.drop_location())
		user.put_in_hands(collar)

	else if(isbasicpet(living_source))
		var/mob/living/basic/pet/pet_source = living_source
		var/obj/collar = pet_source.remove_collar(user.drop_location())
		user.put_in_hands(collar)



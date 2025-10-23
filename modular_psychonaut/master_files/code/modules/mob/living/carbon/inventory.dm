///Bruteforce check for any type or subtype of an item.
/mob/living/carbon/human/proc/is_wearing_item_of_type(type2check)
	var/found
	var/list/my_items = get_equipped_items()
	if(islist(type2check))
		for(var/type_iterator in type2check)
			found = locate(type_iterator) in my_items
			if(found)
				return found
	else
		found = locate(type2check) in my_items
		return found

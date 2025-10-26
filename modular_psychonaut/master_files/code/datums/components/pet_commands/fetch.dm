/datum/pet_command/fetch/Destroy(force)
	var/mob/living/parent = weak_parent.resolve()
	parent?.RemoveElement(/datum/element/ai_held_item)
	return ..()

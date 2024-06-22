/datum/element/ai_held_item/Detach(mob/living/source)
	. = ..()

	var/obj/item/held_item = get_held_item(source)

	if(held_item)
		source.visible_message(span_danger("[source] drops [held_item]."))
		held_item.forceMove(source.drop_location())
		source.ai_controller.clear_blackboard_key(BB_SIMPLE_CARRY_ITEM)

	UnregisterSignal(source, list(COMSIG_ATOM_ATTACK_HAND, COMSIG_ATOM_EXITED, COMSIG_ATOM_EXAMINE, COMSIG_QDELETING, COMSIG_LIVING_DEATH))

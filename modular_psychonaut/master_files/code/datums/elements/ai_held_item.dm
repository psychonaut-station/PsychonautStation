/datum/element/ai_held_item/Detach(datum/source)
	. = ..()
	var/mob/living/living_target = source
	var/obj/item/carried_item = get_held_item(source)
	if(carried_item)
		living_target.visible_message(span_danger("[living_target] drops [carried_item]."))
		carried_item.forceMove(living_target.drop_location())
		living_target.ai_controller.clear_blackboard_key(BB_SIMPLE_CARRY_ITEM)

	UnregisterSignal(source, list(COMSIG_ATOM_ATTACK_HAND, COMSIG_ATOM_EXITED, COMSIG_ATOM_EXAMINE, COMSIG_QDELETING, COMSIG_LIVING_DEATH))

/datum/component/obeys_commands/Destroy(force, silent)
	QDEL_LIST_ASSOC_VAL(available_commands)
	return ..()

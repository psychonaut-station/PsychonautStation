/// Tutorial for showing how to examine things.
/datum/tutorial/examine
	grandfather_date = "2024-03-06"

/datum/tutorial/examine/perform(list/params)
	RegisterSignal(user, COMSIG_MOB_EXAMINING, PROC_REF(on_examine))
	show_instructions()

/datum/tutorial/examine/perform_completion_effects_with_delay()
	UnregisterSignal(user, COMSIG_MOB_EXAMINING)

/datum/tutorial/examine/proc/show_instructions()
	if (QDELETED(src))
		return

	show_instruction("Use Shift+Click at anything for examining it!")

/datum/tutorial/examine/proc/on_examine(mob/source, atom/target, list/examine_strings)
	SIGNAL_HANDLER

	complete()

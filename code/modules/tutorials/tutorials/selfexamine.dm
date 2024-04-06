/// Tutorial for showing how to examine things.
/datum/tutorial/examine
	grandfather_date = "2024-03-06"

/datum/tutorial/examine/perform(list/params)
	RegisterSignal(user, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	show_instructions()

/datum/tutorial/examine/perform_completion_effects_with_delay()
	UnregisterSignal(user, COMSIG_ATOM_EXAMINE)

/datum/tutorial/examine/proc/show_instructions()
	if (QDELETED(src))
		return

	show_instruction("Use Shift+Click to yourself for examining yourself!")

/datum/tutorial/examine/proc/on_examine(atom/source, mob/examiner, list/examine_texts)
	SIGNAL_HANDLER
	if(user != examiner)
		return

	complete()

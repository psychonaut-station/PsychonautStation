/obj/item/mod/module/anomaly_locked/kinesis/grab_atom(atom/movable/target)
	. = ..()
	ADD_TRAIT(grabbed_atom, TRAIT_GRABBED_BY_KINESIS, REF(src))

/obj/item/mod/module/anomaly_locked/kinesis/clear_grab(playsound = TRUE)
	if(!grabbed_atom)
		return ..()
	REMOVE_TRAIT(grabbed_atom, TRAIT_GRABBED_BY_KINESIS, REF(src))
	return ..()

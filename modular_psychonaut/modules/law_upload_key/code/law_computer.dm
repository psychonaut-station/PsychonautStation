/obj/machinery/computer/upload
	var/is_locked = TRUE

/obj/machinery/computer/upload/attackby(obj/item/O, mob/user, list/modifiers, list/attack_modifiers)
	if (istype(O, /obj/item/multitool/ai_detect))
		to_chat(user, span_notice("Multitool displays [GLOB.upload_key] on it's screen."))
		for(var/mob/hearing_mob in get_hearers_in_view(3, user))
			hearing_mob.playsound_local(get_turf(src), 'sound/machines/beep/triple_beep.ogg', ASSEMBLY_BEEP_VOLUME, TRUE)
	else
		return ..()

/obj/machinery/computer/upload/click_alt(mob/user)
	if(is_locked && stripped_input(user, "Please enter the silicon decryption key.", "Secure Upload") != GLOB.upload_key)
		to_chat(user, "<span class='caution'>Unlock failed!</span> The upload key was incorrect!")
		return CLICK_ACTION_BLOCKING

	is_locked = !is_locked
	to_chat(user, "You [is_locked ? "locked" : "unlocked"] the [src]")
	return CLICK_ACTION_SUCCESS

/obj/item/tespih
	name = "tespih"
	desc = "Burda çok dolaşma bura bizim mahalle ayıktın?"
	w_class = WEIGHT_CLASS_SMALL

	icon = 'icons/psychonaut/obj/tespih.dmi'
	icon_state = "tespih"

	inhand_icon_state = "tespih"

	lefthand_file = 'icons/psychonaut/mob/inhands/equipment/tespih_lefthand.dmi'
	righthand_file = 'icons/psychonaut/mob/inhands/equipment/tespih_righthand.dmi'
	tespih_sallama_sound = 'sound/_psychonaut/tespih.ogg'
	var/active = FALSE

/obj/item/tespih/proc/salla(mob/user, delayoverride, volume = 60)
	if(user)
		add_fingerprint(user)
	if(active)
		active = FALSE
		icon_state = (base_icon_state || initial(icon_state)) // fix
		return
	else
		active = TRUE
		icon_state = (base_icon_state || initial(icon_state)) + "_active" // fix
		playsound(src, tespih_sallama_sound, volume, grenade_sound_vary) // fix

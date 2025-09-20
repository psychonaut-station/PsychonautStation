/obj/item/tespih
	name = "tespih"
	desc = "Burda çok dolaşma bura bizim mahalle ayıktın?"
	w_class = WEIGHT_CLASS_SMALL
	custom_price = 5

	icon = 'icons/psychonaut/obj/tespih.dmi'
	icon_state = "tespih"

	inhand_icon_state = "tespih"

	lefthand_file = 'icons/psychonaut/mob/inhands/equipment/tespih_lefthand.dmi'
	righthand_file = 'icons/psychonaut/mob/inhands/equipment/tespih_righthand.dmi'

	var/tespih_sallama_sound = 'sound/_psychonaut/tespih.ogg'
	var/active = FALSE

/obj/item/tespih/proc/salla(mob/user, delayoverride, volume = 60)
	if(active)
		to_chat(user, span_notice("[src] sallamayı bırakır."))
		inhand_icon_state = "tespih"
		update_appearance()
		active = FALSE
	else
		to_chat(user, span_notice("[src] sallamaya başlar."))
		inhand_icon_state = "tespih_active"
		update_appearance()
		playsound(src, tespih_sallama_sound, 60, 1)
		active = TRUE

/obj/item/tespih/attack_self(mob/user, modifiers)
	. = ..()
	salla(user)

/obj/item/tespih/dropped(mob/user)
	. = ..()
	active = FALSE
	inhand_icon_state = "tespih"
	update_appearance()

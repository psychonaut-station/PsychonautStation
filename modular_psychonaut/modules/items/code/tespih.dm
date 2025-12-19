/**
 * Title:
 * 	Tesbih
 * Description:
 * 	Tesbih ekler
 * Related files:
 *  `code/modules/vending/autodrobe.dm`
 * 	`modular_psychonaut/master_files/icons/obj/tespih.dmi`
 *  `modular_psychonaut/master_files/icons/mob/inhands/equipments/tespih_lefthand.dmi`
 *  `modular_psychonaut/master_files/icons/mob/inhands/equipments/tespih_righthand.dmi`
 *  `modular_psychonaut/master_files/sound/effects/tespih.ogg`
 * Credits:
 * 	carmingenium
 */
/obj/item/tasbih
	name = "tasbih"
	desc = "Burda çok dolaşma bura bizim mahalle ayıktın?"
	w_class = WEIGHT_CLASS_SMALL
	custom_price = 5
	icon = 'modular_psychonaut/master_files/icons/obj/tespih.dmi'
	icon_state = "tespih"
	base_icon_state = "tespih"
	inhand_icon_state = "tespih"
	lefthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/equipments/tespih_lefthand.dmi'
	righthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/equipments/tespih_righthand.dmi'

	var/active = FALSE

/obj/item/tasbih/attack_self(mob/user, modifiers)
	. = ..()
	if(active)
		to_chat(user, span_notice("You stopped twirling [src]."))
		inhand_icon_state = base_icon_state
		update_appearance()
		active = FALSE
	else
		to_chat(user, span_notice("You started twirling [src]."))
		inhand_icon_state = "[base_icon_state]_active"
		update_appearance()
		playsound(src, 'modular_psychonaut/master_files/sound/effects/tespih.ogg', 60, 1)
		active = TRUE

/obj/item/tasbih/dropped(mob/user)
	. = ..()
	active = FALSE
	inhand_icon_state = base_icon_state
	update_appearance()

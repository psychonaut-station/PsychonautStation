/obj/machinery/barsign/update_icon_state()
	if(!(machine_stat & BROKEN) && (!(machine_stat & NOPOWER) || machine_stat & EMPED) && chosen_sign && chosen_sign.icon_state)
		icon = chosen_sign.icon
	else
		icon = src::icon

	return ..()

/datum/barsign
	var/icon = 'icons/obj/machines/barsigns.dmi'

/datum/barsign/turkubar
	icon = 'modular_psychonaut/master_files/icons/obj/machines/barsigns.dmi'
	name = "Turku Bar"
	icon_state = "turku-bar"
	desc = "Turku Bar Pavyon."
	neon_color = "#ffffff"

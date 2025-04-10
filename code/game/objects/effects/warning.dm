/// An info button that, when clicked, puts some text in the user's chat
/obj/effect/abstract/warning
	name = "warning"
	icon = 'icons/psychonaut/effects/effects.dmi'
	icon_state = "warning"

/obj/effect/abstract/warning/MouseEntered(location, control, params)
	. = ..()
	icon_state = "warning_hovered"

/obj/effect/abstract/warning/MouseExited()
	. = ..()
	icon_state = initial(icon_state)

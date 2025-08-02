/// An warning button that, when clicked, puts some text in the user's chat
/obj/effect/abstract/warning
	name = "warning"
	icon = 'icons/psychonaut/effects/effects.dmi'
	icon_state = "warning"

	/// What should the warning button display when clicked?
	var/warning_text

	/// What theme should the tooltip use?
	var/tooltip_theme

/obj/effect/abstract/warning/Initialize(mapload, warning_text)
	. = ..()

	if (!isnull(warning_text))
		src.warning_text = warning_text

/obj/effect/abstract/warning/Click()
	. = ..()
	to_chat(usr, warning_text)

/obj/effect/abstract/warning/MouseEntered(location, control, params)
	. = ..()
	icon_state = "warning_hovered"
	openToolTip(usr, src, params, title = name, content = warning_text, theme = tooltip_theme)

/obj/effect/abstract/warning/MouseExited()
	. = ..()
	icon_state = initial(icon_state)

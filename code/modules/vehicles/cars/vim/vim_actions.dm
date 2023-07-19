/datum/action/vehicle/sealed/climb_out/vim
	name = "Eject From Mech"
	button_icon = 'icons/mob/actions/actions_mecha.dmi'
	button_icon_state = "mech_eject"

/datum/action/vehicle/sealed/noise
	var/sound_path = 'sound/items/carhorn.ogg'
	var/sound_message = "makes a sound."

/datum/action/vehicle/sealed/noise/Trigger(trigger_flags)
	var/obj/vehicle/sealed/car/vim/vim_mecha = vehicle_entered_target
	if(!COOLDOWN_FINISHED(vim_mecha, sound_cooldown))
		vim_mecha.balloon_alert(owner, "on cooldown!")
		return FALSE
	COOLDOWN_START(vim_mecha, sound_cooldown, VIM_SOUND_COOLDOWN)
	vehicle_entered_target.visible_message(span_notice("[vehicle_entered_target] [sound_message]"))
	playsound(vim_mecha, sound_path, 75)
	return TRUE

/datum/action/vehicle/sealed/noise/chime
	name = "Chime!"
	desc = "Affirmative!"
	button_icon_state = "vim_chime"
	sound_path = 'sound/machines/chime.ogg'
	sound_message = "chimes!"

/datum/action/vehicle/sealed/noise/chime/Trigger(trigger_flags)
	if(..())
		SEND_SIGNAL(vehicle_entered_target, COMSIG_VIM_CHIME_USED)

/datum/action/vehicle/sealed/noise/buzz
	name = "Buzz."
	desc = "Negative!"
	button_icon_state = "vim_buzz"
	sound_path = 'sound/machines/buzz-sigh.ogg'
	sound_message = "buzzes."

/datum/action/vehicle/sealed/noise/buzz/Trigger(trigger_flags)
	if(..())
		SEND_SIGNAL(vehicle_entered_target, COMSIG_VIM_BUZZ_USED)

/datum/action/vehicle/sealed/headlights/vim
	button_icon_state = "vim_headlights"

/datum/action/vehicle/sealed/headlights/vim/Trigger(trigger_flags)
	. = ..()
	SEND_SIGNAL(vehicle_entered_target, COMSIG_VIM_HEADLIGHTS_TOGGLED, vehicle_entered_target.headlights_toggle)

/datum/action/vehicle/sealed/vim/vim_view_stats
	name = "View Stats"
	button_icon_state = "mech_view_stats"
	button_icon = 'icons/mob/actions/actions_mecha.dmi'

/datum/action/vehicle/sealed/vim/vim_view_stats/Trigger(trigger_flags)
	var/obj/vehicle/sealed/car/vim/vim = vehicle_entered_target
	if(!owner || !vim || owner != vim.driver)
		return
	vim.ui_interact(owner)

/datum/asset/simple/bloodsucker_icons

/datum/asset/simple/bloodsucker_icons/register()
	for(var/datum/action/cooldown/bloodsucker/power as anything in subtypesof(/datum/action/cooldown/bloodsucker))
		add_bloodsucker_icon(initial(power.button_icon), initial(power.button_icon_state))

	return ..()

/datum/asset/simple/bloodsucker_icons/proc/add_bloodsucker_icon(bloodsucker_icon, bloodsucker_icon_state)
	assets[SANITIZE_FILENAME("bloodsucker.[bloodsucker_icon_state].png")] = icon(bloodsucker_icon, bloodsucker_icon_state)

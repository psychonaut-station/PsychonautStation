/datum/antagonist/wizard
	credits_icon = "wizard"

/datum/antagonist/wizard/rename_wizard()
	. = ..()
	var/mob/living/wiz_mob = owner.current
	if(credits_icon)
		var/mutable_appearance/antag_appereance = SScredits.get_antagonist_icon(WEAKREF(wiz_mob.mind))
		if(!isnull(antag_appereance))
			antag_appereance.maptext = "<center>[.]</center>"

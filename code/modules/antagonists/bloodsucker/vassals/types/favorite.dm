/**
 * Favorite Vassal
 *
 * Gets some cool abilities depending on the Clan.
 */
/datum/antagonist/vassal/favorite
	name = "\improper Favorite Vassal"
	show_in_antagpanel = FALSE
	antag_hud_name = "vassal6"
	special_type = FAVORITE_VASSAL
	vassal_description = "The Favorite Vassal gets unique abilities over other Vassals depending on your Clan \
		and becomes completely immune to Mindshields. Their powers scale directly with their Master's rank."

	///Bloodsucker rank synchronization for Favorite Vassals.
	var/vassal_level

/datum/antagonist/vassal/favorite/on_gain()
	. = ..()
	master?.on_favorite_vassal(src)
	set_vassal_level()

/datum/antagonist/vassal/favorite/pre_mindshield(mob/implanter, mob/living/mob_override)
	return COMPONENT_MINDSHIELD_RESISTED

///Set the Vassal's rank to their Bloodsucker level and synchronize scalable powers
/datum/antagonist/vassal/favorite/proc/set_vassal_level(mob/living/carbon/human/target = null)
	if(!master)
		return
	var/old_level = vassal_level
	vassal_level = master.bloodsucker_level
	for(var/datum/action/cooldown/bloodsucker/power in powers)
		if(power.can_level)
			power.level_current = clamp(vassal_level, 0, power.max_level)
			power.update_desc()
	if(old_level != null && vassal_level > old_level)
		to_chat(owner, span_notice("You feel your Master's growing dark influence empower your vampiric gifts!"))

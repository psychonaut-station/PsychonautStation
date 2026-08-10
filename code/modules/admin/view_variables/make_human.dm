ADMIN_VERB_ONLY_CONTEXT_MENU(make_human_mapview, R_NONE, "Make Human", mob/target in view())
	var/selected_outfit = target.client?.robust_dress_shop()
	if (!selected_outfit)
		return

	var/mob/living/carbon/human/newmob = target.change_mob_type(/mob/living/carbon/human, null, null, TRUE)
	if(istype(newmob))
		newmob.equipOutfit(selected_outfit)
		message_admins("[key_name_admin(user)] has transformed [target] into [selected_outfit]")
		log_admin("[key_name(user)] has transformed [target] into [selected_outfit]")

ADMIN_VERB_ONLY_CONTEXT_MENU(delete_mob_mapview, R_NONE, "Delete Mob", mob/target in view())
	if(user && tgui_alert(user, "Are you sure?", "Delete Mob", list("I'm Sure", "Abort")) == "I'm Sure")
		QDEL_IN(target, 1)
		message_admins("[key_name_admin(user)] has deleted [target]")
		log_admin("[key_name(user)] has deleted [target]")

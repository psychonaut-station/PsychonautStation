ADMIN_VERB_ONLY_CONTEXT_MENU(make_human_mapview, R_ADMIN, "Make Human", mob/target in world)
	var/selected_outfit = target.client?.robust_dress_shop()
	if (!selected_outfit)
		return

	var/mob/living/carbon/human/newmob = target.change_mob_type(/mob/living/carbon/human, null, null, TRUE)
	if(istype(newmob))
		newmob.equipOutfit(selected_outfit)
		message_admins("[key_name_admin(user)] has transformed [target] into [selected_outfit]")
		log_admin("[key_name(user)] has transformed [target] into [selected_outfit]")

ADMIN_VERB_ONLY_CONTEXT_MENU(delete_mob_mapview, R_ADMIN, "Delete Mob", mob/target in world)
	user.admin_delete(target)

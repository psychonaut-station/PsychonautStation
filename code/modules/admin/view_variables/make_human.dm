/client/proc/make_human(mob/M)
	if(!holder)
		return

	var/selected_outfit = M.client?.robust_dress_shop()
	if (!selected_outfit)
		return

	var/mob/living/carbon/human/newmob = M.change_mob_type(/mob/living/carbon/human, null, null, TRUE)
	if(istype(newmob))
		newmob.equipOutfit(selected_outfit)
		message_admins("[key_name_admin(src)] has transformed [M] into [selected_outfit]")
		log_admin("[key_name(src)] has transformed [M] into [selected_outfit]")


/client/proc/make_human_mapview(mob/M as mob in view(view))
	set category = "Debug"
	set name = "Make Human"
	make_human(M)

/client/proc/delete_mob(mob/M)
	if(!holder || !M)
		return

	QDEL_IN(M, 1)
	message_admins("[key_name_admin(src)] has deleted [M]")
	log_admin("[key_name(src)] has deleted [M]")


/client/proc/delete_mob_mapview(mob/M as mob in view(view))
	set category = "Debug"
	set name = "Delete Mob"
	delete_mob(M)

ADMIN_VERB(set_credits_title, R_FUN, "Set Credits Title", "Set the title that will show on round end credits.", ADMIN_CATEGORY_FUN)
	var/title = tgui_input_text(user, "What do you want the title to be?", title = "Credits Title")
	if(!title)
		return
	if(SSshuttle.emergency && (SSshuttle.emergency.mode == SHUTTLE_ENDGAME))
		to_chat(user, span_warning("You cant change the title of credits on endof the game!"))
		return

	if(!user.holder.check_for_rights(R_SERVER))
		title = adminscrub(title,500)

	SScredits.customized_name = title
	log_admin("[key_name(user)] set the credits title to [title]")
	BLACKBOX_LOG_ADMIN_VERB("Set Credits Title")

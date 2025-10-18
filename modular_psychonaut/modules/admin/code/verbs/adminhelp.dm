//private
/datum/admin_help/ClosureLinks(ref_src)
	. = ..()
	if (ticket_type == TICKET_TYPE_ADMIN)
		. += " (<A HREF='?_src_=holder;[HrefToken(forceGlobal = TRUE)];ahelp=[ref_src];ahelp_action=karaktermeselesi'>KM</A>)"

/datum/admin_help/proc/KarakterMeselesi(key_name = key_name_admin(usr))
	if(state != AHELP_ACTIVE)
		return

	var/msg = "<font color='red' size='6'><b>- KARAKTER MESELESİ -</b></font><br>"
	msg += "<font color='red'>İnce bir detay iyi düşünülmesi gereken bir kararları ha oldu bitti gitti ye "
	msg += "getirmeyeceksin. Planlı hamleler yapacaksın. Hayatını karambole getirmeyeceksin. Bak şairin sözüne; "
	msg += "“Yaşam şakaya gelmez, hayatını bütün ciddiyetinle yaşayacaksın.” Adam vurgulamış yani. İşte böyle "
	msg += "saçma sapan kararlar alıp sonra ah yandım falan yok. İnce düşünecek geri dönüşü olan kararlar "
	msg += "almayacaksın. Bir karar aldın mı? O kararın arkasında duracaksın. Bu öyle bir şey ki hayatına yön "
	msg += "veren kararları alırken de saygı duyacaksın.</font>"

	if(initiator)
		to_chat(initiator, msg, confidential = TRUE)

	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "KM")
	msg = "Ticket [TicketHref("#[id]")] marked as KM by [key_name]"
	message_admins(msg)
	log_admin_private(msg)
	AddInteraction("Marked as Karakter Meselesi by [key_name]", player_message = "Marked as Karakter Meselesi!")
	SSblackbox.LogAhelp(id, "Karakter Meselesi", "Marked as Karakter Meselesi by [usr.key]", null,  usr.ckey)
	Resolve(silent = TRUE)

SUBSYSTEM_DEF(nightshift)
	name = "Night Shift"
	wait = 10 MINUTES

	var/nightshift_active = FALSE
	var/nightshift_start_time = 702000 //7:30 PM, station time
	var/nightshift_end_time = 270000 //7:30 AM, station time
	var/nightshift_first_check = 30 SECONDS

	var/high_security_mode = FALSE
	var/list/currentrun

/datum/controller/subsystem/nightshift/Initialize()
	if(!CONFIG_GET(flag/enable_night_shifts))
		can_fire = FALSE
	return SS_INIT_SUCCESS

/datum/controller/subsystem/nightshift/fire(resumed = FALSE)
	if(resumed)
		update_nightshift(resumed = TRUE)
		return
	if(world.time - SSticker.round_start_time < nightshift_first_check)
		return
	check_nightshift()

/datum/controller/subsystem/nightshift/proc/announce(message)
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	/*
	priority_announce(
		text = message,
		sound = 'sound/announcer/notice/notice2.ogg',
		sender_override = "Automated Lighting System Announcement",
		color_override = "grey",
	)
	*/
	priority_announce(
		text = message,
		sound = 'sound/announcer/notice/notice2.ogg',
		sender_override = "Otomatik Işıklandırma Sistemi Duyurusu",
		color_override = "grey",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/controller/subsystem/nightshift/proc/check_nightshift()
	var/emergency = SSsecurity_level.get_current_level_as_number() >= SEC_LEVEL_RED
	var/announcing = TRUE
	var/time = station_time()
	var/night_time = (time < nightshift_end_time) || (time > nightshift_start_time)
	if(high_security_mode != emergency)
		high_security_mode = emergency
		if(night_time)
			announcing = FALSE
			if(!emergency)
				// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
				// announce("Restoring night lighting configuration to normal operation.")
				announce("Gece aydınlatmaları normal ayarlarına döndürülüyor.")
				// PSYCHONAUT EDIT ADDITION END - LOCALIZATION
			else
				// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
				// announce("Disabling night lighting: Station is in a state of emergency.")
				announce("Gece aydınlatması devre dışı bırakılıyor: İstasyon acil durumda")
				// PSYCHONAUT EDIT ADDITION END - LOCALIZATION
	if(emergency)
		night_time = FALSE
	if(nightshift_active != night_time)
		update_nightshift(night_time, announcing)

/datum/controller/subsystem/nightshift/proc/update_nightshift(active, announce = TRUE, resumed = FALSE, forced = FALSE)
	if(!resumed)
		currentrun = SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/power/apc)
		nightshift_active = active
		if(announce)
			if (active)
				// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
				// announce("Good evening, crew. To reduce power consumption and stimulate the circadian rhythms of some species, all of the lights aboard the station have been dimmed for the night.")
				announce("İyi akşamlar, mürettebat. Güç tüketimini azaltmak ve bazı türlerin dinlenmelerini sağlamak amacıyla istasyonun ışıkları bu gece için karartılmıştır.")
				// PSYCHONAUT EDIT ADDITION END - LOCALIZATION
			else
				// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
				// announce("Good morning, crew. As it is now day time, all of the lights aboard the station have been restored to their former brightness.")
				announce("Günaydın, mürettebat. Şu anda gündüz olduğu için istasyonun ışıkları eski parlaklığına döndürülmüştür.")
				// PSYCHONAUT EDIT ADDITION END - LOCALIZATION
	for(var/obj/machinery/power/apc/APC as anything in currentrun)
		currentrun -= APC
		if (APC.area && (APC.area.type in GLOB.the_station_areas))
			APC.set_nightshift(nightshift_active)
		if(MC_TICK_CHECK && !forced) // subsystem will be in state SS_IDLE if forced by an admin
			return

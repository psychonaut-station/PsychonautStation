// Normal strength

/datum/round_event_control/meteor_wave
	name = "Meteor Wave: Normal"
	typepath = /datum/round_event/meteor_wave
	weight = 4
	min_players = 35
	max_occurrences = 3
	earliest_start = 25 MINUTES
	category = EVENT_CATEGORY_SPACE
	description = "A regular meteor wave."
	map_flags = EVENT_SPACE_ONLY

/datum/round_event/meteor_wave
	start_when = 6
	end_when = 66
	announce_when = 1
	var/list/wave_type
	var/wave_name = "normal"

/datum/round_event/meteor_wave/New()
	..()
	if(!wave_type)
		determine_wave_type()

/datum/round_event/meteor_wave/proc/determine_wave_type()
	if(!wave_name)
		wave_name = pick_weight(list(
			"normal" = 50,
			"threatening" = 40,
			"catastrophic" = 0))
	switch(wave_name)
		if("normal")
			wave_type = GLOB.meteors_normal
		if("threatening")
			wave_type = GLOB.meteors_threatening
		if("catastrophic")
			if(check_holidays(HALLOWEEN))
				wave_type = GLOB.meteorsSPOOKY
			else
				wave_type = GLOB.meteors_catastrophic
		if("meaty")
			wave_type = GLOB.meateors
		if("space dust")
			wave_type = GLOB.meteors_dust
		if("halloween")
			wave_type = GLOB.meteorsSPOOKY
		else
			WARNING("Wave name of [wave_name] not recognised.")
			kill()

/datum/round_event/meteor_wave/announce(fake)
	priority_announce("İstasyonla çarpışma rotasında olan meteorlar tespit edildi.", "Meteor Uyarısı", ANNOUNCER_METEORS)

/datum/round_event/meteor_wave/tick()
	if(ISMULTIPLE(activeFor, 3))
		spawn_meteors(5, wave_type) //meteor list types defined in gamemode/meteor/meteors.dm

/datum/round_event_control/meteor_wave/threatening
	name = "Meteor Wave: Threatening"
	typepath = /datum/round_event/meteor_wave/threatening
	weight = 5
	min_players = 40
	max_occurrences = 3
	earliest_start = 35 MINUTES
	description = "A meteor wave with higher chance of big meteors."

/datum/round_event/meteor_wave/threatening
	wave_name = "threatening"

/datum/round_event_control/meteor_wave/catastrophic
	name = "Meteor Wave: Catastrophic"
	typepath = /datum/round_event/meteor_wave/catastrophic
	weight = 7
	min_players = 45
	max_occurrences = 3
	earliest_start = 45 MINUTES
	description = "A meteor wave that might summon a tunguska class meteor."

/datum/round_event/meteor_wave/catastrophic
	wave_name = "catastrophic"

/datum/round_event_control/meteor_wave/meaty
	name = "Meteor Wave: Meaty"
	typepath = /datum/round_event/meteor_wave/meaty
	weight = 2
	max_occurrences = 1
	description = "A meteor wave made of meat."

/datum/round_event/meteor_wave/meaty
	wave_name = "meaty"

/datum/round_event/meteor_wave/meaty/announce(fake)
	priority_announce("Etli bir meteorun istasyonla çarpışma rotasında olduğu tespit edildi.", "Kahretsin, paspası getir.", ANNOUNCER_METEORS)

/datum/round_event_control/meteor_wave/dust_storm
	name = "Major Space Dust"
	typepath = /datum/round_event/meteor_wave/dust_storm
	weight = 14
	description = "The station is pelted by sand."
	earliest_start = 15 MINUTES
	min_wizard_trigger_potency = 4
	max_wizard_trigger_potency = 7

/datum/round_event/meteor_wave/dust_storm
	announce_chance = 85
	wave_name = "space dust"

/datum/round_event/meteor_wave/dust_storm/announce(fake)
	var/list/reasons = list()

	reasons += "[station_name()] bir enkaz bulutunun içinden geçmektedir \
		dış donanım ve eşyalarda küçük çaplı hasar beklenmektedir."

	reasons += "Nanotrasen Süper Silahlar Departmanı yeni bir [pick("saha","koruma","nova")] [pick("topu","silahı","tankı","gemisi")] \
		prototipi deniyorlar. Bazı küçük çaplı hasarlar beklenmektedir."

	reasons += "Komşu istasyonlarınızdan biri size taş atıyor. (Belki de \
		mesajlarınızdan bıkmışlardır.)"

	reasons += "[station_name()] yörüngesi bir asteroit madenciliğinden arta kalan bir \
		bulutun içinden geçiyor. İstasyon gövdesinde küçük çaplı hasar beklenmektedir."

	reasons += "[station_name()] ile kesişme rotasında olan büyük bir meteoroid parçalandı.  \
		Enkaz kalıntıları istasyonun dış cephesini etkileyebilir."

	priority_announce(pick(reasons), "Çarpışma Uyarısı")

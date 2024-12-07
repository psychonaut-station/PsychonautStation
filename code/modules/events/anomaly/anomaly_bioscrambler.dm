/datum/round_event_control/anomaly/anomaly_bioscrambler
	name = "Anomaly: Bioscrambler"
	typepath = /datum/round_event/anomaly/anomaly_bioscrambler

	min_players = 10
	max_occurrences = 5
	weight = 20
	description = "This anomaly replaces the limbs of nearby people."
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 2

/datum/round_event/anomaly/anomaly_bioscrambler
	start_when = ANOMALY_START_MEDIUM_TIME
	announce_when = ANOMALY_ANNOUNCE_MEDIUM_TIME
	anomaly_path = /obj/effect/anomaly/bioscrambler

/datum/round_event/anomaly/anomaly_bioscrambler/announce(fake)
	if(isnull(impact_area))
		impact_area = placer.findValidArea()
<<<<<<< HEAD
	priority_announce("[ANOMALY_ANNOUNCE_MEDIUM_TEXT] [impact_area.name] bölgesinde biyolojik uzuv değiştirme maddesi tespit etti. Etkilerine karşı koymak için biyo-giysiler veya başka koruyucu ekipmanlar kullanın. Hesaplanan yaşam süresi %9£$T$%F3 yıl.", "Anomali Uyarısı")
=======
	priority_announce("Biologic limb swapping agent detected on [ANOMALY_ANNOUNCE_MEDIUM_TEXT] [impact_area.name]. Wear biosuits or other protective gear to counter the effects.", "Anomaly Alert")
>>>>>>> 45c4edc57962406d4a7e11ec76b62884b5ff7900

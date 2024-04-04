/datum/round_event_control/anomaly/anomaly_vortex
	name = "Anomaly: Vortex"
	typepath = /datum/round_event/anomaly/anomaly_vortex

	min_players = 35
	max_occurrences = 2
	weight = 10
	description = "This anomaly sucks in and detonates items."
	min_wizard_trigger_potency = 3
	max_wizard_trigger_potency = 7

/datum/round_event/anomaly/anomaly_vortex
	start_when = ANOMALY_START_DANGEROUS_TIME
	announce_when = ANOMALY_ANNOUNCE_DANGEROUS_TIME
	anomaly_path = /obj/effect/anomaly/bhole

/datum/round_event/anomaly/anomaly_vortex/announce(fake)
	if(isnull(impact_area))
		impact_area = placer.findValidArea()
	priority_announce("[ANOMALY_ANNOUNCE_DANGEROUS_TEXT] [impact_area.name] bölgesinde yerelleştirilmiş yüksek yoğunluklu girdap anomalisi tespit edildi.", "Anomali Uyarısı")

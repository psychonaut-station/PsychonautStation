/datum/round_event_control/anomaly/anomaly_time
	name = "Anomaly: Time"
	typepath = /datum/round_event/anomaly/anomaly_time

	min_players = 10
	max_occurrences = 5
	weight = 20
	description = "This anomaly stopping time of nearby people."
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 2

/datum/round_event/anomaly/anomaly_time
	start_when = ANOMALY_START_MEDIUM_TIME
	announce_when = ANOMALY_ANNOUNCE_MEDIUM_TIME
	anomaly_path = /obj/effect/anomaly/time

/datum/round_event/anomaly/anomaly_time/announce(fake)
	priority_announce("Space-time confusion detected on [ANOMALY_ANNOUNCE_MEDIUM_TEXT] [impact_area.name].", "Anomaly Alert")

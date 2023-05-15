/datum/round_event_control/anomaly/anomaly_life
	name = "Anomaly: Life"
	typepath = /datum/round_event/anomaly/anomaly_life

	min_players = 10
	max_occurrences = 5
	weight = 20
	description = "This anomaly slowly deals damage to surrounding people"
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 2

/datum/round_event/anomaly/anomaly_life
	start_when = ANOMALY_START_MEDIUM_TIME
	announce_when = ANOMALY_ANNOUNCE_MEDIUM_TIME
	anomaly_path = /obj/effect/anomaly/life

/datum/round_event/anomaly/anomaly_life/announce(fake)
	priority_announce("An imperceptible sign of life has been detected on [ANOMALY_ANNOUNCE_MEDIUM_TEXT] [impact_area.name].", "Anomaly Alert")
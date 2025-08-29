// Temporal anomaly event
#define ANOMALY_INTENSITY_MINOR "Minor Intensity"
#define ANOMALY_INTENSITY_MODERATE "Moderate Intensity"
#define ANOMALY_INTENSITY_MAJOR "Major Intensity"

/datum/round_event_control/anomaly/anomaly_time
	name = "Anomaly: Temporal Distortion"
	description = "This anomaly distorts time, freezing everything in its area of effect."
	typepath = /datum/round_event/anomaly/anomaly_time
	min_players = 10
	max_occurrences = 5
	weight = 20
	category = EVENT_CATEGORY_ANOMALIES
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 2

/datum/round_event/anomaly/anomaly_time
	anomaly_path = /obj/effect/anomaly/time
	start_when = ANOMALY_START_DANGEROUS_TIME
	announce_when = ANOMALY_ANNOUNCE_DANGEROUS_TIME

/datum/round_event/anomaly/anomaly_time/start()
	var/turf/anomaly_turf
	if(spawn_location)
		anomaly_turf = spawn_location
	else
		anomaly_turf = placer.findValidTurf(impact_area)

	var/newAnomaly
	if(anomaly_turf)
		newAnomaly = new anomaly_path(anomaly_turf)
	if (newAnomaly)
		announce_to_ghosts(newAnomaly)

/datum/round_event/anomaly/anomaly_time/announce(fake)
	if(isnull(impact_area))
		impact_area = placer.findValidArea()
	priority_announce("[ANOMALY_ANNOUNCE_DANGEROUS_TEXT] [impact_area.name] bölgesinde zamansal bozulma tespit etti.", "Anomali Uyarısı")

#undef ANOMALY_INTENSITY_MINOR
#undef ANOMALY_INTENSITY_MODERATE
#undef ANOMALY_INTENSITY_MAJOR

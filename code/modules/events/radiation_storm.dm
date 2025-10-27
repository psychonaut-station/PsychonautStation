/datum/round_event_control/radiation_storm
	name = "Radiation Storm"
	typepath = /datum/round_event/radiation_storm
	max_occurrences = 1
	category = EVENT_CATEGORY_SPACE
	description = "Radiation storm affects the station, forcing the crew to escape to maintenance."
	min_wizard_trigger_potency = 3
	max_wizard_trigger_potency = 7

/datum/round_event/radiation_storm


/datum/round_event/radiation_storm/setup()
	start_when = 3
	end_when = start_when + 1
	announce_when = 1

/datum/round_event/radiation_storm/announce(fake)
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// priority_announce("High levels of radiation detected near the station. Maintenance is best shielded from radiation.", "Anomaly Alert", ANNOUNCER_RADIATION)
	priority_announce("İstasyon yakınlarında yüksek düzeyde radyasyon tespit edildi. Radyasyondan korunmak için Maintenancelere sığınabilirsiniz.", "Anomali Uyarısı", ANNOUNCER_RADIATION)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION
	//sound not longer matches the text, but an audible warning is probably good

/datum/round_event/radiation_storm/start()
	SSweather.run_weather(/datum/weather/rad_storm)

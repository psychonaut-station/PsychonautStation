
/datum/round_event_control/timehole
	name = "Timeholes"
	typepath = /datum/round_event/timehole
	max_occurrences = 3
	weight = 2
	min_players = 2
	category = EVENT_CATEGORY_SPACE
	description = "Space time anomalies appear on the station, randomly teleporting people who walk into them."
	min_wizard_trigger_potency = 3
	max_wizard_trigger_potency = 7

/datum/round_event/timehole
	announce_when = 10
	end_when = 40

	var/list/pick_turfs = list()
	var/list/timeholes = list()
	var/shift_frequency = 5
	var/number_of_timeholes = 200

/datum/round_event/timehole/setup()
	announce_when = rand(0, 20)

/datum/round_event/timehole/start()
	for(var/turf/open/floor/T in world)
		if(is_station_level(T.z))
			pick_turfs += T

	for(var/i in 1 to number_of_timeholes)
		var/turf/T = pick(pick_turfs)
		timeholes += new /obj/effect/timestop(T, rand(1,2), rand(3,5) SECONDS)

/datum/round_event/timehole/announce(fake)
	priority_announce("İstasyonda uzay-zaman anomalileri tespit edildi. Herhangi bir ek veri bulunmamaktadır.", "Anomali Uyarısı", ANNOUNCER_SPANOMALIES)

/datum/round_event/timehole/tick()
	if(activeFor % shift_frequency == 0 || prob(10))
		for(var/i in 1 to number_of_timeholes)
			var/turf/T = pick(pick_turfs)
			timeholes += new /obj/effect/timestop(T, rand(1,2), 5 SECONDS)

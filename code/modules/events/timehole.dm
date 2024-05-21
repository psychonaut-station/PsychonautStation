
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
	admin_setup = list(
		/datum/event_admin_setup/input_number/timeholeseconds,
		/datum/event_admin_setup/input_number/numberoftimehole,
		/datum/event_admin_setup/question/timehole_nosound
	)

/datum/round_event/timehole
	announce_when = 10
	end_when = 40

	var/list/pick_turfs = list()
	var/list/timeholes = list()
	var/second = 5
	var/number_of_timeholes = 200
	var/noSound = TRUE

/datum/round_event/timehole/setup()
	announce_when = rand(0, 20)

/datum/round_event/timehole/start()
	for(var/turf/open/floor/T in world)
		if(is_station_level(T.z))
			pick_turfs += T

	for(var/i in 1 to number_of_timeholes)
		var/turf/T = pick(pick_turfs)
		timeholes += new /obj/effect/timestop(T, rand(1,2), second SECONDS, noSound = noSound)

/datum/round_event/timehole/announce(fake)
	priority_announce("İstasyonda uzay-zaman anomalileri tespit edildi. Herhangi bir ek veri bulunmamaktadır.", "Anomali Uyarısı", ANNOUNCER_SPANOMALIES)

/datum/round_event/timehole/tick()
	if(activeFor % second == 0 || prob(10))
		for(var/i in 1 to number_of_timeholes)
			var/turf/T = pick(pick_turfs)
			timeholes += new /obj/effect/timestop(T, rand(1,2), second SECONDS, noSound = noSound)

/datum/event_admin_setup/input_number/timeholeseconds
	input_text = "For how many seconds will timestop?"
	default_value = 5
	max_value = 10
	min_value = 2

/datum/event_admin_setup/input_number/timeholeseconds/apply_to_event(datum/round_event/timehole/event)
	event.second = chosen_value

/datum/event_admin_setup/input_number/numberoftimehole
	input_text = "How many time stopping events will occur per selected second?"
	default_value = 200
	max_value = 500
	min_value = 1

/datum/event_admin_setup/input_number/numberoftimehole/apply_to_event(datum/round_event/timehole/event)
	event.number_of_timeholes = chosen_value

/datum/event_admin_setup/question/timehole_nosound
	input_text = "Does timestops plays sound?"

/datum/event_admin_setup/question/timehole_nosound/apply_to_event(datum/round_event/timehole/event)
	event.noSound = chosen

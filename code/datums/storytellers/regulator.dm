/datum/storyteller/regulator
	name = STORYTELLER_REGULATOR
	config_tag = STORYTELLER_REGULATOR
	desc = "The Regulator aims to maintain a constant level of entropy. It acts as a stress-test algorithm, adjusting parameters in real-time based on station integrity."
	welcome_text = "Calibration in progress. Maintaining optimal stress levels."

	population_min = 50
	weight = 1
	var/control_cooldown = 5 MINUTES
	var/last_control = 0

/datum/storyteller/regulator/initialize()
	. = ..()
	last_control = world.time

/datum/storyteller/regulator/fire(seconds_per_tick)
	last_control = seconds_per_tick * 10
	if(last_control < control_cooldown)
		return
	last_control = 0
	var/score = 0

	var/total_chaos_points = 0
	var/max_possible_points = 0

	for(var/mob/M in GLOB.mob_list)
		if(isnewplayer(M) || !find_record(M.real_name))
			continue
		if(!isbrain(M) && !iseyemob(M))
			total_chaos_points += M.stat
			max_possible_points += DEAD

	if(max_possible_points > 0)
		score += (total_chaos_points / max_possible_points) * 100

	var/datum/station_state/end_state = new /datum/station_state()
	end_state.count()

	var/roundend_station_integrity = min(PERCENT(GLOB.start_state.score(end_state)), 100)
	score += (100 - roundend_station_integrity)

	var/avg_temp = get_station_avg_temp()
	var/temp_diff = abs(T20C - avg_temp)
	score += min(temp_diff, 100)

	for(var/obj/machinery/telecomms/comms_machine as anything in GLOB.telecomm_machines)
		if((comms_machine.machine_stat & BROKEN) || (comms_machine.machine_stat & NOPOWER) || (comms_machine.machine_stat & EMPED))
			score += 1

	if(score <= 30)
		settings[STORYTELLER_EVENT_WEIGHT_MULTIPLIERS] = list(
			EVENT_TRACK_MUNDANE = 0,
			EVENT_TRACK_MODERATE = 0,
			EVENT_TRACK_MAJOR = 1,
			EVENT_TRACK_ROLESET = 1,
		)
	else if(score <= 75)
		settings[STORYTELLER_EVENT_WEIGHT_MULTIPLIERS] = list(
			EVENT_TRACK_MUNDANE = 0,
			EVENT_TRACK_MODERATE = 1,
			EVENT_TRACK_MAJOR = 0.9,
			EVENT_TRACK_ROLESET = 0.9,
		)
	else if(score <= 150)
		settings[STORYTELLER_EVENT_WEIGHT_MULTIPLIERS] = list(
			EVENT_TRACK_MUNDANE = 2,
			EVENT_TRACK_MODERATE = 1,
			EVENT_TRACK_MAJOR = 0.5,
			EVENT_TRACK_ROLESET = 0.5,
		)
	else
		settings[STORYTELLER_EVENT_WEIGHT_MULTIPLIERS] = list(
			EVENT_TRACK_MUNDANE = 2,
			EVENT_TRACK_MODERATE = 0.5,
			EVENT_TRACK_MAJOR = 0,
			EVENT_TRACK_ROLESET = 0,
		)
	log_storyteller("\[[name]\] set event weight multiplier to (Mundane: [settings[STORYTELLER_EVENT_WEIGHT_MULTIPLIERS][EVENT_TRACK_MUNDANE]], Moderate: [settings[STORYTELLER_EVENT_WEIGHT_MULTIPLIERS][EVENT_TRACK_MODERATE]], Major: [settings[STORYTELLER_EVENT_WEIGHT_MULTIPLIERS][EVENT_TRACK_MAJOR]], Roleset: [settings[STORYTELLER_EVENT_WEIGHT_MULTIPLIERS][EVENT_TRACK_ROLESET]])")

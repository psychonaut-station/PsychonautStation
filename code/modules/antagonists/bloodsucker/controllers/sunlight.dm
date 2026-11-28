///How long Sol will last until it's night again.
#define TIME_BLOODSUCKER_DAY 60
///Base time nighttime should be in for, until Sol rises.
#define TIME_BLOODSUCKER_NIGHT 600
///Time left to send an alert to Bloodsuckers about an incoming Sol.
#define TIME_BLOODSUCKER_DAY_WARN 180
///Time left to send an urgent alert to Bloodsuckers about an incoming Sol.
#define TIME_BLOODSUCKER_DAY_FINAL_WARN 60
///Time left to alert that Sol is rising.
#define TIME_BLOODSUCKER_BURN_INTERVAL 5

///How much time Sol can be 'off' by, keeping the time inconsistent.
#define TIME_BLOODSUCKER_SOL_DELAY 180

GLOBAL_DATUM_INIT(bloodsucker_sunlight, /datum/bloodsucker_sunlight, new)

/// Tracks bloodsuckers/vassals and drives the Sol day/night cycle via SSprocessing.
/datum/bloodsucker_sunlight
	/// Whether Sol cycle processing is currently active on SSprocessing.
	var/processing = FALSE
	/// If the Sun is currently out or not.
	var/sunlight_active = FALSE
	/// The time between the next cycle, randomized every night.
	var/time_til_cycle = TIME_BLOODSUCKER_NIGHT
	/// If Bloodsucker levels for the night has been given out yet.
	var/issued_XP = FALSE
	/// Accumulates fractional seconds_per_tick so step_cycle() advances in 1-second steps.
	var/tick_accumulator = 0
	/// Weakrefs to active bloodsucker antagonist datums.
	var/list/datum/weakref/tracked_bloodsuckers = list()
	/// Weakrefs to active vassal antagonist datums.
	var/list/datum/weakref/tracked_vassals = list()

/datum/bloodsucker_sunlight/Destroy()
	if(processing || (datum_flags & DF_ISPROCESSING))
		STOP_PROCESSING(SSprocessing, src)
		processing = FALSE
	tracked_bloodsuckers.Cut()
	tracked_vassals.Cut()
	return ..()

/datum/bloodsucker_sunlight/process(seconds_per_tick)
	if(!processing)
		tick_accumulator = 0
		return PROCESS_KILL
	tick_accumulator += seconds_per_tick
	while(processing && tick_accumulator >= 1)
		tick_accumulator -= 1
		step_cycle()

/datum/bloodsucker_sunlight/proc/add_tracked_ref(list/datum/weakref/ref_list, datum/target)
	var/datum/weakref/target_ref = WEAKREF(target)
	if(!target_ref)
		return
	var/already_tracked = FALSE
	for(var/i = length(ref_list); i >= 1; i--)
		var/datum/weakref/ref = ref_list[i]
		var/datum/resolved = ref?.resolve()
		if(QDELETED(resolved))
			ref_list.Cut(i, i + 1)
			continue
		if(resolved == target)
			already_tracked = TRUE
	if(!already_tracked)
		ref_list += target_ref

/datum/bloodsucker_sunlight/proc/remove_tracked_ref(list/datum/weakref/ref_list, datum/target)
	for(var/i = length(ref_list); i >= 1; i--)
		var/datum/weakref/ref = ref_list[i]
		var/datum/resolved = ref?.resolve()
		if(QDELETED(resolved) || resolved == target || IS_WEAKREF_OF(target, ref))
			ref_list.Cut(i, i + 1)

/datum/bloodsucker_sunlight/proc/resolve_tracked(list/datum/weakref/ref_list)
	var/list/resolved_datums = list()
	for(var/i = length(ref_list); i >= 1; i--)
		var/datum/weakref/ref = ref_list[i]
		var/datum/resolved = ref?.resolve()
		if(QDELETED(resolved))
			ref_list.Cut(i, i + 1)
			continue
		resolved_datums += resolved
	return resolved_datums

/datum/bloodsucker_sunlight/proc/register_bloodsucker(datum/antagonist/bloodsucker/vamp)
	if(QDELETED(vamp))
		return
	add_tracked_ref(tracked_bloodsuckers, vamp)
	if(!processing && length(tracked_bloodsuckers))
		processing = TRUE
		tick_accumulator = 0
		START_PROCESSING(SSprocessing, src)
		message_admins("New Sol has been created due to Bloodsucker assignment.")

/datum/bloodsucker_sunlight/proc/unregister_bloodsucker(datum/antagonist/bloodsucker/vamp)
	var/was_processing = processing
	remove_tracked_ref(tracked_bloodsuckers, vamp)
	if(!length(tracked_bloodsuckers) && (was_processing || (datum_flags & DF_ISPROCESSING)))
		processing = FALSE
		tick_accumulator = 0
		STOP_PROCESSING(SSprocessing, src)
		reset_cycle()
		if(was_processing)
			message_admins("Sol has been deleted due to the lack of Bloodsuckers")
		if(sunlight_active)
			sunlight_active = FALSE
			if(!QDELETED(vamp))
				vamp.clear_sol_state()

/datum/bloodsucker_sunlight/proc/register_vassal(datum/antagonist/vassal/vassal)
	if(QDELETED(vassal))
		return
	add_tracked_ref(tracked_vassals, vassal)

/datum/bloodsucker_sunlight/proc/unregister_vassal(datum/antagonist/vassal/vassal)
	remove_tracked_ref(tracked_vassals, vassal)

/datum/bloodsucker_sunlight/proc/step_cycle()
	time_til_cycle--
	if(sunlight_active)
		if(time_til_cycle > 0)
			for(var/datum/antagonist/bloodsucker/vamp as anything in resolve_tracked(tracked_bloodsuckers))
				if(!QDELETED(vamp))
					vamp.handle_sol()
			if(!issued_XP && time_til_cycle <= (TIME_BLOODSUCKER_DAY / 2))
				issued_XP = TRUE
				for(var/datum/antagonist/bloodsucker/vamp as anything in resolve_tracked(tracked_bloodsuckers))
					if(!QDELETED(vamp))
						vamp.sol_rank_up()
		if(time_til_cycle <= 0)
			sunlight_active = FALSE
			issued_XP = FALSE
			//randomize the next sol timer
			time_til_cycle = round(rand((TIME_BLOODSUCKER_NIGHT-TIME_BLOODSUCKER_SOL_DELAY), (TIME_BLOODSUCKER_NIGHT+TIME_BLOODSUCKER_SOL_DELAY)), 1)
			message_admins("BLOODSUCKER NOTICE: Daylight Ended. Resetting to Night (Lasts for [DisplayTimeText(time_til_cycle * 1 SECONDS)])")
			for(var/datum/antagonist/bloodsucker/vamp as anything in resolve_tracked(tracked_bloodsuckers))
				if(!QDELETED(vamp))
					vamp.on_sol_end()
			warn_daylight(
				danger_level = DANGER_LEVEL_SOL_ENDED,
				vampire_warning_message = span_announce("The solar flare has ended, and the daylight danger has passed... for now."),
				vassal_warning_message = span_announce("The solar flare has ended, and the daylight danger has passed... for now."),
			)
		return

	switch(time_til_cycle)
		if(TIME_BLOODSUCKER_DAY_WARN)
			for(var/datum/antagonist/bloodsucker/vamp as anything in resolve_tracked(tracked_bloodsuckers))
				if(!QDELETED(vamp))
					vamp.sol_near_start()
			warn_daylight(
				danger_level = DANGER_LEVEL_FIRST_WARNING,
				vampire_warning_message = span_danger("Solar Flares will bombard the station with dangerous UV radiation in [DisplayTimeText(TIME_BLOODSUCKER_DAY_WARN * 1 SECONDS)]. <b>Prepare to seek cover in a coffin or closet.</b>"),
			)
		if(TIME_BLOODSUCKER_DAY_FINAL_WARN)
			message_admins("BLOODSUCKER NOTICE: Daylight beginning in [DisplayTimeText(TIME_BLOODSUCKER_DAY_FINAL_WARN * 1 SECONDS)].)")
			warn_daylight(
				danger_level = DANGER_LEVEL_SECOND_WARNING,
				vampire_warning_message = span_userdanger("Solar Flares are about to bombard the station! You have [DisplayTimeText(TIME_BLOODSUCKER_DAY_FINAL_WARN * 1 SECONDS)] to find cover!"),
				vassal_warning_message = span_danger("In [DisplayTimeText(TIME_BLOODSUCKER_DAY_FINAL_WARN * 1 SECONDS)], your master will be at risk of a Solar Flare. Make sure they find cover!"),
			)
		if(TIME_BLOODSUCKER_BURN_INTERVAL)
			warn_daylight(
				danger_level = DANGER_LEVEL_THIRD_WARNING,
				vampire_warning_message = span_userdanger("Seek cover, for Sol rises!"),
			)
		if(NONE)
			sunlight_active = TRUE
			//set the timer to countdown daytime now.
			time_til_cycle = TIME_BLOODSUCKER_DAY
			message_admins("BLOODSUCKER NOTICE: Daylight Beginning (Lasts for [DisplayTimeText(TIME_BLOODSUCKER_DAY * 1 SECONDS)])")
			warn_daylight(
				danger_level = DANGER_LEVEL_SOL_ROSE,
				vampire_warning_message = span_userdanger("Solar flares bombard the station with deadly UV light! Stay in cover for the next [DisplayTimeText(TIME_BLOODSUCKER_DAY * 1 SECONDS)] or risk Final Death!"),
				vassal_warning_message = span_userdanger("Solar flares bombard the station with UV light!"),
			)

/datum/bloodsucker_sunlight/proc/warn_daylight(danger_level, vampire_warning_message, vassal_warning_message)
	for(var/datum/antagonist/bloodsucker/vamp as anything in resolve_tracked(tracked_bloodsuckers))
		if(!QDELETED(vamp))
			vamp.give_warning(danger_level, vampire_warning_message, vassal_warning_message)
	for(var/datum/antagonist/vassal/vassal as anything in resolve_tracked(tracked_vassals))
		if(!QDELETED(vassal))
			vassal.give_warning(danger_level, vampire_warning_message, vassal_warning_message)

///Restarts the Sol countdown from a fresh night. Used when the last Bloodsucker leaves, so the next one doesn't inherit a half-finished cycle.
/datum/bloodsucker_sunlight/proc/reset_cycle()
	time_til_cycle = TIME_BLOODSUCKER_NIGHT
	issued_XP = FALSE

#undef TIME_BLOODSUCKER_SOL_DELAY

#undef TIME_BLOODSUCKER_DAY
#undef TIME_BLOODSUCKER_NIGHT
#undef TIME_BLOODSUCKER_DAY_WARN
#undef TIME_BLOODSUCKER_DAY_FINAL_WARN
#undef TIME_BLOODSUCKER_BURN_INTERVAL

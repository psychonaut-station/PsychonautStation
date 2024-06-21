/datum/tgs_chat_command/validated/time_dilation
	name = "tidi"
	help_text = "Gets the time dilation"
	admin_only = FALSE
	required_rights = R_NONE

/datum/tgs_chat_command/validated/time_dilation/Validated_Run(datum/tgs_chat_user/sender, params)
	var/current = round(SStime_track.time_dilation_current, 1)
	var/avg_fast = round(SStime_track.time_dilation_avg_fast, 1)
	var/avg = round(SStime_track.time_dilation_avg, 1)
	var/avg_slow = round(SStime_track.time_dilation_avg_slow, 1)

	return new /datum/tgs_message_content("Time Dilation: [current]% AVG:([avg_fast]%, [avg]%, [avg_slow]%)")

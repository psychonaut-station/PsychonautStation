/datum/tgs_chat_command/validated/tidi
	name = "tidi"
	help_text = "Gets the time dilation"
	required_rights = R_DEBUG
	admin_only = FALSE

/datum/tgs_chat_command/validated/tidi/Validated_Run(datum/tgs_chat_user/sender, params)
	var/message_body = "Time Dilation: [round(SStime_track.time_dilation_current,1)]% \
						AVG:([round(SStime_track.time_dilation_avg_fast,1)]%, \
						[round(SStime_track.time_dilation_avg,1)]%, \
						[round(SStime_track.time_dilation_avg_slow,1)]%)"

	return new /datum/tgs_message_content(message_body)

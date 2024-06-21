/datum/tgs_chat_command/validated/master_controller
	name = "mc"
	help_text = "Master Controller status"
	admin_only = FALSE
	required_rights = R_NONE

/datum/tgs_chat_command/validated/master_controller/Validated_Run(datum/tgs_chat_user/sender, params)
	var/message_body = "\
		CPU: [world.cpu]\n\
		Instances: [num2text(world.contents.len, 10)]\n\
		World Time: [world.time]\n\
		Byond: (FPS:[world.fps]) (TickCount:[world.time/world.tick_lag]) (TickDrift:[round(Master.tickdrift,1)]([round((Master.tickdrift/(world.time/world.tick_lag))*100,0.1)]%)) (Internal Tick Usage: [round(MAPTICK_LAST_INTERNAL_TICK_USAGE,0.1)]%)\n\
		Runtimes: [GLOB.total_runtimes]/[GLOB.total_runtimes_skipped]"

	if (SSgarbage)
		message_body += "\nSSgarbage: TD: [SSgarbage.totaldels], TG: [SSgarbage.totalgcs], Q: [SSgarbage.queues.len]"

	return new /datum/tgs_message_content(message_body)

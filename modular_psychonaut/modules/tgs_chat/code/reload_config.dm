/datum/tgs_chat_command/validated/reload_config
	name = "reload_config"
	help_text = "Reloads config"
	admin_only = FALSE
	required_rights = R_DEBUG | R_SERVER

/datum/tgs_chat_command/validated/reload_config/Validated_Run(datum/tgs_chat_user/sender, params)
	if (!config)
		return new /datum/tgs_message_content("Game is not ready yet.")

	config.full_wipe()
	config.Load(world.params[OVERRIDE_CONFIG_DIRECTORY_PARAMETER])
	log_admin("[sender.friendly_name] has forcefully reloaded the configuration from disk.")
	message_admins("[sender.friendly_name] has forcefully reloaded the configuration from disk.")

	return new /datum/tgs_message_content("Reloaded config")

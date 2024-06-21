/datum/tgs_chat_command/validated/toggle_cdn
	name = "toggle_cdn"
	help_text = "Toggle CDN on/off"
	admin_only = FALSE
	required_rights = R_DEBUG | R_SERVER

/datum/tgs_chat_command/validated/toggle_cdn/Validated_Run(datum/tgs_chat_user/sender, params)
	if (!SSassets)
		return new /datum/tgs_message_content("Game is not ready yet.")

	var/new_transport = "simple"
	var/current_transport = CONFIG_GET(string/asset_transport)
	if (!current_transport || current_transport == "simple")
		new_transport = "webroot"
	else
		new_transport = "simple"

	CONFIG_SET(string/asset_transport, new_transport)
	SSassets.OnConfigLoad()

	if (SSassets.transport.validate_config())
		message_admins("[sender.friendly_name] has changed asset transport to [new_transport].")
		log_admin("[sender.friendly_name] has changed asset transport to [new_transport].")
		return new /datum/tgs_message_content("Asset transport is set to [new_transport].")
	else
		message_admins("[sender.friendly_name] tried to change asset transport to [new_transport] but failed.")
		log_admin("[sender.friendly_name] tried to change asset transport to [new_transport] but failed.")
		return new /datum/tgs_message_content("Cannot change asset transport! Check asset log.")

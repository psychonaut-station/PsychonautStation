/datum/smite/randomise_voicepack
	name = "Randomise voicepack"

/datum/smite/randomise_voicepack/effect(client/user, mob/living/carbon/human/target)
	. = ..()
	target.get_bark_voice().randomise(target)

ADMIN_VERB(togglebark, R_SERVER, "Toggle Barks", "Toggles atom talk sounds.", ADMIN_CATEGORY_SERVER)
	GLOB.voices_enabled = !GLOB.voices_enabled
	to_chat(world, span_notice("<B>Vocal barks have been globally [GLOB.voices_enabled ? "enabled" : "disabled"].</B>"))

	log_admin("[key_name(user)] toggled Voice Barks.")
	message_admins("[key_name_admin(user)] toggled Voice Barks.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Voice Bark", "[GLOB.voices_enabled ? "Enabled" : "Disabled"]"))

ADMIN_VERB(reload_voice_packs_file, R_SERVER, "Reload Bark Packs", "Reloads the bark packs from configuration.", ADMIN_CATEGORY_SERVER)
	GLOB.voice_pack_groups_visible = list()
	GLOB.voice_pack_groups_all = list()
	GLOB.random_voice_packs = list()
	GLOB.voice_pack_list = gen_voice_packs()

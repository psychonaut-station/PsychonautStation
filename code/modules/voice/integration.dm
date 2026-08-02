/mob/living/carbon/human/Initialize(mapload)
	. = ..()
	if(!client && !bark_voice)
		bark_voice = new()
		bark_voice.randomise(src)

/mob/living/basic/cow/initial_voice_pack_id()
	return "talk.cow"

/datum/changeling_profile
	var/datum/atom_voice/bark_voice

/datum/antagonist/changeling/create_profile(mob/living/carbon/human/target, protect = 0)
	. = ..()
	var/datum/changeling_profile/new_profile = .
	new_profile.bark_voice = new()
	new_profile.bark_voice.copy_from(target.get_bark_voice())

/datum/antagonist/changeling/transform(mob/living/carbon/human/user, datum/changeling_profile/chosen_profile)
	. = ..()
	user.get_bark_voice().copy_from(chosen_profile.bark_voice)

/datum/smite/normalvoicepack
	name = "Normalise voicepack"

/datum/smite/normalvoicepack/effect(client/user, mob/living/carbon/human/target)
	. = ..()
	target.get_bark_voice().randomise(target)

ADMIN_VERB(togglebark, R_SERVER, "Toggle Voices", "Toggles atom talk sounds.", ADMIN_CATEGORY_SERVER)
	GLOB.voices_enabled = !GLOB.voices_enabled
	to_chat(world, span_notice("<B>Vocal barks have been globally [GLOB.voices_enabled ? "enabled" : "disabled"].</B>"))

	log_admin("[key_name(user)] toggled Voice Barks.")
	message_admins("[key_name_admin(user)] toggled Voice Barks.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Voice Bark", "[GLOB.voices_enabled ? "Enabled" : "Disabled"]"))

ADMIN_VERB(reload_voice_packs_file, R_SERVER, "Reload Voice Packs", "Reloads the voice packs from configuration.", ADMIN_CATEGORY_SERVER)
	GLOB.voice_pack_groups_visible = list()
	GLOB.voice_pack_groups_all = list()
	GLOB.random_voice_packs = list()
	GLOB.voice_pack_list = gen_voice_packs()

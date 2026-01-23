#define CANCEL_FAKE_ALERT -1

/datum/hallucination/station_message
	abstract_hallucination_parent = /datum/hallucination/station_message
	random_hallucination_weight = 1
	hallucination_tier = HALLUCINATION_TIER_RARE
	/// if TRUE, skip on deaf hallucinators
	var/require_hearing = TRUE

/datum/hallucination/station_message/start()
	if(require_hearing && !hallucinator.can_hear())
		return FALSE
	if(do_fake_alert() == CANCEL_FAKE_ALERT)
		return FALSE

	qdel(src) // To be implemented by subtypes, call parent for easy cleanup
	return TRUE

/datum/hallucination/station_message/proc/do_fake_alert()
	return CANCEL_FAKE_ALERT

<<<<<<< HEAD
/datum/hallucination/station_message/blob_alert/start()
	priority_announce("[locale_suffix_locative(station_name())] 5. seviye biyolojik tehdit olduğu doğrulandı. Tüm personeller tehditi kontrol altına almalıdır.", \
		"Biyolojik Tehlike Uyarısı", ANNOUNCER_OUTBREAK5, players = list(hallucinator))
	return ..()
=======
/datum/hallucination/station_message/blob_alert
	require_hearing = TRUE

/datum/hallucination/station_message/blob_alert/do_fake_alert()
	priority_announce("Confirmed outbreak of level 5 biohazard aboard [station_name()]. All personnel must contain the outbreak.", \
		"Biohazard Alert", ANNOUNCER_OUTBREAK5, players = list(hallucinator))
>>>>>>> 37199d7f7fead421df1352f3d2ed876949db1c4d

/datum/hallucination/station_message/shuttle_dock

/datum/hallucination/station_message/shuttle_dock/do_fake_alert()
	priority_announce(
<<<<<<< HEAD
					text = "[SSshuttle.emergency] istasyona yanaştı. Acil durum mekiğine binmek için [DisplayTimeText(SSshuttle.emergency_dock_time)] kadar vaktiniz var.",
					title = "Acil Durum Mekiği Yanaştı",
					sound = ANNOUNCER_SHUTTLEDOCK,
					sender_override = "Acil Durum Mekiği Uyarısı",
					players = list(hallucinator),
					color_override = "orange",
				)
	return ..()
=======
		text = "[SSshuttle.emergency] has docked with the station. You have [DisplayTimeText(SSshuttle.emergency_dock_time)] to board the emergency shuttle.",
		title = "Emergency Shuttle Arrival",
		sound = ANNOUNCER_SHUTTLEDOCK,
		sender_override = "Emergency Shuttle Uplink Alert",
		players = list(hallucinator),
		color_override = "orange",
	)
>>>>>>> 37199d7f7fead421df1352f3d2ed876949db1c4d

/datum/hallucination/station_message/malf_ai
	require_hearing = TRUE

/datum/hallucination/station_message/malf_ai/do_fake_alert()
	if(!(locate(/mob/living/silicon/ai) in GLOB.silicon_mobs))
		return CANCEL_FAKE_ALERT

<<<<<<< HEAD
	priority_announce("Tüm istasyon sistemlerinde saldırgan program hataları tespit edildi. Davranış modülüne gelebilecek olası hasarı önlemek için lütfen AI'ı devre dışı bırakın.", \
		"Anomali Uyarısı", ANNOUNCER_AIMALF, players = list(hallucinator))
	return ..()
=======
	priority_announce("Hostile runtimes detected in all station systems, please deactivate your AI to prevent possible damage to its morality core.", \
		"Anomaly Alert", ANNOUNCER_AIMALF, players = list(hallucinator))
>>>>>>> 37199d7f7fead421df1352f3d2ed876949db1c4d

/datum/hallucination/station_message/heretic
	require_hearing = TRUE
	/// This is gross and will probably easily be outdated in some time but c'est la vie.
	/// Maybe if someone datumizes heretic paths or something this can be improved
	var/static/list/ascension_bodies = list(
		list(
			"text" = "Fear the blaze, for the Ashlord, %FAKENAME% has ascended! The flames shall consume all!",
			"sound" = 'sound/music/antag/heretic/ascend_blade.ogg',
		),
		list(
			"text" = "Master of blades, the Torn Champion's disciple, %FAKENAME% has ascended! Their steel is that which will cut reality in a maelstom of silver!",
			"sound" = 'sound/music/antag/heretic/ascend_blade.ogg',
		),
		list(
			"text" = "Ever coiling vortex. Reality unfolded. ARMS OUTREACHED, THE LORD OF THE NIGHT, %FAKENAME% has ascended! Fear the ever twisting hand!",
			"sound" = 'sound/music/antag/heretic/ascend_flesh.ogg',
		),
		list(
			"text" = "Fear the decay, for the Rustbringer, %FAKENAME% has ascended! None shall escape the corrosion!",
			"sound" = 'sound/music/antag/heretic/ascend_rust.ogg',
		),
		list(
			"text" = "The nobleman of void %FAKENAME% has arrived, stepping along the Waltz that ends worlds!",
			"sound" = 'sound/music/antag/heretic/ascend_void.ogg',
		)
	)

/datum/hallucination/station_message/heretic/do_fake_alert()
	// Unfortunately, this will not be synced if mass hallucinated
	var/mob/living/carbon/human/totally_real_heretic = random_non_sec_crewmember()
	if(!totally_real_heretic)
		return CANCEL_FAKE_ALERT

	var/list/fake_ascension = pick(ascension_bodies)
	var/announcement_text = replacetext(fake_ascension["text"], "%FAKENAME%", totally_real_heretic.real_name)
	priority_announce(
		text = "[generate_heretic_text()] [announcement_text] [generate_heretic_text()]",
		title = "[generate_heretic_text()]",
		sound = fake_ascension["sound"],
		players = list(hallucinator),
		color_override = "pink",
	)

/datum/hallucination/station_message/cult_summon
	require_hearing = TRUE

/datum/hallucination/station_message/cult_summon/do_fake_alert()
	// Same, will not be synced if mass hallucinated
	var/mob/living/carbon/human/totally_real_cult_leader = random_non_sec_crewmember()
	if(!totally_real_cult_leader)
		return CANCEL_FAKE_ALERT

	// Get a fake area that the summoning is happening in
	var/area/hallucinator_area = get_area(hallucinator)
	var/area/fake_summon_area_type = pick(GLOB.the_station_areas - hallucinator_area.type)
	var/area/fake_summon_area = GLOB.areas_by_type[fake_summon_area_type]

	priority_announce(
		text = "Tanrı katından gelen yaratıklar, [totally_real_cult_leader.real_name] tarafından bilinmeyen bir boyuttan [fake_summon_area] içine çağrılıyor. Ne pahasına olursa olsun ayini bozun!",
		title = "[command_name()] Üst Boyutlu İlişkiler",
		sound = 'sound/music/antag/bloodcult/bloodcult_scribe.ogg',
		has_important_message = TRUE,
		players = list(hallucinator),
	)

/datum/hallucination/station_message/meteors
	random_hallucination_weight = 2
	require_hearing = TRUE

<<<<<<< HEAD
/datum/hallucination/station_message/meteors/start()
	priority_announce("İstasyonla çarpışma rotasında olan meteorlar tespit edildi.", "Meteor Uyarısı", ANNOUNCER_METEORS, players = list(hallucinator))
	return ..()
=======
/datum/hallucination/station_message/meteors/do_fake_alert()
	priority_announce("Meteors have been detected on collision course with the station.", "Meteor Alert", ANNOUNCER_METEORS, players = list(hallucinator))
>>>>>>> 37199d7f7fead421df1352f3d2ed876949db1c4d

/datum/hallucination/station_message/supermatter_delam

/datum/hallucination/station_message/supermatter_delam/do_fake_alert()
	SEND_SOUND(hallucinator, 'sound/effects/magic/charge.ogg')
	to_chat(hallucinator, span_bolddanger("You feel reality distort for a moment..."))

/datum/hallucination/station_message/clock_cult_ark
	// Clock cult's long gone, but this stays for posterity.
	random_hallucination_weight = 0

/datum/hallucination/station_message/clock_cult_ark/start()
	hallucinator.playsound_local(hallucinator, 'sound/machines/clockcult/ark_deathrattle.ogg', 50, FALSE, pressure_affected = FALSE)
	hallucinator.playsound_local(hallucinator, 'sound/effects/clockcult_gateway_disrupted.ogg', 50, FALSE, pressure_affected = FALSE)
	addtimer(CALLBACK(src, PROC_REF(play_distant_explosion_sound)), 2.7 SECONDS)
	return TRUE // does not call parent to finish up the sound in a few seconds

/datum/hallucination/station_message/clock_cult_ark/proc/play_distant_explosion_sound()
	if(QDELETED(src))
		return

	hallucinator.playsound_local(get_turf(hallucinator), 'sound/effects/explosion/explosion_distant.ogg', 50, FALSE, pressure_affected = FALSE)
	qdel(src)

#undef CANCEL_FAKE_ALERT

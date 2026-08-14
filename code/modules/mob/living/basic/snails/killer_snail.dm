
/datum/action/cooldown/spell/list_target/telepathy/killer_snail
	name = "Snail Whisper"
	desc = "Send a strange message directly into someone's mind."
	cooldown_time = 10 SECONDS

/datum/action/cooldown/spell/list_target/telepathy/killer_snail/cast(mob/living/cast_on)
	var/original_message = message
	message = "<font size='10' color='#00FF00'><b>[original_message]</b></font>"

	. = ..()

	message = original_message
	return .

/// The unassuming, unkillable, unstoppable snail. Player-controlled.
/mob/living/basic/snail/angry/killer
	name = "Just a Super Ordinary Snnnnnnail"
	desc = "İstasyondaki bir gerizekalı ölümsüz ve çok zengin olmayı dilediği için bir zamanlar tanrı ona ceza olarak bu salyangozu verdi, tebrikler artık bu salyangoz sizinde sorununuz!!"

	health = 1
	maxHealth = 1

	speed = 20

	melee_damage_lower = 1000
	melee_damage_upper = 1000
	obj_damage = 1000

	var/next_sound = 0

/mob/living/basic/snail/angry/killer/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/wall_tearer, allow_reinforced = TRUE, tear_time = 8 SECONDS)
	add_traits(list(TRAIT_GODMODE), type)

	var/static/list/innate_actions = list(
		/datum/action/cooldown/spell/list_target/telepathy/killer_snail,
	)
	grant_actions_by_list(innate_actions)

/mob/living/basic/snail/angry/killer/proc/send_horror_prompt(mob/living/target)
	var/static/list/horror_prompts = list(
		"You feel the presence of something you really should not be near.",
		"You suddenly feel like you should RUN.",
		"Something is terribly wrong. You cannot explain what.",
		"You feel watched.",
		"Your heart sinks as an inexplicable sense of dread washes over you.",
		"You have the overwhelming feeling that something is approaching.",
		"You feel like you should leave. Now.",
		"Why do you suddenly feel unsafe?",
		"Every instinct in your body tells you to get away.",
		"You feel a presence behind you.",
		"You are suddenly very aware that you are not alone.",
		"Your survival instincts scream at you to RUN.",
		"You get the horrible feeling that something has noticed you.",
		"You cannot shake the feeling that you are being hunted.",
		"You feel a deep, irrational fear settle into your chest.",
		"You don't know why, but you really don't want to look back.",
		"You feel an inexplicable urge to flee."
	)

	to_chat(target, "<font size='8' color='#FF0000'><b>[pick(horror_prompts)]</b></font>")

/mob/living/basic/snail/angry/killer/Life(seconds_per_tick = SSMOBS_DT)
	. = ..()

	if(world.time < next_sound)
		return

	var/sound/chosen_sound = pick(list(
		'sound/effects/magic/voidblink.ogg',
		'sound/effects/magic/swap.ogg',
		'sound/effects/magic/magic_block_mind.ogg',
		'sound/effects/creak/creak1.ogg',
		'sound/effects/creak/creak2.ogg',
		'sound/effects/creak/creak3.ogg',
		'sound/machines/woosh.ogg',
		'sound/machines/wewewew.ogg',
		'sound/ambience/earth_rumble/earth_rumble_distant4.ogg',
		'sound/ambience/earth_rumble/earth_rumble_distant3.ogg',
		'sound/ambience/earth_rumble/earth_rumble_distant2.ogg',
		'sound/ambience/earth_rumble/earth_rumble_distant1.ogg',
		'sound/ambience/icemoon/ambiicesting5.ogg',
		'sound/ambience/icemoon/ambiicesting4.ogg',
		'sound/ambience/maintenance/ambimaint.ogg',
		'sound/ambience/misc/ticking_clock.ogg',
		'sound/effects/hallucinations/over_here1.ogg',
		'sound/music/antag/hypnotized.ogg'
	))

	playsound(src, chosen_sound, 50, TRUE)

	var/light_flickered = prob(40)
	if(light_flickered)
		for(var/obj/machinery/light/nearby_light in range(14, src))
			if(nearby_light.on)
				nearby_light.flicker()

	for(var/mob/living/nearby_mob in get_hearers_in_view(14, src))
		if(nearby_mob == src)
			continue

		var/horror_prompt_trigger = light_flickered

		if(prob(10))
			nearby_mob.adjust_eye_blur(4 SECONDS)
			horror_prompt_trigger = TRUE

		if(prob(10))
			nearby_mob.playsound_local(
				nearby_mob,
				'sound/effects/health/fastbeat.ogg',
				60,
				TRUE,
				channel = CHANNEL_HEARTBEAT,
				use_reverb = FALSE
			)
			horror_prompt_trigger = TRUE

		if(prob(10))
			nearby_mob.adjust_temp_blindness(4 SECONDS)
			horror_prompt_trigger = TRUE

		if(prob(50) && horror_prompt_trigger)
			send_horror_prompt(nearby_mob)

	next_sound = world.time + rand(10, 15) SECONDS

/mob/living/basic/snail/angry/killer/gib(drop_bitflags = NONE)
	if(HAS_TRAIT(src, TRAIT_GODMODE))
		return
	return ..()

/mob/living/basic/snail/angry/killer/proc/kill_victim(mob/living/carbon/human/H)
	if(QDELETED(H) || H.undergoing_cardiac_arrest())
		return

	H.set_heartattack(TRUE)

/mob/living/basic/snail/angry/killer/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	if(!proximity_flag)
		return

	if(ishuman(attack_target))
		var/mob/living/carbon/human/H = attack_target

		if(H.undergoing_cardiac_arrest())
			return TRUE

		do_attack_animation(H)

		H.visible_message(
			span_danger("[H] suddenly clutches at [H.p_their()] chest!"),
			span_userdanger("You feel a terrible pain in your chest. You can't breathe properly...")
		)

		H.losebreath += 4
		H.adjust_eye_blur(4 SECONDS)

		addtimer(CALLBACK(src, PROC_REF(kill_victim), H), 2 SECONDS)

		return TRUE

	return ..()


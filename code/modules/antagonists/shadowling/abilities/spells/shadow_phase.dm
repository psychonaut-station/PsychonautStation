// MARK: Effects
/obj/effect/temp_visual/shadow_phase_smoke
	name = "umbral plume"
	icon = 'icons/effects/eldritch.dmi'
	icon_state = "cloud_swirl"
	plane = ABOVE_GAME_PLANE
	layer = EFFECTS_LAYER
	color = "#015fff"
	alpha = 220

/obj/effect/temp_visual/shadow_phase_smoke/Initialize(mapload)
	. = ..()
	animate(src, transform = matrix() * 1.2, time = 4)
	animate(alpha = 0, time = 6)
	QDEL_IN(src, 0.6 SECONDS)
	return .

// MARK: Ability
/datum/action/cooldown/shadowling/shadow_phase
	name = "Shadow Phase"
	desc = "Become incorporeal and phase through walls for a short duration. Bright light forces you out unless ascended."
	button_icon_state = "shadowling_crawl"
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_INCAPACITATED
	cooldown_time = 30 SECONDS
	requires_dark_user = FALSE
	requires_dark_target = FALSE
	max_range = 0
	channel_time = 0
	min_req = 1
	max_req = 3
	required_thralls = 15
	var/phase_duration = 12 SECONDS
	var/static/sfx_enter = 'sound/effects/magic/teleport_app.ogg'

/datum/action/cooldown/shadowling/shadow_phase/is_action_active(atom/movable/screen/movable/action_button/_btn)
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	if(istype(H.loc, /obj/effect/dummy/phased_mob/shadowling))
		return TRUE
	if(H.has_status_effect(/datum/status_effect/shadow/phase))
		return TRUE
	return FALSE

/datum/action/cooldown/shadowling/shadow_phase/can_use(mob/living/carbon/human/H)
	if(!..())
		return FALSE
	if(!isopenturf(H.loc) && !istype(H.loc, /obj/effect/dummy/phased_mob/shadowling))
		owner.balloon_alert(owner, "cannot use while enclosed")
		return FALSE
	return TRUE

/datum/action/cooldown/shadowling/shadow_phase/Trigger(mob/clicker, trigger_flags, atom/target)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/obj/effect/dummy/phased_mob/shadowling/P = istype(H.loc, /obj/effect/dummy/phased_mob/shadowling) ? H.loc : null
	var/is_in_phase = !!P

	if(!is_in_phase)
		if(!can_use(H))
			return FALSE
		if(channel_time > 0)
			if(!PerformChannel(H, null))
				return FALSE
		if(!enter_phase(H))
			return FALSE
		return TRUE
	else
		exit_phase(H, forced_out = FALSE)
		StartCooldown()
		return TRUE

/datum/action/cooldown/shadowling/shadow_phase/proc/fade_out(mob/living/carbon/human/H, time = 0.3 SECONDS)
	animate(H, alpha = 0, time = time)

/datum/action/cooldown/shadowling/shadow_phase/proc/fade_in(mob/living/carbon/human/H, time = 0.3 SECONDS)
	animate(H, alpha = 255, time = time)

/datum/action/cooldown/shadowling/shadow_phase/proc/_auto_exit_if_still_inside(datum/weakref/P_ref)
	var/obj/effect/dummy/phased_mob/shadowling/P = P_ref?.resolve()
	if(!istype(P))
		return
	if(!P.jaunter)
		return
	var/mob/living/carbon/human/H = P.jaunter
	exit_phase(H, forced_out = FALSE)
	StartCooldown()

/datum/action/cooldown/shadowling/shadow_phase/proc/enter_phase(mob/living/carbon/human/H)
	var/turf/start = get_turf(H)
	if(!start)
		return FALSE

	if(istype(H.loc, /obj/effect/dummy/phased_mob/shadowling))
		to_chat(H, span_warning("You are already dissolved into the shadows."))
		return FALSE

	new /obj/effect/temp_visual/shadow_phase_smoke(start)
	playsound(start, sfx_enter, 65, TRUE)
	fade_out(H, 0.3 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(finish_enter_phase), H, start), 0.3 SECONDS)

/datum/action/cooldown/shadowling/shadow_phase/proc/finish_enter_phase(mob/living/carbon/human/H, turf/start)
	var/obj/effect/dummy/phased_mob/shadowling/P = new(start)
	P.dir = H.dir
	P.light_immunity = isshadowling_ascended(owner)
	P.set_jaunter(H)

	addtimer(CALLBACK(src, PROC_REF(_auto_exit_if_still_inside), WEAKREF(P)), phase_duration)

	to_chat(H, span_notice("You dissolve into the shadows."))

	for(var/datum/action/cooldown/shadowling/shadow_phase/A in owner.actions)
		A.apply_button_overlay()

	for(var/datum/action/cooldown/shadowling/A in owner.actions)
		A.build_all_button_icons(UPDATE_BUTTON_STATUS, TRUE)

	return TRUE

/datum/action/cooldown/shadowling/shadow_phase/proc/exit_phase(mob/living/carbon/human/H, forced_out = FALSE)
	var/turf/end_turf = get_turf(H)
	var/obj/effect/dummy/phased_mob/shadowling/P = H.loc

	if(istype(P))
		P.eject_jaunter(forced_out)

		if(end_turf)
			new /obj/effect/temp_visual/shadow_phase_smoke(end_turf)

		fade_in(H, 0.3 SECONDS)
		to_chat(H, span_notice("You return to physical form."))

		for(var/datum/action/cooldown/shadowling/shadow_phase/A in owner.actions)
			A.apply_button_overlay()

		for(var/datum/action/cooldown/shadowling/A in owner.actions)
			A.build_all_button_icons(UPDATE_BUTTON_STATUS, TRUE)

		return TRUE

	if(end_turf)
		new /obj/effect/temp_visual/shadow_phase_smoke(end_turf)

	fade_in(H, 0.3 SECONDS)
	to_chat(H, span_notice("You return to physical form."))

	for(var/datum/action/cooldown/shadowling/shadow_phase/A in owner.actions)
		A.apply_button_overlay()

	for(var/datum/action/cooldown/shadowling/A in owner.actions)
		A.build_all_button_icons(UPDATE_BUTTON_STATUS, TRUE)

	return TRUE

/datum/action/cooldown/shadowling/shadow_phase/proc/materialize_near(mob/living/carbon/human/H, turf/nearby, forced_out = FALSE)
	if(!istype(H))
		return FALSE

	var/exited = FALSE
	var/turf/end_turf = nearby || get_turf(H)

	if(istype(H.loc, /obj/effect/dummy/phased_mob/shadowling))
		var/obj/effect/dummy/phased_mob/shadowling/P = H.loc
		if(istype(nearby))
			P.forceMove(nearby)
		end_turf = get_turf(P) || nearby
		P.eject_jaunter(forced_out)
		exited = TRUE
	else if(H.has_status_effect(/datum/status_effect/shadow/phase))
		if(istype(nearby))
			H.forceMove(nearby)
		H.remove_status_effect(/datum/status_effect/shadow/phase)
		exited = TRUE

	if(!exited)
		return FALSE

	if(end_turf)
		new /obj/effect/temp_visual/shadow_phase_smoke(end_turf)

	fade_in(H, 0.3 SECONDS)
	to_chat(H, span_notice("You return to physical form."))
	StartCooldown()

	for(var/datum/action/cooldown/shadowling/shadow_phase/A in H.actions)
		A.apply_button_overlay()

	for(var/datum/action/cooldown/shadowling/A in H.actions)
		A.build_all_button_icons(UPDATE_BUTTON_STATUS, TRUE)

	return TRUE

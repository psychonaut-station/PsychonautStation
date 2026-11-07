#define ENTHRALL_OXY_DRAIN 35
#define ENTHRALL_OXY_RESTORE -100

// MARK: Ability
/datum/action/cooldown/shadowling/enthrall
	name = "Enthrall"
	desc = "Subjugate a nearby crewmember in front of you into a thrall of the Hive. Requires darkness."
	button_icon_state = "shadow_enthrall"
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_INCAPACITATED | AB_CHECK_HANDS_BLOCKED | AB_CHECK_OPEN_TURF
	cooldown_time = 45 SECONDS
	required_thralls = 0
	requires_dark_user = TRUE
	requires_dark_target = TRUE
	max_range = 2
	var/enthrall_time = 10 SECONDS
	cancel_on_bright = TRUE

/datum/action/cooldown/shadowling/enthrall/proc/find_cone_target(mob/living/carbon/human/H)
	var/mob/living/best = null
	var/best_dist = 999
	var/best_rank = 999
	for(var/mob/living/T in view(2, H))
		if(T == H)
			continue
		if(!in_front_cone(H, T, 90))
			continue
		if(!is_valid_target(H, T))
			continue
		var/d = get_dist(H, T)
		var/tdir = get_dir(H, T)
		var/rank = (tdir == H.dir) ? 0 : 1
		if(d < best_dist || (d == best_dist && rank < best_rank))
			best = T
			best_dist = d
			best_rank = rank
	return best

/datum/action/cooldown/shadowling/enthrall/proc/is_valid_target(mob/living/carbon/human/H, mob/living/T)
	if(!istype(T))
		return FALSE
	if(T.stat == DEAD)
		owner.balloon_alert(owner, "target is dead")
		return FALSE
	if(!ishuman(T) && !GLOB.shadowling_debug_mode)
		owner.balloon_alert(owner, "invalid target")
		return FALSE
	if(!T.mind)
		if(GLOB.shadowling_debug_mode)
			T.mind_initialize()
		else
			owner.balloon_alert(owner, "target lacks a mind")
			return FALSE
	var/datum/team/shadow_hive/hive = get_shadow_hive()
	if(hive)
		if(T in hive.lings)
			return FALSE
		if(T in hive.thralls)
			return FALSE
	if(has_mindshield(T))
		return FALSE
	return TRUE

/datum/action/cooldown/shadowling/enthrall/proc/has_mindshield(mob/living/T)
	if(!iscarbon(T))
		return FALSE
	var/mob/living/carbon/C = T
	if(islist(C.implants) && (locate(/obj/item/implant/mindshield) in C.implants))
		return TRUE
	return FALSE

/datum/action/cooldown/shadowling/enthrall/DoEffect(mob/living/carbon/human/H, atom/_ignored)
	var/mob/living/T = find_cone_target(H)
	if(!T)
		enable()
		return FALSE

	if(HAS_TRAIT(T, TRAIT_BEING_ENTHRALLED))
		owner.balloon_alert(owner, "victim is already being enthralled")
		return FALSE

	if((!is_dark(H) || !is_dark(T)) && !GLOB.shadowling_debug_mode)
		owner.balloon_alert(owner, "light broke the connection")
		StartCooldown()
		return FALSE

	if(get_dist(H, T) > 2 || !is_valid_target(H, T))
		return FALSE

	if(iscarbon(T))
		var/mob/living/carbon/C = T
		var/obj/item/organ/existing = C.get_organ_slot(ORGAN_SLOT_BRAIN_THRALL)
		if(existing)
			owner.balloon_alert(owner, "already bound to hive")
			to_chat(H, span_notice("[T.real_name] is already bound to the hive."))
			return TRUE

	ADD_TRAIT(T, TRAIT_BEING_ENTHRALLED, REF(src))

	to_chat(H, span_notice("You begin binding [T.real_name]'s mind to the hive. Stand still and remain in the dark..."))
	apply_wibbly_filters(T)
	apply_wibbly_filters(H)
	to_chat(T, span_danger("A freezing darkness envelopes your mind..."))

	var/cast_delay = (GLOB.shadowling_debug_mode ? (1 SECONDS) : enthrall_time)
	var/loops = (GLOB.shadowling_debug_mode ? 1 : 3)
	var/total_drained_oxy = 0

	// 30 second cast (1 loop of 1s in debug mode)
	for(var/i in 1 to loops)
		if(cancel_on_bright && !is_dark(H) && !GLOB.shadowling_debug_mode)
			to_chat(H, span_warning("Light severed the connection."))
			if(total_drained_oxy > 0 && !QDELETED(T))
				T.adjust_oxy_loss(-total_drained_oxy)
			if(!QDELETED(T))
				REMOVE_TRAIT(T, TRAIT_BEING_ENTHRALLED, REF(src))
				remove_wibbly_filters(T)
			remove_wibbly_filters(H)
			return FALSE
		if(QDELETED(T) || T.stat == DEAD || get_dist(H, T) > 2 || has_mindshield(T) || (!is_dark(T) && !GLOB.shadowling_debug_mode))
			to_chat(H, span_warning("Target lost."))
			if(total_drained_oxy > 0 && !QDELETED(T))
				T.adjust_oxy_loss(-total_drained_oxy)
			if(!QDELETED(T))
				REMOVE_TRAIT(T, TRAIT_BEING_ENTHRALLED, REF(src))
				remove_wibbly_filters(T)
			remove_wibbly_filters(H)
			return FALSE
		if(!do_after(H, cast_delay, T))
			to_chat(H, span_warning("Connection broken."))
			if(total_drained_oxy > 0 && !QDELETED(T))
				T.adjust_oxy_loss(-total_drained_oxy)
			if(!QDELETED(T))
				REMOVE_TRAIT(T, TRAIT_BEING_ENTHRALLED, REF(src))
				remove_wibbly_filters(T)
			remove_wibbly_filters(H)
			return FALSE

		T.adjust_oxy_loss(ENTHRALL_OXY_DRAIN)
		total_drained_oxy += ENTHRALL_OXY_DRAIN

	if(QDELETED(T) || T.stat == DEAD || get_dist(H, T) > 2 || ((!is_dark(H) || !is_dark(T)) && !GLOB.shadowling_debug_mode) || has_mindshield(T))
		to_chat(H, span_warning("The enthrallment failed."))
		if(total_drained_oxy > 0 && !QDELETED(T))
			T.adjust_oxy_loss(-total_drained_oxy)
		if(!QDELETED(T))
			REMOVE_TRAIT(T, TRAIT_BEING_ENTHRALLED, REF(src))
			remove_wibbly_filters(T)
		remove_wibbly_filters(H)
		return FALSE

	REMOVE_TRAIT(T, TRAIT_BEING_ENTHRALLED, REF(src))
	T.adjust_oxy_loss(ENTHRALL_OXY_RESTORE)

	if(iscarbon(T))
		var/obj/item/organ/brain/shadow/tumor_thrall/O = new
		if(!O.Insert(T))
			if(GLOB.shadowling_debug_mode)
				T.mind?.add_antag_datum(/datum/antagonist/shadow_thrall)
			else
				qdel(O)
				owner.balloon_alert(owner, "binding failed")
				to_chat(H, span_warning("Failed to bind [T.real_name] to the hive."))
				remove_wibbly_filters(T)
				remove_wibbly_filters(H)
				return FALSE
	else if(GLOB.shadowling_debug_mode)
		T.mind?.add_antag_datum(/datum/antagonist/shadow_thrall)

	if(T.mind)
		var/static/list/conflicting_antags = list(
			/datum/antagonist/cult,
			/datum/antagonist/rev,
			/datum/antagonist/nukeop,
			/datum/antagonist/traitor,
			/datum/antagonist/changeling,
			/datum/antagonist/heretic,
		)
		for(var/antag_type in conflicting_antags)
			T.mind.remove_antag_datum(antag_type)

	to_chat(H, span_notice("You bind the mind of [T.real_name] to the hive."))
	to_chat(T, "<span class='reallybig redtext'>A terrifying darkness crashes into your subconscious, obliterating your former identity. All prior allegiances, oaths, and loyalties are entirely meaningless. Your soul belongs wholly to the Shadowling Hive — you will obey and protect your masters without hesitation!</span>")
	remove_wibbly_filters(T)
	remove_wibbly_filters(H)
	return TRUE

#undef ENTHRALL_OXY_DRAIN
#undef ENTHRALL_OXY_RESTORE

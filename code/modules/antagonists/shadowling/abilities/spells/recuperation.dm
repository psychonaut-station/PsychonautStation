/datum/action/cooldown/shadowling/recuperation
	name = "Shadow Recuperation"
	desc = "Channel dark power into a living thrall (within 1 tile and in darkness) to elevate them into a Lesser Shadowling."
	button_icon_state = "shadow_recuperation"
	cooldown_time = 50 SECONDS
	channel_time = 10 SECONDS
	click_to_activate = TRUE
	unset_after_click = TRUE

	var/targeting = FALSE
	var/datum/beam/current_beam
	var/obj/structure/shadowling_cocoon/cover
	var/prev_alpha

	var/static/sfx_start = 'sound/effects/splat.ogg'
	var/static/sfx_end = 'sound/effects/ghost.ogg'

/datum/action/cooldown/shadowling/recuperation/is_action_active(atom/movable/screen/movable/action_button/_btn)
	return targeting

/datum/action/cooldown/shadowling/recuperation/unset_click_ability(mob/on_who, refund_cooldown)
	. = ..()
	targeting = FALSE
	apply_button_overlay()

/datum/action/cooldown/shadowling/recuperation/set_click_ability(mob/on_who, refund_cooldown)
	. = ..()
	targeting = TRUE
	apply_button_overlay()

/datum/action/cooldown/shadowling/recuperation/DoEffect(mob/living/carbon/human/H, atom/target)
	to_chat(H, span_notice("Click on a living thrall within 1 tile and in darkness to elevate them."))
	return FALSE

/datum/action/cooldown/shadowling/recuperation/InterceptClickOn(mob/living/clicker, params, atom/target)
	if(!istype(clicker))
		unset_click_ability(clicker, TRUE)
		return FALSE

	if(!IsAvailable(TRUE))
		unset_click_ability(clicker, TRUE)
		return FALSE

	if(!can_use(clicker))
		unset_click_ability(clicker, TRUE)
		return FALSE

	var/datum/team/shadow_hive/hive = get_shadow_hive()
	if(!hive)
		unset_click_ability(clicker, TRUE)
		return FALSE

	if(!ishuman(target))
		clicker.balloon_alert(clicker, "invalid target")
		unset_click_ability(clicker, TRUE)
		return FALSE

	var/mob/living/carbon/human/T = target

	if(get_dist(clicker, T) > 1)
		clicker.balloon_alert(clicker, "too far")
		unset_click_ability(clicker, TRUE)
		return FALSE

	if((!is_dark(clicker) || !is_dark(T)) && !GLOB.shadowling_debug_mode)
		clicker.balloon_alert(clicker, "too bright")
		unset_click_ability(clicker, TRUE)
		return FALSE

	if(!(T in hive.thralls) || (!T.get_organ_slot(ORGAN_SLOT_BRAIN_THRALL) && !GLOB.shadowling_debug_mode))
		clicker.balloon_alert(clicker, "requires a thrall")
		unset_click_ability(clicker, TRUE)
		return FALSE

	if(T in hive.lings)
		clicker.balloon_alert(clicker, "already a shadowling")
		unset_click_ability(clicker, TRUE)
		return FALSE

	StartCooldown()

	start_beam(clicker, T)
	attach_cover(T)
	prev_alpha = T.alpha
	T.alpha = 0

	var/start_loc = T.loc
	var/cast_time = (GLOB.shadowling_debug_mode ? (1 SECONDS) : channel_time)
	if(!do_after(clicker, cast_time, T))
		stop_beam()
		detach_cover(T)
		if(!QDELETED(T))
			T.alpha = prev_alpha
		unset_click_ability(clicker, TRUE)
		return FALSE

	if(QDELETED(T) || T.loc != start_loc || get_dist(clicker, T) > 1)
		stop_beam()
		detach_cover(T)
		if(!QDELETED(T))
			T.alpha = prev_alpha
		unset_click_ability(clicker, TRUE)
		return FALSE

	var/obj/item/organ/brain/shadow/tumor_thrall/old_tumor = T.get_organ_slot(ORGAN_SLOT_BRAIN_THRALL)
	if(old_tumor)
		old_tumor.mob_remove(T, special = TRUE)
		qdel(old_tumor)

	T.shadowling_strip_quirks()
	T.reset_robotic_limbs()
	T.set_species(/datum/species/shadow/shadowling)

	for(var/datum/action/cooldown/ability in T.actions.Copy())
		if(ability.type in typesof(/datum/action/cooldown/shadowling))
			ability.Remove(T)

	T.mind?.remove_antag_datum(/datum/antagonist/shadow_thrall)
	var/datum/antagonist/shadowling/new_antag = T.mind?.add_antag_datum(/datum/antagonist/shadowling)
	if(new_antag)
		new_antag.ling_role = SHADOWLING_ROLE_LESSER
		new_antag.is_thrall = FALSE

	// Make our thrall a lesser Shadowling
	hive.join_member(T, SHADOWLING_ROLE_LESSER)

	to_chat(clicker, span_notice("You infuse the essence of [T.real_name] with shadows — they rise as a Lesser Shadowling."))
	to_chat(T, span_danger("The darkness rewrites your flesh and mind... You have become a Lesser Shadowling!"))
	playsound(get_turf(T), sfx_end, 65, TRUE)

	stop_beam()
	detach_cover(T)
	if(!QDELETED(T))
		T.alpha = prev_alpha
	unset_click_ability(clicker, FALSE)
	return TRUE

/datum/action/cooldown/shadowling/recuperation/proc/attach_cover(mob/living/carbon/human/T)
	if(cover)
		return
	cover = new /obj/structure/shadowling_cocoon(get_turf(T))

/datum/action/cooldown/shadowling/recuperation/proc/detach_cover(mob/living/carbon/human/T)
	if(!cover)
		return
	qdel(cover)
	cover = null

/datum/action/cooldown/shadowling/recuperation/proc/start_beam(mob/living/source, mob/living/target)
	stop_beam()
	current_beam = source.Beam(
		BeamTarget = target,
		icon = 'icons/mob/antagonists/shadowling/shadowling_objects.dmi',
		icon_state = "shadow_grabber",
		time = channel_time,
		maxdistance = 2,
		emissive = FALSE
	)

/datum/action/cooldown/shadowling/recuperation/proc/stop_beam()
	if(current_beam && !QDELETED(current_beam))
		qdel(current_beam)
	current_beam = null

/datum/action/cooldown/shadowling/recuperation/Destroy()
	stop_beam()
	return ..()

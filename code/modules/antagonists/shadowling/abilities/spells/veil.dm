// MARK: Effects
/obj/effect/temp_visual/circle_wave/shadow_veil
	color = "#5a3a7e"
	max_alpha = 200
	duration = 0.6 SECONDS
	amount_to_scale = 6

// MARK: Ability
/datum/action/cooldown/shadowling/veil
	name = "Shadow Veil"
	desc = "Harness umbral darkness. Left-Click to extinguish lights and disable APCs nearby (Veil). Right-Click to emit a cloud of shadow smoke that heals allies and blinds enemies (Smoke)."
	button_icon_state = "shadow_veil"
	cooldown_time = 25 SECONDS
	min_req = 1
	max_req = 10
	required_thralls = 0
	var/dark_square_radius = 4
	var/shroom_square_radius = 2
	var/blind_duration = 3 SECONDS
	var/smoke_radius = 4
	var/smoke_ticks = 6
	var/heal_amount = 10
	var/smoke_blind_time = 5 SECONDS
	var/smoke_stun_chance = 25
	var/smoke_stun_time = 2 SECONDS
	var/static/sfx_emp = 'sound/effects/empulse.ogg'

/datum/action/cooldown/shadowling/veil/Trigger(mob/clicker, trigger_flags, atom/target)
	if(!istype(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	if(!can_use(H))
		return FALSE

	var/use_smoke = (trigger_flags & TRIGGER_SECONDARY_ACTION) ? TRUE : FALSE
	if(use_smoke)
		return do_smoke(H)
	return do_veil(H)

/datum/action/cooldown/shadowling/veil/proc/do_smoke(mob/living/carbon/human/H)
	var/datum/antagonist/shadowling/antag_datum = H?.mind?.has_antag_datum(/datum/antagonist/shadowling)
	var/ascended = (antag_datum?.is_ascended || isshadowling_ascended(H))
	var/datum/team/shadow_hive/hive = get_shadow_hive()
	var/thrall_count = hive ? hive.count_max_thralls() : 0
	var/req_thralls = hive ? ceil(hive.get_ascension_thralls_needed() * 0.5) : 8

	if(!ascended && !GLOB.shadowling_debug_mode && (thrall_count < req_thralls))
		H.balloon_alert(H, "smoke requires 50% thralls ([thrall_count]/[req_thralls])")
		return FALSE

	var/turf/T = get_turf(H)
	if(!T)
		return FALSE

	playsound(T, 'sound/effects/smoke.ogg', 50, TRUE, -3)
	shadow_spawn_smoke(T, H, smoke_radius, smoke_ticks, heal_amount, smoke_blind_time, smoke_stun_chance, smoke_stun_time)
	to_chat(H, span_notice("You exhale a surging shroud of shadow smoke!"))
	button_icon_state = "shadow_smoke"
	build_all_button_icons(UPDATE_BUTTON_ICON, force = TRUE)
	StartCooldown()
	return TRUE

/datum/action/cooldown/shadowling/veil/proc/do_veil(mob/living/carbon/human/H)
	var/turf/center = get_turf(H)
	if(!center)
		return FALSE

	var/list/turfs_shrooms = RANGE_TURFS(shroom_square_radius, H)
	var/list/turfs_dark = RANGE_TURFS(dark_square_radius, H)

	replace_glowshrooms(turfs_shrooms)
	disable_lights_in_area(turfs_dark)
	break_apcs_in_dark(turfs_shrooms)
	weaken_shaded_mobs(turfs_dark, blind_duration)
	damage_synthetics(turfs_dark)

	playsound(center, sfx_emp, 70, TRUE)
	new /obj/effect/temp_visual/circle_wave/shadow_veil(center)

	to_chat(H, span_notice("A shroud of darkness sweeps across the area."))
	button_icon_state = "shadow_veil"
	build_all_button_icons(UPDATE_BUTTON_ICON, force = TRUE)
	StartCooldown()
	return TRUE

/datum/action/cooldown/shadowling/veil/proc/_is_dark(atom/A)
	var/turf/T = get_turf(A)
	if(!T)
		return FALSE
	return (T.get_lumcount() < SHADOWLING_DIM_THRESHOLD)

/datum/action/cooldown/shadowling/veil/proc/disable_lights_in_area(list/turfs)
	if(!islist(turfs))
		return
	for(var/turf/T in turfs)
		for(var/obj/O in T)
			try_disable_light(O)
		for(var/mob/living/L in T)
			disable_lights_on_mob(L)

/datum/action/cooldown/shadowling/veil/proc/try_disable_light(atom/movable/A)
	if(!A)
		return
	if(ispath(A.type, /obj/machinery/power/apc))
		return
	if(istype(A, /obj/item/flashlight/flare))
		var/obj/item/flashlight/flare/F = A
		F.turn_off()
	if(istype(A, /obj/item/flashlight/glowstick))
		var/obj/item/flashlight/glowstick/G = A
		G.turn_off()
	if(istype(A, /obj/item/food/grown/lanternfruit))
		var/obj/item/food/grown/lanternfruit/G = A
		qdel(G)
	A.extinguish()
	if(istype(A, /obj/machinery/light))
		var/obj/machinery/light/L = A
		L.on_saboteur(src, 30 SECONDS)

/datum/action/cooldown/shadowling/veil/proc/break_apcs_in_dark(list/turfs)
	for(var/turf/T in turfs)
		if(!_is_dark(T))
			continue
		for(var/obj/machinery/power/apc/A in T)
			if(QDELETED(A) || !A.cell)
				continue
			A.set_no_charge()

/datum/action/cooldown/shadowling/veil/proc/disable_lights_on_mob(mob/living/L)
	if(!istype(L))
		return
	for(var/obj/item/I in L.contents)
		try_disable_light(I)

/datum/action/cooldown/shadowling/veil/proc/weaken_shaded_mobs(list/turfs, duration)
	var/datum/team/shadow_hive/hive = get_shadow_hive()
	for(var/turf/T in turfs)
		if(!_is_dark(T))
			continue
		for(var/mob/living/carbon/human/M in T)
			if(!M || M.stat == DEAD)
				continue
			if(hive && ((M in hive.lings) || (M in hive.thralls)))
				continue
			M.set_temp_blindness(3 SECONDS)
			M.adjust_staggered(5 SECONDS)
			M.adjust_stamina_loss(50)

/datum/action/cooldown/shadowling/veil/proc/replace_glowshrooms(list/turfs)
	if(!islist(turfs))
		return
	for(var/turf/T in turfs)
		for(var/obj/structure/glowshroom/G in T)
			qdel(G)

/datum/action/cooldown/shadowling/veil/proc/damage_synthetics(list/turfs)
	if(!islist(turfs))
		return
	for(var/turf/T in turfs)
		for(var/obj/vehicle/sealed/mecha/M in T)
			if(QDELETED(M))
				continue
			M.take_damage(50, BRUTE)
		for(var/mob/living/silicon/S in T)
			if(QDELETED(S))
				continue
			S.flash_act(affect_silicon = TRUE)
			S.adjust_brute_loss(50)
		for(var/mob/living/basic/bot/B in T)
			if(QDELETED(B))
				continue
			B.adjust_brute_loss(50)

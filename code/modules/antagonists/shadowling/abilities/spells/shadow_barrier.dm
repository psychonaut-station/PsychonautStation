/datum/action/cooldown/shadowling/shadow_barrier
	name = "Shadow Barrier"
	desc = "Surround yourself in a pulsing umbral shroud that reflects energy projectiles."
	button_icon_state = "shadow_barrier"
	cooldown_time = 40 SECONDS
	requires_dark_user = FALSE
	requires_dark_target = FALSE
	max_range = 0
	channel_time = 0
	min_req = 1
	max_req = 20
	required_thralls = 30
	var/barrier_duration = 5 SECONDS
	var/barrier_active = FALSE
	var/static/sfx_activate = 'sound/effects/magic/teleport_app.ogg'
	var/list/allowed_projectile_typecache

/datum/action/cooldown/shadowling/shadow_barrier/Destroy()
	if(barrier_active && istype(owner, /mob/living/carbon/human))
		end_barrier(WEAKREF(owner))
	return ..()

/datum/action/cooldown/shadowling/shadow_barrier/Trigger(mob/clicker, trigger_flags, atom/target)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H) || !can_use(H))
		return FALSE
	if(channel_time > 0 && !PerformChannel(H, null))
		return FALSE
	if(!allowed_projectile_typecache)
		allowed_projectile_typecache = typecacheof(list(/obj/projectile/beam))

	if(barrier_active)
		end_barrier(WEAKREF(H))

	barrier_active = TRUE
	RegisterSignal(H, COMSIG_ATOM_PRE_BULLET_ACT, PROC_REF(on_barrier_bullet_act))

	H.add_filter("shadow_barrier_aura", 2, outline_filter("color" = LIGHT_COLOR_PURPLE, "size" = 1.5))
	var/the_filter = H.get_filter("shadow_barrier_aura")
	if(the_filter)
		animate(the_filter, alpha = 0)
		animate(the_filter, alpha = 200, time = 1 SECONDS, loop = -1, easing = SINE_EASING)
		animate(alpha = 60, time = 1 SECONDS, loop = -1, easing = SINE_EASING)

	playsound(H, sfx_activate, 65, TRUE)
	to_chat(H, span_notice("You manifest a protective umbral shroud around yourself!"))
	addtimer(CALLBACK(src, PROC_REF(end_barrier), WEAKREF(H)), barrier_duration)
	StartCooldown()
	return TRUE

/datum/action/cooldown/shadowling/shadow_barrier/proc/end_barrier(datum/weakref/owner_ref)
	var/mob/living/carbon/human/H = owner_ref?.resolve()
	barrier_active = FALSE
	if(H)
		UnregisterSignal(H, COMSIG_ATOM_PRE_BULLET_ACT)
		H.remove_filter("shadow_barrier_aura")
		to_chat(H, span_warning("Your umbral shroud dissipates."))

/datum/action/cooldown/shadowling/shadow_barrier/proc/on_barrier_bullet_act(atom/source, obj/projectile/proj)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = source
	if(!H || QDELETED(H) || !proj || QDELETED(proj) || !barrier_active)
		return
	if(!allowed_projectile_typecache[proj.type])
		return
	proj.reflect(H)
	return COMPONENT_BULLET_BLOCKED

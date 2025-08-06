#define DOAFTER_IMPLANTING_HEAD "implanting"

/obj/item/bodypart/head/clock
	name = "clock"
	desc = "A cutting-edge cyberheart, originally designed for Nanotrasen killsquad usage but later declassified for normal research. Voltaic technology allows the heart to keep the body upright in dire circumstances, alongside redirecting anomalous flux energy to fully shield the user from shocks and electro-magnetic pulses. Requires a refined Flux core as a power source."
	icon_state = "anomalock_heart"
	/*beat_noise = "an astonishing <b>BZZZ</b> of immense electrical power"*/

	var/obj/item/assembly/signaler/anomaly/core
	var/required_anomaly = /obj/item/assembly/signaler/anomaly/bioscrambler
	var/prebuilt = FALSE
	var/core_removable = TRUE

	var/lightning_overlay
	var/lightning_timer

/obj/item/bodypart/head/clock/Destroy() 	/* Destroy DONE */
	QDEL_NULL(core)
	return ..()

/obj/item/bodypart/head/clock/on_adding(mob/living/carbon/organ_owner) /*tak DONE*/
	if(!core)
		return
	add_lightning_overlay(30 SECONDS)
	playsound(organ_owner, 'sound/items/eshield_recharge.ogg', 40)
	organ_owner.AddElement(/datum/element/empprotection, EMP_PROTECT_SELF|EMP_PROTECT_CONTENTS)
	RegisterSignal(organ_owner, COMSIG_ATOM_EMP_ACT, PROC_REF(on_emp_act))
	organ_owner.apply_status_effect(/datum/status_effect/clock_rewind)

/obj/item/bodypart/head/clock/on_removal(mob/living/carbon/old_owner)/*çıkar DONE*/
	. = ..()
	if(!core)
		return
	organ_owner.RemoveElement(/datum/element/empprotection, EMP_PROTECT_SELF|EMP_PROTECT_CONTENTS)
	organ_owner.remove_status_effect(/datum/status_effect/clock_rewind)
	tesla_zap(source = organ_owner, zap_range = 20, power = 2.5e5, cutoff = 1e3)
	qdel(src)

/obj/item/bodypart/head/clock/proc/on_emp_act(severity) /*emp animasyon reaksiyon DONE*/
	SIGNAL_HANDLER
	add_lightning_overlay(10 SECONDS)


/obj/item/bodypart/head/clock/proc/add_lightning_overlay(time_to_last = 10 SECONDS
	if(lightning_overlay)
		lightning_timer = addtimer(CALLBACK(src, PROC_REF(clear_lightning_overlay)), time_to_last, (TIMER_UNIQUE|TIMER_OVERRIDE))
		return
	lightning_overlay = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "lightning")
	owner.add_overlay(lightning_overlay)
	lightning_timer = addtimer(CALLBACK(src, PROC_REF(clear_lightning_overlay)), time_to_last, (TIMER_UNIQUE|TIMER_OVERRIDE))

/obj/item/bodypart/head/clock/proc/clear_lightning_overlay()
	owner.cut_overlay(lightning_overlay)
	lightning_overlay = null

/obj/item/bodypart/head/clock/attack_self(mob/user, modifiers)
	. = ..()
	if(.)
		return

	// Check if we have a core installed
	if(!core)
		balloon_alert(user, "no core installed!")
		return

	// // Check if user is carbon-based // 																						@ragnarok
	// if(!iscarbon(user))
	// 	balloon_alert(user, "incompatible biology!")
	// 	return

	balloon_alert(user, "attaching clockwork head...")

	if(!do_after(user, 1 SECONDS, target = user, extra_checks = CALLBACK(src, PROC_REF(can_still_attach), user)))
		balloon_alert(user, "attachment interrupted!")
		return

	// Attempt to attach the head
	if(try_attach_limb(user))
		balloon_alert(user, "head attached successfully!")
		playsound(user, 'sound/items/eshield_recharge.ogg', 50)
	else
		balloon_alert(user, "attachment failed!")

/obj/item/bodypart/head/clock/proc/can_still_attach(mob/user)
    return core

/obj/item/bodypart/head/clock/item_interaction(mob/living/user, obj/item/tool, list/modifiers) /*core takma*/
	if(!istype(tool, required_anomaly))
		return NONE
	if(core)
		balloon_alert(user, "core already in!")
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(tool, src))
		return ITEM_INTERACT_BLOCKING
	core = tool
	balloon_alert(user, "core installed")
	playsound(src, 'sound/machines/click.ogg', 30, TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/item/bodypart/head/clock/screwdriver_act(mob/living/user, obj/item/tool) /* core çıkarma*/
	. = ..()
	if(!core)
		balloon_alert(user, "no core!")
		return
	if(!core_removable)
		balloon_alert(user, "can't remove core!")
		return
	balloon_alert(user, "removing core...")
	if(!do_after(user, 3 SECONDS, target = src))
		balloon_alert(user, "interrupted!")
		return
	balloon_alert(user, "core removed")
	core.forceMove(drop_location())
	if(Adjacent(user) && !issilicon(user))
		user.put_in_hands(core)
	core = null


/obj/item/bodypart/head/clock/prebuilt/Initialize(mapload)
	. = ..()
	core = new /obj/item/assembly/signaler/anomaly/bioscrambler(src)


#undef DOAFTER_IMPLANTING_HEAD

/obj/item/syndicate_teleporter
	var/list/charge_timers = list()
	var/charge_time = 25 SECONDS

/obj/item/syndicate_teleporter/proc/use_charge(mob/user)
	charges = max(charges - 1, 0)
	to_chat(user, span_notice("You use [src]. It now has [charges] charge[charges == 1 ? "" : "s"] remaining."))
	charge_timers.Add(addtimer(CALLBACK(src, PROC_REF(recharge)), charge_time, TIMER_STOPPABLE))

/obj/item/syndicate_teleporter/proc/recharge(mob/user)
	charges = min(charges+1, max_charges)
	charge_timers.Remove(charge_timers[1])

	if(ishuman(loc))
		var/mob/living/carbon/human/holder = loc
		balloon_alert(holder, "teleporter beeps")
	playsound(src, 'sound/machines/beep/twobeep.ogg', 10, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_distance = 0)

/obj/effect/anomaly/time
	name = "time anomaly"
	icon_state = "time"
	aSignal = /obj/item/assembly/signaler/anomaly/time
	density = FALSE
	COOLDOWN_DECLARE(pulse_cooldown)

	var/pulse_delay = 15 SECONDS

	var/range = 10

/obj/effect/anomaly/time/anomalyEffect(seconds_per_tick)
	. = ..()
	if(!COOLDOWN_FINISHED(src, pulse_cooldown))
		return

	COOLDOWN_START(src, pulse_cooldown, pulse_delay)
	for(var/mob/living/carbon/nearby in range(range, src))
		new /obj/effect/timestop(get_turf(nearby), null, null, null)

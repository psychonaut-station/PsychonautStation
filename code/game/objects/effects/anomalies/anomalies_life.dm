
/obj/effect/anomaly/life
	name = "life anomaly"
	icon_state = "life"
	aSignal = /obj/item/assembly/signaler/anomaly/life
	density = FALSE
	COOLDOWN_DECLARE(pulse_cooldown)
	/// How many seconds between each anomaly pulses
	var/pulse_delay = 30 SECONDS
	/// Range of the anomaly pulse
	var/range = 10

/obj/effect/anomaly/life/anomalyEffect(seconds_per_tick)
	. = ..()
	if(!COOLDOWN_FINISHED(src, pulse_cooldown))
		return

	COOLDOWN_START(src, pulse_cooldown, pulse_delay)
	for(var/mob/living/carbon/nearby in range(range, src))
		nearby.apply_damage_type(50, STAMINA)

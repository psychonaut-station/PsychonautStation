
/obj/effect/anomaly/time
	name = "time anomaly"
	icon_state = "time"
	aSignal = /obj/item/assembly/signaler/anomaly/time
	immortal = TRUE
	
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

/obj/effect/anomaly/time/proc/relocate()
    var/datum/anomaly_placer/placer = new()
    var/area/new_area = placer.findValidArea()
    var/turf/new_turf = placer.findValidTurf(new_area)

    priority_announce("Time instability relocated. Expected location: [new_area.name].", "Anomaly Alert")
    src.forceMove(new_turf)
    prepare_area() 
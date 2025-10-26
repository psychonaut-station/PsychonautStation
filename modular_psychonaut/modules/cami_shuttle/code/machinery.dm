#define LUXURY_MESSAGE_COOLDOWN 100

/obj/machinery/scanner_gate/cami_shuttle
	name = "İman kontrol kapısı"
	desc = "Temizlik imandan gelir."
	density = FALSE
	locked = TRUE
	use_power = NO_POWER_USE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	speech_span = SPAN_ROBOT
	var/check_times

/obj/machinery/scanner_gate/cami_shuttle/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	set_scanline("scanning", 10)
	if(isvehicle(mover))
		return FALSE
	if(ishuman(mover))
		var/mob/living/carbon/human/H = mover
		if(H.shoes)
			return FALSE
	if(isliving(mover))
		say("Hoşgeldin muhterem")
	return TRUE

/obj/machinery/scanner_gate/cami_shuttle/Bumped(atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(H.shoes)
			alarm_beep()
			if(!check_times|| check_times < world.time)
				say("Ayakkabıları çıkartalım")
				check_times = world.time + LUXURY_MESSAGE_COOLDOWN
	else if(isvehicle(AM))
		alarm_beep()
		if(!check_times|| check_times < world.time)
			say("Onunla girilir mi abicim!")
			check_times = world.time + LUXURY_MESSAGE_COOLDOWN

/obj/machinery/scanner_gate/cami_shuttle/auto_scan(atom/movable/AM)
	return

/obj/machinery/scanner_gate/cami_shuttle/attackby(obj/item/W, mob/user, params)
	return

/obj/machinery/scanner_gate/cami_shuttle/emag_act(mob/user)
	return

#undef LUXURY_MESSAGE_COOLDOWN

/datum/map_template/shuttle/emergency/cami
	name = "Cami"
	prefix = "modular_psychonaut/modules/shuttles/maps/"
	suffix = "cami"
	credit_cost = CARGO_CRATE_VALUE * 50
	description = "Uhrevi alemde sorulur sual, Dünyada yaşarken çalsam da kaval, Kurana uymaktir İslamda kural, İbadethanenin simgesi cami."
	occupancy_limit = "70"

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

/obj/machinery/scanner_gate/cami_shuttle/Bumped(atom/movable/bumped_atom)
	if(ishuman(bumped_atom))
		var/mob/living/carbon/human/H = bumped_atom
		if(H.shoes)
			alarm_beep()
			if(!check_times|| check_times < world.time)
				say("Ayakkabıları çıkartalım")
				check_times = world.time + 10 SECONDS
	else if(isvehicle(bumped_atom))
		alarm_beep()
		if(!check_times|| check_times < world.time)
			say("Onunla girilir mi abicim!")
			check_times = world.time + 10 SECONDS

/obj/machinery/scanner_gate/cami_shuttle/auto_scan(atom/movable/AM)
	return

/obj/machinery/scanner_gate/cami_shuttle/attackby(obj/item/W, mob/user, params)
	return

/obj/machinery/scanner_gate/cami_shuttle/emag_act(mob/user)
	return

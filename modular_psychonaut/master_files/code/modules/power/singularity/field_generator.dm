#define FIELD_GENERATOR_WARNING_DELAY (20 SECONDS)

/obj/machinery/field/generator/singularity
	icon = 'modular_psychonaut/master_files/icons/obj/machines/field_generator.dmi'
	icon_state = "Field_Gen_Singularity"

	var/lastwarning = 0

	var/warning_point = 80

	var/emergency_point = 50

	///Our internal radio
	var/obj/item/radio/radio
	///The key our internal radio uses
	var/radio_key = /obj/item/encryptionkey/headset_eng

/obj/machinery/field/generator/singularity/Initialize(mapload)
	. = ..()
	radio = new(src)
	radio.keyslot = new radio_key
	radio.set_listening(FALSE)
	radio.recalculateChannels()

/obj/machinery/field/generator/singularity/Destroy()
	radio.talk_into(
		src,
		"DANGER: Field generator has been destroyed! Containment field is shutting down!",
		null,
		list(SPAN_COMMAND),
		/datum/language/common
	)
	QDEL_NULL(radio)
	return ..()

/obj/machinery/field/generator/singularity/calc_power(set_power_draw)
	var/previous_power = power
	. = ..()
	if(!.)
		radio.talk_into(
			src,
			"DANGER: Field generator's power level is 0%. Shutting down!",
			null,
			list(SPAN_COMMAND)
		)
		return .
	if((REALTIMEOFDAY - lastwarning) < FIELD_GENERATOR_WARNING_DELAY)
		return FALSE
	var/power_percentage = (power / field_generator_max_power) * 100
	if(power_percentage > warning_point)
		return FALSE
	lastwarning = REALTIMEOFDAY
	var/radio_message
	var/emergency = FALSE

	if(power_percentage <= emergency_point)
		lastwarning = REALTIMEOFDAY - (FIELD_GENERATOR_WARNING_DELAY / 1.5)
		emergency = TRUE

	if(previous_power > power)
		radio_message = "[emergency ? "DANGER" : "WARNING"]: Field generator's power is decreasing. Current power percentage is [power_percentage]%!"
	else if(previous_power < power)
		radio_message = "Field generator's power is increasing. Current power percentage is [power_percentage]%."

	if(isnull(radio_message)) // If the power equals the previous power, don't repeat the same text
		return FALSE

	radio.talk_into(
		src,
		radio_message,
		emergency ? null : RADIO_CHANNEL_ENGINEERING,
		emergency ? list(SPAN_COMMAND) : null
	)

#undef FIELD_GENERATOR_WARNING_DELAY

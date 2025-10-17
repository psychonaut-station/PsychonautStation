/// Display days since last delam on incident sign
#define DISPLAY_DELAM (1<<0)
/// Display current number of tram hits on incident sign
#define DISPLAY_TRAM (1<<1)
/// Display days since the last singularity death on incident sign
#define DISPLAY_SINGULARITY_DEATH (1<<2)

#define NAME_SINGULARITY "singularity incident display"
#define DESC_SINGULARITY "A signs describe how long it's been since the last singularity engine-related death. Features an advert for SAFETY MOTH."

#define TREND_RISING "rising"
#define TREND_FALLING "falling"

#define DISPLAY_PIXEL_1_W 21
#define DISPLAY_PIXEL_1_Z -2
#define DISPLAY_PIXEL_2_W 16
#define DISPLAY_PIXEL_2_Z -2
#define DISPLAY_BASE_ALPHA 64
#define DISPLAY_PIXEL_ALPHA 96

#define LIGHT_COLOR_NORMAL "#4b4290"
#define LIGHT_COLOR_SHAME "#e24e76"

/obj/machinery/incident_display
	// Tracks the number of shifts since the last singularity death
	var/last_singularity_death = 0
	// Tracks the record for the longest duration without a singularity death
	var/singularity_deaths_record = 0

/obj/machinery/incident_display/singularity_death
	name = NAME_SINGULARITY
	desc = DESC_SINGULARITY
	sign_features = DISPLAY_SINGULARITY_DEATH
	configured_advert = "advert_meson"
	configured_advert_duration = 7 SECONDS

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/incident_display/singularity_death, 32)

/obj/machinery/incident_display/Initialize(mapload)
	. = ..()
	if(mapload && sign_features == DISPLAY_DELAM && SSmapping.picked_rooms["engine"])
		var/datum/map_template/modular_room/random_engine/engine_template = SSmapping.picked_rooms["engine"]
		if(engine_template.engine_type == "singularity")
			name = NAME_SINGULARITY
			desc = DESC_SINGULARITY
			sign_features = DISPLAY_SINGULARITY_DEATH

/obj/machinery/incident_display/post_machine_initialize()
	update_last_singularity_death(SSpersistence.rounds_since_singularity_death, SSpersistence.singularity_death_record)
	return ..()

/obj/machinery/incident_display/multitool_act(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return FALSE

	if(sign_features == DISPLAY_DELAM)
		tool.play_tool_sound(src)
		balloon_alert(user, "set to singularity deaths")
		name = NAME_SINGULARITY
		desc = DESC_SINGULARITY
		sign_features = DISPLAY_SINGULARITY_DEATH
		update_last_singularity_death(SSpersistence.rounds_since_singularity_death, SSpersistence.singularity_death_record)
		update_appearance()
		return TRUE

	return ..()

/**
 * Update the count of shifts since the last singularity death
 *
 * Use the provided args to update the incident display when in singuloose mode.
 * Arguments:
 * * new_count - number of shifts without a singuloose
 * * record - current high score for the singuloose count
 */
/obj/machinery/incident_display/proc/update_last_singularity_death(new_count, record)
	singularity_deaths_record = record
	last_singularity_death = min(new_count, 199)
	update_appearance()

/obj/machinery/incident_display/update_overlays()
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN))
		return

	if(sign_features & DISPLAY_SINGULARITY_DEATH)
		. += mutable_appearance('modular_psychonaut/master_files/icons/obj/machines/incident_display.dmi', "overlay_singularity")
		. += emissive_appearance('modular_psychonaut/master_files/icons/obj/machines/incident_display.dmi', "overlay_singularity", src, alpha = DISPLAY_PIXEL_ALPHA)

		var/singularity_deaths_pos1 = clamp(last_singularity_death, 0, 199) % 10
		var/mutable_appearance/singularity_deaths_pos1_overlay = mutable_appearance(icon, "num_[singularity_deaths_pos1]")
		var/mutable_appearance/singularity_deaths_pos1_emissive = emissive_appearance(icon, "num_[singularity_deaths_pos1]", src, alpha = DISPLAY_PIXEL_ALPHA)
		singularity_deaths_pos1_overlay.color = delam_display_color
		singularity_deaths_pos1_overlay.pixel_w = DISPLAY_PIXEL_1_W
		singularity_deaths_pos1_emissive.pixel_w = DISPLAY_PIXEL_1_W
		singularity_deaths_pos1_overlay.pixel_z = DISPLAY_PIXEL_1_Z
		singularity_deaths_pos1_emissive.pixel_z = DISPLAY_PIXEL_1_Z
		. += singularity_deaths_pos1_overlay
		. += singularity_deaths_pos1_emissive

		var/singularity_deaths_pos2 = (clamp(last_singularity_death, 0, 199) / 10) % 10
		var/mutable_appearance/singularity_deaths_pos2_overlay = mutable_appearance(icon, "num_[singularity_deaths_pos2]")
		var/mutable_appearance/singularity_deaths_pos2_emissive = emissive_appearance(icon, "num_[singularity_deaths_pos2]", src, alpha = DISPLAY_PIXEL_ALPHA)
		singularity_deaths_pos2_overlay.color = delam_display_color
		singularity_deaths_pos2_overlay.pixel_w = DISPLAY_PIXEL_2_W
		singularity_deaths_pos2_emissive.pixel_w = DISPLAY_PIXEL_2_W
		singularity_deaths_pos2_overlay.pixel_z = DISPLAY_PIXEL_2_Z
		singularity_deaths_pos2_emissive.pixel_z = DISPLAY_PIXEL_2_Z
		. += singularity_deaths_pos2_overlay
		. += singularity_deaths_pos2_emissive

		if(last_singularity_death >= 100)
			. += mutable_appearance(icon, "num_100_red")
			. += emissive_appearance(icon, "num_100_red", src, alpha = DISPLAY_BASE_ALPHA)

		if(last_singularity_death == singularity_deaths_record)
			var/mutable_appearance/singularity_deaths_trend_overlay = mutable_appearance(icon, TREND_RISING)
			var/mutable_appearance/singularity_deaths_trend_emissive = emissive_appearance(icon, "[TREND_RISING]", src, alpha = DISPLAY_PIXEL_ALPHA)
			singularity_deaths_trend_overlay.color = COLOR_DISPLAY_GREEN
			. += singularity_deaths_trend_overlay
			. += singularity_deaths_trend_emissive
		else
			var/mutable_appearance/singularity_deaths_trend_overlay = mutable_appearance(icon, TREND_FALLING)
			var/mutable_appearance/singularity_deaths_trend_emissive = emissive_appearance(icon, "[TREND_FALLING]", src, alpha = DISPLAY_PIXEL_ALPHA)
			singularity_deaths_trend_overlay.color = COLOR_DISPLAY_RED
			. += singularity_deaths_trend_overlay
			. += singularity_deaths_trend_emissive

/obj/machinery/incident_display/examine(mob/user)
	. = ..()
	if(sign_features & DISPLAY_SINGULARITY_DEATH)
		. += span_notice("It can be changed to display tram hits with a [EXAMINE_HINT("multitool")].")
		. += span_info("It has been [last_singularity_death] shift\s since the last singularity engine-related death.")
		switch(last_singularity_death)
			if(0)
				. += span_info("A tragedy has occurred today.<br/>")
			if(1 to 5)
				. += span_info("Keep working on safety protocols.<br/>")
			if(6 to 10)
				. += span_info("The station is improving!<br/>")
			if(31)
				. += span_info("Nice.<br/>")
			else
				. += span_info("Outstanding safety record!<br/>")

#undef DISPLAY_DELAM
#undef DISPLAY_TRAM
#undef DISPLAY_SINGULARITY_DEATH

#undef NAME_SINGULARITY
#undef DESC_SINGULARITY

#undef TREND_RISING
#undef TREND_FALLING

#undef DISPLAY_PIXEL_1_W
#undef DISPLAY_PIXEL_1_Z
#undef DISPLAY_PIXEL_2_W
#undef DISPLAY_PIXEL_2_Z
#undef DISPLAY_BASE_ALPHA
#undef DISPLAY_PIXEL_ALPHA

#undef LIGHT_COLOR_NORMAL
#undef LIGHT_COLOR_SHAME

/obj/machinery/mineral/ore_redemption/RefreshParts()
	. = ..()
	var/ore_multiplier_temp = 1
	for(var/datum/stock_part/micro_laser/internal_laser in component_parts)
		ore_multiplier_temp = 0.95 + (0.05 * internal_laser.tier)
	ore_multiplier = ore_multiplier_temp

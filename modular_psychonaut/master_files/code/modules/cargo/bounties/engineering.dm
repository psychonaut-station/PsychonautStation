/datum/bounty/item/engineering/energy_ball
	name = "Contained Tesla Ball"
	description = "Station 24 is being overrun by hordes of angry Mothpeople. They are requesting the ultimate bug zapper."
	reward = CARGO_CRATE_VALUE * 37.5 //requires 14k credits of purchases, not to mention cooperation with engineering/heads of staff to set up inside the cramped shuttle
	wanted_types = list(/obj/energy_ball = TRUE)

/datum/bounty/item/engineering/energy_ball/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/energy_ball/T = O
	return !T.miniball

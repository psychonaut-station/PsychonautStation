/datum/hud
	var/list/atom/movable/screen/cybernetics/ammo_counter/cybernetics_ammo = list()

/datum/hud/Destroy()
	cybernetics_ammo = null
	return ..()

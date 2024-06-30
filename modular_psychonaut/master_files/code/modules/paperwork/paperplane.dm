/obj/item/paperplane
	/// How much eye damage does it deal at minimum on eye impact?
	var/eye_damage_lower = 6
	/// How much eye damage does it deal at maximum on eye impact?
	var/eye_damage_higher = 8
	/// Does it get deleted when hitting anything or landing?
	var/scrap_on_impact = FALSE

/obj/item/paperplane/proc/turn_into_scrap()
	if(scrap_on_impact)
		var/obj/item/paper/crumpled/scrap = new (get_turf(loc))
		scrap.color = color
		qdel(src)

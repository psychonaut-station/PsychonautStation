/datum/crafting_recipe/noose
	name = "Noose"
	reqs = list(
		/obj/item/stack/cable_coil = 30,
	)
	result = /obj/structure/noose
	category = CAT_STRUCTURE
	time = 5 SECONDS
	crafting_flags = CRAFT_CHECK_DENSITY
	steps = list(
		"make sure that there is a chair under you",
	)

/datum/crafting_recipe/noose/check_requirements(mob/user, list/collected_requirements)
	var/turf/user_turf = get_turf(user)
	if(isnull(locate(/obj/structure/chair) in user_turf))
		return FALSE
	return ..()

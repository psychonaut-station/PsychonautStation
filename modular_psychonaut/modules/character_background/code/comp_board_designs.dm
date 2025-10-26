/datum/design/board/crewdata
	name = "Crew Records Console Board"
	desc = "Allows for the construction of circuit boards used to build a crew records console."
	id = "crewdata"
	build_path = /obj/item/circuitboard/computer/crew_data
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_COMMAND
	)
	departmental_flags = DEPARTMENT_BITFLAG_COMMAND

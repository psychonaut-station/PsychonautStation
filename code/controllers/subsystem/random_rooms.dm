SUBSYSTEM_DEF(random_rooms)
	name = "Random Rooms"
	init_order = INIT_ORDER_RANDOM_ROOMS
	flags = SS_NO_FIRE

/datum/controller/subsystem/random_rooms/Initialize()
#if defined(MAP_TEST) || defined(UNIT_TESTS)
	return SS_INIT_NO_NEED
#else
	SSmapping.load_random_rooms()
	return SS_INIT_NO_MESSAGE
#endif

/datum/unit_test/render_offline_appearance
	test_flags = UNIT_TEST_FOCUS

/datum/unit_test/render_offline_appearance/Run()
	var/datum/client_interface/our_client = new /datum/client_interface
	var/datum/preferences/preferences = new(our_client, FALSE)
	var/mutable_appearance/appearance = render_offline_appearance(our_client.ckey)
	TEST_ASSERT(appearance, "Appearance is not created")
	TEST_ASSERT(istype(appearance), "Appearance is not mutable_appearance")

/// Tests basic Bloodsucker antagonist initialization and starting properties
/datum/unit_test/bloodsucker_initialization/Run()
	var/mob/living/carbon/human/master = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	master.mind_initialize()
	master.mock_client = new()

	var/datum/antagonist/bloodsucker/bs = master.mind.add_antag_datum(/datum/antagonist/bloodsucker)
	TEST_ASSERT_NOTNULL(bs, "Failed to add bloodsucker antagonist datum.")
	TEST_ASSERT_EQUAL(bs.bloodsucker_level, 1, "Bloodsucker level should start at 1.")
	TEST_ASSERT(HAS_TRAIT(master, TRAIT_NOSOFTCRIT), "Bloodsucker should have TRAIT_NOSOFTCRIT.")

/// Tests converting crewmembers into Vassals and verifies master-vassal linkage
/datum/unit_test/bloodsucker_vassalization/Run()
	var/mob/living/carbon/human/master = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	master.mind_initialize()
	master.mock_client = new()

	var/datum/antagonist/bloodsucker/bs = master.mind.add_antag_datum(/datum/antagonist/bloodsucker)
	TEST_ASSERT_NOTNULL(bs, "Failed to add bloodsucker antagonist datum.")

	var/mob/living/carbon/human/victim = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	victim.mind_initialize()
	victim.mock_client = new()

	var/success = bs.make_vassal(victim)
	TEST_ASSERT(success, "Failed to convert victim into a vassal.")
	TEST_ASSERT(victim in bs.vassals, "Victim was not added to master's vassals list.")

	var/datum/antagonist/vassal/vassal_datum = victim.mind.has_antag_datum(/datum/antagonist/vassal)
	TEST_ASSERT_NOTNULL(vassal_datum, "Victim did not receive vassal antagonist datum.")
	TEST_ASSERT_EQUAL(vassal_datum.master, bs, "Vassal's master reference is incorrect.")

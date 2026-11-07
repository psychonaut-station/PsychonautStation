/// Tests basic Shadowling antagonist assignment, hive registration, and ability grants
/datum/unit_test/shadowling_initialization/Run()
	var/mob/living/carbon/human/ling_mob = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	ling_mob.mind_initialize()
	ling_mob.mock_client = new()

	var/datum/antagonist/shadowling/ling_antag = ling_mob.mind.add_antag_datum(/datum/antagonist/shadowling)
	TEST_ASSERT_NOTNULL(ling_antag, "Shadowling antagonist datum could not be added to mind.")

	var/datum/team/shadow_hive/hive = get_shadow_hive()
	TEST_ASSERT_NOTNULL(hive, "Shadowling hive team was not created.")
	TEST_ASSERT(ling_mob in hive.lings, "Shadowling mob was not registered in hive.lings.")

	// Verify hatch action
	var/datum/action/cooldown/shadowling/hatch/hatch_action = locate(/datum/action/cooldown/shadowling/hatch) in ling_mob.actions
	TEST_ASSERT_NOTNULL(hatch_action, "Shadowling was not granted hatch action upon initialization.")

	// Verify hive communication
	var/datum/action/cooldown/shadowling/commune/comm_action = locate(/datum/action/cooldown/shadowling/commune) in ling_mob.actions
	TEST_ASSERT_NOTNULL(comm_action, "Shadowling was not granted commune action upon initialization.")

/// Tests Thrall tumor insertion, antagonist assignment, hive tracking, and extraction
/datum/unit_test/shadow_thrall_lifecycle/Run()
	var/mob/living/carbon/human/victim = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	victim.mind_initialize()
	victim.mock_client = new()

	var/datum/team/shadow_hive/hive = get_shadow_hive()
	var/initial_thrall_count = hive.count_alive_thralls()

	// Insert thrall tumor
	var/obj/item/organ/brain/shadow/tumor_thrall/tumor = new
	var/inserted = tumor.Insert(victim)
	TEST_ASSERT(inserted, "Failed to insert thrall tumor into victim.")

	var/datum/antagonist/shadow_thrall/thrall_antag = victim.mind.has_antag_datum(/datum/antagonist/shadow_thrall)
	TEST_ASSERT_NOTNULL(thrall_antag, "Victim did not gain Shadow Thrall antagonist datum after tumor insertion.")
	TEST_ASSERT(victim in hive.thralls, "Victim was not registered in hive.thralls.")
	TEST_ASSERT_EQUAL(hive.count_alive_thralls(), initial_thrall_count + 1, "Hive alive thrall count did not increment.")

	// Remove tumor (simulate neurosurgery extraction)
	tumor.mob_remove(victim, special = FALSE)
	qdel(tumor)

	TEST_ASSERT_NULL(victim.mind.has_antag_datum(/datum/antagonist/shadow_thrall), "Victim still retained Shadow Thrall antag datum after tumor removal.")
	TEST_ASSERT(!(victim in hive.thralls), "Victim was not removed from hive.thralls after tumor removal.")

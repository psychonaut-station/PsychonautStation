/// Stateful regression tests for Bloodsucker v2 runtime bugfixes.
/datum/unit_test/bloodsucker_regressions
	var/sunlight_state_saved = FALSE
	var/saved_sunlight_active = FALSE
	var/saved_sunlight_can_fire = FALSE

/datum/unit_test/bloodsucker_regressions/Destroy()
	if(sunlight_state_saved)
		SSsunlight.sunlight_active = saved_sunlight_active
		SSsunlight.can_fire = saved_sunlight_can_fire
		sunlight_state_saved = FALSE
	return ..()

/datum/unit_test/bloodsucker_regressions/Run()
	var/mob/living/carbon/human/vampire = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	vampire.mind_initialize()
	vampire.mock_client = new()

	saved_sunlight_active = SSsunlight.sunlight_active
	saved_sunlight_can_fire = SSsunlight.can_fire
	sunlight_state_saved = TRUE

	var/datum/antagonist/bloodsucker/vamp_datum = vampire.mind.add_antag_datum(/datum/antagonist/bloodsucker)
	TEST_ASSERT_NOTNULL(vamp_datum, "Failed to grant bloodsucker antagonist datum.")

	// K-1: Repeated Sol status effect attempts in a closed coffin must not reduce BURN physiology below 1,
	// and an open coffin must not grant Sol immunity.
	SSsunlight.sunlight_active = TRUE
	var/obj/structure/closet/crate/coffin/coffin = allocate(/obj/structure/closet/crate/coffin, run_loc_floor_bottom_left)
	vampire.forceMove(coffin)
	TEST_ASSERT(!coffin.opened, "K-1: Newly allocated coffin should start closed.")
	vampire.apply_status_effect(/datum/status_effect/bloodsucker_sol)
	vampire.apply_status_effect(/datum/status_effect/bloodsucker_sol)
	TEST_ASSERT_EQUAL(GET_PHYSIOLOGY(vampire, BURN), DEFAULT_PHYSIOLOGY_VAL, "K-1: Closed coffin Sol applications altered BURN physiology.")

	coffin.open(vampire)
	TEST_ASSERT(coffin.opened, "K-1: Coffin failed to open.")
	vampire.forceMove(coffin)
	vampire.apply_status_effect(/datum/status_effect/bloodsucker_sol)
	vampire.apply_status_effect(/datum/status_effect/bloodsucker_sol)
	TEST_ASSERT(vampire.has_status_effect(/datum/status_effect/bloodsucker_sol), "K-1: Open coffin failed to apply Sol status effect.")
	TEST_ASSERT(GET_PHYSIOLOGY(vampire, BURN) >= DEFAULT_PHYSIOLOGY_VAL, "K-1: Open coffin Sol applications reduced BURN physiology below 1.")
	vampire.remove_status_effect(/datum/status_effect/bloodsucker_sol)
	TEST_ASSERT_EQUAL(GET_PHYSIOLOGY(vampire, BURN), DEFAULT_PHYSIOLOGY_VAL, "K-1: Removing Sol did not restore BURN physiology to 1.")
	vampire.forceMove(run_loc_floor_bottom_left)

	// K-2: clear_cuffs(null, TRUE) returns FALSE cleanly, and Brawn breaks handcuffs without legcuffs.
	TEST_ASSERT_EQUAL(vampire.clear_cuffs(null, TRUE), FALSE, "K-2: clear_cuffs(null, TRUE) did not return FALSE cleanly.")
	var/obj/item/restraints/handcuffs/cuffs = allocate(/obj/item/restraints/handcuffs, vampire)
	vampire.set_handcuffed(cuffs)
	TEST_ASSERT_EQUAL(vampire.handcuffed, cuffs, "K-2: Failed to apply handcuffs.")
	TEST_ASSERT_NULL(vampire.legcuffed, "K-2: Test subject unexpectedly had legcuffs.")
	var/datum/action/cooldown/bloodsucker/targeted/brawn/brawn = locate() in vamp_datum.powers
	if(!brawn)
		brawn = new()
		vamp_datum.BuyPower(brawn)
	TEST_ASSERT(brawn.break_restraints(), "K-2: Brawn break_restraints() returned FALSE while handcuffed.")
	TEST_ASSERT_NULL(vampire.handcuffed, "K-2: Brawn break_restraints() did not clear handcuffs.")

	// Y-3: Feed resets silent_feed to TRUE on DeactivatePower().
	var/datum/action/cooldown/bloodsucker/feed/feed = locate() in vamp_datum.powers
	TEST_ASSERT_NOTNULL(feed, "Y-3: Bloodsucker did not receive default Feed power.")
	feed.silent_feed = FALSE
	feed.active = TRUE
	feed.DeactivatePower()
	TEST_ASSERT(!feed.active, "Y-3: Feed remained active after DeactivatePower().")
	TEST_ASSERT(feed.silent_feed, "Y-3: Feed silent_feed was not reset to TRUE on DeactivatePower().")

	// Y-4: Masquerade preserves pre-existing diseases while curing diseases contracted during Masquerade.
	var/mob/living/carbon/human/masq_human = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	masq_human.mind_initialize()
	masq_human.mock_client = new()
	TEST_ASSERT(masq_human.ForceContractDisease(new /datum/disease/cold(), make_copy = FALSE, del_on_fail = TRUE), "Y-4: Failed to contract pre-existing cold.")
	var/datum/action/cooldown/bloodsucker/masquerade/masquerade = allocate(/datum/action/cooldown/bloodsucker/masquerade)
	masquerade.Grant(masq_human)
	masquerade.ActivatePower()
	TEST_ASSERT(masq_human.ForceContractDisease(new /datum/disease/flu(), make_copy = FALSE, del_on_fail = TRUE), "Y-4: Failed to contract flu during Masquerade.")
	masquerade.DeactivatePower()
	TEST_ASSERT_NOTNULL(locate(/datum/disease/cold) in masq_human.diseases, "Y-4: Pre-existing cold was cured when Masquerade deactivated.")
	TEST_ASSERT_NULL(locate(/datum/disease/flu) in masq_human.diseases, "Y-4: Flu contracted during Masquerade was not cured on deactivation.")

	// Y-5: Haste deactivation only deletes /datum/component/after_image/bloodsucker, leaving base after_image intact.
	var/datum/component/after_image/sandevistan_after_image = vampire.AddComponent(/datum/component/after_image, 16, 0.5, TRUE)
	TEST_ASSERT_NOTNULL(sandevistan_after_image, "Y-5: Failed to attach base after_image component.")
	var/datum/action/cooldown/bloodsucker/haste/haste = locate() in vamp_datum.powers
	if(!haste)
		haste = new()
		vamp_datum.BuyPower(haste)
	haste.ActivatePower()
	TEST_ASSERT_NOTNULL(vampire.GetComponent(/datum/component/after_image/bloodsucker), "Y-5: Haste did not add bloodsucker after_image component.")
	haste.DeactivatePower()
	TEST_ASSERT_NULL(vampire.GetComponent(/datum/component/after_image/bloodsucker), "Y-5: Haste did not remove bloodsucker after_image component.")
	TEST_ASSERT(!QDELETED(sandevistan_after_image) && (sandevistan_after_image in vampire.GetComponents(/datum/component/after_image)), "Y-5: Haste deactivation deleted pre-existing after_image component.")
	qdel(sandevistan_after_image)

	// O-3: StartCooldown() on a scalable power at level_current = 0 does not inflate cooldown_time above initial().
	var/datum/action/cooldown/bloodsucker/cloak/cloak = locate() in vamp_datum.powers
	if(!cloak)
		cloak = new()
		vamp_datum.BuyPower(cloak)
	cloak.level_current = 0
	cloak.StartCooldown()
	TEST_ASSERT(cloak.cooldown_time <= initial(cloak.cooldown_time), "O-3: StartCooldown() at level_current = 0 inflated cooldown_time above initial.")

	vampire.mind.remove_antag_datum(/datum/antagonist/bloodsucker)
	SSsunlight.sunlight_active = saved_sunlight_active
	SSsunlight.can_fire = saved_sunlight_can_fire
	sunlight_state_saved = FALSE

/// Stateful regression tests for Bloodsucker v2 runtime bugfixes.
/datum/unit_test/bloodsucker_regressions
	var/sunlight_state_saved = FALSE
	var/saved_sunlight_active = FALSE
	var/saved_sunlight_processing = FALSE

/datum/unit_test/bloodsucker_regressions/Destroy()
	if(sunlight_state_saved)
		GLOB.bloodsucker_sunlight.sunlight_active = saved_sunlight_active
		GLOB.bloodsucker_sunlight.processing = saved_sunlight_processing
		if(saved_sunlight_processing)
			START_PROCESSING(SSprocessing, GLOB.bloodsucker_sunlight)
		else
			STOP_PROCESSING(SSprocessing, GLOB.bloodsucker_sunlight)
		sunlight_state_saved = FALSE
	return ..()

/datum/unit_test/bloodsucker_regressions/Run()
	var/mob/living/carbon/human/vampire = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	vampire.mind_initialize()
	vampire.mock_client = new()

	saved_sunlight_active = GLOB.bloodsucker_sunlight.sunlight_active
	saved_sunlight_processing = GLOB.bloodsucker_sunlight.processing
	sunlight_state_saved = TRUE

	var/datum/antagonist/bloodsucker/vamp_datum = vampire.mind.add_antag_datum(/datum/antagonist/bloodsucker)

	// Repeated Sol applications in a closed coffin must not reduce BURN physiology below 1,
	// and an open coffin must still apply Sol and restore BURN physiology on removal.
	GLOB.bloodsucker_sunlight.sunlight_active = TRUE
	var/obj/structure/closet/crate/coffin/coffin = allocate(/obj/structure/closet/crate/coffin, run_loc_floor_bottom_left)
	vampire.forceMove(coffin)
	vampire.apply_status_effect(/datum/status_effect/bloodsucker_sol)
	vampire.apply_status_effect(/datum/status_effect/bloodsucker_sol)
	TEST_ASSERT_EQUAL(GET_PHYSIOLOGY(vampire, BURN), DEFAULT_PHYSIOLOGY_VAL, "Closed coffin Sol applications altered BURN physiology.")

	coffin.open(vampire)
	vampire.forceMove(coffin)
	vampire.apply_status_effect(/datum/status_effect/bloodsucker_sol)
	vampire.apply_status_effect(/datum/status_effect/bloodsucker_sol)
	TEST_ASSERT(vampire.has_status_effect(/datum/status_effect/bloodsucker_sol), "Open coffin failed to apply Sol status effect.")
	TEST_ASSERT(GET_PHYSIOLOGY(vampire, BURN) >= DEFAULT_PHYSIOLOGY_VAL, "Open coffin Sol applications reduced BURN physiology below 1.")
	vampire.remove_status_effect(/datum/status_effect/bloodsucker_sol)
	TEST_ASSERT_EQUAL(GET_PHYSIOLOGY(vampire, BURN), DEFAULT_PHYSIOLOGY_VAL, "Removing Sol did not restore BURN physiology to 1.")
	vampire.forceMove(run_loc_floor_bottom_left)

	// clear_cuffs(null, TRUE) returns FALSE cleanly, and Brawn breaks handcuffs without legcuffs.
	TEST_ASSERT_EQUAL(vampire.clear_cuffs(null, TRUE), FALSE, "clear_cuffs(null, TRUE) did not return FALSE cleanly.")
	var/obj/item/restraints/handcuffs/cuffs = allocate(/obj/item/restraints/handcuffs, vampire)
	vampire.set_handcuffed(cuffs)
	var/datum/action/cooldown/bloodsucker/targeted/brawn/brawn = locate() in vamp_datum.powers
	if(!brawn)
		brawn = new()
		vamp_datum.buy_power(brawn)
	TEST_ASSERT(brawn.break_restraints(), "Brawn break_restraints() returned FALSE while handcuffed.")
	TEST_ASSERT_NULL(vampire.handcuffed, "Brawn break_restraints() did not clear handcuffs.")

	// Targeted click_to_activate flow: Trigger() arms click_intercept and second Trigger() cancels cleanly without cost.
	var/blood_before_brawn = vamp_datum.bloodsucker_blood_volume
	TEST_ASSERT_EQUAL(brawn.Trigger(vampire), TRUE, "Targeted Brawn Trigger() failed to arm click_intercept.")
	TEST_ASSERT_EQUAL(vampire.click_intercept, brawn, "Targeted Brawn Trigger() did not set click_intercept.")
	TEST_ASSERT_EQUAL(vamp_datum.bloodsucker_blood_volume, blood_before_brawn, "Targeted Brawn aiming prematurely deducted blood.")
	TEST_ASSERT_EQUAL(brawn.Trigger(vampire), FALSE, "Second Targeted Brawn Trigger() did not cancel click_intercept.")
	TEST_ASSERT_NULL(vampire.click_intercept, "Second Targeted Brawn Trigger() left click_intercept set.")
	TEST_ASSERT_EQUAL(vamp_datum.bloodsucker_blood_volume, blood_before_brawn, "Cancelling Targeted Brawn deducted blood.")
	// Triggering Brawn while handcuffed resolves via try_trigger_instant() without entering click_intercept.
	var/obj/item/restraints/handcuffs/cuffs_two = allocate(/obj/item/restraints/handcuffs, vampire)
	vampire.set_handcuffed(cuffs_two)
	TEST_ASSERT_EQUAL(brawn.Trigger(vampire), TRUE, "Targeted Brawn Trigger() failed instant restraint break.")
	TEST_ASSERT_NULL(vampire.handcuffed, "Targeted Brawn Trigger() did not break handcuffs.")
	TEST_ASSERT_NULL(vampire.click_intercept, "Targeted Brawn Trigger() entered click_intercept after instant restraint break.")
	brawn.ResetCooldown()

	// Masquerade preserves pre-existing diseases while curing diseases contracted during Masquerade.
	var/mob/living/carbon/human/masq_human = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	masq_human.mind_initialize()
	masq_human.mock_client = new()
	masq_human.ForceContractDisease(new /datum/disease/cold(), make_copy = FALSE, del_on_fail = TRUE)
	var/datum/action/cooldown/bloodsucker/masquerade/masquerade = allocate(/datum/action/cooldown/bloodsucker/masquerade)
	masquerade.Grant(masq_human)
	masquerade.activate_power()
	masq_human.ForceContractDisease(new /datum/disease/flu(), make_copy = FALSE, del_on_fail = TRUE)
	masquerade.deactivate_power()
	TEST_ASSERT_NOTNULL(locate(/datum/disease/cold) in masq_human.diseases, "Pre-existing cold was cured when Masquerade deactivated.")
	TEST_ASSERT_NULL(locate(/datum/disease/flu) in masq_human.diseases, "Flu contracted during Masquerade was not cured on deactivation.")

	// Haste deactivation only deletes /datum/component/after_image/bloodsucker, leaving base after_image intact.
	var/datum/component/after_image/sandevistan_after_image = vampire.AddComponent(/datum/component/after_image, 16, 0.5, TRUE)
	var/datum/action/cooldown/bloodsucker/haste/haste = locate() in vamp_datum.powers
	if(!haste)
		haste = new()
		vamp_datum.buy_power(haste)
	haste.activate_power()
	TEST_ASSERT_NOTNULL(vampire.GetComponent(/datum/component/after_image/bloodsucker), "Haste did not add bloodsucker after_image component.")
	haste.deactivate_power()
	TEST_ASSERT_NULL(vampire.GetComponent(/datum/component/after_image/bloodsucker), "Haste did not remove bloodsucker after_image component.")
	TEST_ASSERT(!QDELETED(sandevistan_after_image) && (sandevistan_after_image in vampire.GetComponents(/datum/component/after_image)), "Haste deactivation deleted pre-existing after_image component.")
	qdel(sandevistan_after_image)

	// StartCooldown() on a scalable power at level_current = 0 does not inflate cooldown_time above initial().
	var/datum/action/cooldown/bloodsucker/cloak/cloak = locate() in vamp_datum.powers
	if(!cloak)
		cloak = new()
		vamp_datum.buy_power(cloak)
	cloak.level_current = 0
	cloak.StartCooldown()
	TEST_ASSERT(cloak.cooldown_time <= initial(cloak.cooldown_time), "StartCooldown() at level_current = 0 inflated cooldown_time above initial.")

	// Vassal conversion guards: reject Bloodsucker minds and TRAIT_UNCONVERTABLE minds.
	var/datum/antagonist/vassal/test_vassal = allocate(/datum/antagonist/vassal)
	TEST_ASSERT_EQUAL(test_vassal.can_be_owned(vampire.mind), FALSE, "Vassal can_be_owned returned TRUE for a Bloodsucker mind.")
	ADD_TRAIT(masq_human.mind, TRAIT_UNCONVERTABLE, "bloodsucker_test")
	TEST_ASSERT_EQUAL(test_vassal.can_be_owned(masq_human.mind), FALSE, "Vassal can_be_owned returned TRUE for a TRAIT_UNCONVERTABLE mind.")
	REMOVE_TRAIT(masq_human.mind, TRAIT_UNCONVERTABLE, "bloodsucker_test")

	vampire.mind.remove_antag_datum(/datum/antagonist/bloodsucker)
	GLOB.bloodsucker_sunlight.sunlight_active = saved_sunlight_active
	GLOB.bloodsucker_sunlight.processing = saved_sunlight_processing
	if(saved_sunlight_processing)
		START_PROCESSING(SSprocessing, GLOB.bloodsucker_sunlight)
	else
		STOP_PROCESSING(SSprocessing, GLOB.bloodsucker_sunlight)
	sunlight_state_saved = FALSE

TEST_FOCUS(/datum/unit_test/bloodsucker_regressions)

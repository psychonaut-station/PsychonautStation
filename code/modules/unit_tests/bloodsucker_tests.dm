/// Regression tests for Bloodsucker Sol coffin shelter and Masquerade disease cleanup.
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

	// Closed coffin shields from Sol without lowering BURN physiology; open coffin applies Sol and burns.
	GLOB.bloodsucker_sunlight.sunlight_active = TRUE
	var/obj/structure/closet/crate/coffin/coffin = allocate(/obj/structure/closet/crate/coffin, run_loc_floor_bottom_left)
	vampire.forceMove(coffin)
	vamp_datum.handle_sol_effects()
	vampire.apply_status_effect(/datum/status_effect/bloodsucker_sol)
	TEST_ASSERT(!vampire.has_status_effect(/datum/status_effect/bloodsucker_sol), "Closed coffin applied Sol status effect.")
	TEST_ASSERT_EQUAL(vampire.getFireLoss(), 0, "Closed coffin allowed Sol burn damage.")
	TEST_ASSERT_EQUAL(GET_PHYSIOLOGY(vampire, BURN), DEFAULT_PHYSIOLOGY_VAL, "Closed coffin Sol applications altered BURN physiology.")

	coffin.open(vampire)
	vampire.forceMove(coffin)
	vamp_datum.handle_sol_effects()
	TEST_ASSERT(vampire.has_status_effect(/datum/status_effect/bloodsucker_sol), "Open coffin failed to apply Sol status effect.")
	TEST_ASSERT(vampire.getFireLoss() > 0, "Open coffin did not burn vampire during Sol.")
	TEST_ASSERT(GET_PHYSIOLOGY(vampire, BURN) >= DEFAULT_PHYSIOLOGY_VAL, "Open coffin Sol applications reduced BURN physiology below 1.")
	vampire.remove_status_effect(/datum/status_effect/bloodsucker_sol)
	TEST_ASSERT_EQUAL(GET_PHYSIOLOGY(vampire, BURN), DEFAULT_PHYSIOLOGY_VAL, "Removing Sol did not restore BURN physiology to 1.")
	vampire.forceMove(run_loc_floor_bottom_left)

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

	vampire.mind.remove_antag_datum(/datum/antagonist/bloodsucker)
	GLOB.bloodsucker_sunlight.sunlight_active = saved_sunlight_active
	GLOB.bloodsucker_sunlight.processing = saved_sunlight_processing
	if(saved_sunlight_processing)
		START_PROCESSING(SSprocessing, GLOB.bloodsucker_sunlight)
	else
		STOP_PROCESSING(SSprocessing, GLOB.bloodsucker_sunlight)
	sunlight_state_saved = FALSE

TEST_FOCUS(/datum/unit_test/bloodsucker_regressions)

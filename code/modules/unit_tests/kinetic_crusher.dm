/// Tests that the Kinetic Crusher fires a projectile on RMB
/datum/unit_test/crusher_projectile

/datum/unit_test/crusher_projectile/Run()
	var/mob/living/carbon/human/consistent/attacker = EASY_ALLOCATE()
	var/obj/item/kinetic_crusher/crusher = EASY_ALLOCATE()

	attacker.put_in_active_hand(crusher, forced = TRUE)
	crusher.attack_self(attacker) // wields the crusher

	click_wrapper(attacker, run_loc_floor_top_right, list(RIGHT_CLICK = TRUE, BUTTON = RIGHT_CLICK))

	TEST_ASSERT(!crusher.charged, "Attacker failed to fire the kinetic crusher on right clicking a distant target")

/datum/unit_test/kinetic_hammer_stats

/datum/unit_test/kinetic_hammer_stats/Run()
	var/obj/item/kinetic_crusher/hammer/hammer = EASY_ALLOCATE()

	TEST_ASSERT(hammer.armour_penetration == 0, "Hammer should have no armour penetration")
	TEST_ASSERT(hammer.attack_speed == CLICK_CD_SLOW, "Hammer should swing slowly")
	TEST_ASSERT(hammer.charge_time == 3 SECONDS, "Hammer should have a slower recharge")
	TEST_ASSERT(hammer.w_class == WEIGHT_CLASS_GIGANTIC, "Hammer should be too bulky to fit in normal storage")

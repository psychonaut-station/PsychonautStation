//////////////////////////////////////////////
//                                          //
//        ROUNDSTART BLOODSUCKER            //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/roundstart/bloodsucker
	name = "Bloodsuckers"
	config_tag = "Roundstart Bloodsucker"
	preview_antag_datum = /datum/antagonist/bloodsucker
	pref_flag = ROLE_BLOODSUCKER
	weight = 3
	min_pop = 20
	max_antag_cap = list("denominator" = 24)
	track = EVENT_TRACK_MODERATE
	tags = list(TAG_COMBAT, TAG_CREW_ANTAG)

/datum/dynamic_ruleset/roundstart/bloodsucker/assign_role(datum/mind/candidate)
	candidate.add_antag_datum(/datum/antagonist/bloodsucker)

//////////////////////////////////////////////
//                                          //
//          MIDROUND BLOODSUCKER            //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/from_living/bloodsucker
	name = "Bloodsucker Breakout"
	config_tag = "Midround Bloodsucker"
	preview_antag_datum = /datum/antagonist/bloodsucker
	midround_type = HEAVY_MIDROUND
	ruleset_flags = RULESET_VARIATION
	pref_flag = ROLE_BLOODSUCKER_BREAKOUT
	jobban_flag = ROLE_BLOODSUCKER
	weight = alist(
		DYNAMIC_TIER_LOW = 0,
		DYNAMIC_TIER_LOWMEDIUM = 1,
		DYNAMIC_TIER_MEDIUMHIGH = 3,
		DYNAMIC_TIER_HIGH = 3,
	)
	min_pop = 20
	repeatable = FALSE
	track = EVENT_TRACK_MODERATE
	tags = list(TAG_COMBAT, TAG_CREW_ANTAG)

/datum/dynamic_ruleset/midround/from_living/bloodsucker/assign_role(datum/mind/candidate)
	var/datum/antagonist/bloodsucker/bloodsuckerdatum = candidate.add_antag_datum(/datum/antagonist/bloodsucker)
	if(bloodsuckerdatum)
		bloodsuckerdatum.bloodsucker_level_unspent = rand(2, 3)
		bloodsuckerdatum.update_hud()

//////////////////////////////////////////////
//                                          //
//          LATEJOIN BLOODSUCKER            //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/latejoin/bloodsucker
	name = "Stowaway Bloodsucker"
	config_tag = "Latejoin Bloodsucker"
	preview_antag_datum = /datum/antagonist/bloodsucker
	ruleset_flags = RULESET_VARIATION
	pref_flag = ROLE_STOWAWAY_BLOODSUCKER
	jobban_flag = ROLE_BLOODSUCKER
	weight = 2
	min_pop = 20
	repeatable = FALSE
	track = EVENT_TRACK_MODERATE
	tags = list(TAG_COMBAT, TAG_CREW_ANTAG)

/datum/dynamic_ruleset/latejoin/bloodsucker/assign_role(datum/mind/candidate)
	var/datum/antagonist/bloodsucker/bloodsuckerdatum = candidate.add_antag_datum(/datum/antagonist/bloodsucker)
	if(bloodsuckerdatum)
		bloodsuckerdatum.bloodsucker_level_unspent = rand(2, 3)
		bloodsuckerdatum.update_hud()


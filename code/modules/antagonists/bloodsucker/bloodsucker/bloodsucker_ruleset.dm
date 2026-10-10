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
	blacklisted_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_SECURITY,
		JOB_PRISONER,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_CURATOR,
		JOB_AI,
		JOB_CYBORG,
	)
	track = EVENT_TRACK_MUNDANE
	tags = list(TAG_COMBAT, TAG_CREW_ANTAG)

/datum/dynamic_ruleset/roundstart/bloodsucker/assign_role(datum/mind/candidate)
	candidate.make_bloodsucker()

//////////////////////////////////////////////
//                                          //
//          MIDROUND BLOODSUCKER            //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/from_living/bloodsucker
	name = "Vampiric Accident"
	config_tag = "Midround Bloodsucker"
	preview_antag_datum = /datum/antagonist/bloodsucker
	midround_type = HEAVY_MIDROUND
	pref_flag = ROLE_VAMPIRICACCIDENT
	jobban_flag = ROLE_BLOODSUCKER
	weight = alist(
		DYNAMIC_TIER_LOW = 0,
		DYNAMIC_TIER_LOWMEDIUM = 1,
		DYNAMIC_TIER_MEDIUMHIGH = 3,
		DYNAMIC_TIER_HIGH = 3,
	)
	min_pop = 20
	repeatable = FALSE
	blacklisted_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_SECURITY,
		JOB_PRISONER,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_CURATOR,
		JOB_AI,
		JOB_CYBORG,
	)
	track = EVENT_TRACK_MAJOR
	tags = list(TAG_COMBAT, TAG_CREW_ANTAG)

/datum/dynamic_ruleset/midround/from_living/bloodsucker/assign_role(datum/mind/candidate)
	var/datum/antagonist/bloodsucker/bloodsuckerdatum = candidate.make_bloodsucker()
	if(bloodsuckerdatum)
		bloodsuckerdatum.bloodsucker_level_unspent = rand(2, 3)

//////////////////////////////////////////////
//                                          //
//          LATEJOIN BLOODSUCKER            //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/latejoin/bloodsucker
	name = "Bloodsucker Breakout"
	config_tag = "Latejoin Bloodsucker"
	preview_antag_datum = /datum/antagonist/bloodsucker
	pref_flag = ROLE_BLOODSUCKERBREAKOUT
	jobban_flag = ROLE_BLOODSUCKER
	weight = 2
	min_pop = 20
	repeatable = FALSE
	blacklisted_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_SECURITY,
		JOB_PRISONER,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_CURATOR,
		JOB_AI,
		JOB_CYBORG,
	)
	track = EVENT_TRACK_MUNDANE
	tags = list(TAG_COMBAT, TAG_CREW_ANTAG)

/datum/dynamic_ruleset/latejoin/bloodsucker/assign_role(datum/mind/candidate)
	var/datum/antagonist/bloodsucker/bloodsuckerdatum = candidate.make_bloodsucker()
	if(bloodsuckerdatum)
		bloodsuckerdatum.bloodsucker_level_unspent = rand(2, 3)

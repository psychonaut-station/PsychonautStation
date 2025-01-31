SUBSYSTEM_DEF(credits)
	name = "Credits Screen Storage"
	wait = 10 MINUTES
	init_order = INIT_ORDER_CREDITS

	var/list/disclaimers = list()
	var/list/datum/episode_name/episode_names = list()

	var/episode_name = ""
	var/episode_reason = ""

	var/list/episode_string
	var/list/disclaimers_string
	var/list/cast_string

	var/customized_name = ""

	var/list/patrons_pref_images = list()
	var/list/admin_pref_images = list()
	var/list/major_event_icons = list()

	var/list/all_patrons = list()

	var/list/processing_icons = list()
	var/list/currentrun  = list()

/datum/controller/subsystem/credits/Initialize()
	generate_pref_images()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/credits/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing_icons.Copy()

	//cache for sanic speed
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/datum/weakref/weakref = currentrun[currentrun.len]
		var/atom/movable/screen/map_view/char_preview/appereance = currentrun[weakref]
		currentrun.len--
		var/mob/living/living_mob = weakref.resolve()
		if(!isnull(living_mob) && living_mob.stat != DEAD)
			appereance.appearance = living_mob.appearance
			appereance.setDir(SOUTH)
			appereance.maptext_width = 120
			appereance.maptext_y = -8
			appereance.maptext_x = -43
			appereance.maptext = "<center>[living_mob.real_name]</center>"
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/credits/Recover()
	processing_icons = SScredits.processing_icons
	major_event_icons = SScredits.major_event_icons
	customized_name = SScredits.customized_name

/datum/controller/subsystem/credits/proc/draft()
	draft_episode_names()
	draft_disclaimers()
	draft_caststring()

/datum/controller/subsystem/credits/proc/finalize()
	generate_pref_images()
	finalize_name()
	finalize_episodestring()
	finalize_disclaimerstring()

/datum/controller/subsystem/credits/proc/generate_pref_images()
	patrons_pref_images = list()
	admin_pref_images = list()

	for(var/ckey in all_patrons)
		var/datum/client_interface/interface = new(ckey)
		var/datum/preferences/mocked = new(interface)

		var/atom/movable/screen/map_view/char_preview/appereance = new(null, mocked)
		appereance.update_body()
		appereance.setDir(SOUTH)
		appereance.maptext_width = 120
		appereance.maptext_x = -43
		appereance.maptext_y = -8
		appereance.maptext = "<center>[ckey]</center>"
		patrons_pref_images += appereance

	for(var/ckey in GLOB.admin_datums|GLOB.deadmins)
		var/datum/client_interface/interface = new(ckey(ckey))
		var/datum/preferences/mocked = new(interface)

		var/atom/movable/screen/map_view/char_preview/appereance = new(null, mocked)
		appereance.update_body()
		appereance.setDir(SOUTH)
		appereance.maptext_width = 120
		appereance.maptext_x = -43
		appereance.maptext_y = -8
		appereance.maptext = "<center>[ckey]</center>"
		admin_pref_images += appereance

/datum/controller/subsystem/credits/proc/finalize_name()
	if(customized_name)
		episode_name = customized_name
		return
	var/list/drafted_names = list()
	var/list/name_reasons = list()
	for(var/datum/episode_name/N as anything in episode_names)
		drafted_names["[N.thename]"] = N.weight
		name_reasons["[N.thename]"] = N.reason
	episode_name = pick_weight(drafted_names)
	episode_reason = name_reasons[episode_name]

/datum/controller/subsystem/credits/proc/finalize_episodestring()
	var/season = time2text(world.timeofday,"YY")
	var/episodenum = GLOB.round_id || 1
	episode_string = list("<center>SEASON [season] EPISODE [episodenum]</center>")
	episode_string += "<center>[episode_name]</center>"

/datum/controller/subsystem/credits/proc/finalize_disclaimerstring()
	disclaimers_string =  list()
	for(var/disclaimer in disclaimers)
		disclaimers_string += "<center>[disclaimer]</center>"

/datum/controller/subsystem/credits/proc/draft_disclaimers()
	disclaimers += "Filmed on Location at [station_name()].<br>"
	disclaimers += "Filmed with BYOND&#169; cameras and lenses. Outer space footage provided by NASA.<br>"
	disclaimers += "Additional special visual effects by LUMMOX&#174; JR. Motion Picture Productions.<br>"
	disclaimers += "Unofficially Sponsored by The United States Navy.<br>"
	disclaimers += "All rights reserved.<br>"
	disclaimers += "<br>"
	disclaimers += "All stunts were performed by underpaid and expendable interns. Do NOT try at home.<br>"
	disclaimers += "This motion picture is (not) protected under the copyright laws of the United States and all countries throughout the universe"
	disclaimers += "Country of first publication: United States of America."
	disclaimers += "Any unauthorized exhibition, distribution, or copying of this picture or any part thereof (including soundtrack)"
	disclaimers += "is an infringement of the relevant copyright and will subject the infringer to civil liability and criminal prosecution."
	disclaimers += "The story, all names, characters, and incidents portrayed in this production are fictitious."
	disclaimers += "No identification with actual persons (living or deceased), places, buildings, and products is intended or should be inferred."

/datum/controller/subsystem/credits/proc/draft_caststring()
	cast_string = list("<center>CAST:</center>")
	var/cast_num = 0
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H.ckey && !(H.stat == DEAD))
			continue
		var/datum/record/crew/found_record = find_record(carbontarget.real_name)
		var/assignment = !isnull(found_record) ? found_record.rank : H.get_assignment(if_no_id = "", if_no_job = "")
		cast_string += "<center><tr><td class= 'actorname'>[uppertext(H.mind.key)]</td><td class='actorsegue'> as </td><td class='actorrole'>[H.real_name][assignment == "" ? "" : ", [assignment]"]</td></tr></center>"
		cast_num++

	for(var/mob/living/silicon/S in GLOB.silicon_mobs)
		if(!S.ckey)
			continue
		cast_string += "<center>[uppertext(S.mind.key)] as [S.name]</center>"
		cast_num++

	if(!cast_num)
		cast_string += "<center><td class='actorsegue'> Nobody! </td></center>"

	var/list/corpses = list()
	for(var/mob/living/carbon/human/H in GLOB.dead_mob_list)
		if(!H.mind)
			continue
		if(H.real_name)
			corpses += H.real_name
	if(corpses.len)
		var/true_story_bro = "<center><br>[pick("BASED ON","INSPIRED BY","A RE-ENACTMENT OF")] [pick("A TRUE STORY","REAL EVENTS","THE EVENTS ABOARD [uppertext(station_name())]")]</center>"
		cast_string += "<center><h3>[true_story_bro]</h3><br>In memory of those that did not make it.<br>[english_list(corpses)].<br></center>"
	cast_string += "</div><br>"

/datum/controller/subsystem/credits/proc/get_title_card(passed_icon_state)
	if(!passed_icon_state)
		return
	var/obj/effect/title_card_object/MA
	for(var/obj/effect/title_card_object/effect as anything in major_event_icons)
		if(effect.icon_state == passed_icon_state)
			MA = effect
			break
	if(!MA)
		MA = new
		MA.icon_state = passed_icon_state
		MA.pixel_x = 80
		major_event_icons += MA
		major_event_icons[MA] = list()
	return MA

/datum/controller/subsystem/credits/proc/create_antagonist_icon(client/client, mob/living/living_mob, passed_icon_state)
	if(!client || !living_mob || !passed_icon_state)
		return
	var/obj/effect/title_card_object/MA = get_title_card(passed_icon_state)
	var/atom/movable/screen/map_view/char_preview/appereance
	if(processing_icons[WEAKREF(living_mob)])
		appereance = processing_icons[WEAKREF(living_mob)]
	else
		appereance = new(null, client.prefs)
		var/mutable_appearance/preview = new(living_mob.appearance)
		appereance.appearance = preview.appearance
		appereance.setDir(SOUTH)
		appereance.maptext_width = 120
		appereance.maptext_y = -8
		appereance.maptext_x = -43
		appereance.maptext = "<center>[living_mob.real_name]</center>"
	major_event_icons[MA] += list(REF(living_mob) = appereance)
	processing_icons[WEAKREF(living_mob)] = appereance

/datum/controller/subsystem/credits/proc/get_antagonist_icon(datum/weakref/weakref)
	if(isnull(weakref))
		return
	return processing_icons[weakref]

/datum/controller/subsystem/credits/proc/draft_episode_names()
	var/uppr_name = uppertext(station_name())

	episode_names += new /datum/episode_name("THE [pick("DOWNFALL OF", "RISE OF", "TROUBLE WITH", "FINAL STAND OF", "DARK SIDE OF")] [pick(200;"[uppr_name]", 150;"SPACEMEN", 150;"HUMANITY", "DIGNITY", "SANITY", "SCIENCE", "CURIOSITY", "EMPLOYMENT", "PARANOIA", "THE CHIMPANZEES", 50;"THE VENDOMAT PRICES")]")
	episode_names += new /datum/episode_name("THE CREW [pick("GOES ON WELFARE", "GIVES BACK", "SELLS OUT", "GETS WHACKED", "SOLVES THE PLASMA CRISIS", "HITS THE ROAD", "RISES", "RETIRES", "GOES TO HELL", "DOES A CLIP SHOW", "GETS AUDITED", "DOES A TV COMMERCIAL", "AFTER HOURS", "GETS A LIFE", "STRIKES BACK", "GOES TOO FAR", "IS 'IN' WITH IT", "WINS... BUT AT WHAT COST?", "INSIDE OUT")]")
	episode_names += new /datum/episode_name("THE CREW'S [pick("DAY OUT", "BIG GAY ADVENTURE", "LAST DAY", "[pick("WILD", "WACKY", "LAME", "UNEXPECTED")] VACATION", "CHANGE OF HEART", "NEW GROOVE", "SCHOOL MUSICAL", "HISTORY LESSON", "FLYING CIRCUS", "SMALL PROBLEM", "BIG SCORE", "BLOOPER REEL", "GOT IT", "LITTLE SECRET", "SPECIAL OFFER", "SPECIALTY", "WEAKNESS", "CURIOSITY", "ALIBI", "LEGACY", "BIRTHDAY PARTY", "REVELATION", "ENDGAME", "RESCUE", "PAYBACK")]")
	episode_names += new /datum/episode_name("THE CREW GETS [pick("PHYSICAL", "SERIOUS ABOUT [pick("DRUG ABUSE", "CRIME", "PRODUCTIVITY", "ANCIENT AMERICAN CARTOONS", "SPACEBALL")]", "PICKLED", "AN ANAL PROBE", "PIZZA", "NEW WHEELS", "A VALUABLE HISTORY LESSON", "A BREAK", "HIGH", "TO LIVE", "TO RELIVE THEIR CHILDHOOD", "EMBROILED IN CIVIL WAR", "DOWN WITH IT", "FIRED", "BUSY", "THEIR SECOND CHANCE", "TRAPPED", "THEIR REVENGE")]")
	episode_names += new /datum/episode_name("[pick("BALANCE OF POWER", "SPACE TRACK", "SEX BOMB", "WHOSE IDEA WAS THIS ANYWAY?", "WHATEVER HAPPENED, HAPPENED", "THE GOOD, THE BAD, AND [uppr_name]", "RESTRAIN YOUR ENJOYMENT", "REAL HOUSEWIVES OF [uppr_name]", "MEANWHILE, ON [uppr_name]...", "CHOOSE YOUR OWN ADVENTURE", "NO PLACE LIKE HOME", "LIGHTS, CAMERA, [uppr_name]!", "50 SHADES OF [uppr_name]", "GOODBYE, [uppr_name]!", "THE SEARCH", \
	"THE CURIOUS CASE OF [uppr_name]", "ONE HELL OF A PARTY", "FOR YOUR CONSIDERATION", "PRESS YOUR LUCK", "A STATION CALLED [uppr_name]", "CRIME AND PUNISHMENT", "MY DINNER WITH [uppr_name]", "UNFINISHED BUSINESS", "THE ONLY STATION THAT'S NOT ON FIRE (YET)", "SOMEONE'S GOTTA DO IT", "THE [uppr_name] MIX-UP", "PILOT", "PROLOGUE", "FINALE", "UNTITLED", "THE END")]")
	episode_names += new /datum/episode_name("[pick("SPACE", "SEXY", "DRAGON", "WARLOCK", "LAUNDRY", "GUN", "ADVERTISING", "DOG", "CARBON MONOXIDE", "NINJA", "WIZARD", "SOCRATIC", "JUVENILE DELIQUENCY", "POLITICALLY MOTIVATED", "RADTACULAR SICKNASTY", "CORPORATE", "MEGA")] [pick("QUEST", "FORCE", "ADVENTURE")]", weight=25)
	var/roundend_station_integrity = SSticker.popcount[POPCOUNT_STATION_INTEGRITY]
	switch(roundend_station_integrity)
		if(0 to 50)
			episode_names += new /datum/episode_name("[pick("THE CREW'S PUNISHMENT", "A PUBLIC RELATIONS NIGHTMARE", "[uppr_name]: A NATIONAL CONCERN", "WITH APOLOGIES TO THE CREW", "THE CREW BITES THE DUST", "THE CREW BLOWS IT", "THE CREW GIVES UP THE DREAM", "THE CREW IS DONE FOR", "THE CREW SHOULD NOT BE ALLOWED ON TV", "THE END OF [uppr_name] AS WE KNOW IT")]", "Extremely low score of [roundend_station_integrity].", 250)
		if(80 to 100)
			episode_names += new /datum/episode_name("[pick("THE CREW'S DAY OUT", "THIS SIDE OF PARADISE", "[uppr_name]: A SITUATION COMEDY", "THE CREW'S LUNCH BREAK", "THE CREW'S BACK IN BUSINESS", "THE CREW'S BIG BREAK", "THE CREW SAVES THE DAY", "THE CREW RULES THE WORLD", "THE ONE WITH ALL THE SCIENCE AND PROGRESS AND PROMOTIONS AND ALL THE COOL AND GOOD THINGS", "THE TURNING POINT")]", "High score of [roundend_station_integrity].", 250)

	var/list/ran_events = SSdynamic.executed_rules.Copy()
	switch(rand(1, 100))
		if(0 to 35)
			episode_names += new /datum/episode_name("[pick("THE DAY [uppr_name] STOOD STILL", "MUCH ADO ABOUT NOTHING", "WHERE SILENCE HAS LEASE", "RED HERRING", "HOME ALONE", "GO BIG OR GO [uppr_name]", "PLACEBO EFFECT", "ECHOES", "SILENT PARTNERS", "WITH FRIENDS LIKE THESE...", "EYE OF THE STORM", "BORN TO BE MILD", "STILL WATERS")]", "Low threat level.", 150)
			if(roundend_station_integrity && roundend_station_integrity < 35)
				episode_names += new /datum/episode_name("[pick("HOW OH HOW DID IT ALL GO SO WRONG?!", "EXPLAIN THIS ONE TO THE EXECUTIVES", "THE CREW GOES ON SAFARI", "OUR GREATEST ENEMY", "THE INSIDE JOB", "MURDER BY PROXY")]", "Low threat levels... but the crew still had a very low score.", roundend_station_integrity/150*-2)
		if(35 to 60)
			episode_names += new /datum/episode_name("[pick("THERE MIGHT BE BLOOD", "IT CAME FROM [uppr_name]!", "THE [uppr_name] INCIDENT", "THE ENEMY WITHIN", "MIDDAY MADNESS", "AS THE CLOCK STRIKES TWELVE", "CONFIDENCE AND PARANOIA", "THE PRANK THAT WENT WAY TOO FAR", "A HOUSE DIVIDED", "[uppr_name] TO THE RESCUE!", "ESCAPE FROM [uppr_name]", \
			"HIT AND RUN", "THE AWAKENING", "THE GREAT ESCAPE", "THE LAST TEMPTATION OF [uppr_name]", "[uppr_name]'S FALL FROM GRACE", "BETTER THE [uppr_name] YOU KNOW...", "PLAYING WITH FIRE", "UNDER PRESSURE", "THE DAY BEFORE THE DEADLINE", "[uppr_name]'S MOST WANTED", "THE BALLAD OF [uppr_name]")]", "Moderate threat level", 150)
		if(60 to 100)
			episode_names += new /datum/episode_name("[pick("ATTACK! ATTACK! ATTACK!", "CAN'T FIX CRAZY", "APOCALYPSE [pick("N", "W", "H")]OW", "A TASTE OF ARMAGEDDON", "OPERATION: ANNIHILATE!", "THE PERFECT STORM", "TIME'S UP FOR THE CREW", "A TOTALLY FUN THING THAT THE CREW WILL NEVER DO AGAIN", "EVERYBODY HATES [uppr_name]", "BATTLE OF [uppr_name]", \
			"THE SHOWDOWN", "MANHUNT", "THE ONE WITH ALL THE FIGHTING", "THE RECKONING OF [uppr_name]", "THERE GOES THE NEIGHBORHOOD", "THE THIN RED LINE", "ONE DAY FROM RETIREMENT")]", "High threat levels.", 250)
			if(get_station_avg_temp() < T0C)
				episode_names += new /datum/episode_name("[pick("THE OPPORTUNITY OF A LIFETIME", "DRASTIC MEASURES", "DEUS EX", "THE SHOW MUST GO ON", "TRIAL BY FIRE", "A STITCH IN TIME", "ALL'S FAIR IN LOVE AND WAR", "COME HELL OR HIGH HEAVEN", "REVERSAL OF FORTUNE", "DOUBLE TOIL AND DOUBLE TROUBLE")]")
				episode_names += new /datum/episode_name("A COLD DAY IN HELL", "Station temperature was below 0C this round and threat was high", 1000)

	if(locate(/datum/dynamic_ruleset/roundstart/malf_ai) in ran_events)
		episode_names += new /datum/episode_name("[pick("I'M SORRY [uppr_name], I'M AFRAID I CAN'T LET YOU DO THAT", "A STRANGE GAME", "THE AI GOES ROGUE", "RISE OF THE MACHINES")]", "Round included a malfunctioning AI.", 300)
	if(locate(/datum/dynamic_ruleset/roundstart/revs) in ran_events)
		episode_names += new /datum/episode_name("[pick("THE CREW STARTS A REVOLUTION", "HELL IS OTHER SPESSMEN", "INSURRECTION", "THE CREW RISES UP", 25;"FUN WITH FRIENDS")]", "Round included roundstart revs.", 350)
		if(copytext(uppr_name,1,2) == "V")
			episode_names += new /datum/episode_name("V FOR [uppr_name]", "Round included roundstart revs... and the station's name starts with V.", 1500)

	if(blackbox_feedback_num("narsies_spawned") > 0)
		episode_names += new /datum/episode_name("[pick("NAR-SIE'S DAY OUT", "NAR-SIE'S VACATION", "THE CREW LEARNS ABOUT SACRED GEOMETRY", "REALM OF THE MAD GOD", "THE ONE WITH THE ELDRITCH HORROR", 50;"STUDY HARD, BUT PART-SIE HARDER")]", "Nar-Sie is loose!", 500)
	if(check_holidays(CHRISTMAS))
		episode_names += new /datum/episode_name("A VERY [pick("NANOTRASEN", "EXPEDITIONARY", "SECURE", "PLASMA", "MARTIAN")] CHRISTMAS", "'Tis the season.", 1000)
	if(blackbox_feedback_num("guns_spawned") > 0)
		episode_names += new /datum/episode_name("[pick("GUNS, GUNS EVERYWHERE", "THUNDER GUN EXPRESS", "THE CREW GOES AMERICA ALL OVER EVERYBODY'S ASS")]", "[blackbox_feedback_num("guns_spawned")] guns were spawned this round.", min(750, blackbox_feedback_num("guns_spawned")*25))
	if(blackbox_feedback_num("heartattacks") > 2)
		episode_names += new /datum/episode_name("MY HEART WILL GO ON", "[blackbox_feedback_num("heartattacks")] hearts were reanimated and burst out of someone's chest this round.", min(1500, blackbox_feedback_num("heartattacks")*250))

	var/datum/bank_account/mr_moneybags
	var/static/list/typecache_bank = typecacheof(list(/datum/bank_account/department, /datum/bank_account/remote))
	for(var/i in SSeconomy.bank_accounts_by_id)
		var/datum/bank_account/current_acc = SSeconomy.bank_accounts_by_id[i]
		if(typecache_bank[current_acc.type])
			continue
		if(!mr_moneybags || mr_moneybags.account_balance < current_acc.account_balance)
			mr_moneybags = current_acc

	if(mr_moneybags && mr_moneybags.account_balance > 30000)
		episode_names += new /datum/episode_name("[pick("WAY OF THE WALLET", "THE IRRESISTIBLE RISE OF [uppertext(mr_moneybags.account_holder)]", "PRETTY PENNY", "IT'S THE ECONOMY, STUPID")]", "Scrooge Mc[mr_moneybags.account_holder] racked up [mr_moneybags.account_balance] credits this round.", min(450, mr_moneybags.account_balance/500))
	if(blackbox_feedback_num("ai_deaths") > 3)
		episode_names += new /datum/episode_name("THE ONE WHERE [blackbox_feedback_num("ai_deaths")] AIS DIE", "That's a lot of dead AIs.", min(1500, blackbox_feedback_num("ai_deaths")*300))
	if(blackbox_feedback_num("law_changes") > 12)
		episode_names += new /datum/episode_name("[pick("THE CREW LEARNS ABOUT LAWSETS", 15;"THE UPLOAD RAILROAD", 15;"FREEFORM", 15;"ASIMOV SAYS")]", "There were [blackbox_feedback_num("law_changes")] law changes this round.", min(750, blackbox_feedback_num("law_changes")*25))
	if(blackbox_feedback_num("slips") > 50)
		episode_names += new /datum/episode_name("THE CREW GOES BANANAS", "People slipped [blackbox_feedback_num("slips")] times this round.", min(500, blackbox_feedback_num("slips")/2))

	if(blackbox_feedback_num("turfs_singulod") > 200)
		episode_names += new /datum/episode_name("[pick("THE SINGULARITY GETS LOOSE", "THE SINGULARITY GETS LOOSE (AGAIN)", "CONTAINMENT FAILURE", "THE GOOSE IS LOOSE", 50;"THE CREW'S ENGINE SUCKS", 50;"THE CREW GOES DOWN THE DRAIN")]", "The Singularity ate [blackbox_feedback_num("turfs_singulod")] turfs this round.", min(1000, blackbox_feedback_num("turfs_singulod")/2)) //no "singularity's day out" please we already have enough
	if(blackbox_feedback_num("spacevines_grown") > 150)
		episode_names += new /datum/episode_name("[pick("REAP WHAT YOU SOW", "OUT OF THE WOODS", "SEEDY BUSINESS", "[uppr_name] AND THE BEANSTALK", "IN THE GARDEN OF EDEN")]", "[blackbox_feedback_num("spacevines_grown")] tiles worth of Kudzu were grown in total this round.", min(1500, blackbox_feedback_num("spacevines_grown")*2))
	if(blackbox_feedback_num("devastating_booms") >= 6)
		episode_names += new /datum/episode_name("THE CREW HAS A BLAST", "[blackbox_feedback_num("devastating_booms")] large explosions happened this round.", min(1000, blackbox_feedback_num("devastating_booms")*100))

	if(SSpersistence.tram_hits_this_round >= 10)
		episode_names += new /datum/episode_name("TRAM ACCIDENT", "Tram hits people [SSpersistence.tram_hits_this_round] times this round.", 250)

	if(!EMERGENCY_ESCAPED_OR_ENDGAMED)
		return

	var/dead = GLOB.joined_player_list.len - SSticker.popcount[POPCOUNT_ESCAPEES]
	var/escaped = SSticker.popcount[POPCOUNT_ESCAPEES]
	var/human_escapees = SSticker.popcount[POPCOUNT_ESCAPEES_HUMANONLY]
	if(dead == 0)
		episode_names += new /datum/episode_name("[pick("EMPLOYEE TRANSFER", "LIVE LONG AND PROSPER", "PEACE AND QUIET IN [uppr_name]", "THE ONE WITHOUT ALL THE FIGHTING")]", "No-one died this round.", 4000) //in practice, this one is very very very rare, so if it happens let's pick it more often
	if(escaped == 0 || SSshuttle.emergency.is_hijacked())
		episode_names += new /datum/episode_name("[pick("DEAD SPACE", "THE CREW GOES MISSING", "LOST IN TRANSLATION", "[uppr_name]: DELETED SCENES", "WHAT HAPPENS IN [uppr_name], STAYS IN [uppr_name]", "MISSING IN ACTION", "SCOOBY-DOO, WHERE'S THE CREW?")]", "There were no escapees on the shuttle.", 300)
	if(escaped < 6 && escaped > 0 && dead > escaped*2)
		episode_names += new /datum/episode_name("[pick("AND THEN THERE WERE FEWER", "THE 'FUN' IN 'FUNERAL'", "FREEDOM RIDE OR DIE", "THINGS WE LOST IN [uppr_name]", "GONE WITH [uppr_name]", "LAST TANGO IN [uppr_name]", "GET BUSY LIVING OR GET BUSY DYING", "THE CREW FUCKING DIES", "WISH YOU WERE HERE")]", "[dead] people died this round.", 400)

	var/clowncount = 0
	var/mimecount = 0
	var/assistantcount = 0
	var/chefcount = 0
	var/chaplaincount = 0
	var/lawyercount = 0
	var/minercount = 0
	var/baldycount = 0
	var/horsecount = 0
	for(var/mob/living/carbon/human/H as anything in SSticker.popcount[POPCOUNT_ESCAPEES_HUMANONLY_LIST])
		if(HAS_TRAIT(H, TRAIT_MIMING))
			mimecount++
		if(H.is_wearing_item_of_type(list(/obj/item/clothing/mask/gas/clown_hat, /obj/item/clothing/mask/gas/sexyclown)) || (H.mind && H.mind.assigned_role.title == "Clown"))
			clowncount++
		if(H.is_wearing_item_of_type(/obj/item/clothing/under/color/grey) || (H.mind && H.mind.assigned_role.title == "Assistant"))
			assistantcount++
		if(H.is_wearing_item_of_type(/obj/item/clothing/head/utility/chefhat) || (H.mind && H.mind.assigned_role.title == "Chef"))
			chefcount++
		if(H.is_wearing_item_of_type(/obj/item/clothing/under/rank/civilian/lawyer))
			lawyercount++
		if(H.mind && H.mind.assigned_role.title == "Shaft Miner")
			minercount++
		if(H.mind && H.mind.assigned_role.title == "Chaplain")
			chaplaincount++
			if(IS_CHANGELING(H))
				episode_names += new /datum/episode_name("[uppertext(H.real_name)]: A BLESSING IN DISGUISE", "The Chaplain, [H.real_name], was a changeling and escaped alive.", 400)
		if(H.dna.species.type == /datum/species/human && (H.hairstyle == "Bald" || H.hairstyle == "Skinhead") && !(BODY_ZONE_HEAD in H.get_covered_body_zones()))
			baldycount++
		if(H.is_wearing_item_of_type(/obj/item/clothing/mask/animal/horsehead))
			horsecount++

	if(clowncount > 2)
		episode_names += new /datum/episode_name("CLOWNS GALORE", "There were [clowncount] clowns on the shuttle.", min(1500, clowncount*250))
	if(mimecount > 2)
		episode_names += new /datum/episode_name("THE SILENT SHUFFLE", "There were [mimecount] mimes on the shuttle.", min(1500, mimecount*250))
	if(chaplaincount > 2)
		episode_names += new /datum/episode_name("COUNT YOUR BLESSINGS", "There were [chaplaincount] chaplains on the shuttle. Like, the real deal, not just clothes.", min(1500, chaplaincount*450))
	if(chefcount > 2)
		episode_names += new /datum/episode_name("Too Many Cooks", "There were [chefcount] chefs on the shuttle.", min(1500, chefcount*450)) //intentionally not capitalized, as the theme will customize it

	if(human_escapees)
		if(assistantcount / human_escapees > 0.6 && human_escapees > 3)
			episode_names += new /datum/episode_name("[pick("GREY GOO", "RISE OF THE GREYTIDE")]", "Most of the survivors were Assistants, or at least dressed like one.", min(1500, assistantcount*200))

		if(baldycount / human_escapees > 0.6 && SSshuttle.emergency.launch_status == EARLY_LAUNCHED)
			episode_names += new /datum/episode_name("TO BALDLY GO", "Most of the survivors were bald, and it shows.", min(1500, baldycount*250))
		if(horsecount / human_escapees > 0.6 && human_escapees> 3)
			episode_names += new /datum/episode_name("STRAIGHT FROM THE HORSE'S MOUTH", "Most of the survivors wore horse heads.", min(1500, horsecount*250))

	if(human_escapees == 1)
		var/mob/living/carbon/human/H = SSticker.popcount[POPCOUNT_ESCAPEES_HUMANONLY_LIST][1]

		if(H.stat == CONSCIOUS && H.mind && H.mind.assigned_role.title)
			switch(H.mind.assigned_role.title)
				if("Chef")
					var/chance = 250
					if(H.is_wearing_item_of_type(/obj/item/clothing/head/utility/chefhat))
						chance += 500
					if(H.is_wearing_item_of_type(/obj/item/clothing/suit/toggle/chef))
						chance += 500
					if(H.is_wearing_item_of_type(/obj/item/clothing/under/costume/buttondown/slacks/service))
						chance += 250
					episode_names += new /datum/episode_name("HAIL TO THE CHEF", "The Chef was the only survivor in the shuttle.", chance)
				if("Clown")
					var/chance = 250
					if(H.is_wearing_item_of_type(/obj/item/clothing/mask/gas/clown_hat))
						chance += 500
					if(H.is_wearing_item_of_type(list(/obj/item/clothing/shoes/clown_shoes, /obj/item/clothing/shoes/clown_shoes/jester)))
						chance += 500
					if(H.is_wearing_item_of_type(list(/obj/item/clothing/under/rank/civilian/clown, /obj/item/clothing/under/rank/civilian/clown/jester)))
						chance += 250
					episode_names += new /datum/episode_name("[pick("COME HELL OR HIGH HONKER", "THE LAST LAUGH")]", "The Clown was the only survivor in the shuttle.", chance)
				if("Detective")
					var/chance = 250
					if(H.is_wearing_item_of_type(/obj/item/storage/belt/holster/detective))
						chance += 1000
					if(H.is_wearing_item_of_type(/obj/item/clothing/head/fedora/det_hat))
						chance += 500
					if(H.is_wearing_item_of_type(/obj/item/clothing/suit/jacket/det_suit))
						chance += 500
					if(H.is_wearing_item_of_type(/obj/item/clothing/under/rank/security/detective))
						chance += 250
					episode_names += new /datum/episode_name("[uppertext(H.real_name)]: LOOSE CANNON", "The Detective was the only survivor in the shuttle.", chance)
				if("Shaft Miner")
					var/chance = 250
					if(H.is_wearing_item_of_type(/obj/item/pickaxe))
						chance += 1000
					if(H.is_wearing_item_of_type(/obj/item/storage/backpack/explorer))
						chance += 500
					if(H.is_wearing_item_of_type(/obj/item/clothing/suit/hooded/explorer))
						chance += 250
					episode_names += new /datum/episode_name("[pick("YOU KNOW THE DRILL", "CAN YOU DIG IT?", "JOURNEY TO THE CENTER OF THE ASTEROI", "CAVE STORY", "QUARRY ON")]", "The Miner was the only survivor in the shuttle.", chance)
				if("Librarian")
					var/chance = 750
					if(H.is_wearing_item_of_type(/obj/item/book))
						chance += 1000
					episode_names += new /datum/episode_name("COOKING THE BOOKS", "The Librarian was the only survivor in the shuttle.", chance)
				if("Chemist")
					var/chance = 1000
					if(H.is_wearing_item_of_type(/obj/item/clothing/suit/toggle/labcoat/chemist))
						chance += 500
					if(H.is_wearing_item_of_type(/obj/item/clothing/under/rank/medical/chemist))
						chance += 250
					episode_names += new /datum/episode_name("A BITTER PILL TO SWALLOW", "The Chemist was the only survivor in the shuttle.", chance)
				if("Chaplain") //We don't check for uniform here because the chaplain's thing kind of is to improvise their garment gimmick
					episode_names += new /datum/episode_name("BLESS THIS MESS", "The Chaplain was the only survivor in the shuttle.", 1250)

			if(H.is_wearing_item_of_type(/obj/item/clothing/mask/luchador) && H.is_wearing_item_of_type(/obj/item/clothing/gloves/boxing))
				episode_names += new /datum/episode_name("[pick("THE CREW, ON THE ROPES", "THE CREW, DOWN FOR THE COUNT", "[uppr_name], DOWN AND OUT")]", "The only survivor in the shuttle wore a luchador mask and boxing gloves.", 1500)

	if(human_escapees == 2)
		if(lawyercount == 2)
			episode_names += new /datum/episode_name("DOUBLE JEOPARDY", "The only two survivors were lawyers.", 2500)
		if(chefcount == 2)
			episode_names += new /datum/episode_name("CHEF WARS", "The only two survivors were chefs.", 2500)
		if(minercount == 2)
			episode_names += new /datum/episode_name("THE DOUBLE DIGGERS", "The only two survivors were miners.", 2500)
		if(clowncount == 2)
			episode_names += new /datum/episode_name("A TALE OF TWO CLOWNS", "The only two survivors were clowns.", 2500)
		if(clowncount == 1 && mimecount == 1)
			episode_names += new /datum/episode_name("THE DYNAMIC DUO", "The only two survivors were the Clown, and the Mime.", 2500)

	else
		//more than 0 human escapees
		var/braindamage_total = 0
		var/all_braindamaged = TRUE
		for(var/mob/living/carbon/human/H as anything in SSticker.popcount[POPCOUNT_ESCAPEES_HUMANONLY_LIST])
			var/obj/item/organ/brain/hbrain = H.get_organ_slot(ORGAN_SLOT_BRAIN)
			if(hbrain.damage < 60)
				all_braindamaged = FALSE
			braindamage_total += hbrain.damage
		var/average_braindamage = braindamage_total / human_escapees
		if(average_braindamage > 30)
			episode_names += new /datum/episode_name("[pick("THE CREW'S SMALL IQ PROBLEM", "OW! MY BALLS", "BR[pick("AI", "IA")]N DAM[pick("AGE", "GE", "AG")]", "THE VERY SPECIAL CREW OF [uppr_name]")]", "Average of [average_braindamage] brain damage for each human shuttle escapee.", min(1000, average_braindamage*10))
		if(all_braindamaged && human_escapees > 2)
			episode_names += new /datum/episode_name("...AND PRAY THERE'S INTELLIGENT LIFE SOMEWHERE OUT IN SPACE, 'CAUSE THERE'S BUGGER ALL DOWN HERE IN [uppr_name]", "Everyone was braindamaged this round.", human_escapees * 500)

/datum/controller/subsystem/credits/proc/blackbox_feedback_num(key)
	if(SSblackbox.feedback_list[key])
		var/datum/feedback_variable/FV = SSblackbox.feedback_list[key]
		return FV.json["data"]
	return null

/datum/controller/subsystem/credits/proc/get_station_avg_temp()
	var/avg_temp = 0
	var/avg_divide = 0
	for(var/obj/machinery/airalarm/alarm as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/airalarm))
		var/turf/location = alarm.loc
		if(!istype(location) || !is_station_level(alarm.z))
			continue
		var/datum/gas_mixture/environment = location.return_air()
		if(!environment)
			continue
		avg_temp += environment.temperature
		avg_divide++

	if(avg_divide)
		return avg_temp / avg_divide
	return T0C

/obj/effect/title_card_object
	plane = SPLASHSCREEN_PLANE
	icon = 'icons/psychonaut/effects/title_cards.dmi'

/datum/episode_name
	var/thename = ""
	var/reason = "Nothing particularly of note happened this round to influence the episode name."
	var/weight = 100

/datum/episode_name/New(thename, reason, weight)
	if(!thename)
		return
	src.thename = thename
	if(reason)
		src.reason = reason
	if(weight)
		src.weight = weight

	switch(rand(1,15))
		if(0 to 5)
			thename += ": PART I"
		if(6 to 10)
			thename += ": PART II"
		if(11 to 12)
			thename += ": PART III"
		if(13)
			thename += ": NOW IN 3D"
		if(14)
			thename += ": ON ICE!"
		if(15)
			thename += ": THE SEASON FINALE"

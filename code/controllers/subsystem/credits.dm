SUBSYSTEM_DEF(credits)
	name = "Credits Screen Storage"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_CREDITS

	var/star = ""
	var/ss = ""
	var/list/disclaimers = list()
	var/list/datum/episode_name/episode_names = list()

	var/episode_name = ""
	var/episode_reason = ""
	var/producers_string = ""
	var/list/episode_string
	var/list/disclaimers_string
	var/list/cast_string

	//If any of the following five are modified, the episode is considered "not a rerun".
	var/customized_name = ""
	var/customized_star = ""
	var/customized_ss = ""
	var/rare_episode_name = FALSE
	var/theme = "NT"

	var/js_args = list()

	var/list/patrons_pref_images = list()
	var/list/admin_pref_images = list()
	var/list/major_event_icons = list()
	var/list/all_patrons = list("RengaN")

/datum/controller/subsystem/credits/Initialize()
	generate_pref_images()
	return SS_INIT_SUCCESS

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
		appereance.maptext_width = 120
		appereance.maptext_y = -8
		appereance.maptext_x = -42
		appereance.maptext = "<center>[ckey]</center>"
		patrons_pref_images += appereance

	for(var/ckey in GLOB.admin_datums)
		var/datum/client_interface/interface = new(ckey(ckey))
		var/datum/preferences/mocked = new(interface)

		var/atom/movable/screen/map_view/char_preview/appereance = new(null, mocked)
		appereance.update_body()
		appereance.maptext_width = 120
		appereance.maptext_x = -42
		appereance.maptext_y = -8
		appereance.maptext = "<center>[ckey]</center>"
		admin_pref_images += appereance

/datum/controller/subsystem/credits/proc/draft_star()
	var/mob/living/carbon/human/most_talked
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H.ckey || H.stat == DEAD)
			continue
		if(!most_talked || H.talkcount > most_talked.talkcount)
			most_talked = H
	star = thebigstar(most_talked)


/datum/controller/subsystem/credits/proc/finalize_name()
	if(customized_name)
		episode_name = customized_name
		return
	var/list/drafted_names = list()
	var/list/name_reasons = list()
	var/list/is_rare_assoc_list = list()
	for(var/datum/episode_name/N as anything in episode_names)
		drafted_names["[N.thename]"] = N.weight
		name_reasons["[N.thename]"] = N.reason
		is_rare_assoc_list["[N.thename]"] = N.rare
	episode_name = pick_weight(drafted_names)
	episode_reason = name_reasons[episode_name]
	if(is_rare_assoc_list[episode_name] == TRUE)
		rare_episode_name = TRUE

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
		var/assignment = H.get_assignment(if_no_id = "", if_no_job = "")
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


/datum/controller/subsystem/credits/proc/thebigstar(star)
	if(istext(star))
		return star
	if(ismob(star))
		var/mob/M = star
		return "[uppertext(M.mind.key)] as [M.real_name]"

/datum/controller/subsystem/credits/proc/generate_major_icon(list/mobs, passed_icon_state)
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

	major_event_icons[MA] |= mobs

/datum/controller/subsystem/credits/proc/resolve_clients(list/clients, icon_state)
	var/list/created_appearances = list()

	//hell
	if(icon_state == "cult")
		var/datum/team/cult/cult = locate(/datum/team/cult) in GLOB.antagonist_teams
		if(cult)
			for(var/mob/living/cultist in cult.true_cultists)
				if(!cultist.client)
					continue
				clients |= WEAKREF(cultist.client)
	if(icon_state == "revolution")
		var/datum/team/revolution/cult = locate(/datum/team/revolution) in GLOB.antagonist_teams
		if(cult)
			for(var/datum/mind/cultist in (cult.ex_revs + cult.ex_headrevs + cult.members))
				if(!cultist?.current?.client)
					continue
				clients |= WEAKREF(cultist.current.client)

	for(var/datum/weakref/weak as anything in clients)
		var/client/client = weak.resolve()
		if(!client)
			continue
		var/atom/movable/screen/map_view/char_preview/appereance = new(null, client.prefs)
		var/mutable_appearance/preview = new(getFlatIcon(client.mob?.appearance))
		appereance.appearance = preview.appearance
		appereance.maptext_width = 120
		appereance.maptext_y = -8
		appereance.maptext_x = -42
		appereance.maptext = "<center>[client.mob.real_name]</center>"
		created_appearances += appereance
	return created_appearances

/datum/controller/subsystem/credits/proc/draft_episode_names()
	var/uppr_name = uppertext(station_name()) //so we don't run these two 500 times

	episode_names += new /datum/episode_name("THE [pick("DOWNFALL OF", "RISE OF", "TROUBLE WITH", "FINAL STAND OF", "DARK SIDE OF")] [pick(200;"[uppr_name]", 150;"SPACEMEN", 150;"HUMANITY", "DIGNITY", "SANITY", "SCIENCE", "CURIOSITY", "EMPLOYMENT", "PARANOIA", "THE CHIMPANZEES", 50;"THE VENDOMAT PRICES")]")
	episode_names += new /datum/episode_name("THE CREW [pick("GOES ON WELFARE", "GIVES BACK", "SELLS OUT", "GETS WHACKED", "SOLVES THE PLASMA CRISIS", "HITS THE ROAD", "RISES", "RETIRES", "GOES TO HELL", "DOES A CLIP SHOW", "GETS AUDITED", "DOES A TV COMMERCIAL", "AFTER HOURS", "GETS A LIFE", "STRIKES BACK", "GOES TOO FAR", "IS 'IN' WITH IT", "WINS... BUT AT WHAT COST?", "INSIDE OUT")]")
	episode_names += new /datum/episode_name("THE CREW'S [pick("DAY OUT", "BIG GAY ADVENTURE", "LAST DAY", "[pick("WILD", "WACKY", "LAME", "UNEXPECTED")] VACATION", "CHANGE OF HEART", "NEW GROOVE", "SCHOOL MUSICAL", "HISTORY LESSON", "FLYING CIRCUS", "SMALL PROBLEM", "BIG SCORE", "BLOOPER REEL", "GOT IT", "LITTLE SECRET", "SPECIAL OFFER", "SPECIALTY", "WEAKNESS", "CURIOSITY", "ALIBI", "LEGACY", "BIRTHDAY PARTY", "REVELATION", "ENDGAME", "RESCUE", "PAYBACK")]")
	episode_names += new /datum/episode_name("THE CREW GETS [pick("PHYSICAL", "SERIOUS ABOUT [pick("DRUG ABUSE", "CRIME", "PRODUCTIVITY", "ANCIENT AMERICAN CARTOONS", "SPACEBALL")]", "PICKLED", "AN ANAL PROBE", "PIZZA", "NEW WHEELS", "A VALUABLE HISTORY LESSON", "A BREAK", "HIGH", "TO LIVE", "TO RELIVE THEIR CHILDHOOD", "EMBROILED IN CIVIL WAR", "DOWN WITH IT", "FIRED", "BUSY", "THEIR SECOND CHANCE", "TRAPPED", "THEIR REVENGE")]")
	episode_names += new /datum/episode_name("[pick("BALANCE OF POWER", "SPACE TRACK", "SEX BOMB", "WHOSE IDEA WAS THIS ANYWAY?", "WHATEVER HAPPENED, HAPPENED", "THE GOOD, THE BAD, AND [uppr_name]", "RESTRAIN YOUR ENJOYMENT", "REAL HOUSEWIVES OF [uppr_name]", "MEANWHILE, ON [uppr_name]...", "CHOOSE YOUR OWN ADVENTURE", "NO PLACE LIKE HOME", "LIGHTS, CAMERA, [uppr_name]!", "50 SHADES OF [uppr_name]", "GOODBYE, [uppr_name]!", "THE SEARCH", \
	"THE CURIOUS CASE OF [uppr_name]", "ONE HELL OF A PARTY", "FOR YOUR CONSIDERATION", "PRESS YOUR LUCK", "A STATION CALLED [uppr_name]", "CRIME AND PUNISHMENT", "MY DINNER WITH [uppr_name]", "UNFINISHED BUSINESS", "THE ONLY STATION THAT'S NOT ON FIRE (YET)", "SOMEONE'S GOTTA DO IT", "THE [uppr_name] MIX-UP", "PILOT", "PROLOGUE", "FINALE", "UNTITLED", "THE END")]")
	episode_names += new /datum/episode_name("[pick("SPACE", "SEXY", "DRAGON", "WARLOCK", "LAUNDRY", "GUN", "ADVERTISING", "DOG", "CARBON MONOXIDE", "NINJA", "WIZARD", "SOCRATIC", "JUVENILE DELIQUENCY", "POLITICALLY MOTIVATED", "RADTACULAR SICKNASTY", "CORPORATE", "MEGA")] [pick("QUEST", "FORCE", "ADVENTURE")]", weight=25)

	switch(SSticker.roundend_station_integrity)
		if(-INFINITY to -2000)
			episode_names += new /datum/episode_name("[pick("THE CREW'S PUNISHMENT", "A PUBLIC RELATIONS NIGHTMARE", "[uppr_name]: A NATIONAL CONCERN", "WITH APOLOGIES TO THE CREW", "THE CREW BITES THE DUST", "THE CREW BLOWS IT", "THE CREW GIVES UP THE DREAM", "THE CREW IS DONE FOR", "THE CREW SHOULD NOT BE ALLOWED ON TV", "THE END OF [uppr_name] AS WE KNOW IT")]", "Extremely low score of [SSticker.roundend_station_integrity].", 250)
		if(4500 to INFINITY)
			episode_names += new /datum/episode_name("[pick("THE CREW'S DAY OUT", "THIS SIDE OF PARADISE", "[uppr_name]: A SITUATION COMEDY", "THE CREW'S LUNCH BREAK", "THE CREW'S BACK IN BUSINESS", "THE CREW'S BIG BREAK", "THE CREW SAVES THE DAY", "THE CREW RULES THE WORLD", "THE ONE WITH ALL THE SCIENCE AND PROGRESS AND PROMOTIONS AND ALL THE COOL AND GOOD THINGS", "THE TURNING POINT")]", "High score of [SSticker.roundend_station_integrity].", 250)

	if(blackbox_feedback_num("narsies_spawned") > 0)
		episode_names += new /datum/episode_name/rare("[pick("NAR-SIE'S DAY OUT", "NAR-SIE'S VACATION", "THE CREW LEARNS ABOUT SACRED GEOMETRY", "REALM OF THE MAD GOD", "THE ONE WITH THE ELDRITCH HORROR", 50;"STUDY HARD, BUT PART-SIE HARDER")]", "Nar-Sie is loose!", 500)
	if(check_holidays(CHRISTMAS))
		episode_names += new /datum/episode_name("A VERY [pick("NANOTRASEN", "EXPEDITIONARY", "SECURE", "PLASMA", "MARTIAN")] CHRISTMAS", "'Tis the season.", 1000)
	if(blackbox_feedback_num("guns_spawned") > 0)
		episode_names += new /datum/episode_name/rare("[pick("GUNS, GUNS EVERYWHERE", "THUNDER GUN EXPRESS", "THE CREW GOES AMERICA ALL OVER EVERYBODY'S ASS")]", "[blackbox_feedback_num("guns_spawned")] guns were spawned this round.", min(750, blackbox_feedback_num("guns_spawned")*25))
	if(blackbox_feedback_num("heartattacks") > 2)
		episode_names += new /datum/episode_name/rare("MY HEART WILL GO ON", "[blackbox_feedback_num("heartattacks")] hearts were reanimated and burst out of someone's chest this round.", min(1500, blackbox_feedback_num("heartattacks")*250))

	var/datum/bank_account/mr_moneybags
	var/static/list/typecache_bank = typecacheof(list(/datum/bank_account/department, /datum/bank_account/remote))
	for(var/i in SSeconomy.bank_accounts_by_id)
		var/datum/bank_account/current_acc = SSeconomy.bank_accounts_by_id[i]
		if(typecache_bank[current_acc.type])
			continue
		if(!mr_moneybags || mr_moneybags.account_balance < current_acc.account_balance)
			mr_moneybags = current_acc

	if(mr_moneybags && mr_moneybags.account_balance > 30000)
		episode_names += new /datum/episode_name/rare("[pick("WAY OF THE WALLET", "THE IRRESISTIBLE RISE OF [uppertext(mr_moneybags.account_holder)]", "PRETTY PENNY", "IT'S THE ECONOMY, STUPID")]", "Scrooge Mc[mr_moneybags.account_holder] racked up [mr_moneybags.account_balance] credits this round.", min(450, mr_moneybags.account_balance/500))
	if(blackbox_feedback_num("ai_deaths") > 3)
		episode_names += new /datum/episode_name/rare("THE ONE WHERE [blackbox_feedback_num("ai_deaths")] AIS DIE", "That's a lot of dead AIs.", min(1500, blackbox_feedback_num("ai_deaths")*300))
	if(blackbox_feedback_num("law_changes") > 12)
		episode_names += new /datum/episode_name/rare("[pick("THE CREW LEARNS ABOUT LAWSETS", 15;"THE UPLOAD RAILROAD", 15;"FREEFORM", 15;"ASIMOV SAYS")]", "There were [blackbox_feedback_num("law_changes")] law changes this round.", min(750, blackbox_feedback_num("law_changes")*25))
	if(blackbox_feedback_num("slips") > 50)
		episode_names += new /datum/episode_name/rare("THE CREW GOES BANANAS", "People slipped [blackbox_feedback_num("slips")] times this round.", min(500, blackbox_feedback_num("slips")/2))

	if(blackbox_feedback_num("turfs_singulod") > 200)
		episode_names += new /datum/episode_name/rare("[pick("THE SINGULARITY GETS LOOSE", "THE SINGULARITY GETS LOOSE (AGAIN)", "CONTAINMENT FAILURE", "THE GOOSE IS LOOSE", 50;"THE CREW'S ENGINE SUCKS", 50;"THE CREW GOES DOWN THE DRAIN")]", "The Singularity ate [blackbox_feedback_num("turfs_singulod")] turfs this round.", min(1000, blackbox_feedback_num("turfs_singulod")/2)) //no "singularity's day out" please we already have enough
	if(blackbox_feedback_num("spacevines_grown") > 150)
		episode_names += new /datum/episode_name/rare("[pick("REAP WHAT YOU SOW", "OUT OF THE WOODS", "SEEDY BUSINESS", "[uppr_name] AND THE BEANSTALK", "IN THE GARDEN OF EDEN")]", "[blackbox_feedback_num("spacevines_grown")] tiles worth of Kudzu were grown in total this round.", min(1500, blackbox_feedback_num("spacevines_grown")*2))
	if(blackbox_feedback_num("devastating_booms") >= 6)
		episode_names += new /datum/episode_name/rare("THE CREW HAS A BLAST", "[blackbox_feedback_num("devastating_booms")] large explosions happened this round.", min(1000, blackbox_feedback_num("devastating_booms")*100))

/datum/controller/subsystem/credits/proc/blackbox_feedback_num(key)
	if(SSblackbox.feedback_list[key])
		var/datum/feedback_variable/FV = SSblackbox.feedback_list[key]
		return FV.json["data"]
	return null

/obj/effect/title_card_object
	plane = SPLASHSCREEN_PLANE
	icon = 'icons/psychonaut/effects/title_cards.dmi'

/datum/episode_name
	var/thename = ""
	var/reason = "Nothing particularly of note happened this round to influence the episode name." //Explanation on why this episode name fits this round. For the admin panel.
	var/weight = 100 //50 will have 50% the chance of being picked. 200 will have 200% the chance of being picked, etc. Relative to other names, not total (just the default names already total 700%)
	var/rare = FALSE //If set to true and this episode name is picked, the current round is considered "not a rerun" for client preferences.

/datum/episode_name/rare
	rare = TRUE

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

/proc/get_station_avg_temp()
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

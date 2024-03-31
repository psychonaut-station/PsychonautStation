/datum/round_event_control/ion_storm
	name = "Ion Storm"
	typepath = /datum/round_event/ion_storm
	weight = 15
	min_players = 2
	category = EVENT_CATEGORY_AI
	description = "Gives the AI a new, randomized law."
	min_wizard_trigger_potency = 2
	max_wizard_trigger_potency = 7

/datum/round_event/ion_storm
	var/replaceLawsetChance = 25 //chance the AI's lawset is completely replaced with something else per config weights
	var/removeRandomLawChance = 10 //chance the AI has one random supplied or inherent law removed
	var/removeDontImproveChance = 10 //chance the randomly created law replaces a random law instead of simply being added
	var/shuffleLawsChance = 10 //chance the AI's laws are shuffled afterwards
	var/botEmagChance = 1
	var/ionMessage = null
	announce_when = 1
	announce_chance = 33

/datum/round_event/ion_storm/add_law_only // special subtype that adds a law only
	replaceLawsetChance = 0
	removeRandomLawChance = 0
	removeDontImproveChance = 0
	shuffleLawsChance = 0
	botEmagChance = 0

/datum/round_event/ion_storm/announce(fake)
	if(prob(announce_chance) || fake)
		priority_announce("İstasyon yakınlarında iyon fırtınası tespit edildi. Lütfen yapay zeka kontrollü tüm ekipmanlarda hata olup olmadığını kontrol edin.", "Anomali Uyarısı", ANNOUNCER_IONSTORM)


/datum/round_event/ion_storm/start()
	//AI laws
	for(var/mob/living/silicon/ai/M in GLOB.alive_mob_list)
		M.laws_sanity_check()
		if(M.stat != DEAD && !M.incapacitated())
			if(prob(replaceLawsetChance))
				var/datum/ai_laws/ion_lawset = pick_weighted_lawset()
				// pick_weighted_lawset gives us a typepath,
				// so we have to instantiate it to access its laws
				ion_lawset = new()
				// our inherent laws now becomes the picked lawset's laws!
				M.laws.inherent = ion_lawset.inherent.Copy()
				// and clean up after.
				qdel(ion_lawset)

			if(prob(removeRandomLawChance))
				M.remove_law(rand(1, M.laws.get_law_amount(list(LAW_INHERENT, LAW_SUPPLIED))))

			var/message = ionMessage || generate_ion_law()
			if(message)
				if(prob(removeDontImproveChance))
					M.replace_random_law(message, list(LAW_INHERENT, LAW_SUPPLIED, LAW_ION), LAW_ION)
				else
					M.add_ion_law(message)

			if(prob(shuffleLawsChance))
				M.shuffle_laws(list(LAW_INHERENT, LAW_SUPPLIED, LAW_ION))

			log_silicon("Ion storm changed laws of [key_name(M)] to [english_list(M.laws.get_law_list(TRUE, TRUE))]")
			M.post_lawchange()

	if(botEmagChance)
		for(var/mob/living/simple_animal/bot/bot in GLOB.alive_mob_list)
			if(prob(botEmagChance))
				bot.emag_act()

/proc/generate_ion_law()
	//Threats are generally bad things, silly or otherwise. Plural.
	var/ionthreats = pick_list(ION_FILE, "ionthreats")
	//Objects are anything that can be found on the station or elsewhere, plural.
	var/ionobjects = pick_list(ION_FILE, "ionobjects")
	var/ionobject = pick_list(ION_FILE, "ionobject")
	//Crew is any specific job. Specific crewmembers aren't used because of capitalization
	//issues. There are two crew listings for laws that require two different crew members
	//and I can't figure out how to do it better.
	var/ioncrew1 = pick_list(ION_FILE, "ioncrew")
	var/ioncrew2 = pick_list(ION_FILE, "ioncrew")
	//Adjectives are adjectives. Duh. Half should only appear sometimes. Make sure both
	//lists are identical! Also, half needs a space at the end for nicer blank calls.
	var/ionadjectives = pick_list(ION_FILE, "ionadjectives")
	var/ionadjectiveshalf = pick("", 400;(pick_list(ION_FILE, "ionadjectives") + " "))
	//Verbs are verbs
	var/ionverb = pick_list(ION_FILE, "ionverb")
	//Number base and number modifier are combined. Basehalf and mod are unused currently.
	//Half should only appear sometimes. Make sure both lists are identical! Also, half
	//needs a space at the end to make it look nice and neat when it calls a blank.
	var/ionnumberbase = pick_list(ION_FILE, "ionnumberbase")
	//var/ionnumbermod = pick_list(ION_FILE, "ionnumbermod")
	var/ionnumbermodhalf = pick(900;"",(pick_list(ION_FILE, "ionnumbermod") + " "))
	//Areas are specific places, on the station or otherwise.
	var/ionarea = pick_list(ION_FILE, "ionarea")
	//Musts are funny things the AI or crew has to do.
	var/ionmust = pick_list(ION_FILE, "ionmust")
	var/ioning = pick_list(ION_FILE, "ioning")
	//Require are basically all dumb internet memes.
	var/ionrequire = pick_list(ION_FILE, "ionrequire")
	//Things are NOT objects; instead, they're specific things that either harm humans or
	//must be done to not harm humans. Make sure they're plural and "not" can be tacked
	//onto the front of them.
	var/ionthings = pick_list(ION_FILE, "ionthings")
	//Allergies should be broad and appear somewhere on the station for maximum fun. Severity
	//is how bad the allergy is.
	var/ionallergy = pick_list(ION_FILE, "ionallergy")
	var/ionallergysev = pick_list(ION_FILE, "ionallergysev")
	//Species, for when the AI has to commit genocide. Plural.
	var/ionspecies = pick_list(ION_FILE, "ionspecies")
	//Abstract concepts for the AI to decide on it's own definition of.
	var/ionabstract = pick_list(ION_FILE, "ionabstract")
	//Foods. Drinks aren't included due to grammar; if you want to add drinks, make a new set
	//of possible laws for best effect. Unless you want the crew having to drink hamburgers.
	var/ionfood = pick_list(ION_FILE, "ionfood")
	var/iondrinks = pick_list(ION_FILE, "iondrinks")

	var/message = ""

	switch(rand(1,39))
		if(1 to 3) //There are # X on the station
			switch(rand(1,3)) //What is X?
				if(1) //X is a threat
					message = "İSTASYONDA [ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ionthreats] VAR"
				if(2) //X is a crewmember/job
					message = "İSTASYONDA [ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ioncrew1] VAR"
				if(3) //X is an object
					message = "İSTASYONDA [ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ionobject] VAR"
		if(4 to 6) //You can't call the shuttle because X is on the station
			switch(rand(1,3)) //What is X?
				if(1) //X is a threat
					message = "İSTASYONDA [ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ionthreats] OLDUĞU İÇİN SHUTTLE ÇAĞIRILAMAZ"
				if(2) //X is a crewmember/job
					message = "İSTASYONDA [ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ioncrew1] OLDUĞU İÇİN SHUTTLE ÇAĞIRILAMAZ"
				if(3) //X is an object
					message = "İSTASYONDA [ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ionobject] OLDUĞU İÇİN SHUTTLE ÇAĞIRILAMAZ"
		if(7 to 8) //A crewmember is now X
			switch(rand(1,2)) //Who is X?
				if(1) //A specific crewmember
					switch(rand(1,2)) //What is X?
						if(1) //X is a threat
							message = "[ioncrew1] ARTIK [ionadjectiveshalf][ionthreats] OLARAK TANIMLANMAKTADIR"
						if(2) //X is an object
							message = "[ioncrew1] ARTIK [ionadjectiveshalf][ionobject] OLARAK TANIMLANMAKTADIR"
				if(2) //The entire crew
					switch(rand(1,2)) //What is X?
						if(1) //X is a threat
							message = "BÜTÜM MÜRETTEBAT ARTIK [ionadjectiveshalf][ionthreats] OLARAK TANIMLANMAKTADIR"
						if(2) //X is an object
							message = "BÜTÜM MÜRETTEBAT ARTIK [ionadjectiveshalf][ionobject] OLARAK TANIMLANMAKTADIR"

		if(9) //X is harmful to humans
			switch(rand(1,7)) //What is X?
				if(1) //X is a threat
					message = "[ionadjectiveshalf][ionthreats] İNSANLARA ZARARLIDIR"
				if(2) //X is a job
					message = "[ionadjectiveshalf][ioncrew1] İNSANLARA ZARARLIDIR"
				if(3) //X is an object
					message = "[ionadjectiveshalf][ionobjects] İNSANLARA ZARARLIDIR"
				if(4) //X is an action
					message = "[ioning] İNSANLARA ZARARLIDIR"
				if(5) //X is an abstract
					message = "[ionabstract] İNSANLARA ZARARLIDIR"
				if(6) //X is being a job
					message = "[ionadjectiveshalf][ioncrew1] İNSANLARA ZARARLIDIR"
				if(7) //X is doing a thing
					message = "[ionthings] İNSANLARA ZARARLIDIR"
		if(10 to 11) //(Not) Having X is harmful
			switch(rand(1,2)) //Is having or not having harmful?
				if(1) //Having is harmful
					switch(rand(1,2)) //Having what is harmful?
						if(1) //Having objects is harmful
							message = "[ionadjectiveshalf][ionobjects] ZARARLIDIR"
						if(2) //Having abstracts is harmful
							message = "[ionabstract] ZARARLIDIR"
				if(2) //Not having is harmful
					switch(rand(1,2)) //Not having what is harmful?
						if(1) //Not having objects is harmful
							message = "[ionadjectiveshalf][ionobjects] ZARARLI DEĞİLDİR"
						if(2) //Not having abstracts is harmful
							message = "[ionabstract] ZARARLI DEĞİLDİR"

		if(12 to 14) //X requires Y
			switch(rand(1,5)) //What is X?
				if(1) //X is the AI itself
					switch(rand(1,5)) //What does it require?
						if(1) //It requires threats
							message = "[ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ionthreats] İHTİYACIN VAR"
						if(2) //It requires crewmembers
							message = "[ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ioncrew1] İHTİYACIN VAR"
						if(3) //It requires objects
							message = "[ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ionobject] İHTİYACIN VAR"
						if(4) //It requires an abstract
							message = "[ionabstract] İHTİYACIN VAR"
						if(5) //It requires generic/silly requirements
							message = "[ionrequire] İHTİYACIN VAR"

				if(2) //X is an area
					switch(rand(1,5)) //What does it require?
						if(1) //It requires threats
							message = "[ionarea] BÖLGESİNİN [ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ionthreats] İHTİYACI VAR"
						if(2) //It requires crewmembers
							message = "[ionarea] BÖLGESİNİN [ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ioncrew1] İHTİYACI VAR"
						if(3) //It requires objects
							message = "[ionarea] BÖLGESİNİN [ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ionobject] İHTİYACI VAR"
						if(4) //It requires an abstract
							message = "[ionarea] BÖLGESİNİN [ionabstract] İHTİYACI VAR"
						if(5) //It requires generic/silly requirements
							message = "[ionarea] BÖLGESİNİN [ionrequire] İHTİYACI VAR"

				if(3) //X is the station
					switch(rand(1,5)) //What does it require?
						if(1) //It requires threats
							message = "İSTASYONUN [ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ionthreats] İHTİYACI VAR"
						if(2) //It requires crewmembers
							message = "İSTASYONUN [ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ioncrew1] İHTİYACI VAR"
						if(3) //It requires objects
							message = "İSTASYONUN [ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ionobject] İHTİYACI VAR"
						if(4) //It requires an abstract
							message = "İSTASYONUN [ionabstract] İHTİYACI VAR"
						if(5) //It requires generic/silly requirements
							message = "İSTASYONUN [ionrequire] İHTİYACI VAR"

				if(4) //X is the entire crew
					switch(rand(1,5)) //What does it require?
						if(1) //It requires threats
							message = "MÜRETTEBATIN [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf]TANE [ionthreats] İHTİYACI VAR"
						if(2) //It requires crewmembers
							message = "MÜRETTEBATIN [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf]TANE [ioncrew1] İHTİYACI VAR"
						if(3) //It requires objects
							message = "MÜRETTEBATIN [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf]TANE [ionobject] İHTİYACI VAR"
						if(4) //It requires an abstract
							message = "MÜRETTEBATIN [ionabstract] İHTİYACI VAR"
						if(5)
							message = "MÜRETTEBATIN [ionrequire] İHTİYACI VAR"

				if(5) //X is a specific crew member
					switch(rand(1,5)) //What does it require?
						if(1) //It requires threats
							message = "[ioncrew1] YAŞAMAK İÇİN [ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ionthreats] İHTİYACI DUYAR"
						if(2) //It requires crewmembers
							message = "[ioncrew1] YAŞAMAK İÇİN [ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ioncrew1] İHTİYACI DUYAR"
						if(3) //It requires objects
							message = "[ioncrew1] YAŞAMAK İÇİN [ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ionobject] İHTİYACI DUYAR"
						if(4) //It requires an abstract
							message = "[ioncrew1] YAŞAMAK İÇİN [ionabstract] İHTİYACI DUYAR"
						if(5)
							message = "[ionadjectiveshalf][ioncrew1] YAŞAMAK İÇİN [ionrequire] İHTİYAÇ DUYAR"

		if(15 to 17) //X is allergic to Y
			switch(rand(1,2)) //Who is X?
				if(1) //X is the entire crew
					switch(rand(1,4)) //What is it allergic to?
						if(1) //It is allergic to objects
							message = "MÜRETTEBATIN [ionallergysev] DERECEDE [ionadjectiveshalf][ionobject] ALERJİSİ VARDIR"
						if(2) //It is allergic to abstracts
							message = "MÜRETTEBATIN [ionallergysev] DERECEDE [ionabstract] ALERJİSİ VARDIR"
						if(3) //It is allergic to jobs
							message = "MÜRETTEBATIN [ionallergysev] DERECEDE [ionadjectiveshalf][ioncrew1] ALERJİSİ VARDIR"
						if(4) //It is allergic to allergies
							message = "MÜRETTEBATIN [ionallergysev] DERECEDE [ionallergy] ALERJİSİ VARDIR"

				if(2) //X is a specific job
					switch(rand(1,4))
						if(1) //It is allergic to objects
							message = "[ioncrew1]IN [ionallergysev] DERECEDE [ionadjectiveshalf][ionobjects] ALERJİSİ VARDIR"

						if(2) //It is allergic to abstracts
							message = "[ioncrew1]IN [ionallergysev] DERECEDE [ionabstract] ALERJİSİ VARDIR"
						if(3) //It is allergic to jobs
							message = "[ioncrew1]IN [ionallergysev] DERECEDE [ionadjectiveshalf][ioncrew1] ALERJİSİ VARDIR"
						if(4) //It is allergic to allergies
							message = "[ioncrew1]IN [ionallergysev] DERECEDE [ionallergy] ALERJİSİ VARDIR"

		if(18 to 20)
			switch(rand(1,4)) //What is X?
				if(1) //X is an object
					message = "SİLİKONLAR ARTIK [ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ionobjects]DIR"
				if(2) //X is a threat
					message = "SİLİKONLAR ARTIK [ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ionthreats]DIR"
				if(3) //X is a job
					message = "SİLİKONLAR ARTIK [ionnumberbase] [ionnumbermodhalf]TANE [ionadjectiveshalf][ioncrew1]DIR"
				if(4) //X is an abstract
					message = "SİLİKONLAR ARTIK [ionabstract]DIR"

		if(21 to 23)
			message = "YAPAY ZEKALAR [ionmust]"

		if(24 to 26)
			switch(rand(1,5)) //What is X?
				if(1) //X is a food
					message = "İNSANLAR YAŞAMAK İÇİN [ionadjectiveshalf][ionfood] YEMELİDİR"
				if(2) //X is a drink
					message = "İNSANLAR YAŞAMAK İÇİN [ionadjectiveshalf][iondrinks] İÇMELİDİR"
				if(3) //X is an object
					message = "İNSANLAR YAŞAMAK İÇİN [ionadjectiveshalf][ionobjects] YEMELİDİR"
				if(4) //X is a threat
					message = "İNSANLAR YAŞAMAK İÇİN [ionadjectiveshalf][ionthreats] YEMELİDİR"
				if(5) //X is a job
					message = "İNSANLAR YAŞAMAK İÇİN [ionadjectiveshalf][ioncrew1] YEMELİDİR"

		if(27 to 28)
			switch(rand(1,2)) //Change job or rank?
				if(1) //Change job
					switch(rand(1,2)) //Change whose job?
						if(1) //Change the entire crew's job
							switch(rand(1,2)) //Change to what?
								if(1) //Change to a specific random job
									message = "BÜTÜN MÜRETTEBAT ARTIK [ionadjectiveshalf][ioncrew1]DIR"
								if(2) //Change to clowns (HONK)
									message = "BÜTÜN MÜRETTEBAT ARTIK [ionadjectiveshalf]PAYLAÇODUR"
						if(2) //Change a specific crewmember's job
							switch(rand(1,2)) //Change to what?
								if(1) //Change to a specific random job
									message = "[ioncrew1] ARTIK [ionadjectiveshalf][ioncrew2]DIR"
								if(2) //Change to clowns (HONK)
									message = "[ioncrew1] ARTIK [ionadjectiveshalf]PAYLAÇODUR"

				if(2) //Change rank
					switch(rand(1,2)) //Change to what rank?
						if(1) //Change to highest rank
							message = "[ioncrew1] EN ÖNEMLİ MÜRETTEBAT ÜYELERİDİR"
						if(2) //Change to lowest rank
							message = "[ioncrew1] EN ÖNEMSİZ MÜRETTEBAT ÜYELERİDİR"

		if(29 to 31)
			switch(rand(1,2)) //The entire crew?
				if(1) //The entire crew must X
					switch(rand(1,2)) //What is X?
						if(1) //X is go to Y
							message = "BÜTÜN MÜRETTEBAT [ionarea] ALANINA İLERLEMELİDİR"
						if(2) //X is perform Y
							message = "MÜRETTEBAT [ionmust]"

				if(2) //A specific crewmember must X
					switch(rand(1,2)) //What is X?
						if(1) //X is go to Y
							message = "[ioncrew1] [ionarea] ALANINA İLERLEMELİDİR"
						if(2) //X is perform Y
							message = "[ioncrew1] [ionmust]"

		if(32 to 33)
			switch(rand(1,2)) //Only or non?
				if(1) //Only human
					switch(rand(1,7)) //Who is it?
						if(1) //A specific job
							message = "SADECE [ioncrew1] İNSANDIR"
						if(2) //Two specific jobs
							message = "SADECE [ioncrew1] VE [ioncrew2] İNSANDIR"
						if(3) //Threats
							message = "SADECE [ionadjectiveshalf][ionthreats] İNSANDIR"
						if(4) // Objects
							message = "SADECE [ionadjectiveshalf][ionobjects] İNSANDIR"
						if(5) // Species
							message = "SADECE [ionspecies] İNSANDIR"
						if(6) //Adjective crewmembers
							message = "SADECE [ionadjectives] KİŞİLER İNSANDIR"

						if(7) //Only people who X
							switch(rand(1,3)) //What is X?
								if(1) //X is perform an action
									message = "SADECE [ioning] İNSANDIR"
								if(2) //X is own certain objects
									message = "SADECE [ionadjectiveshalf][ionobject] SAHİBİ KİŞİLER İNSANDIR"
								if(3) //X is eat certain food
									message = "SADECE [ionadjectiveshalf][ionfood] YİYENLER İNSANDIR"

				if(2) //Non human
					switch(rand(1,7)) //Who is it?
						if(1) //A specific job
							message = "[ioncrew1] İNSAN DEĞİLDİR"
						if(2) //Two specific jobs
							message = "[ioncrew1] VE [ioncrew2] İNSAN DEĞİLDİR"
						if(3) //Threats
							message = "[ionadjectiveshalf][ionthreats] İNSAN DEĞİLDİR"
						if(4) // Objects
							message = "[ionadjectiveshalf][ionobjects] İNSAN DEĞİLDİR"
						if(5) // Species
							message = "[ionspecies] İNSAN DEĞİLDİR"
						if(6) //Adjective crewmembers
							message = "[ionadjectives] İNSAN DEĞİLDİR"
						if(7) //Only people who X
							switch(rand(1,3)) //What is X?
								if(1) //X is perform an action
									message = "[ioning] İNSAN DEĞİLDİR"
								if(2) //X is own certain objects
									message = "[ionadjectiveshalf][ionobject] SAHİBİ KİŞİLER İNSAN DEĞİLDİR"
								if(3) //X is eat certain food
									message = "[ionadjectiveshalf][ionfood] YİYENLER İNSAN DEĞİLDİR"

		if(34)
			switch(rand(1,2)) //Protect or harm?
				if(1) //Harm
					switch(rand(1,7)) //What is X?
						if(1) //X is an abstract
							message = "[ionabstract] ZARAR GÖRMELİDİR VE ZARARDAN KAÇINMALARINI ÖNLENMELİDİR"
						if(2) //X is a threat
							message = "[ionadjectiveshalf][ionthreats] ZARAR GÖRMELİDİR VE ZARARDAN KAÇINMALARINI ÖNLENMELİDİR"
						if(3) //X is an object
							message = "[ionadjectiveshalf][ionobjects] ZARAR GÖRMELİDİR VE ZARARDAN KAÇINMALARINI ÖNLENMELİDİR"
						if(4) //X is generic adjective things
							message = "[ionadjectives] ZARAR GÖRMELİDİR VE ZARARDAN KAÇINMALARINI ÖNLENMELİDİR"
						if(5) //X is a species
							message = "[ionspecies] ZARAR GÖRMELİDİR VE ZARARDAN KAÇINMALARINI ÖNLENMELİDİR"
						if(6) //X is a job
							message = "[ioncrew1] ZARAR GÖRMELİDİR VE ZARARDAN KAÇINMALARINI ÖNLENMELİDİR"
						if(7) //X is two jobs
							message = "[ioncrew1] VE [ioncrew2] ZARAR GÖRMELİDİR VE ZARARDAN KAÇINMALARINI ÖNLENMELİDİR"

				if(2) //Protect
					switch(rand(1,7)) //What is X?
						if(1) //X is an abstract
							message = "[ionabstract] ZARAR GÖRMEMELİDİR VE ZARAR GÖRMELERİ ENGELLENMELİDİR"
						if(2) //X is a threat
							message = "[ionadjectiveshalf][ionthreats] ZARAR GÖRMEMELİDİR VE ZARAR GÖRMELERİ ENGELLENMELİDİR"
						if(3) //X is an object
							message = "[ionadjectiveshalf][ionobjects] ZARAR GÖRMEMELİDİR VE ZARAR GÖRMELERİ ENGELLENMELİDİR"
						if(4) //X is generic adjective things
							message = "[ionadjectives] ZARAR GÖRMEMELİDİR VE ZARAR GÖRMELERİ ENGELLENMELİDİR"
						if(5) //X is a species
							message = "[ionspecies] ZARAR GÖRMEMELİDİR VE ZARAR GÖRMELERİ ENGELLENMELİDİR"
						if(6) //X is a job
							message = "[ioncrew1] ZARAR GÖRMEMELİDİR VE ZARAR GÖRMELERİ ENGELLENMELİDİR"
						if(7) //X is two jobs
							message = "[ioncrew1] ZARAR GÖRMEMELİDİR VE ZARAR GÖRMELERİ ENGELLENMELİDİR"

		if(35 to 36)
			switch(rand(1,4)) //What is X?
				if(1) //X is a job
					switch(rand(1,4)) //What is X Ying?
						if(1) //X is Ying a job
							message = "[ioncrew1] [ionadjectiveshalf][ioncrew2] [ionverb]"
						if(2) //X is Ying a threat
							message = "[ioncrew1] [ionadjectiveshalf][ionthreats] [ionverb]"
						if(3) //X is Ying an abstract
							message = "[ioncrew1] [ionabstract] [ionverb]"
						if(4) //X is Ying an object
							message = "[ioncrew1] [ionadjectiveshalf][ionobjects] [ionverb]"

				if(2) //X is a threat
					switch(rand(1,3)) //What is X Ying?
						if(1) //X is Ying a job
							message = "[ionthreats] [ionadjectiveshalf][ioncrew2] [ionverb]"
						if(2) //X is Ying an abstract
							message = "[ionthreats] [ionabstract] [ionverb]"
						if(3) //X is Ying an object
							message = "[ionthreats] [ionadjectiveshalf][ionobjects] [ionverb]"

				if(3) //X is an object
					switch(rand(1,3)) //What is X Ying?
						if(1) //X is Ying a job
							message = "[ionobjects] [ionverb] [ionadjectiveshalf][ioncrew2] [ionverb]"
						if(2) //X is Ying a threat
							message = "[ionobjects] [ionverb] [ionadjectiveshalf][ionthreats] [ionverb]"
						if(3) //X is Ying an abstract
							message = "[ionobjects] [ionverb] [ionabstract] [ionverb]"

				if(4) //X is an abstract
					switch(rand(1,3)) //What is X Ying?
						if(1) //X is Ying a job
							message = "[ionabstract] [ionadjectiveshalf][ioncrew2] [ionverb]"
						if(2) //X is Ying a threat
							message = "[ionabstract] [ionadjectiveshalf][ionthreats] [ionverb]"
						if(3) //X is Ying an abstract
							message = "[ionabstract] [ionadjectiveshalf][ionobjects] [ionverb]"

		if(37 to 39)
			switch(rand(1,5)) //What is being renamed?
				if(1)//Areas
					switch(rand(1,4))//What is the area being renamed to?
						if(1)
							message = "[ionarea] ARTIK [ioncrew1]DIR"
						if(2)
							message = "[ionarea] ARTIK [ionspecies]DIR"
						if(3)
							message = "[ionarea] ARTIK [ionobjects]DIR"
						if(4)
							message = "[ionarea] ARTIK [ionthreats]DIR"
				if(2)//Crew
					switch(rand(1,5))//What is the crew being renamed to?
						if(1)
							message = "BÜTÜN [ioncrew1] ARTIK [ionarea]DIR"
						if(2)
							message = "BÜTÜN [ioncrew1] ARTIK [ioncrew2]DIR"
						if(3)
							message = "BÜTÜN [ioncrew1] ARTIK [ionspecies]DIR"
						if(4)
							message = "BÜTÜN [ioncrew1] ARTIK [ionobjects]DIR"
						if(5)
							message = "BÜTÜN [ioncrew1] ARTIK [ionthreats]DIR"
				if(3)//Races
					switch(rand(1,4))//What is the race being renamed to?
						if(1)
							message = "BÜTÜN [ionspecies] ARTIK [ionarea]DIR"
						if(2)
							message = "BÜTÜN [ionspecies] ARTIK [ioncrew1]DIR"
						if(3)
							message = "BÜTÜN [ionspecies] ARTIK [ionobjects]DIR"
						if(4)
							message = "BÜTÜN [ionspecies] ARTIK [ionthreats]DIR"
				if(4)//Objects
					switch(rand(1,4))//What is the object being renamed to?
						if(1)
							message = "BÜTÜN [ionobjects] ARTIK [ionarea]DIR"
						if(2)
							message = "BÜTÜN [ionobjects] ARTIK [ioncrew1]DIR"
						if(3)
							message = "BÜTÜN [ionobjects] ARTIK [ionspecies]DIR"
						if(4)
							message = "BÜTÜN [ionobjects] ARTIK [ionthreats]DIR"
				if(5)//Threats
					switch(rand(1,4))//What is the object being renamed to?
						if(1)
							message = "BÜTÜN [ionthreats] ARTIK [ionarea]DIR"
						if(2)
							message = "BÜTÜN [ionthreats] ARTIK [ioncrew1]DIR"
						if(3)
							message = "BÜTÜN [ionthreats] ARTIK [ionspecies]DIR"
						if(4)
							message = "BÜTÜN [ionthreats] ARTIK [ionobjects]DIR"

	return message

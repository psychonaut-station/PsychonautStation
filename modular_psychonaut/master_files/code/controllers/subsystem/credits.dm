SUBSYSTEM_DEF(credits)
	name = "Roundend Credits"
	wait = 10 MINUTES
	init_stage = INITSTAGE_LAST

	var/list/disclaimers = list()
	var/list/datum/episode_name/episode_names = list()

	var/episode_name = ""

	var/list/episode_string
	var/list/disclaimers_string
	var/list/cast_string

	var/customized_name = ""

	var/list/patron_appearances = list()
	var/list/admin_appearances = list()
	var/list/antag_appearances = list()

	var/list/processing_icons = list()
	var/list/currentrun  = list()

	var/list/credit_order_for_this_round = list()

/datum/controller/subsystem/credits/Initialize()
#if defined(UNIT_TESTS)
	return SS_INIT_NO_NEED
#else
	generate_patron_icons()
	return SS_INIT_SUCCESS
#endif

/datum/controller/subsystem/credits/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing_icons.Copy()

	//cache for sanic speed
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/datum/weakref/weakref = currentrun[currentrun.len]
		var/mutable_appearance/appearance = currentrun[weakref]
		currentrun.len--
		var/datum/mind/antag_mind = weakref.resolve()
		var/mob/living/living_mob = antag_mind?.current
		if(!isnull(living_mob) && living_mob.stat != DEAD)
			if(isliving(living_mob) && !isbrain(living_mob))
				appearance.copy_overlays(living_mob, TRUE)
			else
				appearance.appearance = living_mob.get_mob_appearance()
			appearance.transform = matrix()
			appearance.setDir(SOUTH)
			var/bound_width = living_mob.bound_width || world.icon_size
			appearance.maptext_width = 88
			appearance.maptext_height = world.icon_size * 1.5
			appearance.maptext_x = ((88 - bound_width) * -0.5) - living_mob.base_pixel_x
			appearance.maptext_y = -16
			appearance.maptext = "<center>[antag_mind.name]</center>"
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/credits/Recover()
	processing_icons = SScredits.processing_icons
	antag_appearances = SScredits.antag_appearances
	customized_name = SScredits.customized_name
	patron_appearances = SScredits.patron_appearances

/datum/controller/subsystem/credits/proc/draft()
	if(!customized_name)
		draft_episode_names()
	draft_disclaimers()
	draft_caststring()
	generate_admin_icons()

/datum/controller/subsystem/credits/proc/finalize()
	finalize_name()
	finalize_episodestring()
	finalize_disclaimerstring()
	finalize_credits()

/datum/controller/subsystem/credits/proc/finalize_name()
	if(customized_name)
		episode_name = customized_name
		return
	var/list/drafted_names = list()
	for(var/datum/episode_name/N as anything in episode_names)
		drafted_names["[N.name]"] = N.weight
	episode_name = pick_weight(drafted_names)

/datum/controller/subsystem/credits/proc/finalize_episodestring()
	var/season = time2text(world.timeofday,"YY")
	var/episodenum = GLOB.round_id || 1
	episode_string = list("<center>SEZON [season] BÖLÜM [episodenum]</center>")
	episode_string += "<center>[episode_name]</center>"

/datum/controller/subsystem/credits/proc/finalize_disclaimerstring()
	disclaimers_string =  list()
	for(var/disclaimer in disclaimers)
		disclaimers_string += "<center>[disclaimer]</center>"

/datum/controller/subsystem/credits/proc/finalize_credits()
	credit_order_for_this_round = list()
	credit_order_for_this_round += episode_string
	credit_order_for_this_round += ""
	credit_order_for_this_round += disclaimers_string
	credit_order_for_this_round += cast_string
	var/list/admins = shuffle(admin_appearances)
	var/admins_length = length(admins)
	var/y_offset = 0
	if(admins_length)
		credit_order_for_this_round += "<center>Yetkili Ekibi</center>"
		for(var/i in 1 to CEILING(admins_length / 6, 1))
			var/x_offset = -16
			for(var/b in 1 to 6)
				var/mutable_appearance/picked = pick_n_take(admins)
				if(!picked)
					break
				picked.pixel_x = x_offset
				picked.pixel_y = y_offset
				x_offset += 96
				credit_order_for_this_round += picked

	var/list/patrons = shuffle(patron_appearances)
	var/patrons_length = length(patrons)
	if(patrons_length)
		credit_order_for_this_round += "<center>Sevgili Destekçilerimiz</center>"
		for(var/i in 1 to CEILING(patrons_length / 6, 1))
			var/x_offset = -16
			for(var/b in 1 to 6)
				var/mutable_appearance/picked = pick_n_take(patrons)
				if(!picked)
					break
				picked.pixel_x = x_offset
				picked.pixel_y = y_offset
				x_offset += 96
				credit_order_for_this_round += picked

	for(var/obj/effect/title_card_object/MA as anything in antag_appearances)
		var/list/antagonist_icons = antag_appearances[MA]
		antagonist_icons = shuffle(antagonist_icons)
		var/antagonists_length = length(antagonist_icons)
		if(antagonists_length)
			credit_order_for_this_round += MA
			for(var/i in 1 to CEILING(antagonists_length / 6, 1))
				var/x_offset = -16
				for(var/b in 1 to 6)
					if(!length(antagonist_icons))
						break
					var/mutable_appearance/picked = pick_n_take(antagonist_icons)
					if(!picked)
						break
					picked.pixel_x = x_offset
					picked.pixel_y = y_offset
					x_offset += 96
					credit_order_for_this_round += picked

/datum/controller/subsystem/credits/proc/draft_disclaimers()
	disclaimers += "[locale_suffix_locative(station_name())] çekilmiştir.<br>"
	disclaimers += "BYOND© kameraları ve lensleri ile çekilmiştir. Uzay görüntüleri NASA tarafından sağlanmıştır.<br>"
	disclaimers += "Özel görsel efektler LUMMOX® JR. Motion Picture Productions tarafından sağlanmıştır.<br>"
	disclaimers += "Tüm hakları saklıdır.<br>"
	disclaimers += "<br>"
	disclaimers += "Tüm tehlikeli sahneler düşük maaşlı ve harcanabilir stajyerler tarafından gerçekleştirilmiştir. EVDE DENEMEYİN.<br>"
	disclaimers += "Bu film, Türkiye ve evrenin dört bir yanındaki tüm ülkelerin telif hakkı yasaları tarafından korunmaktadır(korunmamaktadır).<br>"
	disclaimers += "İlk yayınlanan ülke: Türkiye.<br><br>"
	disclaimers += "Bu filmin veya herhangi bir kısmının (ses bandı dahil) izinsiz gösterimi, dağıtımı veya kopyalanması ilgili telif hakkı yasalarının ihlalidir ve suçlu kişiyi hukuki ve cezai yaptırımlara tabi tutar.<br>"
	disclaimers += "Bu yapımda anlatılan hikaye, tüm isimler, karakterler ve olaylar tamamen kurgusaldır.<br>"
	disclaimers += "Gerçek kişi (yaşayan veya ölü), mekan, bina veya ürünlerle herhangi bir benzerlik amaçlanmamıştır ve böyle bir bağlantı çıkarılmamalıdır.<br>"

/datum/controller/subsystem/credits/proc/draft_caststring()
	cast_string = list("<center>OYUNCULAR:</center>")
	var/is_anyone_there = FALSE
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H.ckey && !(H.stat == DEAD) && !H.mind)
			continue

		var/obj/effect/cast_object/human_name = new
		human_name.maptext = "<p align='right'>[H.mind.name]</p>"
		human_name.maptext_width = 232

		var/obj/effect/cast_object/human_key = new
		human_key.maptext = "<p align='left'><b>[H.mind.key]</b></p>"
		human_key.maptext_width = 232
		human_key.maptext_x = 240

		cast_string += list(human_name, human_key)
		is_anyone_there = TRUE
		CHECK_TICK

	for(var/mob/living/silicon/S in GLOB.silicon_mobs)
		if(!S.ckey && !S.mind)
			continue
		var/obj/effect/cast_object/silicon_name = new
		silicon_name.maptext = "<p align='right'>[S.name]</p>"
		silicon_name.maptext_width = 224

		var/obj/effect/cast_object/silicon_key = new
		silicon_key.maptext = "<p align='left'><b>[S.mind.key]</b></p>"
		silicon_key.maptext_width = 224
		silicon_key.maptext_x = 240

		cast_string += list(silicon_name, silicon_key)
		is_anyone_there = TRUE
		CHECK_TICK

	if(!is_anyone_there)
		cast_string += "<center><td> Kimse! </td></center>"

	var/is_anyone_died = FALSE
	cast_string += "<br><center><h3>[pick("GERÇEK OLAYLARDAN İLHAM ALINMIŞTIR","GERÇEK BİR HİKAYEDEN ESİNLENİLMİŞTİR")]</h3></center>"

	for(var/mob/living/carbon/human/H in GLOB.dead_mob_list)
		if(!H.last_mind)
			continue
		if(!is_anyone_died)
			cast_string += "<br><center>Hayatta kalamayanların anısına.</center><br>"
			is_anyone_died = TRUE

		var/obj/effect/cast_object/human_name = new
		human_name.maptext = "<p align='right'>[H.last_mind.name]</p>"
		human_name.maptext_width = 224

		var/obj/effect/cast_object/human_key = new
		human_key.maptext = "<p align='left'><b>[H.last_mind.key]</b></p>"
		human_key.maptext_width = 224
		human_key.maptext_x = 240

		cast_string += list(human_name, human_key)
		CHECK_TICK

	cast_string += "<br>"

/datum/controller/subsystem/credits/proc/draft_episode_names()
	var/uppr_name = locale_uppertext(station_name())

	episode_names += new /datum/episode_name("[locale_uppertext(locale_suffix_genitive(pick(200;"[uppr_name]", 150;"ASTRONOT", 150;"INSANLIK", "İTİBAR", "AKIL SAĞLIĞI", "BİLİM", "MERAK", "ÇALIŞANLAR", "PARANOYA", "ŞEMPANZELER")))] [pick("DÜŞÜŞÜ", "YÜKSELİŞİ", "SORUNU", "KARANLIK YÜZÜ")] ")
	episode_names += new /datum/episode_name("MÜRETTEBAT [pick("REFAHDA", "TÜKENDİ", "HAREKETE GEÇİYOR", "PLAZMA KRİZİNİ ÇÖZÜYOR", "YOLA ÇIKIYOR", "YÜKSELİYOR", "EMEKLİ OLUYOR", "CEHENNEME GİDİYOR", "KLİP ÇEKİYOR", "DENETLENIYOR", "HAYATSIZLAŞIYOR", "SALDIRIYOR", "ÇOK İLERİ GİDİYOR", "KAZANIYOR... AMA NE PAHASINA!!")]")
	episode_names += new /datum/episode_name("MÜRETTEBATIN [pick("GÜNÜBİRLİK GEZİSİ", "SON GÜNÜ", "[pick("ÇILGIN", "TUHAF", "SÖNÜK", "BEKLENMEDİK")] TATİLİ", "FİKİR DEĞİŞİMİ", "YENİ RİTMİ", "OKUL MÜZİKALİ", "TARİH DERSİ", "UÇAN SİRKİ", "KÜÇÜK BİR SORUNU", "BÜYÜK BAŞARISI", "HATA KAYITLARI", "KÜÇÜK SIRRI", "ÖZEL TEKLİFİ", "UZMANLIĞI", "ZAYIF NOKTASI", "MERAKI", "ALİBİSİ", "MİRASI", "KEŞFİ", "SON OYUNU", "KURTARMA OPERASYONU", "İNTİKAMI")]")
	episode_names += new /datum/episode_name("İSTASYONUN [pick("UZAY", "SEKSİ", "BÜYÜLÜ", "KİRLİ", "SİLAH", "REKLAM", "KÖPEK", "KARBONMONOKSİT", "NİNJA", "SİHİRBAZ", "SOKRATİK", "GENÇLİK SUÇLULUĞU", "POLİTİK GÜDÜMLÜ", "RADİKAL DERECEDE HARİKA", "KURUMSAL", "MEGA")] [pick("MACERASI", "GÜCÜ", "YOLCULUĞU", "YOLU")]", 25)
	var/roundend_station_integrity = SSticker.popcount["station_integrity"]
	switch(roundend_station_integrity)
		if(0 to 50)
			episode_names += new /datum/episode_name("[pick("MÜRETTEBATIN CEZASI", "BİR HALKLA İLİŞKİLER KÂBUSU", "[uppr_name]: ULUSAL BİR MESELE", "MÜRETTEBATTAN ÖZÜR DİLERİZ", "MÜRETTEBAT TOZU YUTUYOR", "MÜRETTEBAT HER ŞEYİ BATIRIYOR", "MÜRETTEBAT HAYALLERİNDEN VAZGEÇİYOR", "MÜRETTEBATIN SONU GELDİ", "MÜRETTEBAT TELEVİZYONA ÇIKMAMALI", "[locale_uppertext(locale_suffix_genitive(uppr_name))] SONU GELDİĞİNİ BİLİYORUZ")]", 250)
		if(80 to 100)
			episode_names += new /datum/episode_name("[pick("MÜRETTEBATIN GEZİSİ", "CENNETİN BU TARAFI", "[uppr_name]: BİR DURUM KOMEDİSİ", "MÜRETTEBATIN ÖĞLE MOLASI", "MÜRETTEBAT YENİDEN İŞE DÖNÜYOR", "MÜRETTEBATIN BÜYÜK ÇIKIŞI", "MÜRETTEBAT GÜNÜ KURTARIYOR", "MÜRETTEBAT DÜNYAYA HÜKMEDİYOR", "TÜM BİLİM, GELİŞİM, TERFİLER VE HAVALI ŞEYLERİN OLDUĞU BÖLÜM", "DÖNÜM NOKTASI")]", 250)

	switch(SSdynamic.current_tier.tier)
		if(0 to 1) // DYNAMIC_TIER_GREEN to DYNAMIC_TIER_LOW
			episode_names += new /datum/episode_name("[pick("O GÜN [uppr_name] DURDU", "BOŞ YERE KOPAN FIRTINA", "SESSİZLİĞİN KİRALIK OLDUĞU YER", "YANILTMA TAKTİĞİ", "EVDE TEK BAŞINA", "YA BÜYÜK OYNA YA DA [uppr_name]", "PLASEBO ETKİSİ", "YANKILAR", "SESSİZ ORTAKLAR", "BÖYLE DOSTLARIN OLDUĞUNDA...", "FIRTINANIN GÖZÜ", "USLU DOĞDUK", "DURGUN SULAR")]", 150)
			if(roundend_station_integrity && roundend_station_integrity < 35)
				episode_names += new /datum/episode_name("[pick("NASIL OLDU DA HER ŞEY BU KADAR YANLIŞ GİTTİ?!", "BUNU YÖNETİCİLERE AÇIKLAYIN", "MÜRETTEBAT SAFARİDE", "EN BÜYÜK DÜŞMANIMIZ", "İÇERİDEN İŞ", "VEKİL KATİL")]", roundend_station_integrity/150*-2)
		if(2 to 3) // DYNAMIC_TIER_LOWMEDIUM to DYNAMIC_TIER_MEDIUMHIGH
			episode_names += new /datum/episode_name("[pick("KAN DÖKÜLEBİLİR", "O [locale_uppertext(locale_suffix_ablative(uppr_name))] GELDİ!", "[uppr_name] OLAYI", "İÇİMİZDEKİ DÜŞMAN", "ÖĞLE ÇILGINLIĞI", "SAAT ON İKİYİ VURDUĞUNDA", "ÖZGÜVEN VE PARANOYA", "FAZLA KAÇAN ŞAKA", "İKİYE BÖLÜNMÜŞ EV", "[uppr_name] YARDIMA KOŞUYOR!", "[locale_uppertext(locale_suffix_ablative(uppr_name))] KAÇIŞ", \
				"HİT VE KAÇ", "UYANIŞ", "BÜYÜK KAÇIŞ", "[locale_uppertext(locale_suffix_genitive(uppr_name))] SON AYARTISI", "[locale_uppertext(locale_suffix_genitive(uppr_name))] DÜŞÜŞÜ", "ATEŞLE OYNAMAK", "BASKI ALTINDA", "SON GÜNDEN ÖNCEKİ GÜN", "[locale_uppertext(locale_suffix_genitive(uppr_name))] ARANANLARI")]", 150)
		if(4) // DYNAMIC_TIER_HIGH
			episode_names += new /datum/episode_name("[pick("SALDIRI! SALDIRI! SALDIRI!", "DELİLİĞİ TAMİR EDEMEZSİN", "KIYAMET", "KIYAMETİN TADI", "OPERASYON: YOK EDİN!", "KUSURSUZ FIRTINA", "MÜRETTEBATIN ZAMANI DOLDU", "HERKES [locale_uppertext(locale_suffix_ablative(uppr_name))] NEFRET EDİYOR", "[uppr_name] SAVAŞI", \
				"KAPIŞMA", "İNSAN AVI", "KAVGANIN OLDUĞU BÖLÜM", "[locale_uppertext(locale_suffix_genitive(uppr_name))] HESAP GÜNÜ", "İNCELEN KIRMIZI ÇİZGİ", "EMEKLİLİĞE BİR GÜN KALA")]", 250)
			if(get_station_avg_temp() < T0C)
				episode_names += new /datum/episode_name("CEHENNEMDE SOĞUK BİR GÜN", 1000)

	CHECK_TICK

	var/list/ran_events = SSdynamic.executed_rulesets.Copy()
	if(locate(/datum/dynamic_ruleset/roundstart/malf_ai) in ran_events)
		episode_names += new /datum/episode_name("[pick("GARİP BİR OYUN", "YAPAY ZEKA DELİYE DÖNÜYOR", "MAKİNELERİN YÜKSELİŞİ")]", 300)
	if(locate(/datum/dynamic_ruleset/roundstart/revolution) in ran_events)
		episode_names += new /datum/episode_name("[pick("MÜRETTEBAT DEVRİME BAŞLIYOR", "CEHENNEMİN DİĞER YÜZÜ", "[pick("İSYAN","DEVRİM")]!!", "MÜRETTEBATIN YÜKSELİŞİ", "AYAKLANIN KARDEŞLERİM!!")]", 350)
	if((locate(/datum/dynamic_ruleset/roundstart/blood_cult) in ran_events) && blackbox_feedback_num("narsies_spawned") > 0)
		episode_names += new /datum/episode_name("[pick("NAR-SIE'NIN BOŞ GÜNÜ'", "NAR-SIE TATİLDE")]", 500)

	if(check_holidays(CHRISTMAS))
		episode_names += new /datum/episode_name("[pick("MUTLU", "BİLİMLİ", "GÜVENLİ", "PLASMALI")] NOELLER", 1000)
	if(blackbox_feedback_num("guns_spawned") > 0)
		episode_names += new /datum/episode_name("[pick("SILAHLAR, SILAHLAR HERYERDE", "ŞİMŞEK HIZINDA SİLAH TESLIMATI")]", min(750, blackbox_feedback_num("guns_spawned")*25))
	if(blackbox_feedback_num("heartattacks") > 2)
		episode_names += new /datum/episode_name("KALBIM AĞRIYOR!!", min(1500, blackbox_feedback_num("heartattacks")*250))

	var/datum/bank_account/mr_moneybags
	var/static/list/typecache_bank = typecacheof(list(/datum/bank_account/department, /datum/bank_account/remote))
	for(var/i in SSeconomy.bank_accounts_by_id)
		var/datum/bank_account/current_acc = SSeconomy.bank_accounts_by_id[i]
		if(typecache_bank[current_acc.type])
			continue
		if(!mr_moneybags || mr_moneybags.account_balance < current_acc.account_balance)
			mr_moneybags = current_acc
		CHECK_TICK

	if(mr_moneybags && mr_moneybags.account_balance > 30000)
		episode_names += new /datum/episode_name("[pick("BEREKET VERSİN", "[locale_uppertext(locale_suffix_genitive(mr_moneybags.account_holder))] KÂRI", "BUNA BIREYSEL EKONOMİ DENİR, SALAK HERİF")]", min(450, mr_moneybags.account_balance/500))
	if(blackbox_feedback_num("ai_deaths") > 3)
		episode_names += new /datum/episode_name("YAPAY ZEKANIN [blackbox_feedback_num("ai_deaths")] KEZ ÖLÜMÜ", min(1500, blackbox_feedback_num("ai_deaths")*300))
	if(blackbox_feedback_num("law_changes") > 12)
		episode_names += new /datum/episode_name("[pick("MÜRETTEBAT YASA DEĞİŞMEYİ ÖĞRENİYOR", 15;"ASIMOV DİYORKİ")]", min(750, blackbox_feedback_num("law_changes")*25))
	if(blackbox_feedback_num("slips") > 50)
		episode_names += new /datum/episode_name("YERLERI KİM YAĞLADI", min(500, blackbox_feedback_num("slips")/2))

	if(blackbox_feedback_num("turfs_singulod") > 200)
		episode_names += new /datum/episode_name("[pick("SINGULARITYNIN KAYBOLUŞU", "MUHAFAZA SORUNU", 50;"MÜHENDİSLER UYUYOR")]", min(1000, blackbox_feedback_num("turfs_singulod")/2)) //no "singularity's day out" please we already have enough
	if(blackbox_feedback_num("spacevines_grown") > 150)
		episode_names += new /datum/episode_name("[pick("NE EKERSEN ONU BİÇERSİN", "ORMANDAN ÇIKMAK", "TOHUMLU İŞLER", "[uppr_name] VE FASULYE SIRIKLARI")]", min(1500, blackbox_feedback_num("spacevines_grown")*2))
	if(blackbox_feedback_num("devastating_booms") >= 6)
		episode_names += new /datum/episode_name("ISTASYONDAKİ BOMBALI SALDIRILAR", min(1000, blackbox_feedback_num("devastating_booms")*100))

	if(SSpersistence.tram_hits_this_round >= 10)
		episode_names += new /datum/episode_name("TRAMVAY KAZASI", 250)

	CHECK_TICK

	if(!EMERGENCY_ESCAPED_OR_ENDGAMED)
		return

	var/dead = GLOB.joined_player_list.len - SSticker.popcount[POPCOUNT_ESCAPEES]
	var/escaped = SSticker.popcount[POPCOUNT_ESCAPEES]
	var/human_escapees = SSticker.popcount[POPCOUNT_ESCAPEES_HUMANONLY]
	if(dead == 0)
		episode_names += new /datum/episode_name("[pick("ÇALIŞAN TRANSFERİ", "UZUN YAŞA VE GELİŞ", "[locale_uppertext(locale_suffix_locative(uppr_name))] HUZUR VE SAKİNLİK", "SAVAŞSIZ OLAN")]", 4000) //in practice, this one is very very very rare, so if it happens let's pick it more often
	if(escaped == 0 || SSshuttle.emergency.is_hijacked())
		episode_names += new /datum/episode_name("[pick("ÖLÜM ALANI", "MÜRETTEBAT KAYBOLUYOR", "[uppr_name]: SİLİNEN SAHNELER", "[locale_uppertext(locale_suffix_locative(uppr_name))] OLAN [locale_uppertext(locale_suffix_locative(uppr_name))] KALIR", "MİSYONDA KAYIP", "SCOOBY-DOO: MÜRETTEBAT NEREDE?")]", 300)
	if(escaped < 6 && escaped > 0 && dead > escaped*2)
		episode_names += new /datum/episode_name("[pick("YA ÖZGÜRLÜK YA ÖLÜM", "[locale_uppertext(locale_suffix_locative(uppr_name))] KAYBETTİĞİMİZ ŞEYLER", "[uppr_name] İLE GİDİP", "[locale_uppertext(locale_suffix_locative(uppr_name))] SON TANGO", "CANLI KAL, YA DA ÖL", "AMAN TANRIM, MÜRETTEBAT ÖLÜYOR")]", 400)

	var/clowncount = 0
	var/mimecount = 0
	var/assistantcount = 0
	var/chefcount = 0
	var/chaplaincount = 0
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
		if(H.mind && H.mind.assigned_role.title == "Shaft Miner")
			minercount++
		if(H.mind && H.mind.assigned_role.title == "Chaplain")
			chaplaincount++
			if(IS_CHANGELING(H))
				episode_names += new /datum/episode_name("[locale_uppertext(H.mind.name)]: A BLESSING IN DISGUISE", 400)
		if(H.dna.species.type == /datum/species/human && (H.hairstyle == "Bald" || H.hairstyle == "Skinhead") && !(BODY_ZONE_HEAD in H.get_covered_body_zones()))
			baldycount++
		if(H.is_wearing_item_of_type(/obj/item/clothing/mask/animal/horsehead))
			horsecount++
		CHECK_TICK

	if(clowncount > 2)
		episode_names += new /datum/episode_name("SAYISIZ PALYAÇO", min(1500, clowncount*250))
	if(mimecount > 2)
		episode_names += new /datum/episode_name("SESSİZ SİNEMA", min(1500, mimecount*250))
	if(chaplaincount > 2)
		episode_names += new /datum/episode_name("DUALARINIZ BIZIMLE", min(1500, chaplaincount*450))
	if(chefcount > 2)
		episode_names += new /datum/episode_name("ÇOK FAZLA ŞEF", min(1500, chefcount*450)) //intentionally not capitalized, as the theme will customize it

	if(human_escapees)
		if(assistantcount / human_escapees > 0.6 && human_escapees > 3)
			episode_names += new /datum/episode_name("GRİ GİYEN ADAMLAR", min(1500, assistantcount*200))

		if(baldycount / human_escapees > 0.6 && SSshuttle.emergency.launch_status == EARLY_LAUNCHED)
			episode_names += new /datum/episode_name("BAŞIMIN ÜSTÜNDE KELİM VAR", min(1500, baldycount*250))
		if(horsecount / human_escapees > 0.6 && human_escapees> 3)
			episode_names += new /datum/episode_name("AT KAFASI", min(1500, horsecount*250))

	CHECK_TICK

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
					episode_names += new /datum/episode_name("ŞEFİ SELAMLAYIN!!", chance)
				if("Clown")
					var/chance = 250
					if(H.is_wearing_item_of_type(/obj/item/clothing/mask/gas/clown_hat))
						chance += 500
					if(H.is_wearing_item_of_type(list(/obj/item/clothing/shoes/clown_shoes, /obj/item/clothing/shoes/clown_shoes/jester)))
						chance += 500
					if(H.is_wearing_item_of_type(list(/obj/item/clothing/under/rank/civilian/clown, /obj/item/clothing/under/rank/civilian/clown/jester)))
						chance += 250
					episode_names += new /datum/episode_name("SON GÜLEN İYİ GÜLER", chance)
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
					episode_names += new /datum/episode_name("[locale_uppertext(H.mind.name)]: KAYIP İPUCU", chance)
				if("Shaft Miner")
					var/chance = 250
					if(H.is_wearing_item_of_type(/obj/item/pickaxe))
						chance += 1000
					if(H.is_wearing_item_of_type(/obj/item/storage/backpack/explorer))
						chance += 500
					if(H.is_wearing_item_of_type(/obj/item/clothing/suit/hooded/explorer))
						chance += 250
					episode_names += new /datum/episode_name("[pick("ASTEROİTİN MERKEZİNE YOLCULUK", "BİR MAĞARA HİKAYESİ")]", chance)
				if("Librarian")
					var/chance = 750
					if(H.is_wearing_item_of_type(/obj/item/book))
						chance += 1000
					episode_names += new /datum/episode_name("KİTAP KURDU", chance)
				if("Chemist")
					var/chance = 1000
					if(H.is_wearing_item_of_type(/obj/item/clothing/suit/toggle/labcoat/chemist))
						chance += 500
					if(H.is_wearing_item_of_type(/obj/item/clothing/under/rank/medical/chemist))
						chance += 250
					episode_names += new /datum/episode_name("HAPI YUTTUK", chance)
				if("Chaplain") //We don't check for uniform here because the chaplain's thing kind of is to improvise their garment gimmick
					episode_names += new /datum/episode_name("YANLIZ DEGİLİM TANRI YANIMDA", 1250)

			if(H.is_wearing_item_of_type(/obj/item/clothing/mask/luchador) && H.is_wearing_item_of_type(/obj/item/clothing/gloves/boxing))
				episode_names += new /datum/episode_name("[pick("DÖVÜŞ KLUBÜ", "NAKAVT")]", 1500)

	if(human_escapees == 2)
		if(chefcount == 2)
			episode_names += new /datum/episode_name("MASTERCHEF", 2500)
		if(minercount == 2)
			episode_names += new /datum/episode_name("ROCK AND STONE", 2500)
		if(clowncount == 2)
			episode_names += new /datum/episode_name("BİR SİRK İKİ PALYAÇO", 2500)
		if(clowncount == 1 && mimecount == 1)
			episode_names += new /datum/episode_name("DİNAMİK İKİLİ", 2500)

	else
		//more than 0 human escapees
		var/braindamage_total = 0
		var/all_braindamaged = TRUE
		for(var/mob/living/carbon/human/H as anything in SSticker.popcount[POPCOUNT_ESCAPEES_HUMANONLY_LIST])
			var/obj/item/organ/brain/hbrain = H.get_organ_slot(ORGAN_SLOT_BRAIN)
			if(hbrain.damage < 60)
				all_braindamaged = FALSE
			braindamage_total += hbrain.damage
			CHECK_TICK

		var/average_braindamage = braindamage_total / human_escapees
		if(average_braindamage > 30)
			episode_names += new /datum/episode_name("[pick("MÜRETTEBATIN DÜŞÜK IQ PROBLEMI", "AH! KAFAM", "[pick("BEYİN HASARI", "BEVİN HASAVI","HASAVI BEVIN")]", "[locale_uppertext(locale_suffix_genitive(uppr_name))] ÇOK ÖZEL MÜRETTEBATI")]", min(1000, average_braindamage*10))
		if(all_braindamaged && human_escapees > 2)
			episode_names += new /datum/episode_name("UMARIM UZAYIN BİR YERLERİNDE AKILLI YAŞAM FORMLARI VARDIR, ÇÜNKÜ [locale_uppertext(locale_suffix_locative(uppr_name))] YOK!!", human_escapees * 500)

/datum/controller/subsystem/credits/proc/get_title_card(passed_icon_state)
	if(!passed_icon_state)
		return
	var/obj/effect/title_card_object/MA
	for(var/obj/effect/title_card_object/effect as anything in antag_appearances)
		if(effect.icon_state == passed_icon_state)
			MA = effect
			break
	if(!MA)
		MA = new
		MA.icon_state = passed_icon_state
		antag_appearances += MA
		antag_appearances[MA] = list()
	return MA

/datum/controller/subsystem/credits/proc/generate_admin_icons()
	admin_appearances = list()

	var/list/all_admins = GLOB.admin_datums + GLOB.deadmins
	var/mob/living/carbon/human/dummy/our_dummy = new()
	for(var/ckey in all_admins)
		var/datum/admins/admin_datum = all_admins[ckey]
		if(!(admin_datum.rank_flags() & R_AUTOADMIN))
			continue
		var/mutable_appearance/appearance
		if(GLOB.preferences_datums[ckey])
			var/datum/preferences/preferences_datum = GLOB.preferences_datums[ckey]
			our_dummy.wipe_state()
			appearance = new
			appearance.appearance = preferences_datum.render_new_preview_appearance(our_dummy, TRUE)
		else
			appearance = render_offline_appearance(ckey, our_dummy)
		if(!appearance)
			continue
		appearance.setDir(SOUTH)
		appearance.maptext_width = 88
		appearance.maptext_height = world.icon_size * 1.5
		appearance.maptext_x = ((88 - world.icon_size) * -0.5) - our_dummy.base_pixel_x
		appearance.maptext_y = -16
		appearance.maptext = "<center>[ckey]</center>"
		admin_appearances += appearance

	qdel(our_dummy)

/datum/controller/subsystem/credits/proc/generate_patron_icons()
	set waitfor = FALSE

	var/list/all_patrons = get_patrons()
	if(isnull(all_patrons))
		return
	patron_appearances = list()
	var/mob/living/carbon/human/dummy/our_dummy = new()
	for(var/ckey in all_patrons)
		var/mutable_appearance/appearance
		if(GLOB.preferences_datums[ckey])
			var/datum/preferences/preferences_datum = GLOB.preferences_datums[ckey]
			our_dummy.wipe_state()
			appearance = new
			appearance.appearance = preferences_datum.render_new_preview_appearance(our_dummy, TRUE)
		else
			appearance = render_offline_appearance(ckey, our_dummy)
		if(!appearance)
			continue
		appearance.setDir(SOUTH)
		appearance.maptext_width = 88
		appearance.maptext_height = world.icon_size * 1.5
		appearance.maptext_x = ((88 - world.icon_size) * -0.5) - our_dummy.base_pixel_x
		appearance.maptext_y = -16
		appearance.maptext = "<center>[ckey]</center>"
		patron_appearances += appearance
	qdel(our_dummy)

/datum/controller/subsystem/credits/proc/create_antagonist_icon(client/client, mob/living/living_mob, passed_icon_state)
	if(!client || !living_mob || !living_mob.mind || !passed_icon_state)
		return
	var/obj/effect/title_card_object/MA = get_title_card(passed_icon_state)
	var/mutable_appearance/appearance
	if(processing_icons[WEAKREF(living_mob.mind)])
		appearance = processing_icons[WEAKREF(living_mob.mind)]
	else
		appearance = new (living_mob.get_mob_appearance())
		appearance.transform = matrix()
		appearance.setDir(SOUTH)
		appearance.maptext_width = 88
		appearance.maptext_height = world.icon_size * 1.5
		appearance.maptext_x = ((88 - world.icon_size) * -0.5) - living_mob.base_pixel_x
		appearance.maptext_y = -16
		appearance.maptext = "<center>[living_mob.mind.name]</center>"
	antag_appearances[MA] += appearance
	processing_icons[WEAKREF(living_mob.mind)] = appearance

/datum/controller/subsystem/credits/proc/get_antagonist_icon(datum/weakref/weakref)
	if(isnull(weakref))
		return
	return processing_icons[weakref]

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
		CHECK_TICK

	if(avg_divide)
		return avg_temp / avg_divide
	return T0C

/datum/controller/subsystem/credits/proc/get_patrons()
	if(!CONFIG_GET(string/apiurl) || !CONFIG_GET(string/apitoken))
		return

	var/datum/http_request/request = new ()
	request.prepare(RUSTG_HTTP_METHOD_GET, "[CONFIG_GET(string/apiurl)]/patreon/patrons", headers = list("X-EXP-KEY" = "[CONFIG_GET(string/apitoken)]"))
	request.begin_async()

	UNTIL(request.is_complete())

	var/datum/http_response/response = request.into_response()

	if(!response.errored && response.status_code == 200)
		var/list/json = json_decode(response.body)
		return json["patrons"]

/obj/effect/title_card_object
	plane = SPLASHSCREEN_PLANE
	icon = 'modular_psychonaut/master_files/icons/effects/title_cards.dmi'
	pixel_x = 80

/obj/effect/cast_object
	plane = SPLASHSCREEN_PLANE

/datum/episode_name
	var/name = ""
	var/weight = 100

/datum/episode_name/New(name, weight)
	if(!name)
		return
	src.name = name
	if(weight)
		src.weight = weight

	switch(rand(1,15))
		if(0 to 5)
			name += ": PART I"
		if(6 to 10)
			name += ": PART II"
		if(11 to 12)
			name += ": PART III"
		if(13)
			name += ": ŞİMDİ 3D"
		if(14)
			name += ": BUZULLARIN ÜZERİNDE!"
		if(15)
			name += ": SEZON FİNALİ"

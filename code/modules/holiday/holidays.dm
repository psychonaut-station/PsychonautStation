/// List of all holiday-related mail. Do not edit this directly, instead add to var/list/holiday_mail
GLOBAL_LIST_INIT(holiday_mail, list())

/datum/holiday
	///Name of the holiday itself. Visible to players.
	var/name = "If you see this the holiday calendar code is broken"

	///What day of begin_month does the holiday begin on?
	var/begin_day = 1
	///What month does the holiday begin on?
	var/begin_month = 0
	/// What day of end_month does the holiday end? Default of 0 means the holiday lasts a single.
	var/end_day = 0
	/// What month does the holiday end on?
	var/end_month = 0
	/// for christmas neverending, or testing. Forces a holiday to be celebrated.
	var/always_celebrate = FALSE
	/// Held variable to better calculate when certain holidays may fall on, like easter.
	var/current_year = 0
	/// How many years are you offsetting your calculations for begin_day and end_day on. Used for holidays like easter.
	var/year_offset = 0
	///Timezones this holiday is celebrated in (defaults to three timezones spanning a 50 hour window covering all timezones)
	var/list/timezones = list(TIMEZONE_LINT, TIMEZONE_UTC, TIMEZONE_ANYWHERE_ON_EARTH)
	///If this is defined, drones/assistants without a default hat will spawn with this item in their head clothing slot.
	var/obj/item/holiday_hat
	///When this holiday is active, does this prevent mail from arriving to cargo? Overrides var/list/holiday_mail. Try not to use this for longer holidays.
	var/no_mail_holiday = FALSE
	/// The list of items we add to the mail pool. Can either be a weighted list or a normal list. Leave empty for nothing.
	var/list/holiday_mail = list()
	var/poster_name = "generic celebration poster"
	var/poster_desc = "A poster for celebrating some holiday. Unfortunately, its unfinished, so you can't see what the holiday is."
	var/poster_icon = "holiday_unfinished"
	/// Color scheme for this holiday
	var/list/holiday_colors
	/// The default pattern of the holiday, if the requested pattern is null.
	var/holiday_pattern = PATTERN_DEFAULT

// This proc gets run before the game starts when the holiday is activated. Do festive shit here.
/datum/holiday/proc/celebrate()
	if(no_mail_holiday)
		SSeconomy.mail_blocked = TRUE
	if(LAZYLEN(holiday_mail) && !no_mail_holiday)
		GLOB.holiday_mail += holiday_mail
	return

// When the round starts, this proc is ran to get a text message to display to everyone to wish them a happy holiday
/datum/holiday/proc/greet()
	return "[name] kutlu olsun!"

// Returns special prefixes for the station name on certain days. You wind up with names like "Christmas Object Epsilon". See new_station_name()
/datum/holiday/proc/getStationPrefix()
	//get the first word of the Holiday and use that
	var/i = findtext(name, " ")
	return copytext(name, 1, i)

// Return 1 if this holidy should be celebrated today
/datum/holiday/proc/shouldCelebrate(dd, mm, yyyy, ddd)
	if(always_celebrate)
		return TRUE

	if(!end_day)
		end_day = begin_day
	if(!end_month)
		end_month = begin_month
	if(end_month > begin_month) //holiday spans multiple months in one year
		if(mm == end_month) //in final month
			if(dd <= end_day)
				return TRUE

		else if(mm == begin_month)//in first month
			if(dd >= begin_day)
				return TRUE

		else if(mm in begin_month to end_month) //holiday spans 3+ months and we're in the middle, day doesn't matter at all
			return TRUE

	else if(end_month == begin_month) // starts and stops in same month, simplest case
		if(mm == begin_month && (dd in begin_day to end_day))
			return TRUE

	else // starts in one year, ends in the next
		if(mm >= begin_month && dd >= begin_day) // Holiday ends next year
			return TRUE
		if(mm <= end_month && dd <= end_day) // Holiday started last year
			return TRUE

	return FALSE

/// Procs to return holiday themed colors for recoloring atoms
/datum/holiday/proc/get_holiday_colors(atom/thing_to_color, pattern = holiday_pattern)
	if(!holiday_colors)
		return
	switch(pattern)
		if(PATTERN_DEFAULT)
			return holiday_colors[(thing_to_color.y % holiday_colors.len) + 1]
		if(PATTERN_VERTICAL_STRIPE)
			return holiday_colors[(thing_to_color.x % holiday_colors.len) + 1]

/proc/request_holiday_colors(atom/thing_to_color, pattern)
	switch(pattern)
		if(PATTERN_RANDOM)
			return "#[random_short_color()]"
		if(PATTERN_RAINBOW)
			var/datum/holiday/pride_week/rainbow_datum = new()
			return rainbow_datum.get_holiday_colors(thing_to_color, PATTERN_DEFAULT)
	if(!length(GLOB.holidays))
		return
	for(var/holiday_key in GLOB.holidays)
		var/datum/holiday/holiday_real = GLOB.holidays[holiday_key]
		if(!holiday_real.holiday_colors)
			continue
		return holiday_real.get_holiday_colors(thing_to_color, pattern || holiday_real.holiday_pattern)

// The actual holidays

// JANUARY

//Fleet Day is celebrated on Jan 19th, the date on which moths were merged (#34498)
/datum/holiday/fleet_day
	name = "Filo Günü"
	begin_month = JANUARY
	begin_day = 19
	holiday_hat = /obj/item/clothing/head/mothcap

/datum/holiday/fleet_day/greet()
	return "Bu gün, Mothic Grand Nomad Filosu'nda başarılı bir şekilde hayatta kalmanın bir yılını daha anıyor. Galaksi genelindeki Moth'ların yemek yemesi, içmesi ve eğlenmesi teşvik edilir."

/datum/holiday/fleet_day/getStationPrefix()
	return pick("Moth", "Fleet", "Nomadic")

// FEBRUARY

/datum/holiday/groundhog
	name = "Bugün Aslında Dündü"
	begin_day = 2
	begin_month = FEBRUARY

/datum/holiday/groundhog/getStationPrefix()
	return pick("Deja Vu") //I have been to this place before

/datum/holiday/nz
	name = "Waitangi Günü"
	timezones = list(TIMEZONE_NZDT, TIMEZONE_CHADT)
	begin_day = 6
	begin_month = FEBRUARY
	holiday_colors = list(
		COLOR_UNION_JACK_BLUE,
		COLOR_WHITE,
		COLOR_UNION_JACK_RED,
		COLOR_WHITE,
	)

/datum/holiday/nz/getStationPrefix()
	return pick("Aotearoa","Kiwi","Fish 'n' Chips","Kākāpō","Southern Cross")

/datum/holiday/nz/greet()
	var/nz_age = text2num(time2text(world.timeofday, "YYYY", TIMEZONE_NZST)) - 1840
	return "[nz_age] yıl önce bugün, Yeni Zelanda'nın Waitangi Antlaşması, ulusun kurucu belgesi, imzalandı!"

/datum/holiday/valentines
	name = VALENTINES
	begin_day = 13
	end_day = 15
	begin_month = FEBRUARY
	poster_name = "lovey poster"
	poster_desc = "A poster celebrating all the relationships built today. Of course, you probably don't have one."
	poster_icon = "holiday_love"
	holiday_mail = list(
		/obj/item/food/bonbon/chocolate_truffle,
		/obj/item/food/candyheart,
		/obj/item/food/grown/rose,
		)

/datum/holiday/valentines/getStationPrefix()
	return pick("Love","Amore","Single","Smootch","Hug")

/datum/holiday/birthday
	name = "Space Station 13'ün doğum günü"
	begin_day = 16
	begin_month = FEBRUARY
	holiday_hat = /obj/item/clothing/head/costume/festive
	poster_name = "station birthday poster"
	poster_desc = "A poster celebrating another year of the station's operation. Why anyone would be happy to be here is byond you."
	poster_icon = "holiday_cake" // is a lie
	holiday_mail = list(
		/obj/item/clothing/mask/party_horn,
		/obj/item/food/cakeslice/birthday,
		/obj/item/sparkler,
		/obj/item/storage/box/party_poppers,
	)

/datum/holiday/birthday/greet()
	var/game_age = text2num(time2text(world.timeofday, "YYYY", world.timezone)) - 2003
	var/Fact
	switch(game_age)
		if(16)
			Fact = " SS13 artık ehliyet alabilir!"
		if(18)
			Fact = " SS13 artık yetişkin!"
		if(21)
			Fact = " SS13 artık alkol içebilir!"
		if(26)
			Fact = " SS13 artık araba alabilir!"
		if(30)
			Fact = " SS13 artık bir yuva kurabilir!"
		if(40)
			Fact = " SS13 artık cumhurbaşkanlığı için aday olabilir!"
		if(60)
			Fact = " SS13 artık emekli olabilir!"
	if(!Fact)
		Fact = " SS13 [game_age] yaşında!"

	return "Space Station 13'e doğum günü dileklerini ilet, Şubat'ın 16. günü, 2003'te herkes tarafından oynanabilir hale geldi![Fact]"

/datum/holiday/random_kindness
	name = "Rastgele İyilik ve Teşekkür Haftası"
	begin_day = 17
	begin_month = FEBRUARY
	poster_name = "act of kindness poster"
	poster_desc = "A poster notifying the reader today is 'Act of Kindness' day. What a nice thing to do."
	poster_icon = "holiday_kind"

/datum/holiday/random_kindness/greet()
	return "Git ve yabancı birine rastgele birkaç iyilik yap!"  // piskonat yapar mı ki

// MARCH

/datum/holiday/pi
	name = "Pi Günü"
	begin_day = 14
	begin_month = MARCH
	poster_name = "pi day poster"
	poster_desc = "A poster celebrating the 3.141529th day of the year. At least theres free pie."
	poster_icon = "holiday_pi"
	holiday_mail = list(
		/obj/item/food/pieslice/apple,
		/obj/item/food/pieslice/bacid_pie,
		/obj/item/food/pieslice/blumpkin,
		/obj/item/food/pieslice/cherry,
		/obj/item/food/pieslice/frenchsilk,
		/obj/item/food/pieslice/frostypie,
		/obj/item/food/pieslice/meatpie,
		/obj/item/food/pieslice/pumpkin,
		/obj/item/food/pieslice/shepherds_pie,
		/obj/item/food/pieslice/tofupie,
		/obj/item/food/pieslice/xemeatpie,
	)

/datum/holiday/pi/getStationPrefix()
	return pick("Sinüs","Cosinüs","Tanjant","Sekant", "Kosekant", "Kotanjant")

/datum/holiday/no_this_is_patrick
	name = "Aziz Patrick Günü"
	begin_day = 17
	begin_month = MARCH
	holiday_hat = /obj/item/clothing/head/soft/green
	holiday_colors = list(
		COLOR_IRISH_GREEN,
		COLOR_WHITE,
		COLOR_IRISH_ORANGE,
	)
	holiday_pattern = PATTERN_VERTICAL_STRIPE
	/// Could we settle this over a pint?
	holiday_mail = list(
		/obj/item/reagent_containers/cup/glass/bottle/ale,
		/obj/item/reagent_containers/cup/glass/drinkingglass/filled/irish_cream,
	)

/datum/holiday/no_this_is_patrick/getStationPrefix()
	return pick("Blarney","Yeşil","Leprikon","İçki")

/datum/holiday/no_this_is_patrick/greet()
	return "Ulusal Sarhoşluk Gününüz Kutlu Olsun!"

// APRIL

/datum/holiday/april_fools
	name = APRIL_FOOLS
	begin_month = APRIL
	begin_day = 1
	end_day = 2
	holiday_hat = /obj/item/clothing/head/chameleon/broken
	holiday_mail = list(
		/obj/item/clothing/head/costume/whoopee,
		/obj/item/grown/bananapeel/gros_michel,
	)

/datum/holiday/april_fools/celebrate()
	. = ..()
	SSjob.set_overflow_role(/datum/job/clown)
	SSticker.set_lobby_music('sound/music/lobby_music/clown.ogg', override = TRUE)
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/P = i
		if(P.client)
			P.client.playtitlemusic()

/datum/holiday/april_fools/get_holiday_colors(atom/thing_to_color)
	return "#[random_short_color()]"

/datum/holiday/spess
	name = "Kozmonotlar Günü"
	begin_day = 12
	begin_month = APRIL
	holiday_hat = /obj/item/clothing/head/syndicatefake

/datum/holiday/spess/greet()
	return "Tam 600 yıl önce bugün, Yoldaş Yuri Gagarin ilk kez uzaya adım attı!"

/datum/holiday/fourtwenty
	name = "Dört-yirmi"
	begin_day = 20
	begin_month = APRIL
	holiday_hat = /obj/item/clothing/head/rasta
	holiday_colors = list(
		COLOR_ETHIOPIA_GREEN,
		COLOR_ETHIOPIA_YELLOW,
		COLOR_ETHIOPIA_RED,
	)
	holiday_mail = list(/obj/item/cigarette/rollie/cannabis)

/datum/holiday/fourtwenty/getStationPrefix()
	return pick("Snoop","Blunt","Toke","Dank","Cheech","Chong")

/datum/holiday/tea
	name = "Ulusal Çay Günü"
	begin_day = 21
	begin_month = APRIL
	holiday_mail = list(/obj/item/reagent_containers/cup/glass/mug/tea)

/datum/holiday/tea/getStationPrefix()
	return pick("Crumpet","Assam","Oolong","Pu-erh","Tatlı Çay","Yeşil","Siyah")

/datum/holiday/earth
	name = "Dünya Günü"
	begin_day = 22
	begin_month = APRIL

/datum/holiday/cocuk_bayrami
	name = "Ulusal Egemenlik ve Çocuk Bayramı"
	begin_day = 23
	begin_month = APRIL
	holiday_colors = list(
		COLOR_TURKISH_RED,
		COLOR_WHITE,
	)

// MAY

/datum/holiday/labor
	name = "Emek ve Dayanışma Günü"
	begin_day = 1
	begin_month = MAY
	holiday_hat = /obj/item/clothing/head/utility/hardhat
	no_mail_holiday = TRUE

//Draconic Day is celebrated on May 3rd, the date on which the Draconic language was merged (#26780)
/datum/holiday/draconic_day
	name = "Draconic Dili Günü"
	begin_month = MAY
	begin_day = 3

/datum/holiday/draconic_day/greet()
	return "Bu gün; Lizard türleri, edebiyat ve diğer kültürel eserlerle dillerini kutlar."

/datum/holiday/draconic_day/getStationPrefix()
	return pick("Draconic", "Literature", "Reading")

/datum/holiday/spor_bayrami
	name = "Atatürk’ü Anma, Gençlik ve Spor Bayramı"
	begin_day = 19
	begin_month = MAY
	holiday_colors = list(
		COLOR_TURKISH_RED,
		COLOR_WHITE,
	)

/datum/holiday/firefighter
	name = "İtfaiyeciler Günü"
	begin_day = 4
	begin_month = MAY
	holiday_hat = /obj/item/clothing/head/utility/hardhat/red
	holiday_mail = list(/obj/item/extinguisher/mini)

/datum/holiday/firefighter/getStationPrefix()
	return pick("Yanan","Alevli","Plazma","Ateş")

/datum/holiday/bee
	name = "Dünya Arı Günü"
	begin_day = 20
	begin_month = MAY
	holiday_mail = list(
		/obj/item/clothing/suit/hooded/bee_costume,
		/obj/item/food/honeycomb,
		/obj/item/food/monkeycube/bee,
		/obj/item/toy/plush/beeplushie,
	)

/datum/holiday/bee/getStationPrefix()
	return pick("Arı","Bal","Kovan","Afrikalılaştırılmış","Ballı","Vızz")

/datum/holiday/goth
	name = "Goth Day"
	begin_day = 22
	begin_month = MAY
	holiday_mail = list(
		/obj/item/lipstick,
		/obj/item/lipstick/black,
		/obj/item/clothing/suit/costume/gothcoat,
	)
	holiday_colors = list(
		COLOR_WHITE,
		COLOR_BLACK,
	)

/datum/holiday/goth/getStationPrefix()
	return pick("Goth", "Sanguine", "Tenebris", "Lacrimosa", "Umbra", "Noctis")

// JUNE

/// Garbage DAYYYYY
/// Huh?.... NOOOO
/// *GUNSHOT*
/// AHHHGHHHHHHH
/datum/holiday/garbageday
	name = GARBAGEDAY
	begin_day = 17
	end_day = 17
	begin_month = JUNE
	holiday_mail = list(
		/obj/effect/spawner/random/trash/garbage,
		/obj/item/storage/bag/trash,
	)

/datum/holiday/summersolstice
	name = "Yaz gündönümü"
	begin_day = 21
	begin_month = JUNE
	holiday_hat = /obj/item/clothing/head/costume/garland

/datum/holiday/pride_week
	name = PRIDE_WEEK
	begin_month = JUNE
	// Stonewall was June 28th, this captures its week.
	begin_day = 23
	end_day = 29
	holiday_colors = list(
		COLOR_PRIDE_PURPLE,
		COLOR_PRIDE_BLUE,
		COLOR_PRIDE_GREEN,
		COLOR_PRIDE_YELLOW,
		COLOR_PRIDE_ORANGE,
		COLOR_PRIDE_RED,
	)
	holiday_mail = list(
		/obj/item/bedsheet/rainbow,
		/obj/item/clothing/accessory/pride,
		/obj/item/clothing/gloves/color/rainbow,
		/obj/item/clothing/head/costume/garland/rainbowbunch,
		/obj/item/clothing/head/soft/rainbow,
		/obj/item/clothing/shoes/sneakers/rainbow,
		/obj/item/clothing/under/color/jumpskirt/rainbow,
		/obj/item/clothing/under/color/rainbow,
		/obj/item/food/egg/rainbow,
		/obj/item/food/grown/rainbow_flower,
		/obj/item/food/snowcones/rainbow,
		/obj/item/toy/crayon/rainbow,
	)

// JULY

/datum/holiday/doctor
	name = "Doktorlar Günü"
	begin_day = 1
	begin_month = JULY
	holiday_hat = /obj/item/clothing/head/costume/nursehat
	holiday_mail = list(
		/obj/item/stack/medical/gauze,
		/obj/item/stack/medical/ointment,
		/obj/item/storage/box/bandages,
	)

/datum/holiday/ufo
	name = "UFO Günü"
	begin_day = 2
	begin_month = JULY
	holiday_hat = /obj/item/clothing/head/collectable/xenom
	holiday_mail = list(
		/obj/item/toy/plush/abductor,
		/obj/item/toy/plush/abductor/agent,
		/obj/item/toy/plush/rouny,
		/obj/item/toy/toy_xeno,
	)

/datum/holiday/ufo/getStationPrefix() //Is such a thing even possible?
	return pick("Ayy","Truth","Tsoukalos","Mulder","Scully") //Yes it is!

/datum/holiday/demokrasi_bayrami
	name = "Milli Birlik ve Demokrasi Günü"
	begin_day = 15
	begin_month = JULY
	holiday_colors = list(
		COLOR_TURKISH_RED,
		COLOR_WHITE,
	)

/datum/holiday/usa
	name = "Amerikan Bağımsızlık Günü"
	timezones = list(TIMEZONE_EDT, TIMEZONE_CDT, TIMEZONE_MDT, TIMEZONE_MST, TIMEZONE_PDT, TIMEZONE_AKDT, TIMEZONE_HDT, TIMEZONE_HST)
	begin_day = 4
	begin_month = JULY
	no_mail_holiday = TRUE
	holiday_hat = /obj/item/clothing/head/cowboy/brown
	holiday_colors = list(
		COLOR_OLD_GLORY_BLUE,
		COLOR_OLD_GLORY_RED,
		COLOR_WHITE,
		COLOR_OLD_GLORY_RED,
		COLOR_WHITE,
	)

/datum/holiday/usa/getStationPrefix()
	return pick("Bağımsız","Amerikan","Burger","Kel Kartal","Yıldızlarla Süslü", "Havai Fişekler")

/datum/holiday/writer
	name = "Yazarlar Günü"
	begin_day = 8
	begin_month = JULY
	holiday_mail = list(/obj/item/pen/fountain)

/datum/holiday/france
	name = "Bastille Günü"
	timezones = list(TIMEZONE_CEST)
	begin_day = 14
	begin_month = JULY
	holiday_hat = /obj/item/clothing/head/beret
	no_mail_holiday = TRUE
	holiday_colors = list(
		COLOR_FRENCH_BLUE,
		COLOR_WHITE,
		COLOR_FRENCH_RED
	)
	holiday_pattern = PATTERN_VERTICAL_STRIPE

/datum/holiday/france/getStationPrefix()
	return pick("Fransız", "Fromaj", "Zut", "Merde", "Sacrebleu")

/datum/holiday/france/greet()
	return "İnsanların şarkı söylediğini duyuyor musunuz?"

/datum/holiday/hotdogday
	name = HOTDOG_DAY
	begin_day = 17
	begin_month = JULY
	holiday_mail = list(/obj/item/food/hotdog)

/datum/holiday/hotdogday/greet()
	return "Ulusal Sosisli Sandviç Gününüz Kutlu Olsun!"

//Gary Gygax's birthday, a fitting day for Wizard's Day
/datum/holiday/wizards_day
	name = "Wizard'ın Günü"  // ozel isim gibi
	begin_month = JULY
	begin_day = 27
	holiday_hat = /obj/item/clothing/head/wizard

/datum/holiday/wizards_day/getStationPrefix()
	return pick("Dungeon", "Elf", "Magic", "D20", "Edition")

/datum/holiday/friendship
	name = "Arkadaşlık Günü"
	begin_day = 30
	begin_month = JULY
	holiday_mail = list(/obj/item/food/grown/apple)

// AUGUST

/datum/holiday/zafer_bayrami
	name = "Zafer Bayramı"
	begin_month = AUGUST
	begin_day = 30
	holiday_colors = list(
		COLOR_TURKISH_RED,
		COLOR_WHITE,
	)

// SEPTEMBER

//Tiziran Unification Day is celebrated on Sept 1st, the day on which lizards were made a roundstart race
/datum/holiday/tiziran_unification
	name = "Kertenkele Birliği Günü"
	begin_month = SEPTEMBER
	begin_day = 1
	holiday_hat = /obj/item/clothing/head/costume/lizard
	holiday_mail = list(/obj/item/toy/plush/lizard_plushie)

/datum/holiday/tiziran_unification/greet()
	return "400 yılı aşkın bir süre önce bugün, Kertenkele halkı ilk kez tek bir bayrak altında birleşti ve tek bir halk olarak yıldızlarla yüzleşmeye hazır oldu."

/datum/holiday/tiziran_unification/getStationPrefix()
	return pick("Tizira", "Lizard")

/datum/holiday/ianbirthday
	name = IAN_HOLIDAY //github.com/tgstation/tgstation/commit/de7e4f0de0d568cd6e1f0d7bcc3fd34700598acb
	begin_month = SEPTEMBER
	begin_day = 9
	end_day = 10
	holiday_mail = list(
		/obj/item/bedsheet/ian,
		/obj/item/bedsheet/ian/double,
		/obj/item/clothing/suit/costume/wellworn_shirt/graphic/ian,
		/obj/item/clothing/suit/costume/wellworn_shirt/messy/graphic/ian,
		/obj/item/clothing/suit/costume/wellworn_shirt/wornout/graphic/ian,
		/obj/item/clothing/suit/hooded/ian_costume,
		/obj/item/radio/toy,
		/obj/item/toy/figure/ian,
	)

/datum/holiday/ianbirthday/greet()
	return "Doğum günün kutlu olsun, Ian!"

/datum/holiday/ianbirthday/getStationPrefix()
	return pick("Ian", "Corgi", "Erro")

/datum/holiday/pirate
	name = "Korsan Gibi Konuşma Günü"
	begin_day = 19
	begin_month = SEPTEMBER
	holiday_hat = /obj/item/clothing/head/costume/pirate
	holiday_mail = list(/obj/item/clothing/head/costume/pirate)

/datum/holiday/pirate/greet()
	return "Bugün bir korsan gibi konuşmalısın yoksa tahtada yürürsün, dostum!"

/datum/holiday/pirate/getStationPrefix()
	return pick("Yarr","Scurvy","Yo-ho-ho")

/datum/holiday/questions
	name = "Aptal Soru Sor Günü"
	begin_day = 28
	begin_month = SEPTEMBER

/datum/holiday/questions/greet()
	return "Mutlu bir Aptal Soru Sor Günü geçiriyor musunuz?"

// OCTOBER

/datum/holiday/animal
	name = "Hayvanlar Günü"
	begin_day = 4
	begin_month = OCTOBER

/datum/holiday/animal/getStationPrefix()
	return pick("Parrot","Corgi","Cat","Pug","Goat","Fox")

/datum/holiday/smile
	name = "Dünya Gülümseme Günü"
	begin_day = 7
	begin_month = OCTOBER
	holiday_hat = /obj/item/clothing/head/costume/papersack/smiley
	holiday_mail = list(/obj/item/sticker/smile)

/datum/holiday/boss
	name = "Patronlar Günü"
	begin_day = 16
	begin_month = OCTOBER
	holiday_hat = /obj/item/clothing/head/hats/tophat

/datum/holiday/cumhuriyet_bayrami
	name = "Cumhuriyet Bayramı"
	begin_day = 29
	begin_month = OCTOBER
	holiday_colors = list(
		COLOR_TURKISH_RED,
		COLOR_WHITE,
	)

/datum/holiday/halloween
	name = HALLOWEEN
	begin_day = 29
	begin_month = OCTOBER
	end_day = 2
	end_month = NOVEMBER
	holiday_colors = list(COLOR_MOSTLY_PURE_ORANGE, COLOR_PRISONER_BLACK)
	holiday_mail = list(
		/obj/item/food/cookie/sugar/spookycoffin,
		/obj/item/food/cookie/sugar/spookyskull,
		)

/datum/holiday/halloween/greet()
	return "Have a spooky Halloween!"

/datum/holiday/halloween/getStationPrefix()
	return pick("Bone-Rattling","Mr. Bones' Own","2SPOOKY","Spooky","Scary","Skeletons")

// NOVEMBER

/datum/holiday/vegan
	name = "Veganlar Günü"
	begin_day = 1
	begin_month = NOVEMBER
	holiday_mail = list(/obj/item/food/tofu)

/datum/holiday/vegan/getStationPrefix()
	return pick("Tofu", "Tempeh", "Seitan", "Tofurkey")

/datum/holiday/october_revolution
	name = "Ekim Devrimi Günü"
	begin_day = 6
	begin_month = NOVEMBER
	end_day = 7
	holiday_colors = list(
		COLOR_MEDIUM_DARK_RED,
		COLOR_GOLD,
		COLOR_MEDIUM_DARK_RED,
	)

/datum/holiday/october_revolution/getStationPrefix()
	return pick("Communist", "Soviet", "Bolshevik", "Socialist", "Red", "Workers'")

/datum/holiday/remembrance_day
	name = "Anma Günü"
	begin_month = NOVEMBER
	begin_day = 11
	holiday_hat = /obj/item/food/grown/poppy
	holiday_mail = list(
		/obj/item/food/grown/harebell,
		/obj/item/food/grown/poppy,
		/obj/item/storage/fancy/candle_box,
	)

/datum/holiday/remembrance_day/greet()
	return "Unutmayalım."

/datum/holiday/remembrance_day/getStationPrefix()
	return pick("Barış", "Ateşkes", "Gelincik")

/datum/holiday/lifeday
	name = "Yaşam Günü"
	begin_day = 17
	begin_month = NOVEMBER

/datum/holiday/lifeday/getStationPrefix()
	return pick("Kaşıntılı", "Yumrulu", "Malla", "Kazook") //he really pronounced it "Kazook", I wish I was making shit up

/datum/holiday/kindness
	name = "Nezaket Günü"
	begin_day = 13
	begin_month = NOVEMBER

/datum/holiday/flowers
	name = "Çiçekler Günü"
	begin_day = 19
	begin_month = NOVEMBER
	holiday_hat = /obj/item/food/grown/moonflower
	holiday_mail = list(
		/obj/item/food/grown/harebell,
		/obj/item/food/grown/moonflower,
		/obj/item/food/grown/poppy,
		/obj/item/food/grown/poppy/geranium,
		/obj/item/food/grown/poppy/geranium/fraxinella,
		/obj/item/food/grown/poppy/lily,
		/obj/item/food/grown/rose,
		/obj/item/food/grown/sunflower,
		/obj/item/grown/carbon_rose,
		/obj/item/grown/novaflower,
	)

/datum/holiday/hello
	name = "Selamlaşma Günü"
	begin_day = 21
	begin_month = NOVEMBER

/datum/holiday/hello/greet()
	return "[pick(list("Aloha", "Bonjour", "Hello", "Hi", "Greetings", "Salutations", "Bienvenidos", "Hola", "Howdy", "Ni hao", "Guten Tag", "Konnichiwa", "G'day cunt", "Selam"))]! " + ..()

//The Festival of Holy Lights is celebrated on Nov 28th, the date on which ethereals were merged (#40995)
/datum/holiday/holy_lights
	name = "Kutsal Işıklar Festivali"
	begin_month = NOVEMBER
	begin_day = 28
	/// If there's more of them I forgot
	holiday_mail = list(
		/obj/item/food/energybar,
		/obj/item/food/pieslice/bacid_pie,
	)

/datum/holiday/holy_lights/greet()
	return "Kutsal Işıklar Festivali, Ethereal takviminin son günüdür. Genellikle yılın şık bir şekilde kapanmasını sağlayan bir kutlamanın ardından dua günüdür."

/datum/holiday/holy_lights/getStationPrefix()
	return pick("Ethereal", "Lantern", "Holy")

// DECEMBER

/datum/holiday/festive_season
	name = FESTIVE_SEASON
	begin_day = 1
	begin_month = DECEMBER
	end_day = 31
	holiday_hat = /obj/item/clothing/head/costume/santa

/datum/holiday/festive_season/greet()
	return "Mutlu yıllar!"

/datum/holiday/human_rights
	name = "İnsan Hakları Günü"
	begin_day = 10
	begin_month = DECEMBER

/datum/holiday/monkey
	name = MONKEYDAY
	begin_day = 14
	begin_month = DECEMBER

/datum/holiday/monkey/celebrate()
	. = ..()
	SSstation.setup_trait(/datum/station_trait/job/pun_pun)
	//SSevents should initialize before SSatoms but who knows if it'll ever change.
	if(GLOB.the_one_and_only_punpun)
		new /obj/effect/landmark/start/pun_pun(GLOB.the_one_and_only_punpun.loc)
		qdel(GLOB.the_one_and_only_punpun)

/datum/holiday/xmas
	name = CHRISTMAS
	begin_day = 18
	begin_month = DECEMBER
	end_day = 27
	holiday_hat = /obj/item/clothing/head/costume/santa
	no_mail_holiday = TRUE
	holiday_colors = list(
		COLOR_CHRISTMAS_GREEN,
		COLOR_CHRISTMAS_RED,
	)

/datum/holiday/xmas/getStationPrefix()
	return pick(
		"Bible",
		"Birthday",
		"Chimney",
		"Claus",
		"Crucifixion",
		"Elf",
		"Fir",
		"Ho Ho Ho",
		"Jesus",
		"Jolly",
		"Merry",
		"Present",
		"Sack",
		"Santa",
		"Sleigh",
		"Yule",
	)

/datum/holiday/xmas/greet()
	return "Mutlu Noeller!"

/datum/holiday/boxing
	name = "Boks Günü"
	begin_day = 26
	begin_month = DECEMBER
	holiday_mail = list(
		/obj/item/clothing/gloves/boxing,
		/obj/item/clothing/gloves/boxing/blue,
		/obj/item/clothing/gloves/boxing/green,
		/obj/item/clothing/gloves/boxing/yellow,
	)

/datum/holiday/new_year
	name = NEW_YEAR
	begin_day = 31
	begin_month = DECEMBER
	end_day = 2
	end_month = JANUARY
	holiday_hat = /obj/item/clothing/head/costume/festive
	no_mail_holiday = TRUE

/datum/holiday/new_year/getStationPrefix()
	return pick("Party","New","Hangover","Resolution", "Auld")

// MOVING DATES

/datum/holiday/programmers
	name = "Yazılımcılar Günü"
	holiday_mail = list(/obj/item/sticker/robot)

/datum/holiday/programmers/shouldCelebrate(dd, mm, yyyy, ddd) //Programmer's day falls on the 2^8th day of the year
	if(mm == 9)
		if(yyyy/4 == round(yyyy/4)) //Note: Won't work right on September 12th, 2200 (at least it's a Friday!)
			if(dd == 12)
				return TRUE
		else
			if(dd == 13)
				return TRUE
	return FALSE

/datum/holiday/programmers/getStationPrefix()
	return pick("span>","DEBUG: ","null","/list","EVENT PREFIX NOT FOUND") //Portability

// ISLAMIC

/datum/holiday/islamic
	name = "Islamic calendar code broken"

/datum/holiday/islamic/shouldCelebrate(dd, mm, yyyy, ddd)
	var/datum/foreign_calendar/islamic/cal = new(yyyy, mm, dd)
	return ..(cal.dd, cal.mm, cal.yyyy, ddd)

/datum/holiday/islamic/ramadan/eve
	name = "Ramazan Bayramı Arifesi"
	begin_month = 9
	begin_day = 30
	end_day = 30

/datum/holiday/islamic/ramadan
	name = "Ramazan Bayramı"
	begin_month = 10
	begin_day = 1
	end_day = 3

// HEBREW

/datum/holiday/hebrew
	name = "If you see this the Hebrew holiday calendar code is broken"

/datum/holiday/hebrew/shouldCelebrate(dd, mm, yyyy, ddd)
	var/datum/foreign_calendar/hebrew/cal = new(yyyy, mm, dd)
	return ..(cal.dd, cal.mm, cal.yyyy, ddd)

/datum/holiday/hebrew/hanukkah
	name = "Hanuka"
	begin_day = 25
	begin_month = 9
	end_day = 2
	end_month = 10

/datum/holiday/hebrew/hanukkah/greet()
	return "Hanuka gününüz kutlu olsun!"

/datum/holiday/hebrew/hanukkah/getStationPrefix()
	return pick("Dreidel", "Menorah", "Latkes", "Gelt")

// HOLIDAY ADDONS

/datum/holiday/xmas/celebrate()
	. = ..()
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(roundstart_celebrate)))
	GLOB.maintenance_loot += list(
		list(
			/obj/item/clothing/head/costume/santa = 1,
			/obj/item/gift/anything = 1,
			/obj/item/toy/xmas_cracker = 3,
		) = maint_holiday_weight,
	)

/datum/holiday/xmas/proc/roundstart_celebrate()
	for(var/obj/machinery/computer/security/telescreen/entertainment/Monitor as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/computer/security/telescreen/entertainment))
		Monitor.icon_state_on = "entertainment_xmas"

	for(var/mob/living/basic/pet/dog/corgi/ian/Ian in GLOB.mob_living_list)
		Ian.place_on_head(new /obj/item/clothing/head/helmet/space/santahat(Ian))


// EASTER (this having its own spot should be understandable)

/datum/holiday/easter
	name = EASTER
	holiday_hat = /obj/item/clothing/head/costume/rabbitears
	holiday_mail = list(
		/obj/item/clothing/head/costume/rabbitears,
		/obj/item/food/chocolatebunny,
		/obj/item/food/chocolateegg,
		/obj/item/food/egg/blue,
		/obj/item/food/egg/green,
		/obj/item/food/egg/orange,
		/obj/item/food/egg/purple,
		/obj/item/food/egg/rainbow,
		/obj/item/food/egg/red,
		/obj/item/food/egg/yellow,
	)
	var/const/days_early = 1 //to make editing the holiday easier
	var/const/days_extra = 1

/datum/holiday/easter/shouldCelebrate(dd, mm, yyyy, ddd)
	if(!begin_month)
		current_year = text2num(time2text(world.timeofday, "YYYY", world.timezone))
		var/list/easterResults = EasterDate(current_year+year_offset)

		begin_day = easterResults["day"]
		begin_month = easterResults["month"]

		end_day = begin_day + days_extra
		end_month = begin_month
		if(end_day >= 32 && end_month == MARCH) //begins in march, ends in april
			end_day -= 31
			end_month++
		if(end_day >= 31 && end_month == APRIL) //begins in april, ends in june
			end_day -= 30
			end_month++

		begin_day -= days_early
		if(begin_day <= 0)
			if(begin_month == APRIL)
				begin_day += 31
				begin_month-- //begins in march, ends in april

	return ..()

/datum/holiday/easter/celebrate()
	. = ..()
	GLOB.maintenance_loot += list(
		list(
			/obj/item/surprise_egg = 15,
			/obj/item/storage/basket/easter = 15
		) = maint_holiday_weight,
	)

/datum/holiday/easter/greet()
	return "Selamlar! Mutlu Paskalyalar ve Paskalya Tavşanlarına dikkat edin!"

/datum/holiday/easter/getStationPrefix()
	return pick("Fluffy","Bunny","Easter","Egg")

/// Takes a holiday datum, a starting month, ending month, max amount of days to test in, and min/max year as input
/// Returns a list in the form list("yyyy/m/d", ...) representing all days the holiday runs on in the tested range
/proc/poll_holiday(datum/holiday/path, min_month, max_month, min_year, max_year, max_day)
	var/list/deets = list()
	for(var/year in min_year to max_year)
		for(var/month in min_month to max_month)
			for(var/day in 1 to max_day)
				var/datum/holiday/new_day = new path()
				if(new_day.shouldCelebrate(day, month, year, iso_to_weekday(day_of_month(year, month, day))))
					deets += "[year]/[month]/[day]"
	return deets

/// Does the same as [/proc/poll_holiday], but prints the output to admins instead of returning it
/proc/print_holiday(datum/holiday/path, min_month, max_month, min_year, max_year, max_day)
	var/list/deets = poll_holiday(path, min_month, max_month, min_year, max_year, max_day)
	message_admins("The accepted dates for [path] in the input range [min_year]-[max_year]/[min_month]-[max_month]/1-[max_day] are [deets.Join("\n")]")

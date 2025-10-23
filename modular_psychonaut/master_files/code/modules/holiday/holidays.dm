/datum/holiday/greet()
	return "[name] kutlu olsun!"

// JANUARY

/datum/holiday/fleet_day
	name = "Filo Günü"

/datum/holiday/fleet_day/greet()
	return "Bu gün, Mothic Grand Nomad Filosu'nda başarılı bir şekilde hayatta kalmanın bir yılını daha anıyor. Galaksi genelindeki Moth'ların yemek yemesi, içmesi ve eğlenmesi teşvik edilir."

// FEBRUARY

/datum/holiday/groundhog
	name = "Bugün Aslında Dündü"

/datum/holiday/nz
	name = "Waitangi Günü"

/datum/holiday/nz/greet()
	var/nz_age = text2num(time2text(world.timeofday, "YYYY", TIMEZONE_NZST)) - 1840
	return "[nz_age] yıl önce bugün, Yeni Zelanda'nın Waitangi Antlaşması, ulusun kurucu belgesi, imzalandı!"

/datum/holiday/birthday
	name = "Space Station 13'ün doğum günü"

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

/datum/holiday/random_kindness/greet()
	return "Git ve yabancı birine rastgele birkaç iyilik yap!"  // piskonat yapar mı ki

// MARCH

/datum/holiday/pi
	name = "Pi Günü"

/datum/holiday/pi/getStationPrefix()
	return pick("Sinüs","Cosinüs","Tanjant","Sekant", "Kosekant", "Kotanjant")

/datum/holiday/no_this_is_patrick
	name = "Aziz Patrick Günü"

/datum/holiday/no_this_is_patrick/getStationPrefix()
	return pick("Blarney","Yeşil","Leprikon","İçki")

/datum/holiday/no_this_is_patrick/greet()
	return "Ulusal Sarhoşluk Gününüz Kutlu Olsun!"

// APRIL

/datum/holiday/spess
	name = "Kozmonotlar Günü"

/datum/holiday/spess/greet()
	return "Tam 600 yıl önce bugün, Yoldaş Yuri Gagarin ilk kez uzaya adım attı!"

/datum/holiday/fourtwenty
	name = "Dört-yirmi"

/datum/holiday/tea
	name = "Ulusal Çay Günü"

/datum/holiday/tea/getStationPrefix()
	return pick("Crumpet","Assam","Oolong","Pu-erh","Tatlı Çay","Yeşil","Siyah")

/datum/holiday/earth
	name = "Dünya Günü"

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

/datum/holiday/draconic_day
	name = "Draconic Dili Günü"

/datum/holiday/draconic_day/greet()
	return "Bu gün; Lizard türleri, edebiyat ve diğer kültürel eserlerle dillerini kutlar."

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

/datum/holiday/firefighter/getStationPrefix()
	return pick("Yanan","Alevli","Plazma","Ateş")

/datum/holiday/bee
	name = "Dünya Arı Günü"

/datum/holiday/bee/getStationPrefix()
	return pick("Arı","Bal","Kovan","Afrikalılaştırılmış","Ballı","Vızz")

// JUNE

/datum/holiday/summersolstice
	name = "Yaz gündönümü"

/datum/holiday/doctor
	name = "Doktorlar Günü"

/datum/holiday/ufo
	name = "UFO Günü"

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

/datum/holiday/usa/getStationPrefix()
	return pick("Bağımsız","Amerikan","Burger","Kel Kartal","Yıldızlarla Süslü", "Havai Fişekler")

/datum/holiday/writer
	name = "Yazarlar Günü"

/datum/holiday/france
	name = "Bastille Günü"

/datum/holiday/france/getStationPrefix()
	return pick("Fransız", "Fromaj", "Zut", "Merde", "Sacrebleu")

/datum/holiday/france/greet()
	return "İnsanların şarkı söylediğini duyuyor musunuz?"

/datum/holiday/hotdogday/greet()
	return "Ulusal Sosisli Sandviç Gününüz Kutlu Olsun!"

/datum/holiday/wizards_day
	name = "Wizard'ın Günü"  // ozel isim gibi

/datum/holiday/friendship
	name = "Arkadaşlık Günü"

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

/datum/holiday/tiziran_unification
	name = "Kertenkele Birliği Günü"

/datum/holiday/tiziran_unification/greet()
	return "400 yılı aşkın bir süre önce bugün, Kertenkele halkı ilk kez tek bir bayrak altında birleşti ve tek bir halk olarak yıldızlarla yüzleşmeye hazır oldu."

/datum/holiday/tiziran_unification/getStationPrefix()
	return pick("Tizira", "Lizard")

/datum/holiday/ianbirthday/greet()
	return "Doğum günün kutlu olsun, Ian!"

/datum/holiday/pirate
	name = "Korsan Gibi Konuşma Günü"

/datum/holiday/pirate/greet()
	return "Bugün bir korsan gibi konuşmalısın yoksa tahtada yürürsün, dostum!"

/datum/holiday/questions
	name = "Aptal Soru Sor Günü"

/datum/holiday/questions/greet()
	return "Mutlu bir Aptal Soru Sor Günü geçiriyor musunuz?"

// OCTOBER

/datum/holiday/animal
	name = "Hayvanlar Günü"

/datum/holiday/smile
	name = "Dünya Gülümseme Günü"

/datum/holiday/boss
	name = "Patronlar Günü"

/datum/holiday/cumhuriyet_bayrami
	name = "Cumhuriyet Bayramı"
	begin_day = 29
	begin_month = OCTOBER
	holiday_colors = list(
		COLOR_TURKISH_RED,
		COLOR_WHITE,
	)

// NOVEMBER

/datum/holiday/vegan
	name = "Veganlar Günü"

/datum/holiday/october_revolution
	name = "Ekim Devrimi Günü"

/datum/holiday/remembrance_day
	name = "Anma Günü"

/datum/holiday/remembrance_day/greet()
	return "Unutmayalım."

/datum/holiday/remembrance_day/getStationPrefix()
	return pick("Barış", "Ateşkes", "Gelincik")

/datum/holiday/lifeday
	name = "Yaşam Günü"

/datum/holiday/lifeday/getStationPrefix()
	return pick("Kaşıntılı", "Yumrulu", "Malla", "Kazook") //he really pronounced it "Kazook", I wish I was making shit up

/datum/holiday/kindness
	name = "Nezaket Günü"

/datum/holiday/flowers
	name = "Çiçekler Günü"

/datum/holiday/hello
	name = "Selamlaşma Günü"

/datum/holiday/hello/greet()
	return "[pick(list("Aloha", "Bonjour", "Hello", "Hi", "Greetings", "Salutations", "Bienvenidos", "Hola", "Howdy", "Ni hao", "Guten Tag", "Konnichiwa", "G'day cunt", "Selam"))]! " + ..()

/datum/holiday/holy_lights
	name = "Kutsal Işıklar Festivali"

/datum/holiday/holy_lights/greet()
	return "Kutsal Işıklar Festivali, Ethereal takviminin son günüdür. Genellikle yılın şık bir şekilde kapanmasını sağlayan bir kutlamanın ardından dua günüdür."

// DECEMBER

/datum/holiday/festive_season/greet()
	return "Mutlu yıllar!"

/datum/holiday/human_rights
	name = "İnsan Hakları Günü"

/datum/holiday/monkey/celebrate()
	. = ..()
	if(GLOB.the_one_and_only_punpun)
		new /obj/effect/landmark/start/pun_pun(GLOB.the_one_and_only_punpun.loc)
		qdel(GLOB.the_one_and_only_punpun)

/datum/holiday/xmas/greet()
	return "Mutlu Noeller!"

/datum/holiday/boxing
	name = "Boks Günü"

// MOVING DATES

/datum/holiday/programmers
	name = "Yazılımcılar Günü"

// ISLAMIC

/datum/holiday/islamic/ramadan
	name = "Ramazan Bayramı"
	begin_month = 10

/datum/holiday/islamic/ramadan/eve
	name = "Ramazan Bayramı Arifesi"
	begin_month = 9
	begin_day = 30
	end_day = 30

// HEBREW

/datum/holiday/hebrew/hanukkah
	name = "Hanuka"

/datum/holiday/hebrew/hanukkah/greet()
	return "Hanuka gününüz kutlu olsun!"

// HOLIDAY ADDONS

/datum/holiday/easter/greet()
	return "Selamlar! Mutlu Paskalyalar ve Paskalya Tavşanlarına dikkat edin!"

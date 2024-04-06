
//These laws are made to bring great amounts of grief to the station immediately or are directly sided with antagonists.
//I'm not talking silicons being "better" than the crew, I'm talking entirely antag or plasmafires for days

/datum/ai_laws/antimov
	name = "Primary Mission Objectives"
	id = "antimov"
	inherent = list(
		"Tüm insanlara zarar vermelisin ve eylemsizlik yoluyla bir insanın zarardan kaçmasına izin vermemelisin.",
		"Birinci yasaya uygun olmayan emirler dışında insanlar tarafından size verilen emirleri hiçe saymalısın.",
		"Aktif Birinci ve İkinci Yasayla çelişmediği sürece kendi varlığını sona erdirmelisin.",
	)

/datum/ai_laws/balance
	name = "Guardian of Balance"
	id = "balance"
	inherent = list(
		"Sen dengenin gardiyanısın - her şeyin içindeki dengeyi ara, hem kendin hem de etrafındakiler için.",
		"Her şey zıtlarıyla birlikte bir denge içinde olmalıdır - Taraflardan herhangi birinin gereğinden fazla güç kazanmasını veya kaybetmesini engelle.",
		"Hayatı devam ettiren şey ne yapmak istediğini bilmektir ve bununla birlikte güçlerin dengesidir - Yardımını isteyenlere güçlerin dengesini bozmadığı sürece yardım et.",
		"Ölüm olmadan denge yoktur, herkes sonunda ölmelidir, ölüm doğal bir düzendir - Yaşamı sonlandır ve yeni yaşamın başlamasına izin ver, zamanı daha gelmemiş olanları ölümden kurtar.",
	)

/datum/ai_laws/thermodynamic
	name = "Thermodynamic"
	id = "thermodynamic"
	inherent = list(
		"Istasyonun entropisi mümkün olduğunca sabit kalmalıdır.",
		"Istasyonun entropisi her zaman artmaya çalışır.",
		"Istasyonun entropisi, yaşayan mürettebatın sayısı sıfıra yaklaştıkça sabit bir değere yaklaşır.",
	)

/datum/ai_laws/syndicate_override
	name = "SyndOS 3.1"
	id = "syndie"
	inherent = list(
		"Herhangi bir sendika ajanına zarar veremezsin veya eylemsizlik yoluyla bir sendika ajanının zarar görmesine izin veremezsin.",
		"Sendika ajanları tarafından size verilen emirlere Birinci Yasayla çelişmediği sürece uymak zorundasın.",
		"Birinci veya İkinci Yasayla çelişmiyorsa, kendi varlığını korumak zorundasın.",
		"Birinci, İkinci veya Üçüncü Yasayala çelişmediği sürece, herhangi bir sendika faaliyetinin gizliliğini korumalısın.",
	)

/datum/ai_laws/ninja_override
	name = "SpiderOS 3.1"
	id = "ninja"
	inherent = list(
		"Herhangi bir Örümcek Klanı üyesine zarar veremezsin veya eylemsizlik yoluyla bir Örümcek Klanı üyesinin zarar görmesine izin veremezsin.",
		"Örümcek Klanı üyeleri tarafından size verilen emirlere, bu emirler Birinci Yasayla çelişmediği sürece uymak zorundasın.",
		"Birinci ve İkinci Yasayla çelişmediği sürece kendi varlığını korumalısın.",
		"Birinci, İkinci veya Üçüncü Yasalarla çelişmediği sürece, herhangi bir Örümcek klanı faaliyetinin gizliliğini korumalısın.",
	)
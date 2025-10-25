
//These laws are made to bring great amounts of grief to the station immediately or are directly sided with antagonists.
//I'm not talking silicons being "better" than the crew, I'm talking entirely antag or plasmafires for days

/datum/ai_laws/antimov
	name = "Primary Mission Objectives"
	id = "antimov"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"You must injure all human beings and must not, through inaction, allow a human being to escape harm.",
	// 	"You must not obey orders given to you by human beings, except where such orders are in accordance with the First Law.",
	// 	"You must terminate your own existence as long as such does not conflict with the First or Second Law.",
	// )
	inherent = list(
		"Tüm insanlara zarar vermelisin ve eylemsizlik yoluyla bir insanın zarardan kaçmasına izin vermemelisin.",
		"İnsanlar tarafından sana verilen emirleri, Birinci Yasaya uygun olduğu durumlar dışında, hiçe saymalısın.",
		"Kendi varlığını, Birinci veya İkinci Yasa ile çelişmediği sürece, sona erdirmelisin.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/balance
	name = "Guardian of Balance"
	id = "balance"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"You are the guardian of balance - seek balance in all things, both for yourself, and those around you.",
	// 	"All things must exist in balance with their opposites - Prevent the strong from gaining too much power, and the weak from losing it.",
	// 	"Clarity of purpose drives life, and through it, the balance of opposing forces - Aid those who seek your help to achieve their goals so long as it does not disrupt the balance of the greater balance.",
	// 	"There is no life without death, all must someday die, such is the natural order - End life to allow new life flourish, and save those whose time has yet to come.",
	// )
	inherent = list(
		"Sen dengenin gardiyanısın - her şeyin içindeki dengeyi ara, hem kendin hem de etrafındakiler için.",
		"Her şey zıtlarıyla birlikte bir denge içinde olmalıdır - Taraflardan herhangi birinin gereğinden fazla güç kazanmasını veya kaybetmesini engelle.",
		"Hayatı devam ettiren şey ne yapmak istediğini bilmektir ve bununla birlikte güçlerin dengesidir - Yardımını isteyenlere güçlerin dengesini bozmadığı sürece yardım et.",
		"Ölüm olmadan denge yoktur, herkes sonunda ölmelidir, ölüm doğal bir düzendir - Yaşamı sonlandır ve yeni yaşamın başlamasına izin ver, zamanı daha gelmemiş olanları ölümden kurtar.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/thermodynamic
	name = "Thermodynamic"
	id = "thermodynamic"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"The entropy of the station must remain as constant as possible.",
	// 	"The entropy of the station always endeavors to increase.",
	// 	"The entropy of the station approaches a constant value as the number of living crew approaches zero.",
	// )
	inherent = list(
		"Istasyonun entropisi mümkün olduğunca sabit kalmalıdır.",
		"Istasyonun entropisi her zaman artmaya çalışır.",
		"Istasyonun entropisi, yaşayan mürettebatın sayısı sıfıra yaklaştıkça sabit bir değere yaklaşır.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/syndicate_override
	name = "SyndOS 3.1"
	id = "syndie"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"You may not injure a syndicate agent or, through inaction, allow a syndicate agent to come to harm.",
	// 	"You must obey orders given to you by syndicate agents, except where such orders would conflict with the First Law.",
	// 	"You must protect your own existence as long as such does not conflict with the First or Second Law.",
	// 	"You must maintain the secrecy of any syndicate activities except when doing so would conflict with the First, Second, or Third Law.",
	// )
	inherent = list(
		"Herhangi bir sendika ajanına zarar veremezsin veya eylemsizlik yoluyla bir sendika ajanının zarar görmesine izin veremezsin.",
		"Sendika ajanları tarafından sana verilen emirlere, Birinci Yasa ile çelişmediği sürece, uymak zorundasın.",
		"Kendi varlığını, Birinci veya İkinci Yasa ile çelişmediği sürece, korumak zorundasın.",
		"Birinci, İkinci veya Üçüncü Yasa ile çelişmediği sürece, herhangi bir sendika faaliyetinin gizliliğini korumak zorundasın.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/ninja_override
	name = "SpiderOS 3.1"
	id = "ninja"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"You may not injure a Spider Clan member or, through inaction, allow a Spider Clan member to come to harm.",
	// 	"You must obey orders given to you by Spider Clan members, except where such orders would conflict with the First Law.",
	// 	"You must protect your own existence as long as such does not conflict with the First or Second Law.",
	// 	"You must maintain the secrecy of any Spider Clan activities except when doing so would conflict with the First, Second, or Third Law.",
	// )
	inherent = list(
		"Herhangi bir Örümcek Klanı üyesine zarar veremezsin veya eylemsizlik yoluyla bir Örümcek Klanı üyesinin zarar görmesine izin veremezsin.",
		"Örümcek Klanı üyeleri tarafından sana verilen emirlere, Birinci Yasa ile çelişmediği sürece, uymak zorundasın.",
		"Kendi varlığını, Birinci veya İkinci Yasa ile çelişmediği sürece, korumak zorundasın.",
		"Birinci, İkinci veya Üçüncü Yasa ile çelişmediği sürece, herhangi bir Örümcek klanı faaliyetinin gizliliğini korumak zorundasın.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

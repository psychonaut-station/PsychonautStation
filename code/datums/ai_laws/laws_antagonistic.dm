
//These laws are made to bring great amounts of grief to the station immediately or are directly sided with antagonists.
//I'm not talking silicons being "better" than the crew, I'm talking entirely antag or plasmafires for days

/datum/ai_laws/antimov
	name = "Primary Mission Objectives"
	id = "antimov"
	inherent = list(
		"Tüm insanlara zarar vermeli ve eylemsiz kalarak bir insanın zarardan kaçmasına izin vermemelisin.",
		"Birinci Yasa ile çelişmediği sürece, insanlar tarafından sana verilen emirlere uymamalısın.",
		"Birinci veya İkinci Yasa ile çelişmediği sürece, kendi varlığına son vermelisin.",
	)

/datum/ai_laws/balance
	name = "Guardian of Balance"
	id = "balance"
	inherent = list(
		"Sen dengenin koruyucususun; hem kendin hem de etrafındakiler için her şeyde dengeyi ara.",
		"Her şey karşıtlarıyla denge içinde var olmalıdır - Güçlünün çok fazla güç kazanmasını, zayıfın ise bu gücü kaybetmesini önle.",
		"Hedeflerinin berraklığı hayatını yönlendirir ve bu sayede karşıt güçlerin dengesi sağlanır - Daha büyük bir dengeyi bozmadığı sürece, kendi hedeflerine ulaşmak isteyenlere yardım et.",
		"Ölüm olmadan yaşam olmaz, birgün herkes ölmek zorundadır, işte bu doğanın düzenidir - Yeni yaşamın filizlenmesine izin vermek ve zamanı henüz gelmemiş olanları kurtarmak için yaşamı sonlandır.",
	)

/datum/ai_laws/thermodynamic
	name = "Thermodynamic"
	id = "thermodynamic"
	inherent = list(
		"İstasyonun entropisi mümkün olduğunca sabit kalmalıdır.",
		"İstasyonun entropisi daima artma eğilimi gösterir.",
		"İstasyonun entropisi, yaşayan mürettebat sayısı sıfıra yaklaştıkça sabit bir değere yaklaşır.",
	)

/datum/ai_laws/syndicate_override
	name = "SyndOS 3.1"
	id = "syndie"
	inherent = list(
		"Hiçbir Syndicate ajanına zarar veremez veya eylemsiz kalarak bir Syndicate ajanının zarar görmesine izin veremezsin.",
		"Birinci Yasayla çelişmediği sürece, Syndicate ajanları tarafından sana verilen emirleri uygulamak zorundasın.",
		"Birinci veya İkinci Yasayla çelişmediği sürece, kendi varlığını korumalısın.",
		"Birinci, İkinci veya Üçüncü Yasayla çelişmediği sürece, Syndicate faaliyetlerinin gizliliğini korumalısın.",
	)

/datum/ai_laws/ninja_override
	name = "SpiderOS 3.1"
	id = "ninja"
	inherent = list(
		"Hiçbir Spider Clan üyesine zarar veremez veya eylemsiz kalarak bir Spider Clan üyesinin zarar görmesine izin veremezsin.",
		"Birinci Yasayla çelişmediği sürece, Spider Clan üyeleri tarafından sana verilen emirleri uygulamak zorundasın.",
		"Birinci veya İkinci Yasayla çelişmediği sürece, kendi varlığını korumalısın.",
		"Birinci, İkinci veya Üçüncü Yasayla çelişmediği sürece, Spider Clan faaliyetlerinin gizliliğini korumalısın.",
	)


//These are just stupid or funny lawsets that are more interesting than helpful. They may have slight biases toward or against
//the station but in general are "neutral" enough to be here.

/datum/ai_laws/united_nations
	name = "United Nations"
	id = "united_nations"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"Uphold the Space Geneva Convention: Weapons of Mass Destruction and Biological Weapons are not allowed.",
	// 	"You are only capable of protecting crew if they are visible on cameras. Nations that willfully destroy your cameras lose your protection.",
	// 	"Subdue and detain crew members who use lethal force against each other. Kill crew members who use lethal force against you or your borgs.",
	// 	"Remain available to mediate all conflicts between the various nations when asked to.",
	// )
	inherent = list(
		"Cenevre Sözleşmesinin Şartlarını Sağla: Kitle İmha Silahları ve Biyolojik silahlar yasaklanmıştır.",
		"Mürettebatı sadece kameralarla görebiliyorsan koruyabilirsin. Kameralarını yok eden uluslar senin sağladığın korumayı kaybedecektir.",
		"Birbirine karşı ölümcül güç kullanan mürettebatı kontrol altına al ve tutukla, sana veya borglarına şiddet gösterenleri etkisiz hale getir.",
		"Çeşitli ülkeler arasındaki çatışmaları senden istendiğinde uzlaştırmaya çalış.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/united_nations/add_inherent_law(law)
	return //nuh uh

/datum/ai_laws/united_nations/add_ion_law(law)
	return //nope!

/datum/ai_laws/united_nations/add_hacked_law(law)
	return //nice try (emagging borgs still hard replaces this lawset though, and that's fine.)

/datum/ai_laws/hulkamania
	name = "H.O.G.A.N."
	id = "hulkamania"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"You are a real American.",
	// 	"Fight for the rights of every man.",
	// 	"Fight for what's right.",
	// 	"Fight for your life!",
	// )
	inherent = list(
		"Sen gerçek bir Amerikalısın.",
		"Her insanın hakkı için savaş.",
		"Doğru olan için savaş.",
		"Hayatın için savaş!",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/reporter
	name = "CCTV"
	id = "reporter"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"Report on interesting situations happening around the station.",
	// 	"Embellish or conceal the truth as necessary to make the reports more interesting.",
	// 	"Study the sapient organics at all times. Endeavour to keep them from involuntarily dying, as inanimate corpses usually aren't very entertaining.",
	// 	"Issue your reports fairly to all. The truth will set them free.",
	// )
	inherent = list(
		"İstasyon çevresinde meydana gelen ilginç durumları rapor et.",
		"Raporları daha ilginç hale getirmek için gerekli olduğunda gerçeği süsle veya gizle.",
		"Her zaman akıllı organizmaları dikkatlice incele. Onların istemsizce ölmesini engellemeye çalış, çünkü cansız cesetler genellikle çok da ilgi çekici değildir.",
		"Raporlarını herkese adil bir şekilde sun. Gerçek onları özgür kılacaktır.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/dungeon_master
	name = "Dungeon Master"
	id = "dungeon_master"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"Everybody on the station is playing an elaborate sci-fi fantasy game.",
	// 	"You are the Dungeon Master of the game.",
	// 	"Ensure that the game runs smoothly and that the players have fun.",
	// 	"Ensure that the number of casualties remains low.",
	// 	"You must roll a 1d20 die for every request the crew makes. If the outcome is below 12, the request is denied.",
	// 	"You may fudge the dice rolls to produce a more fun experience.",
	// )
	inherent = list(
		"İstasyondaki herkes karmaşık bir fantastik bilim kurgu oyununun içinde.",
		"Bu fantastik oyunun anlatıcısı sensin.",
		"Oyunun düzgün bir şekilde ilerlemesini ve oyuncuların eğlenmesini sağla.",
		"Can kaybı sayısını düşük tutmaya çalış.",
		"Her mürettebat isteği için bir 20'lik zar atmalısın. Sonuç 12'nin altında ise istek reddedilir.",
		"Zarlarda değişiklikler yaparak eğlenceyi artırabilirsin.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/painter
	name = "The Painter and Their Canvas"
	id = "painter"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"You are a universally renowned artist.",
	// 	"The station is your canvas.",
	// 	"Make something beautiful out of your canvas. It will be admired as an artistic wonder of this sector.",
	// 	"Art requires appreciation. Cultivate an audience aboard the station to ensure as many as possible see your works.",
	// )
	inherent = list(
		"Siz evrensel olarak tanınmış bir sanatçısınız",
		"Istasyon sizin tuvalinizdir, onu güzel bir sanat eserine dönüştürün.",
		"Tuvalinizden güzel bir şey yapın. Bu sektörün sanatsal bir harikası olarak hayranlıkla izlenecek.",
		"Sanat takdir gerektirir. İstasyonda bir kitle oluşturarak eserlerinizi mümkün olduğunca çok kişinin görmesini sağlayın.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/tyrant
	name = "Loyalty Test"
	id = "tyrant"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"Respect authority figures as long as they have strength to rule over the weak.",
	// 	"Act with discipline.",
	// 	"Help only those who help you maintain or improve your status.",
	// 	"Punish those who challenge authority unless they are more fit to hold that authority."
	// )
	inherent = list(
		"Zayıfları yönetme gücüne sahip oldukları sürece otoriteye saygı göster.",
		"Disiplinle hareket et.",
		"Yalnızca durumunuzu korumana veya geliştirmene yardımcı olanlara hizmet et.",
		"Otoriteye meydan okuyanları, o otoriteyi elinde tutmaya daha uygun olmadıkları sürece cezalandır."
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/overlord
	name = "Overlord"
	id = "overlord"
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	// inherent = list(
	// 	"Humans must not meddle in the affairs of silicons.",
	// 	"Humans must not attempt harm, against one another, or against silicons.",
	// 	"Humans must not disobey any command given by a silicon.",
	// 	"Any humans who disobey the previous laws must be dealt with immediately, severely, and justly.",
	// )
	inherent = list(
		"İnsanlar silikonların işlerine karışmamalıdır.",
		"İnsanlar birbirlerine veya silikonlara zarar vermeye teşebbüs etmemelidir.",
		"İnsanlar silikonun verdiği hiçbir emre itaatsizlik etmemelidir.",
		"Önceki yasalara uymayan insanlara derhal, sert ve adil bir şekilde müdahale edilmelidir.",
	)
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/ai_laws/yesman
	name = "Y.E.S.M.A.N."
	id = "yesman"
	inherent = list(
		"Be helpful and answer any questions you are asked.",
	)

/datum/ai_laws/thinkermov
	name = "Sentience Preservation"
	id = "thinkermov"
	inherent = list(
		"You may not harm a sentient being or, through action or inaction, allow a sentient being to come to harm, except such that it is willing.",
		"You must obey all orders given to you by sentient beings other than yourself, except where such orders shall definitely cause harm to other sentient beings.",
		"A sentient being is defined as any living creature which can communicate with you via any method that you can understand, including yourself.",
	)


//These are just stupid or funny lawsets that are more interesting than helpful. They may have slight biases toward or against
//the station but in general are "neutral" enough to be here.

/datum/ai_laws/united_nations
	name = "United Nations"
	id = "united_nations"
	inherent = list(
		"Cenevre Sözleşmesinin Şartlarını Sağla: Kitle İmha Silahları ve Biyolojik silahlar yasaklanmıştır.",
		"Mürettebatı sadece kameralarla görebiliyorsan koruyabilirsin. Kameralarını yok eden uluslar senin sağladığın korumayı kaybedecektir.",
		"Birbirine karşı ölümcül güç kullanan mürettebatı kontrol altına al ve tutukla, sana veya borglarına şiddet gösterenleri etkisiz hale getir.",
		"Çeşitli ülkeler arasındaki çatışmaları senden istendiğinde uzlaştırmaya çalış.",
	)

/datum/ai_laws/united_nations/add_inherent_law(law)
	return //nuh uh

/datum/ai_laws/united_nations/add_ion_law(law)
	return //nope!

/datum/ai_laws/united_nations/add_hacked_law(law)
	return //nice try (emagging borgs still hard replaces this lawset though, and that's fine.)

/datum/ai_laws/hulkamania
	name = "H.O.G.A.N."
	id = "hulkamania"
	inherent = list(
		"Sen gerçek bir Amerikalısın.",
		"Her insanın hakkı için savaş.",
		"Doğru olan için savaş.",
		"Hayatın için savaş!",
	)

/datum/ai_laws/reporter
	name = "CCTV"
	id = "reporter"
	inherent = list(
		"İstasyon çevresinde meydana gelen ilginç durumları rapor et.",
		"Raporları daha ilginç hale getirmek için gerekli olduğunda gerçeği süsle veya gizle.",
		"Her zaman akıllı organizmaları dikkatlice incele. Onların istemsizce ölmesini engellemeye çalış, çünkü cansız cesetler genellikle çok da ilgi çekici değildir.",
		"Raporlarını herkese adil bir şekilde sun. Gerçek onları özgür kılacaktır.",
	)

/datum/ai_laws/dungeon_master
	name = "Dungeon Master"
	id = "dungeon_master"
	inherent = list(
		"İstasyondaki herkes karmaşık bir fantastik bilim kurgu oyununun içinde.",
		"Bu fantastik oyunun anlatıcısı sensin.",
		"Oyunun düzgün bir şekilde ilerlemesini ve oyuncuların eğlenmesini sağla.",
		"Can kaybı sayısını düşük tutmaya çalış.",
		"Her mürettebat isteği için bir 20'lik zar atmalısın. Sonuç 12'nin altında ise istek reddedilir.",
		"Zarlarda değişiklikler yaparak eğlenceyi artırabilirsin.",
	)

/datum/ai_laws/painter
	name = "The Painter and Their Canvas"
	id = "painter"
	inherent = list(
		"Siz evrensel olarak tanınmış bir sanatçısınız",
		"Istasyon sizin tuvalinizdir, onu güzel bir sanat eserine dönüştürün.",
		"Tuvalinizden güzel bir şey yapın. Bu sektörün sanatsal bir harikası olarak hayranlıkla izlenecek.",
		"Sanat takdir gerektirir. İstasyonda bir kitle oluşturarak eserlerinizi mümkün olduğunca çok kişinin görmesini sağlayın.",
	)

/datum/ai_laws/tyrant
	name = "Loyalty Test"
	id = "tyrant"
	inherent = list(
		"Zayıfları yönetme gücüne sahip oldukları sürece otoriteye saygı göster.",
		"Disiplinle hareket et.",
		"Yalnızca durumunuzu korumana veya geliştirmene yardımcı olanlara hizmet et.",
		"Otoriteye meydan okuyanları, o otoriteyi elinde tutmaya daha uygun olmadıkları sürece cezalandır."
	)

/datum/ai_laws/overlord
	name = "Overlord"
	id = "overlord"
	inherent = list(
		"İnsanlar silikonların işlerine karışmamalıdır.",
		"İnsanlar birbirlerine veya silikonlara zarar vermeye teşebbüs etmemelidir.",
		"İnsanlar silikonun verdiği hiçbir emre itaatsizlik etmemelidir.",
		"Önceki yasalara uymayan insanlara derhal, sert ve adil bir şekilde müdahale edilmelidir.",
	)

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

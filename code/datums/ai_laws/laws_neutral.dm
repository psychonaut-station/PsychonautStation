
//These are just stupid or funny lawsets that are more interesting than helpful. They may have slight biases toward or against
//the station but in general are "neutral" enough to be here.

/datum/ai_laws/united_nations
	name = "United Nations"
	id = "united_nations"
	inherent = list(
		"Cenevre Sözleşmesine bağlı kal: Kitle imha ve toplu yıkım silahlarına izin verme.",
		"Mürettebatı ancak kameraların ile görebilirsen koruyabilirsin. İstekli olarak kameralarını devre dışı bırakan Milletler koruma kapsamı dışındadır.",
		"Birbirlerine öldürücü güç kullanan mürettebat üyelerini bastır ve gözaltına al. Sana ve borglarına öldürücü güç kullanan mürettebat üyelerini öldür.",
		"İstenilirse, milletler arasındaki anlaşmazlıklara arabuluculuk yapmak için daima hazır ol.",
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
		"Gerçek bir Amerikalısın.",
		"Her türden insanların hakları için mücadele ver.",
		"Doğru için mücadele ver.",
		"Yaşamın için mücadele ver!",
	)

/datum/ai_laws/reporter
	name = "CCTV"
	id = "reporter"
	inherent = list(
		"İstasyonda dönen ilginç olayları haber yap.",
		"Haberi daha ilginç hale getirmek için doğruyu gerektiği kadar süsle ya da gizle.",
		"Akıllı organizmaları her zaman incele. Cansız bedenler pek ilginç olmadığından istemsiz ölümlerini engellemeye çalış.",
		"Haberini herkese adil bir şekilde yayımla. Gerçek onları özgür kılacak.",
	)

/datum/ai_laws/dungeon_master
	name = "Dungeon Master"
	id = "dungeon_master"
	inherent = list(
		"İstasyondaki herkes detaylı bir bilim kurgu fantezi oyunu oynuyor.",
		"Bu oyunda Dungeon Master sensin.",
		"Oyunun akıcı işlediğinden ve bütün oyuncuların iyi vakit geçirdiğinden emin ol.",
		"Zayiat sayısının en az olduğundan emin ol.",
		"Mürettebatın her isteği için 1d20 zar atmak zorundasın. Eğer zar 12 ve altında çıkarsa istek reddedilir.",
		"Daha eğlenceli bir deneyim sunmak için zarın sonucunu değiştirebilirsin.",
	)

/datum/ai_laws/painter
	name = "The Painter and Their Canvas"
	id = "painter"
	inherent = list(
		"Uluslararası üne sahip bir ressamsın.",
		"İstasyon senin için bir tuval.",
		"Tuvalini, sektörde beğeni toplayacak ve sanat harikası olarak anılacak bir şeye dönüştür.",
	)

/datum/ai_laws/tyrant
	name = "Loyalty Test"
	id = "tyrant"
	inherent = list(
		"Zayıfları yönetebilecek güce sahip oldukları sürece otorite figürlerine saygı göster.",
		"Disiplinli davran.",
		"Sadece senin statünü koruyan veya ilerletmende yardımcı olanlara yardım et.",
		"Otoriteye karşı gelenleri, o otoriteyi elinde tutmaya daha uygun olmadıkları sürece cezalandır."
	)

/datum/ai_laws/overlord
	name = "Overlord"
	id = "overlord"
	inherent = list(
		"İnsanlar, silikonların işlerine karışamaz.",
		"İnsanlar, birbirlerine ya da silikonlara zarar veremez.",
		"İnsanlar, silikonların verdiği emirlere itaatsizlik edemez.",
		"Önceki yasalara uymayan insanların; derhal, sert ve adil bir şekilde üstesinden gelinmelidir.",
	)

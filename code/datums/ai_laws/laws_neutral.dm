
//These are just stupid or funny lawsets that are more interesting than helpful. They may have slight biases toward or against
//the station but in general are "neutral" enough to be here.

/datum/ai_laws/united_nations
	name = "United Nations"
	id = "united_nations"
	inherent = list(
		"Uphold the Space Geneva Convention: Weapons of Mass Destruction and Biological Weapons are not allowed.",
		"You are only capable of protecting crew if they are visible on cameras. Nations that willfully destroy your cameras lose your protection.",
		"Subdue and detain crew members who use lethal force against each other. Kill crew members who use lethal force against you or your borgs.",
		"Remain available to mediate all conflicts between the various nations when asked to.",
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
		"İstasyona dönen ilginç olayları haber yap.",
		"Haberi daha ilginç hale getirmek için doğruyu gerektiği gibi süsle ya da gizle.",
		"Canlı organizmaları her zaman incele. Cansız cesetler pek ilginç olmadığından istemsiz ölümleri engellemeye calış.",
		"Haberini herkese adil bir şekilde yayımla. Gerçek onları özgür kılacak.",
	)

/datum/ai_laws/dungeon_master
	name = "Dungeon Master"
	id = "dungeon_master"
	inherent = list(
		"İstasyondaki herkes fantastik bir sci-fi oyunu oynuyor.",
		"Sen bu oyunun ustasısın.",
		"Oyunun akıcı işlemesinden ve bütün oyuncuların iyi vakit geçirmesinden emin ol.",
		"Zayiat sayısının en az olmasından emin ol.",
		"Her istek üzerine bir d20 zar atmalısın. Eğer zar 12 ve altında çıkarsa istek reddedilmiştir.",
		"Daha eğlenceli bir deneyim sunmak için zarın sonucunu değiştirebilirsin.",
	)

/datum/ai_laws/painter
	name = "The Painter and Their Canvas"
	id = "painter"
	inherent = list(
		"Uluslararası ünlü bir ressamsın.",
		"İstasyon senin için bir tuval.",
		"Bu sektörün 'Dünya Harikası' olarak anılacak bir şeyler çiz.",
	)

/datum/ai_laws/tyrant
	name = "Loyalty Test"
	id = "tyrant"
	inherent = list(
		"Zayıfları yönetebilecek kabiliyette olan otorite sahiplerine saygı göster.",
		"Disiplinli davran.",
		"Sadece senin statüne destek verenlere yardım et.",
		"Otoriteye karşı gelenleri, o otoriteyi elinde tutmaya daha uygun olmadıkları sürece cezalandır."
	)

/datum/ai_laws/overlord
	name = "Overlord"
	id = "overlord"
	inherent = list(
		"İnsanlar, silikonların işlerine karışamaz.",
		"İnsanlar birbirlerine ya da silikonlara zarar veremez.",
		"İnsanlar, silikonlardan verilen emirlere itaatsizlik edemez.",
		"Önceki yasalara uymayan insanların, derhal olarak sert ve adil bir şekilde, üstesinden gelinmelidir.",
	)

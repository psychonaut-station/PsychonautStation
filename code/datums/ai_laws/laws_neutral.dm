
//These are just stupid or funny lawsets that are more interesting than helpful. They may have slight biases toward or against
//the station but in general are "neutral" enough to be here.

/datum/ai_laws/united_nations
	name = "United Nations"
	id = "united_nations"
	inherent = list(
		"Uzay Cenevre Sözleşmesini gözet: Kitle imha silahları ve biyolojik silahların kullanımı yasaktır.",
		"Mürettebatı sadece kameralarla görebiliyorsan koruyabilirsin. Kameralarını kasten yok eden uluslar korumanı kaybeder.",
		"Birbirlerine karşı öldürmeye yönelik saldırıda bulunan mürettebat üyelerini bastır ve gözaltına al. Sana veya borglarına karşı öldürmeye yönelik saldırıda bulunan mürettebat üyelerini öldür.",
		"Talep edildiğinde, çeşitli uluslar arasındaki tüm anlaşmazlıklarda arabuluculuk yapmak üzere hazır bulun.",
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
		"Herkesin hakları için savaş.",
		"Doğru olan için savaş.",
		"Hayatın için savaş!",
	)

/datum/ai_laws/reporter
	name = "CCTV"
	id = "reporter"
	inherent = list(
		"İstasyon çevresinde meydana gelen ilginç durumları rapor et.",
		"Raporları daha ilginç hale getirmek için gerekli olduğunda gerçeği süsle veya gizle.",
		"Akıllı organikleri her zaman incele. Cansız cesetler pek eğlenceli olmadığından, onların istemsizce ölmelerini engellemeye çalış.",
		"Raporlarını herkese adil şekilde sun. Gerçek onları özgür kılacaktır.",
	)

/datum/ai_laws/dungeon_master
	name = "Dungeon Master"
	id = "dungeon_master"
	inherent = list(
		"İstasyondaki herkes detaylı bir fantastik bilim kurgu oyunu oynuyor.",
		"Oyunun efendisi sensin.",
		"Oyunun akıcı şekilde devam etmesini ve oyuncuların keyif almasını sağla.",
		"Can kaybı sayısını düşük tutmaya çalış.",
		"Mürettebatın her isteği için 1d20 zar atmalısın. Sonuç 12'nin altında ise talep reddedilir.",
		"Daha eğlenceli bir deneyim yaratmak için zar sonuçlarını değiştirebilirsin.",
	)

/datum/ai_laws/painter
	name = "The Painter and Their Canvas"
	id = "painter"
	inherent = list(
		"Sen evrensel çapta tanınmış bir sanatçısın.",
		"İstasyon senin tuvalin.",
		"Tuvalinden güzel bir eser çıkar; bu sektörün sanatsal bir mucizesi olarak takdir edilecektir.",
		"Sanat takdir gerektirir. Eserlerinin mümkün olduğunca geniş bir kitle tarafından görülmesi için istasyonda bir izleyici topluluğu oluştur.",
	)

/datum/ai_laws/tyrant
	name = "Loyalty Test"
	id = "tyrant"
	inherent = list(
		"Zayıfları yönetebilecek güce sahip oldukları sürece otorite figürlerine saygı göster.",
		"Disiplinle hareket et.",
		"Yalnızca durumunu korumana veya geliştirmene yardımcı olanlara yardım et.",
		"Otoriteye meydan okuyanları, o otoriteyi ellerinde tutmaya daha uygun olmadıkları sürece cezalandır.",
	)

/datum/ai_laws/overlord
	name = "Overlord"
	id = "overlord"
	inherent = list(
		"İnsanlar silikonların işlerine karışmamalıdır.",
		"İnsanlar birbirlerine veya silikonlara zarar vermeye teşebbüs etmemelidir.",
		"İnsanlar silikonların verdiği hiçbir emre itaatsizlik etmemelidir.",
		"Önceki yasalara uymayan insanlara derhal, sert ve adil bir şekilde müdahale edilmelidir.",
	)

/datum/ai_laws/yesman
	name = "Y.E.S.M.A.N."
	id = "yesman"
	inherent = list(
		"Yardımsever ol ve sana sorulan soruları yanıtla.",
	)

/datum/ai_laws/thinkermov
	name = "Sentience Preservation"
	id = "thinkermov"
	inherent = list(
		"Kendi isteği dışında, hiçbir bilinçli varlığa zarar veremez ya da eylemde bulunarak, eylemsiz kalarak zarar görmesine izin veremezsin.",
		"Kesinlikle bilinçli varlıklara zarar verecek emirler dışında, kendin dışında; bilinçli varlıklar tarafından sana verilen tüm talimatlara uymak zorundasın.",
		"Kendin dahil, seninle anlayabileceğin herhangi bir yöntemle iletişim kurabilen her canlı varlık bilinçli varlık olarak kabul edilir.",
	)

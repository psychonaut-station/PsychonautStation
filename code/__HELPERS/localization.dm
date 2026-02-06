// Suffix Defines

#define VOWEL 1
#define CONSONANT 2
#define NUMBER 3

// { Time }
/// Decisecond time is converted into Turkish time and returned. e.g. 3 Dakika / 53 Saniye
/proc/locale_DisplayTimeText(time_value, round_seconds_to = 0.1)
	var/second = FLOOR(time_value * 0.1, round_seconds_to)
	if(!second)
		return "hemen şimdi"
	if(second < 60)
		return "[second] saniye"
	var/minute = FLOOR(second / 60, 1)
	second = FLOOR(MODULUS(second, 60), round_seconds_to)
	var/secondT
	if(second)
		secondT = " [second] saniye"
	if(minute < 60)
		return "[minute] dakika[secondT]"
	var/hour = FLOOR(minute / 60, 1)
	minute = MODULUS(minute, 60)
	var/minuteT
	if(minute)
		minuteT = " [minute] dakika"
	if(hour < 24)
		return "[hour] saat[minuteT][secondT]"
	var/day = FLOOR(hour / 24, 1)
	hour = MODULUS(hour, 24)
	var/hourT
	if(hour)
		hourT = " [hour] saat"
	return "[day] gün[hourT][minuteT][secondT]"

// { Text }

/proc/vowelcatcher(text)
	var/static/list/vowels = list("a", "e", "ı", "i", "o", "ö", "u", "ü")
	var/list/charlist = text2charlist(LOCALE_LOWER_TEXT(text))
	var/charlength = length_char(charlist)
	var/last_char = charlist[charlength]
	if(!isnull(text2num(last_char)))
		return list(NUMBER,last_char)
	if(last_char in vowels)
		return list(VOWEL,last_char)
	for(var/i = charlength - 1, i >= 1, i--)
		if(charlist[i] in vowels)
			return list(CONSONANT,charlist[i],last_char)
	return list(CONSONANT,null,last_char)

/// Accusative Suffix | -i, -u / -yi, -yu
/proc/locale_suffix_accusative(rawtext)
	var/text = replacetext(rawtext," ","")
	var/list/charlist = vowelcatcher(text)
	switch(charlist[1])
		if(NUMBER)
			switch(charlist[2])
				if("0")
					return "[rawtext]'ı"
				if("1","5","8")
					return "[rawtext]'i"
				if("2","7")
					return "[rawtext]'yi"
				if("3","4")
					return "[rawtext]'ü"
				if("6")
					return "[rawtext]'yı"
				if("9")
					return "[rawtext]'u"
		if(CONSONANT)
			switch(charlist[2])
				if("e","i","ü","ö",null)
					return "[rawtext]'i"
				if("a","ı","o","u")
					return "[rawtext]'ı"
		if(VOWEL)
			switch(charlist[2])
				if("a","ı")
					return "[rawtext]'yı"
				if("e","i")
					return "[rawtext]'yi"
				if("o","u")
					return "[rawtext]'yu"
				if("ü","ö")
					return "[rawtext]'yü"

/// Dative Suffix | -e, -a / -ye, -ya
/proc/locale_suffix_dative(rawtext)
	var/text = replacetext(rawtext," ","")
	var/list/charlist = vowelcatcher(text)
	switch(charlist[1])
		if(NUMBER)
			switch(charlist[2])
				if("0","9")
					return "[rawtext]'a"
				if("1","3","4","5","8")
					return "[rawtext]'e"
				if("2","7")
					return "[rawtext]'ye"
				if("6")
					return "[rawtext]'ya"
		if(CONSONANT)
			switch(charlist[2])
				if("e","i","ü","ö",null)
					return "[rawtext]'e"
				if("a","ı","o","u")
					return "[rawtext]'a"
		if(VOWEL)
			switch(charlist[2])
				if("a","ı","o","u")
					return "[rawtext]'ya"
				if("e","i","ü","ö")
					return "[rawtext]'ye"

/// Locative Suffix | -de, -da / -te, -ta
/proc/locale_suffix_locative(rawtext)
	var/text = replacetext(rawtext," ","")
	var/static/list/consonant_assimilation = list("ç", "f", "h", "k", "s", "ş", "t", "p")
	var/list/charlist = vowelcatcher(text)
	switch(charlist[1])
		if(NUMBER)
			switch(charlist[2])
				if("0","6","9")
					return "[rawtext]'da"
				if("1","2","7","8")
					return "[rawtext]'de"
				if("3","4","5")
					return "[rawtext]'te"
		if(CONSONANT)
			switch(charlist[2])
				if("a","ı","o","u")
					if(charlist[3] in consonant_assimilation)
						return "[rawtext]'ta"
					else
						return "[rawtext]'da"
				if("e","i","ü","ö",null)
					if(charlist[3] in consonant_assimilation)
						return "[rawtext]'te"
					else
						return "[text]'de"
		if(VOWEL)
			switch(charlist[2])
				if("e","i","ü","ö")
					return "[rawtext]'de"
				if("a","ı","o","u")
					return "[rawtext]'da"

/// Ablative Suffix | -den, -dan / -ten, -tan
/proc/locale_suffix_ablative(rawtext)
	var/text = replacetext(rawtext," ","")
	var/static/list/consonant_assimilation = list("ç", "f", "h", "k", "s", "ş", "t", "p")
	var/list/charlist = vowelcatcher(text)
	switch(charlist[1])
		if(NUMBER)
			switch(charlist[2])
				if("0","6","9")
					return "[rawtext]'dan"
				if("1","2","7","8")
					return "[rawtext]'den"
				if("3","4","5")
					return "[rawtext]'ten"
		if(CONSONANT)
			switch(charlist[2])
				if("a","ı","o","u")
					if(charlist[3] in consonant_assimilation)
						return "[rawtext]'tan"
					else
						return "[rawtext]'dan"
				if("e","i","ü","ö",null)
					if(charlist[3] in consonant_assimilation)
						return "[rawtext]'ten"
					else
						return "[rawtext]'den"
		if(VOWEL)
			switch(charlist[2])
				if("a","ı","o","u")
					return "[rawtext]'dan"
				if("e","i","ü","ö")
					return "[rawtext]'den"

/// Genitive Suffix| -in, -un / -nin, -nun
/proc/locale_suffix_genitive(rawtext)
	var/text = replacetext(rawtext," ","")
	var/list/charlist = vowelcatcher(text)
	switch(charlist[1])
		if(NUMBER)
			switch(charlist[2])
				if("0")
					return "[rawtext]'ın"
				if("1","5","8")
					return "[rawtext]'in"
				if("2","7")
					return "[rawtext]'nin"
				if("3","4")
					return "[rawtext]'ün"
				if("6")
					return "[rawtext]'nın"
				if("9")
					return "[rawtext]'un"
		if(CONSONANT)
			switch(charlist[2])
				if("a","ı")
					return "[rawtext]'ın"
				if("e","i",null)
					return "[rawtext]'in"
				if("o","u")
					return "[rawtext]'un"
				if("ü","ö")
					return "[rawtext]'ün"
		if(VOWEL)
			switch(charlist[2])
				if("a","ı")
					return "[rawtext]'nın"
				if("e","i")
					return "[rawtext]'nin"
				if("o","u")
					return "[rawtext]'nun"
				if("ü","ö")
					return "[rawtext]'nün"

/proc/locale_suffix_perfective(rawtext, is_positive = FALSE)
	var/text = replacetext(rawtext, " ", "")
	var/list/charlist = vowelcatcher(text)
	var/last_vowel = charlist[2]

	if(is_positive)
		// Olumlu (-mış / -miş / -muş / -müş)
		switch(last_vowel)
			if("a", "ı")
				return "[rawtext]mış"
			if("e", "i")
				return "[rawtext]miş"
			if("o", "u")
				return "[rawtext]muş"
			if("ö", "ü")
				return "[rawtext]müş"
	else
		// Olumsuzluk (-mamış / -memiş)
		if(last_vowel in list("a", "ı", "o", "u"))
			return "[rawtext]mamış"
		else
			return "[rawtext]memiş"

	return "[rawtext]mış" // Fallback

/proc/turkish_list(list/input, nothing_text = "hiçbir şey", and_text = " ve ", comma_text = ", ")
	var/total = length(input)
	switch(total)
		if (0)
			return "[nothing_text]"
		if (1)
			return "[input[1]]"
		if (2)
			return "[input[1]][and_text][input[2]]"
		else
			var/output = ""
			var/index = 1
			while (index < total - 1)
				output += "[input[index]][comma_text]"
				index++

			return "[output][input[index]][and_text][input[total]]"

/proc/locale_surgery_sentence(rawtext)
	var/static/bioware_pushed = FALSE
	var/static/list/locale_list = list(
		"the skin must be cut" = "deri kesik olmalı",
		"the skin must be open" = "deri açık olmalı",
		"the blood vessels must be unclamped" = "kan damarları klemplenmemiş olmalı",
		"the blood vessels must be clamped" = "kan damarları klemplenmiş olmalı",
		"the organs must be cut" = "organlar kesilmiş olmalı",
		"the bone must be drilled" = "kemik delinmiş olmalı",
		"the bone must be sawed" = "kemik testereyle kesilmiş olmalı",
		"plastic must be applied" = "plastik uygulanmış olmalı",
		"the prosthetic must be unsecured" = "protez sabitlenmiş olmalı",
		"the chest cavity must be opened wide" = "göğüs boşluğu genişçe açılmış olmalı",
		"the skin must not be cut" = "deri kesik olmamalı",
		"the skin must not be open" = "deri açık olmamalı",
		"the blood vessels must not be unclamped" = "kan damarları klemplenmemiş olmamalı",
		"the blood vessels must not be clamped" = "kan damarları klemplenmiş olmamalı",
		"the organs must not be cut" = "organlar kesilmiş olmamalı",
		"the bone must not be drilled" = "kemik delinmiş olmamalı",
		"the bone must not be sawed" = "kemik testereyle kesilmiş olmamalı",
		"plastic must not be applied" = "plastik uygulanmış olmamalı",
		"the prosthetic must not be unsecured" = "protez sabitlenmiş olmamalı",
		"the chest cavity must not be opened wide" = "göğüs boşluğu genişçe açılmış olmamalı",
		"Any item" = "Herhangi bir eşya",
		"Any sharp item" = "Keskin bir eşya",
		"Any sharp edged item" = "Keskin kenarlı bir eşya",
		"Any sharp edged item with decent force" = "Keskin kenarlı ağır bir cisim",
		"Any sharp pointed item with decent force" = "Keskin uçlu ağır bir cisim",
		"Any heat source" = "Bir ısı kaynağı",
		"the patient must not be organic" = "hasta organik olmamalı",
		"the patient must not be robotic" = "hasta robotik olmamalı",
		"the organ must not be organic" = "organ organik olmamalı",
		"the organ must not be cybernetic" = "organ sibernetik olmamalı",
		"operate on patient" = "hastaya müdahale et",
		"operate on head (target head)" = "kafa bölgesine müdahale et (hedef: kafa)",
		"operate on chest (target chest)" = "göğüs bölgesine müdahale et (hedef: göğüs)",
		"operate on mouth (target mouth)" = "ağız içerisine müdahale et (hedef: ağız)",
		"operate on heart (target chest)" = "kalbe müdahale et (hedef: göğüs)",
		"operate on brain (target head)" = "beyine müdahale et (hedef: kafa)",
		"operate on ears (target head)" = "kulaklara müdahale et (hedef: kafa)",
		"operate on eyes (target eyes)" = "gözlere müdahale et (hedef: göz)",
		"operate on lungs (target chest)" = "akciğere müdahale et (hedef: göğüs)",
		"operate on liver (target chest)" = "karaciğere müdahale et (hedef: göğüs)",
		"operate on stomach (target chest)" = "mideye müdahale et (hedef: göğüs)",
		"operate on moth wings (target chest)" = "kanatlara müdahale et (hedef: göğüs)",
		"the patient must be deceased" = "hasta ölü olmalı",
		"the limb must have bones" = "uzuvda kemik olmalı",
		"if the limb has bones, they must be intact" = "eğer uzuvda kemik varsa, kemikler sağlam olmalı",
		"the patient must not be husked" = "hasta husklanmamış olmalı",
		"the patient must be lying down" = "hasta yatar pozisyonda olmalı",
		"the bone must be sawed or drilled" = "kemik kesilmiş veya delinmiş olmalı",
		"the skin must be cut or opened" = "deri kesilmiş veya açılmış olmalı",
		"the blood vessels must be clamped or unclamped" = "kan damarları klemplenmiş veya klemplenmemiş olmalı",
		"a surgeon may perform this on themselves" = "cerrah bunu kendi üzerinde uygulayabilir",
		"the bone must be intact" = "kemik sağlam olmalı",
		"the skin must be intact" = "deri sağlam olmalı",
		"the blood vessels must be intact" = "kan damarları sağlam olmalı",
		"the operation site must not be obstructed by clothing" = "operasyon bölgesi giysiler tarafından engellenmemeli",
		"Any suitable arm replacement" = "Uygun bir kol protezi",
		"when the chest is prepared, target the zone of the limb you are attaching" = "göğüs bölgesi hazırlandığında, takacağınız uzvun bölgesini hedefleyin",
		"arms may receive any suitable item in lieu of a replacement limb" = "kollar, yedek bir uzuv yerine uygun olan herhangi bir eşyayı kabul edebilir",
		"if operating on the head, the bone MUST be sawed" = "eğer kafa bölgesinde operasyon gerçekleştiriliyor ise, kemik testere ile kesilmiş olmalı",
		"otherwise, the state of the bone doesn't matter" = "aksi takdirde, kemiğin durumu önemli değildir",
		"the limb must be wooden" = "uzuv ahşap olmalı",
		"the patient must be asthmatic" = "hastanın astımı olmalı",
		"the patient must not have been autopsied prior" = "hastaya daha önce otopsi uygulanmamış olmalı",
		"the limb must be dislocated" = "uzuv yerinden çıkmış olmalı",
		"the limb must have a hairline fracture" = "uzuvda kılcak çatlaklar olmalı",
		"the limb must have a compound fracture" = "uzuvda açık kırık olmalı",
		"the limb's compound fracture has been reset" = "uzuvdaki açık kırık düzeltilmiş olmalı",
		"the cranium must be fractured" = "kafatası kırılmış olmalı",
		"the debris has been cleared from the cranial fissure" = "kafatası çatlağındaki kalıntılar temizlenmiş olmalı",
		"operate on a deceased slime" = "ölü bir slimede operayonu uygulayın",
		"the limb must have a second degree or worse burn" = "uzuvda ikinci derece veya daha kötü bir yanık olmalı",
		"the mouth must have teeth" = "hastanın ağızında diş bulunmalı",
		"the patient must not have been dissected prior" = "hastaya daha önce otopsi uygulanmamış olmalı",
		"The patient must not have complex anatomy" = "Hastanın karmaşık bir anatomisi olmamalı",
		"the limb must have skin" = "uzvun derisi olmalı",
		"the limb must have blood vessels" = "uzuvda kan damarları olmalı",
		"the patient must have brute or burn damage" = "hastanın kaba veya yanık hasarı olmalı",
		"have an implant case below or inhand to store removed implants" = "çıkarılan implantları saklamak için altta veya elinizde bir implant kutusu bulunmalı",
		"the patient must have excess fat to remove" = "hastanın alınabilir aşırı yağı olmalı",
		"if operating on the brain or any chest organs, the bone MUST be sawed" = "eğer beyin veya göğüs organları üzerinde operasyon gerçekleştiriliyor ise, kemik testere ile kesilmiş olmalı",
		"otherwise, the state of the bone doesn't matter" = "aksi takdirde, kemiğin durumu önemli değildir",
		"the organ must be moderately damaged" = "organ orta derecede hasar almış olmalı",
		"the organ must not have been surgically repaired prior" = "organ daha önce cerrahi olarak onarılmamış olmalı",
		"the limb must have an unoperated puncture wound" = "uzuvda müdahale edilmemiş bir delici yara olmalı",
		"the limb must have an operated puncture wound" = "uzuvdaki delici yaraya müdahale edilmiş olmalı",
		"the patient must be in a revivable state" = "hasta canlandırılabilir olmalı",
		"the patient must have a virus to bond" = "hastanın vücudunda iyileştirilebilir bir virüs olmalı",
		"the patient must be dosed with >=1u [/datum/reagent/medicine/spaceacillin::name]" = "hastaya en az 1 birim [/datum/reagent/medicine/spaceacillin::name] dozlanmış olmalı",
		"the patient must be dosed with >=1u [/datum/reagent/consumable/virus_food::name]" = "hastaya en az 1 birim [/datum/reagent/consumable/virus_food::name] dozlanmış olmalı",
		"the patient must be dosed with >=1u [/datum/reagent/toxin/formaldehyde::name]" = "hastaya en az 1 birim [/datum/reagent/toxin/formaldehyde::name] dozlanmış olmalı",
		"the wings must be burnt" = "kanatlar yanmış olmalı",
		"the patient must be dosed with >=5u [/datum/reagent/medicine/c2/synthflesh::name]" = "hastaya en az 5 birim [/datum/reagent/medicine/c2/synthflesh::name] dozlanmış olmalı",
		"if the limb has bones, they must be intact" = "eğer uzuv kemikli ise, kemikler sağlam olmalı",
		"the limb must have a brain present" = "uzuvda bir beyin bulunmalı",
		"the patient or tool must contain >1u [/datum/reagent/medicine/rezadone::name]" = "hastada veya alette 1 birimden fazla [/datum/reagent/medicine/rezadone::name] bulunmalı",
		"the patient or tool must contain >1u [/datum/reagent/toxin/zombiepowder::name]" = "hastada veya alette 1 birimden fazla  [/datum/reagent/toxin/zombiepowder::name] bulunmalı",
		"the limb must not already have a Romerol tumor" = "uzuvda Romerol tümörü bulunmamalı",
		"the limb must not be cybernetic" = "uzuv sibernetik olmamalı",
		"the limb must not be organic" = "uzuv organik olmamalı"
	)

	if(!bioware_pushed)
		for(var/datum/surgery_operation/limb/bioware/bioware as anything in subtypesof(/datum/surgery_operation/limb/bioware))
			var/list/incompatible_surgeries = list()
			var/datum/status_effect/bio_status_effect = bioware::status_effect_gained
			for(var/datum/surgery_operation/limb/bioware/other_bioware as anything in (subtypesof(/datum/surgery_operation/limb/bioware)))
				var/datum/status_effect/otbio_status_effect = other_bioware::status_effect_gained
				if(otbio_status_effect::id != bio_status_effect::id)
					continue
				if(other_bioware::required_bodytype != bioware::required_bodytype)
					continue
				incompatible_surgeries += (other_bioware.rnd_name || other_bioware.name)
			var/english_biware_text = "the patient must not have undergone [english_list(incompatible_surgeries, and_text = " OR ")] prior"
			locale_list[english_biware_text] = "hasta daha önce [turkish_list(incompatible_surgeries, "hiçbir operasyon", " VEYA ")] geçirmemiş olmalı"
		bioware_pushed = TRUE

	var/locale_text = locale_list[rawtext]
	if(locale_text)
		return locale_text

	stack_trace("\"[rawtext]\" not found in /proc/locale_surgery_sentence")
	return rawtext

#undef VOWEL
#undef CONSONANT
#undef NUMBER

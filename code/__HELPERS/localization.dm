// Türkçeleştirme için gerekli fonksiyonları buraya yazabilirsiniz.
// Dosya büyürse ek dosyaları klasör içi açabiliriz
// Lütfen fonksiyonlara açıklama yazmayı unutmayın.
// Fonksiyonları "locale_" ile başlatırsak güzel olur

// { SURELER }
/// Decisecond sureyi turkcelestirir. Orn. 3 Dakika / 53 Saniye
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

// { YAZILAR }
// harfleri kontrol ediyoruz
/proc/getLast2Word(kelime)
	var/list/unluHarfler = list("a", "e", "ı", "i", "o", "ö", "u", "ü")
	var/list/sayilar = list("0","1","2","3","4","5","6","7","8","9")
	var/kucult = locale_lowertext(kelime)
	var/list/charlist = text2charlist(kucult)
	var/h1 = charlist[length(charlist)-1]
	var/h2 = charlist[length(charlist)]
	if(h1 in unluHarfler)
		return list("1",h1,h2) // sondan 2. harf unlu
	if(h2 in unluHarfler)
		return list(2,h2,h1) // sonuncu harf unlu
	if(h2 in sayilar)
		return list(3,h2)
	return FALSE


// gelen yazıyı *text şeklinde döndürme sebebim bug tespitini rahat yapabilmek

/// Belirtme eki | -i, -u / -yi, -yu turkce harfler dahildir
/proc/locale_Suffix_Accusative(text)
	var/list/kelime = getLast2Word(text)
	if(kelime == FALSE)
		return ("*"+text)
	if(kelime[1] == "1")
		switch(kelime[2])
			if("a","ı")
				return (text+("'ı"))
			if("e","i")
				return (text+("'i"))
			if("o","u")
				return (text+("'u"))
			if("ü","ö")
				return (text+("'ü"))
	else if (kelime[1] == "2")
		switch(kelime[2])
			if("a","ı")
				return (text+("'yı"))
			if("e","i")
				return (text+("'yi"))
			if("o","u")
				return (text+("'yu"))
			if("ü","ö")
				return (text+("'yü"))
		return ("*"+text)
	else if (kelime[1] == "3")
		switch(kelime[2])
			if("0")
				return (text+("'ı"))
			if("1","5","8")
				return (text+("'i"))
			if("2","7")
				return (text+("'yi"))
			if("3","4")
				return (text+("'ü"))
			if("6")
				return (text+("'yı"))
			if("9")
				return (text+("'u"))
	else
		return ("*"+text)

/// Yonelme eki | -e, -a / -ye, -ya
/proc/locale_Suffix_Dative(text)
	var/list/kelime = getLast2Word(text)
	if(kelime == FALSE)
		return ("*"+text)
	if(kelime[1] == "1")
		switch(kelime[2])
			if("a","ı","o","u")
				return (text+("'a"))
			if("e","i","ü","ö")
				return (text+("'e"))
	else if (kelime[1] == "2")
		switch(kelime[2])
			if("a","ı","o","u")
				return (text+("'ya"))
			if("e","i","ü","ö")
				return (text+("'ye"))
		return ("*"+text)
	else if (kelime[1] == "3")
		switch(kelime[2])
			if("0","9")
				return (text+("'a"))
			if("1","3","4","5","8")
				return (text+("'e"))
			if("2","7")
				return (text+("'ye"))
			if("6")
				return (text+("'ya"))
	else
		return ("*"+text)

/// Bulunma eki | -de, -da / -te, -ta
/proc/locale_Suffix_Locative(text)
	var/list/sert = list("ç", "f", "h", "k", "s", "ş", "t", "p")
	var/list/kelime = getLast2Word(text)
	if(kelime == FALSE)
		return ("*"+text)
	if(kelime[1] == "1" || kelime[1] == "2")
		switch(kelime[2])
			if("a","ı","o","u")
				if(kelime[3] in sert)
					return (text+("'ta"))
				else
					return (text+("'da"))
			if("e","i","ü","ö")
				if(kelime[3] in sert)
					return (text+("'te"))
				else
					return (text+("'de"))
	else if (kelime[1] == "3")
		switch(kelime[2])
			if("0","6","9")
				return (text+("'da"))
			if("1","2","7","8")
				return (text+("'de"))
			if("3","4","5")
				return (text+("'te"))
	else
		return ("*"+text)

/// Ayrilma eki | -den, -dan / -ten, -tan
/proc/locale_Suffix_Ablative(text)
	var/list/sert = list("ç", "f", "h", "k", "s", "ş", "t", "p")
	var/list/kelime = getLast2Word(text)
	if(kelime == FALSE)
		return ("*"+text)
	if(kelime[1] == "1")
		switch(kelime[2])
			if("a","ı","o","u")
				if(kelime[3] in sert)
					return (text+("'tan"))
				else
					return (text+("'dan"))
			if("e","i","ü","ö")
				if(kelime[3] in sert)
					return (text+("'ten"))
				else
					return (text+("'den"))
	else if(kelime[1] == "3")
		switch(kelime[2])
			if("0","6","9")
				return (text+("'dan"))
			if("1","2","7","8")
				return (text+("'den"))
			if("3","4","5")
				return (text+("'ten"))
	else
		return ("*"+text)

/// Ilgi eki | -in, -un / -nin, -nun turkce harfler dahildir
/proc/locale_Suffix_Genitive(text)
	var/list/kelime = getLast2Word(text)
	if(kelime == FALSE)
		return ("*"+text)
	if(kelime[1] == "1")
		switch(kelime[2])
			if("a","ı")
				return (text+("'ın"))
			if("e","i")
				return (text+("'in"))
			if("o","u")
				return (text+("'un"))
			if("ü","ö")
				return (text+("'ün"))
	else if (kelime[1] == "2")
		switch(kelime[2])
			if("a","ı")
				return (text+("'nın"))
			if("e","i")
				return (text+("'nin"))
			if("o","u")
				return (text+("'nun"))
			if("ü","ö")
				return (text+("'nüns"))
		return ("*"+text)
	else if (kelime[1] == "3")
		switch(kelime[2])
			if("0")
				return (text+("'ın"))
			if("1","5","8")
				return (text+("'in"))
			if("2","7")
				return (text+("'nin"))
			if("3","4")
				return (text+("'ün"))
			if("6")
				return (text+("'nın"))
			if("9")
				return (text+("'un"))
	else
		return ("*"+text)

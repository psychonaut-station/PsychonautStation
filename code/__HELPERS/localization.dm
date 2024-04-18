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
/proc/son_iki_harf_unlu_mu(kelime)
	var/list/unluHarfler = list("a", "e", "ı", "i", "o", "ö", "u", "ü")
	var/kucult = locale_lowertext(kelime)
	var/list/charlist = text2charlist(kucult)
	var/h1 = charlist[length(charlist)-1]
	var/h2 = charlist[length(charlist)]
	if(h1 in unluHarfler)
		return list("1",h1,h2) // sondan 2. harf unlu
	if(h2 in unluHarfler)
		return list(2,h2,h1) // sonuncu harf unlu
	// son iki harf unsuz ise sonuncu harfe gore fonksiyonu gelecek
	return FALSE


// gelen yazıyı *text şeklinde döndürme sebebim bug tespitini rahat yapabilmek

// belirtme eki | ı i u ü
/proc/belirtmeEki(text)
	var/list/kelime = son_iki_harf_unlu_mu(text)
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
	else
		return ("*"+text)

// yönelme a e

// bulunma da de ta te
/proc/bulunmaEki(text)
	var/list/sert = list("ç", "f", "h", "k", "s", "ş", "t", "p")
	var/list/kelime = son_iki_harf_unlu_mu(text)
	if(kelime == FALSE)
		return ("*"+text)
	if(kelime[1] == "1")
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
	else
		return ("*"+text)

// ayrılma dan den tan ten

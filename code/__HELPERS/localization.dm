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
	var/list/charlist = text2charlist(locale_lowertext(text))
	if(!isnull(text2num(charlist[length(charlist)])))
		return list(NUMBER,charlist[length(charlist)])
	if(charlist[length(charlist)] in vowels)
		return list(VOWEL,charlist[length(charlist)])
	for(var/i = length(charlist), i >= 1, i--)
		if(charlist[i] in vowels)
			return list(CONSONANT,charlist[i],charlist[length(charlist)])
	return list(CONSONANT,null,charlist[length(charlist)])

/// Accusative Suffix | -i, -u / -yi, -yu
/proc/locale_suffix_accusative(rawtext)
	var/text = replacetext(rawtext," ","")
	var/list/charlist = vowelcatcher(text)
	switch(charlist[1])
		if(NUMBER)
			switch(charlist[2])
				if("0")
					return "[text]'ı"
				if("1","5","8")
					return "[text]'i"
				if("2","7")
					return "[text]'yi"
				if("3","4")
					return "[text]'ü"
				if("6")
					return "[text]'yı"
				if("9")
					return "[text]'u"
		if(CONSONANT)
			switch(charlist[2])
				if("e","i","ü","ö",null)
					return "[text]'i"
				if("a","ı","o","u")
					return "[text]'ı"
		if(VOWEL)
			switch(charlist[2])
				if("a","ı")
					return "[text]'yı"
				if("e","i")
					return "[text]'yi"
				if("o","u")
					return "[text]'yu"
				if("ü","ö")
					return "[text]'yü"

/// Dative Suffix | -e, -a / -ye, -ya
/proc/locale_suffix_dative(rawtext)
	var/text = replacetext(rawtext," ","")
	var/list/charlist = vowelcatcher(text)
	switch(charlist[1])
		if(NUMBER)
			switch(charlist[2])
				if("0","9")
					return "[text]'a"
				if("1","3","4","5","8")
					return "[text]'e"
				if("2","7")
					return "[text]'ye"
				if("6")
					return "[text]'ya"
		if(CONSONANT)
			switch(charlist[2])
				if("e","i","ü","ö",null)
					return "[text]'e"
				if("a","ı","o","u")
					return "[text]'a"
		if(VOWEL)
			switch(charlist[2])
				if("a","ı","o","u")
					return "[text]'ya"
				if("e","i","ü","ö")
					return "[text]'ye"

/// Locative Suffix | -de, -da / -te, -ta
/proc/locale_suffix_locative(rawtext)
	var/text = replacetext(rawtext," ","")
	var/static/list/consonant_assimilation = list("ç", "f", "h", "k", "s", "ş", "t", "p")
	var/list/charlist = vowelcatcher(text)
	switch(charlist[1])
		if(NUMBER)
			switch(charlist[2])
				if("0","6","9")
					return "[text]'da"
				if("1","2","7","8")
					return "[text]'de"
				if("3","4","5")
					return "[text]'te"
		if(CONSONANT)
			switch(charlist[2])
				if("a","ı","o","u")
					if(charlist[3] in consonant_assimilation)
						return "[text]'ta"
					else
						return "[text]'da"
				if("e","i","ü","ö",null)
					if(charlist[3] in consonant_assimilation)
						return "[text]'te"
					else
						return "[text]'de"
		if(VOWEL)
			switch(charlist[2])
				if("e","i","ü","ö")
					return "[text]'de"
				if("a","ı","o","u")
					return "[text]'da"

/// Ablative Suffix | -den, -dan / -ten, -tan
/proc/locale_suffix_ablative(rawtext)
	var/text = replacetext(rawtext," ","")
	var/static/list/consonant_assimilation = list("ç", "f", "h", "k", "s", "ş", "t", "p")
	var/list/charlist = vowelcatcher(text)
	switch(charlist[1])
		if(NUMBER)
			switch(charlist[2])
				if("0","6","9")
					return "[text]'dan"
				if("1","2","7","8")
					return "[text]'den"
				if("3","4","5")
					return "[text]'ten"
		if(CONSONANT)
			switch(charlist[2])
				if("a","ı","o","u")
					if(charlist[3] in consonant_assimilation)
						return "[text]'tan"
					else
						return "[text]'dan"
				if("e","i","ü","ö",null)
					if(charlist[3] in consonant_assimilation)
						return "[text]'ten"
					else
						return "[text]'den"
		if(VOWEL)
			switch(charlist[2])
				if("a","ı","o","u")
					return "[text]'dan"
				if("e","i","ü","ö")
					return "[text]'den"

/// Genitive Suffix| -in, -un / -nin, -nun
/proc/locale_suffix_genitive(rawtext)
	var/text = replacetext(rawtext," ","")
	var/list/charlist = vowelcatcher(text)
	switch(charlist[1])
		if(NUMBER)
			switch(charlist[2])
				if("0")
					return "[text]'ın"
				if("1","5","8")
					return "[text]'in"
				if("2","7")
					return "[text]'nin"
				if("3","4")
					return "[text]'ün"
				if("6")
					return "[text]'nın"
				if("9")
					return "[text]'un"
		if(CONSONANT)
			switch(charlist[2])
				if("a","ı")
					return "[text]'ın"
				if("e","i",null)
					return "[text]'in"
				if("o","u")
					return "[text]'un"
				if("ü","ö")
					return "[text]'ün"
		if(VOWEL)
			switch(charlist[2])
				if("a","ı")
					return "[text]'nın"
				if("e","i")
					return "[text]'nin"
				if("o","u")
					return "[text]'nun"
				if("ü","ö")
					return "[text]'nün"

#undef VOWEL
#undef CONSONANT
#undef NUMBER

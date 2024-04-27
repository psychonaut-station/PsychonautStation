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

#undef VOWEL
#undef CONSONANT
#undef NUMBER

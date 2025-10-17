
// Turkish Alphabet [A-a]
// I-ı = \u0049 - \u0131
// İ-i = \u0130 - \u0069
// Ü-ü = \u00DC - \u00FC
// Ö-ö = \u00D6 - \u00F6
// Ş-ş = \u015E - \u015F
// Ğ-ğ = \u011E - \u011F
// Ç-ç = \u00C7 - \u00E7

/proc/locale_uppertext(t)
	. = ""
	for(var/c in text2charlist(t))
		switch (c)
			if ("\u0131")  // ı
				. += "\u0049"  // I
			if ("\u0069")  // i
				. += "\u0130" // İ
			if ("\u00FC")  // ü
				. += "\u00DC"  // Ü
			if ("\u00F6")  // ö
				. += "\u00D6"  // Ö
			if ("\u015F")  // ş
				. += "\u015E"  // Ş
			if ("\u011F")  // ğ
				. += "\u011E"  // Ğ
			if ("\u00E7")  // ç
				. += "\u00C7"  // Ç
			else
				. += uppertext(c)

/proc/locale_lowertext_(t)
	. = ""
	for(var/c in text2charlist(t))
		switch(c)
			if("\u0049")  // I
				. += "\u0131"  // ı
			if("\u0130")  // İ
				. += "\u0069" // i
			if ("\u00DC")  // Ü
				. += "\u00FC"  // ü
			if ("\u00D6")  // Ö
				. += "\u00F6"  // ö
			if ("\u015E")  // Ş
				. += "\u015F"  // ş
			if ("\u011E")  // Ğ
				. += "\u011F"  // ğ
			if ("\u00C7")  // Ç
				. += "\u00E7"  // ç
			else
				. += LOWER_TEXT(c)

/proc/delocale_text(t)
	. = ""
	for(var/c in text2charlist(t))
		switch(c)
			if ("\u0131")  // ı
				. += "\u0069"  // i
			if ("\u0130")  // İ
				. += "\u0049" // I
			if ("\u00DC")  // Ü
				. += "\u0055"  // U
			if ("\u00FC")  // ü
				. += "\u0075"  // u
			if ("\u00D6")  // Ö
				. += "\u004F"  // O
			if ("\u00F6")  // ö
				. += "\u006F"  // o
			if ("\u015E")  // Ş
				. += "\u0053"  // S
			if ("\u015F")  // ş
				. += "\u0073"  // s
			if ("\u011E")  // Ğ
				. += "\u0047"  // G
			if ("\u011F")  // ğ
				. += "\u0067"  // g
			if ("\u00C7")  // Ç
				. += "\u0043"  // C
			if ("\u00E7")  // ç
				. += "\u0063"  // c
			else
				. += c

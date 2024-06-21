/proc/locale_uppertext(t)
	. = ""
	for(var/c in text2charlist(t))
		switch (c)
			if ("ı")  // ı
				. += "I"  // I
			if ("i")  // i
				. += "İ" // İ
			if ("ü")  // ü
				. += "Ü"  // Ü
			if ("ö")  // ö
				. += "Ö"  // Ö
			if ("ş")  // ş
				. += "Ş"  // Ş
			if ("ğ")  // ğ
				. += "Ğ"  // Ğ
			if ("ç")  // ç
				. += "Ç"  // Ç
			else
				. += uppertext(c)

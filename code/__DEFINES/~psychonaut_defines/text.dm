/// Folder directory for strings
#define PSYCHONAUT_STRING_DIRECTORY "modular_psychonaut/master_files/strings"

/// Simply removes the < and > characters, and limits the length of the message. Uses copytext_char instead of copytext.
#define STRIP_HTML_LOCALE_SIMPLE(text, limit) (GLOB.angular_brackets.Replace(copytext_char(text, 1, limit), ""))

/// Removes everything enclose in < and > inclusive of the bracket, and limits the length of the message. Uses copytext_char instead of copytext.
#define STRIP_HTML_LOCALE_FULL(text, limit) (GLOB.html_tags.Replace(copytext_char(text, 1, limit), ""))

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

/proc/locale_lowertext(t)
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
				. += lowertext(c)

// Define this after proc
#define uppertext(text) locale_uppertext("[text]")

#define lowertext(text) locale_lowertext("[text]")

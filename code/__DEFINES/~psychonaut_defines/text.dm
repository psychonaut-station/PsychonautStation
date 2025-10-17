
/// Simply removes the < and > characters, and limits the length of the message. Uses copytext_char instead of copytext.
#define STRIP_HTML_LOCALE_SIMPLE(text, limit) (GLOB.angular_brackets.Replace(copytext_char(text, 1, limit), ""))

/// Removes everything enclose in < and > inclusive of the bracket, and limits the length of the message. Uses copytext_char instead of copytext.
#define STRIP_HTML_LOCALE_FULL(text, limit) (GLOB.html_tags.Replace(copytext_char(text, 1, limit), ""))

#define LOCALE_LOWER_TEXT(thing) locale_lowertext_("[thing]")

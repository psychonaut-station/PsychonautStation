/proc/get_strings_directory(filepath)
	. = STRING_DIRECTORY
	if(GLOB.psychonaut_strings.Find(filepath))
		return PSYCHONAUT_STRING_DIRECTORY

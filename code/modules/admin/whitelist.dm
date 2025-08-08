#define WHITELISTFILE "[global.config.directory]/whitelist.txt"
#define JOBWHITELISTFILE "data/job_whitelist.txt"

GLOBAL_LIST(whitelist)
GLOBAL_LIST(job_whitelist)

/proc/load_whitelist()
	GLOB.whitelist = list()
	for(var/line in world.file2list(WHITELISTFILE))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue
		GLOB.whitelist += ckey(line)

	if(!GLOB.whitelist.len)
		GLOB.whitelist = null

/proc/check_whitelist(ckey)
	if(!GLOB.whitelist)
		return FALSE
	. = (ckey in GLOB.whitelist)

<<<<<<< HEAD
/proc/load_job_whitelist()
	GLOB.job_whitelist = list()

	for(var/line in world.file2list(JOBWHITELISTFILE))
		if(!line)
			continue
		GLOB.job_whitelist += ckey(line)

/proc/check_job_whitelist(ckey)
	. = (ckey in GLOB.job_whitelist)

/proc/add_job_whitelist(name)
	if(!name)
		return

	GLOB.job_whitelist += ckey(name)
	WRITE_FILE(file(JOBWHITELISTFILE), ckey(name))
=======
ADMIN_VERB(whitelist_player, R_BAN, "Whitelist CKey", "Adds a ckey to the Whitelist file.", ADMIN_CATEGORY_MAIN)
	var/input_ckey = input("CKey to whitelist: (Adds CKey to the whitelist.txt)") as null|text
	// The ckey proc "santizies" it to be its "true" form
	var/canon_ckey = ckey(input_ckey)
	if(!input_ckey || !canon_ckey)
		return
	// Dont add them to the whitelist if they are already in it
	if(canon_ckey in GLOB.whitelist)
		return

	GLOB.whitelist += canon_ckey
	rustg_file_append("\n[input_ckey]", WHITELISTFILE)

	message_admins("[input_ckey] has been whitelisted by [key_name(user)]")
	log_admin("[input_ckey] has been whitelisted by [key_name(user)]")

ADMIN_VERB_CUSTOM_EXIST_CHECK(whitelist_player)
	return CONFIG_GET(flag/usewhitelist)
>>>>>>> 9636478921c98f5b22d94526c84b5ee3f748f6dc

#undef WHITELISTFILE
#undef JOBWHITELISTFILE

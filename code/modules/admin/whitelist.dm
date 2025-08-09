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

#undef WHITELISTFILE
#undef JOBWHITELISTFILE

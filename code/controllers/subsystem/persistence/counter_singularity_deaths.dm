/// Location where we save the information about how many rounds it has been since the engine blew up
#define SINGULARITY_DEATH_COUNT_FILEPATH "data/rounds_since_singularity_death.txt"
#define SINGULARITY_DEATH_HIGHSCORE_FILEPATH "data/singularity_death_highscore.txt"

/datum/controller/subsystem/persistence/proc/load_singularity_death_counter()
	if(!fexists(SINGULARITY_DEATH_COUNT_FILEPATH))
		return
	rounds_since_singularity_death = text2num(file2text(SINGULARITY_DEATH_COUNT_FILEPATH))
	if(fexists(SINGULARITY_DEATH_HIGHSCORE_FILEPATH))
		singularity_death_record = text2num(file2text(SINGULARITY_DEATH_HIGHSCORE_FILEPATH))
	for(var/obj/machinery/incident_display/sign as anything in GLOB.map_incident_displays)
		sign.update_delam_count(rounds_since_singularity_death, singularity_death_record)

/datum/controller/subsystem/persistence/proc/save_singularity_death_counter()
	rustg_file_write("[rounds_since_singularity_death + 1]", SINGULARITY_DEATH_COUNT_FILEPATH)
	if((rounds_since_singularity_death + 1) > singularity_death_record)
		rustg_file_write("[rounds_since_singularity_death + 1]", SINGULARITY_DEATH_HIGHSCORE_FILEPATH)

#undef SINGULARITY_DEATH_COUNT_FILEPATH
#undef SINGULARITY_DEATH_HIGHSCORE_FILEPATH

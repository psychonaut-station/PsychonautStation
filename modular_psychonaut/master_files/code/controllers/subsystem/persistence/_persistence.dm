/datum/controller/subsystem/persistence
	var/rounds_since_singularity_death = 0
	var/singularity_death_record = 0

/datum/controller/subsystem/persistence/Initialize()
	. = ..()
	load_singularity_death_counter()

/datum/controller/subsystem/persistence/collect_data()
	. = ..()
	save_singularity_death_counter()
	save_trading_cards()

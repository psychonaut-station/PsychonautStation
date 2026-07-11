/area/teammatch
	name = "Teammatch Arena"
	icon = 'icons/area/area_teammatch.dmi'
	requires_power = FALSE
	default_gravity = STANDARD_GRAVITY
	area_flags = LOCAL_TELEPORT | EVENT_PROTECTED | QUIET_LOGS | NO_DEATH_MESSAGE | BINARY_JAMMING
	area_flags_mapping = NONE

/area/teammatch/xm
	requires_power = TRUE

/area/teammatch/xm/crashed_ship
	name = "\improper Crashed Ship"
	icon_state = "shuttlered"

/area/teammatch/xm/engineering
	name = "\improper Engineering"
	icon_state = "engie"

/area/teammatch/xm/security
	name = "\improper Security"
	icon_state = "sec"

/area/teammatch/xm/armory
	name = "\improper Armory"
	icon_state = "sec"

/area/teammatch/xm/main_hall
	name = "\improper Main Hall"
	icon_state = "mainhall"

/area/teammatch/xm/quart
	name = "\improper Quartermasters"
	icon_state = "quart"

/area/teammatch/xm/quartstorage
	name = "\improper Quartermaster Storage"
	icon_state = "quart_storage"

/area/teammatch/xm/quartstorage/dome

/area/teammatch/xm/quartstorage/two

/area/teammatch/xm/quartstorage/outdoors
	name = "\improper Cargo Bay Area"
	icon_state = "purple"

/area/teammatch/xm/kitchen
	name = "\improper Kitchen"
	icon_state = "kitchen"

/area/teammatch/xm/canteen
	name = "\improper Canteen"
	icon_state = "canteen"

/area/teammatch/xm/sleep_female
	name = "\improper Sleep Female"
	icon_state = "sleepfemale"

/area/teammatch/xm/sleep_male
	name = "\improper Sleep Male"
	icon_state = "sleepmale"

/area/teammatch/xm/chapel
	name = "\improper Chapel"
	icon_state = "chapel"

/area/teammatch/xm/toilet
	name = "\improper Toilet"
	icon_state = "toilet"

/area/teammatch/xm/cpt_quarters
	name = "\improper Commandant's Quarters"
	icon_state = "captain_quarters"

/area/teammatch/xm/tablefort
	name = "\improper Table Fort"
	icon_state = "tablefort"

/area/teammatch/xm/bridge
	name = "\improper Bridge"
	icon_state = "away12"
	tacmap_color = TACMAP_SOLID

/area/teammatch/xm/bridge/west
	name = "\improper Western Bridge"

/area/teammatch/xm/bridge/east
	name = "\improper Eastern Bridge"

/area/teammatch/xm/caves
	tacmap_color = TACMAP_DIRT

/area/teammatch/xm/caves/rock
	name = "\improper Rock"
	icon_state = "transparent"

/area/teammatch/xm/caves/west1
	name = "Western Caves"
	icon_state = "away1"

/area/teammatch/xm/caves/east1
	name = "Eastern Caves"
	icon_state = "away2"

/area/teammatch/xm/caves/central1
	name = "Central Caves"
	icon_state = "away3" //meh

/area/teammatch/xm/caves/central2
	name = "Central Caves"
	icon_state = "away4"

/area/teammatch/xm/caves/west2
	name = "North Western Caves"
	icon_state = "cave"

/area/teammatch/xm/caves/east2
	name = "North Eastern Caves"
	icon_state = "cave"

/area/teammatch/xm/caves/central3
	name = "South Central Caves"
	icon_state = "away5"

/area/teammatch/xm/caves/central5
	name = "South Western Central Caves"
	icon_state = "away6"

/area/teammatch/xm/caves/central4
	name = "South Western Caves"
	icon_state = "away7"


/area/teammatch/xm/jungle
	tacmap_color = TACMAP_GRASS

/area/teammatch/xm/jungle/central
	name = "\improper Central Forest"
	icon_state = "jungle_c"

/area/teammatch/xm/jungle/south
	name = "\improper Southern Forest"
	icon_state = "jungle_s"

/area/teammatch/xm/jungle/southeast
	name = "\improper South Forest"
	icon_state = "jungle_se"

/area/teammatch/xm/jungle/southwest
	name = "\improper South West Forest"
	icon_state = "jungle_sw"

/area/teammatch/xm/jungle/north
	name = "\improper Northern Forest"
	icon_state = "jungle_n"

/area/teammatch/xm/jungle/northeast
	name = "\improper Northeast Forest"
	icon_state = "jungle_ne"

/area/teammatch/xm/jungle/northwest
	name = "\improper Northwest Forest"
	icon_state = "jungle_nw"

/area/teammatch/xm/jungle/east
	name = "\improper Eastern Forest"
	icon_state = "jungle_e"

/area/teammatch/xm/jungle/west
	name = "\improper Western Forest"
	icon_state = "jungle_w"

/area/teammatch/xm/jungle/west/central
	name = "\improper Central Western Forest"




/area/teammatch/xm/compound/central
	name = "\improper Central Compound"
	icon_state = "purple"

/area/teammatch/xm/compound/southeast
	name = "\improper Southeast Compound"
	icon_state = "comp_se"

/area/teammatch/xm/compound/southwest
	name = "\improper South West Compound"
	icon_state = "comp_sw"

/area/teammatch/xm/compound/north
	name = "\improper Northern Compound"
	icon_state = "comp_n"

/area/teammatch/xm/compound/northeast
	name = "\improper Northeast Compound"
	icon_state = "comp_ne"


/area/teammatch/xm/spaceport
	name = "\improper Eastern Space Port"
	icon_state = "landingzone1"

/area/teammatch/xm/spaceport2
	name = "\improper Western Space Port"
	icon_state = "landingzone2"

/area/teammatch/xm/testroom
	requires_power = FALSE
	name = "\improper Abandoned Test Room"
	icon_state = "storage"

/area/teammatch/xm/landing1
	name = "\improper Normandy Landing Zone"
	icon_state = "away1"

/area/teammatch/xm/landing2
	name = "\improper Alamo Landing Zone"
	icon_state = "away2"

/area/teammatch/xm/river1
	name = "\improper Western River"
	icon_state = "aqua1"
	tacmap_color = TACMAP_WATER

/area/teammatch/xm/river2
	name = "\improper Central River"
	icon_state = "purple"
	tacmap_color = TACMAP_WATER

/area/teammatch/xm/river3
	name = "\improper Eastern River"
	icon_state = "aqua1"
	tacmap_color = TACMAP_WATER



/area/teammatch/xm/filtration
	name = "\improper Filtration Plant"
	icon_state = "away25"

/area/teammatch/xm/ruin
	name = "\improper Unknown structure"
	icon_state = "ruin"

/area/teammatch/xm/atmos
	name = "\improper Atmospherics"
	icon_state = "atmos"

/area/teammatch/xm/bar
	name = "\improper Bar"
	icon_state = "bar"




/area/teammatch/xm/overgrown
	name = "\improper Overgrown Dome"
	icon_state = "away9"

/area/teammatch/xm/secure_storage
	name = "\improper Secure Storage"
	icon_state = "storage"

/area/teammatch/xm/hydroponics
	name = "\improper Hydroponics"
	icon_state = "away10"

/area/teammatch/xm/hydroponics/aux
	name = "\improper Auxillary Hydroponics"

/area/teammatch/xm/internal_affairs
	name = "\improper Internal Affairs"
	icon_state = "away11"

/area/teammatch/xm/comms
	name = "\improper Communications Relay"
	icon_state = "away12"

/area/teammatch/xm/corporate_affairs
	name = "\improper Corporate Affairs"
	icon_state = "away11"

/area/teammatch/xm/robotics
	name = "\improper Robotics"
	icon_state = "away13"

/area/teammatch/xm/research
	name = "\improper Research Lab"
	icon_state = "away14"

/area/teammatch/xm/fitness
	name = "\improper Fitness Room"
	icon_state = "away15"

/area/teammatch/xm/mining_base
	name = "\improper Mining Base"
	icon_state = "away15"


/area/teammatch/xm/medbay
	name = "\improper Medbay"
	icon_state = "medbay"


/area/teammatch/xm/sandtemple
	name = "\improper Mysterious Temple"
	icon_state = "away24"

/area/teammatch/xm/sand1
	name = "\improper Western Barrens"
	icon_state = "away18"

/area/teammatch/xm/sand2
	name = "\improper Central Barrens"
	icon_state = "away19"

/area/teammatch/xm/sand3
	name = "\improper Eastern Barrens"
	icon_state = "away20"

/area/teammatch/xm/sand4
	name = "\improper North Western Barrens"
	icon_state = "away21"

/area/teammatch/xm/sand5
	name = "\improper North Central Barrens"
	icon_state = "away22"

/area/teammatch/xm/sand6
	name = "\improper North Eastern Barrens"
	icon_state = "away23"

/area/teammatch/xm/sand7
	name = "\improper South Western Barrens"
	icon_state = "away24"

/area/teammatch/xm/sand8
	name = "\improper South Central Barrens"
	icon_state = "away25"

/area/teammatch/xm/sand9
	name = "\improper South Eastern Barrens"
	icon_state = "away26"

/area/teammatch/fullbright
	static_lighting = FALSE
	base_lighting_alpha = 255

/area/shuttle/minigame/canterbury
	name = "Canterbury Ship"



/obj/effect/landmark/teammatch_player_spawn
	name = "Teammatch Player Spawner"
	var/team_type

/obj/effect/landmark/nuke_disk_candidate
	icon = 'icons/obj/machines/computer.dmi'
	icon_state = "computer"

/obj/effect/landmark/nuke_bomb_spawner
	name = "Nuclear Bomb Spawner"
	icon = 'icons/obj/machines/nuke.dmi'
	icon_state = "nuclearbomb_base"

/obj/effect/landmark/xeno_tunnel_spawn
	name = "Xeno Tunnel Spawner"
	icon_state = "navigate"

/obj/effect/landmark/minimap_spawner
	name = "Minimap Table Spawner"
	icon = 'icons/psychonaut/obj/machines/minimap_table.dmi'
	icon_state = "off"



/obj/machinery/computer/nukedisk_generator
	name = "nuke disk generator"
	desc = "A secure terminal used to retrieve nuclear authentication codes and print them onto disks."
	icon_screen = "command"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	///Time needed for the machine to generate the disc
	var/segment_time = 1.5 MINUTES
	///Time to start a segment
	var/start_time = 15 SECONDS
	///Time to print a disk
	var/printing_time = 15 SECONDS

	///Total number of times the hack is required
	var/total_segments = 5
	///What segment we are on, (once this hits total, disk is printed)
	var/completed_segments = 0
	///The current ID of the timer running
	var/current_timer
	///Overall seconds elapsed
	var/seconds_elapsed = 0

	///Check if someone is printing already
	var/busy = FALSE
	///Is a segment currently running?
	var/running = FALSE
	///List of fluff text used in orger, each time a segment is completed
	var/list/technobabble = list(
		"Booting up terminal-  -Terminal running",
		"Establishing link to offsite mainframe- Link established",
		"WARNING, DIRECTORY CORRUPTED, running search algorithms- nuke_fission_timing.exe found",
		"Invalid credentials, upgrading permissions through TGMC military override- Permissions upgraded, nuke_fission_timing.exe available",
		"Downloading nuke_fission_timing.exe to removable storage- nuke_fission_timing.exe downloaded to floppy disk, getting ready to print",
		"Program downloaded to disk. Have a nice day."
	)

	///The flavor message that shows up in the UI upon segment completion
	var/message = "error"
	///UI style used by this computer
	var/ui_style = "NukeDiskGenerator"
	var/key_color
	var/disk_type = /obj/item/disk/nuclear/fake

/obj/machinery/computer/nukedisk_generator/Initialize(mapload, map_id)
	. = ..()
	if(key_color)
		add_minimap_blip(src, MINIMAP_NUKEDISK_BLIP, "[key_color]_disk_off", 'icons/psychonaut/ui_icons/minimap/map_blips_large.dmi', TRUE, 12, map_id)

/obj/machinery/computer/nukedisk_generator/process()
	. = ..()
	if(. || !current_timer)
		if(running)
			seconds_elapsed += 2
		return

	seconds_elapsed = (segment_time/10) * completed_segments
	running = FALSE
	deltimer(current_timer)
	current_timer = null

	visible_message("<b>[src]</b> shuts down as it loses power. Any running programs will now exit")

/obj/machinery/computer/nukedisk_generator/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NukeDiskGenerator")
		ui.open()

/obj/machinery/computer/nukedisk_generator/ui_data(mob/user)
	var/list/data = list()

	if(completed_segments >= total_segments)
		message = "Disk generated. Run program to print."
	else if(current_timer)
		message = "Program running."
	else if(!completed_segments)
		message = "Idle."
	else if(completed_segments < total_segments)
		message = "Restart required. Please re-run the program."

	data["message"] = message

	data["progress"] = seconds_elapsed * 10 / (segment_time * total_segments) //*10 because we need to convert to deciseconds

	data["time_left"] = current_timer ? round(timeleft(current_timer) * 0.1, 2) : "You shouldn't be seeing this, yell at coders."

	data["flavor_text"] = technobabble[completed_segments + 1]

	data["completed"] = (completed_segments == total_segments)

	data["running"] = running

	data["segment_time"] = segment_time

	data["color"] = key_color

	return data

/obj/machinery/computer/nukedisk_generator/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("run_program")
			if(busy || current_timer)
				to_chat(usr, span_warning("A program is already running."))
				return

			if(completed_segments == total_segments) //If we're done, there's no need to run a segment again
				start_final(usr)
				return

			start_segment(usr)

/obj/machinery/computer/nukedisk_generator/proc/start_segment(mob/user)
	busy = TRUE

	user.visible_message(span_notice("[user] begins typing away at the [src]'s keyboard..."),
	span_notice("You begin typing away at the [src]'s keyboard..."))
	if(!do_after(user, start_time, src, NONE, extra_checks=CALLBACK(src, TYPE_PROC_REF(/datum, process))))
		busy = FALSE
		return FALSE

	busy = FALSE
	running = TRUE
	current_timer = addtimer(CALLBACK(src, PROC_REF(complete_segment)), segment_time, TIMER_STOPPABLE)
	return TRUE

/obj/machinery/computer/nukedisk_generator/proc/complete_segment()
	playsound(src, 'sound/machines/ping.ogg', 25, 1)
	deltimer(current_timer)
	current_timer = null
	completed_segments = min(completed_segments + 1, total_segments)

	running = FALSE

	if(completed_segments == total_segments)
		say("Program retrieval successful. Standing by to print...")
		return

	say("Program run has concluded! Standing by...")

/obj/machinery/computer/nukedisk_generator/proc/start_final(mob/user)
	busy = TRUE

	user.visible_message(span_notice("[user] inserts a floppy disk into the [src] and begins to type..."),
	span_notice("You insert a floppy disk into the [src] and begin to type..."))
	if(!do_after(user, printing_time, src, NONE, extra_checks=CALLBACK(src, TYPE_PROC_REF(/datum, process))))
		busy = FALSE
		return

	new disk_type(get_turf(src))
	visible_message(span_notice("[src] beeps, and spits out a [key_color] floppy disk!"))
	busy = FALSE

/obj/machinery/computer/nukedisk_generator/red
	name = "red nuke disk generator"
	disk_type = /obj/item/disk/nuclear/fake/three_disked/red
	icon_keyboard = "syndie_key"
	key_color = "red"

/obj/machinery/computer/nukedisk_generator/green
	name = "green nuke disk generator"
	disk_type = /obj/item/disk/nuclear/fake/three_disked/green
	icon_keyboard = "med_key"
	key_color = "green"

/obj/machinery/computer/nukedisk_generator/blue
	name = "blue nuke disk generator"
	disk_type = /obj/item/disk/nuclear/fake/three_disked/blue
	icon_keyboard = "rd_key"
	key_color = "blue"


/obj/machinery/power/rtg/canterbury
	name = "canterbury " + parent_type::name
	desc = "A simple nuclear power generator, used in small outposts to reliably provide power for decades."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	power_gen = 20 KILO WATTS
	circuit = null
	affected_by_parts = FALSE

/obj/effect/landmark/minimap_spawner
	name = "Minimap Table Spawner"
	icon = 'icons/psychonaut/obj/machines/minimap_table.dmi'
	icon_state = "off"
	var/id

/obj/machinery/telecomms/allinone/marine
	freq_listening = list(FREQ_XM_MARINE)

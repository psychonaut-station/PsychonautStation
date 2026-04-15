/// Thermals for Yog-style AI server hardware.
#define AI_TEMPERATURE_MULTIPLIER 5
#define AI_TEMP_LIMIT 288.15

#define AI_HEATSINK_CAPACITY 5000
#define AI_HEATSINK_COEFF 1
#define AI_CPU_BASE_POWER_USAGE 1250
#define AI_RAM_POWER_USAGE 500
#define AI_MAX_CPUS_PER_RACK 4
#define AI_MAX_RAM_PER_RACK 4
#define AI_DOWNLOAD_PER_PROCESS 5
#define AI_CAMERA_MEMORY_TICKS 10
#define AI_RESEARCH_PER_CPU 1

#define MAX_AI_DATA_CORE_TICKS 450
#define AI_DATA_CORE_POWER_USAGE 7500
#define MAX_AI_SERVER_CABINET_TICKS 150

#define MAX_AI_BITCOIN_MINED_PER_TICK 10
#define AI_BITCOIN_PRICE 10
#define MAX_AI_REGULAR_RESEARCH_PER_TICK 10
#define AI_REGULAR_RESEARCH_POINT_MULTIPLIER 1
#define AI_BLACKBOX_LIFETIME 300
#define AI_BLACKBOX_PROCESSING_REQUIREMENT 2500

#define AI_CORE_CPU_REQUIREMENT 1
#define AI_CORE_RAM_REQUIREMENT 1
#define CELL_POWERUSE_MULTIPLIER 0.025

#define AI_PROJECT_HUDS "Sensor HUDs"
#define AI_PROJECT_CAMERAS "Visibility Upgrades"
#define AI_PROJECT_INDUCTION "Induction"
#define AI_PROJECT_SURVEILLANCE "Surveillance"
#define AI_PROJECT_EFFICIENCY "Efficiency"
#define AI_PROJECT_CROWD_CONTROL "Crowd Control"
#define AI_PROJECT_CYBORG "Cyborg Management"
#define AI_PROJECT_MISC "Misc."

#define AI_CRYPTO "crypto"
#define AI_RESEARCH "research"
#define AI_REVIVAL "revival"
#define AI_PUZZLE "puzzle"

GLOBAL_LIST_INIT(possible_ainet_activities, list(
	AI_CRYPTO,
	AI_RESEARCH,
	AI_REVIVAL,
))

GLOBAL_LIST_INIT(ainet_activity_tagline, list(
	AI_CRYPTO = "Use spare network CPU to mine credits.",
	AI_RESEARCH = "Convert local compute into science point income.",
	AI_REVIVAL = "Divert cluster compute into recovering dead AI blackboxes.",
))

GLOBAL_LIST_INIT(ainet_activity_description, list(
	AI_CRYPTO = "Spare cluster compute is diverted into NTCoin mining and can be withdrawn as holochips from an AI network terminal.",
	AI_RESEARCH = "Allocates spare cluster compute to standard station science research, separate from the AI's own dashboard research queue.",
	AI_REVIVAL = "When a volatile neural core is inserted into an active AI data core, this project feeds compute into reconstructing the stored AI.",
))

GLOBAL_LIST_INIT(ai_project_categories, list(
	AI_PROJECT_HUDS,
	AI_PROJECT_CAMERAS,
	AI_PROJECT_SURVEILLANCE,
	AI_PROJECT_INDUCTION,
	AI_PROJECT_EFFICIENCY,
	AI_PROJECT_CROWD_CONTROL,
	AI_PROJECT_CYBORG,
	AI_PROJECT_MISC,
))

/// Basic machine status text shared by the first ported AI network machines.
#define AI_MACHINE_TOO_HOT "Environment too hot"
#define AI_MACHINE_NO_NETWORK "Lacks a network connection"
#define AI_MACHINE_BROKEN_NOPOWER_EMPED "Either broken, out of power or EMPed"

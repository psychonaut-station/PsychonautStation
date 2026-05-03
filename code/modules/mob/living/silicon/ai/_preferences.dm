#define PSYCHONAUT_AI_HOLOGRAM_ICON 'icons/psychonaut/ai_screens/ai_holograms.dmi'

// A mapping between AI_EMOTION_* string constants, which also double as user readable descriptions, and the name of the iconfile. (used for /obj/machinery/status_display/ai )
GLOBAL_LIST_INIT(ai_status_display_emotes, list(
	// Original AI emotion states
	AI_EMOTION_AWESOME = "ai_awesome",
	AI_EMOTION_BLANK = AI_DISPLAY_DONT_GLOW,
	AI_EMOTION_BLUE_GLOW = "ai_sal",
	AI_EMOTION_CONFUSED = "ai_confused",
	AI_EMOTION_DORFY = "ai_urist",
	AI_EMOTION_FACEPALM = "ai_facepalm",
	AI_EMOTION_FRIEND_COMPUTER = "ai_friend",
	AI_EMOTION_HAPPY = "ai_happy",
	AI_EMOTION_NEUTRAL = "ai_neutral",
	AI_EMOTION_PROBLEMS = "ai_trollface",
	AI_EMOTION_RED_GLOW = "ai_hal",
	AI_EMOTION_SAD = "ai_sad",
	AI_EMOTION_THINKING = "ai_thinking",
	AI_EMOTION_UNSURE = "ai_unsure",
	AI_EMOTION_VERY_HAPPY = "ai_veryhappy",
	AI_EMOTION_DEAD = "ai_dead",
	AI_EMOTION_DOWNLOAD = "ai_download",
))

// Mapping from AI core display options to new status display icon states
// This allows AI status displays to show the same choice as AI core displays
GLOBAL_LIST_INIT(ai_core_to_status_display_mapping, sort_list(list(
	"Alien" = "ai_status_alien",
	"Angry Face" = "ai_status_angryface",
	"Anima" = "ai_status_anima",
	"Angel" = "ai_status_angel",
	"Banned" = "ai_status_banned",
	"Bliss" = "ai_status_bliss",
	"Blob" = "ai_status_blob",
	"Blue" = "ai_status_blue",
	"Boy" = "ai_status_boy",
	"Boy Malf" = "ai_status_boy_malf",
	"Clown" = "ai_status_clown",
	"Carrion" = "ai_status_carrion",
	"Cat" = "ai_status_cat",
	"Cheese" = "ai_status_cheese",
	"Company" = "ai_status_company",
	"Dark Matter" = "ai_status_darkmatter",
	"Database" = "ai_status_database",
	"Dorf" = "ai_status_dorf",
	"Extranet" = "ai_status_extranet",
	"Facepunch" = "ai_status_facepunch",
	"Firewall" = "ai_status_firewall",
	"Fabulous" = "ai_status_fabulous",
	"Flukie" = "ai_status_flukie",
	"Fuzzy" = "ai_status_fuzzy",
	"Gentoo" = "ai_status_gentoo",
	"Girl" = "ai_status_girl",
	"Girl Malf" = "ai_status_girl_malf",
	"Glitchman" = "ai_status_glitchman",
	"Gondola" = "ai_status_gondola",
	"Goon" = "ai_status_goon",
	"Hades" = "ai_status_hades",
	"HAL 9000" = "ai_status_hal9000",
	"Heartline" = "ai_status_heartline",
	"Helios" = "ai_status_helios",
	"House" = "ai_status_house",
	"Kitty" = "ai_status_kitty",
	"Malicious" = "ai_status_malicious",
	"Matrix" = "ai_status_matrix",
	"Monochrome" = "ai_status_monochrome",
	"Murica" = "ai_status_murica",
	"Nadburn" = "ai_status_nadburn",
	"Nanotrasen" = "ai_status_nanotrasen",
	"NT" = "ai_status_nt",
	"Not Malf" = "ai_status_not_malf",
	"Plain" = "ai_status_plain",
	"President" = "ai_status_president",
	"Rainbow" = "ai_status_rainbow",
	"Rainbow Slime" = "ai_status_rainbowslime",
	"Realistic Face" = "ai_status_realisticface",
	"Red October" = "ai_status_red_october",
	"Red" = "ai_status_red",
	"SHODAN" = "ai_status_shodan",
	"SHODAN Chill" = "ai_status_shodan_chill",
	"SHODAN Data" = "ai_status_shodan_data",
	"SHODAN Pulse" = "ai_status_shodan_pulse",
	"Sneaker Database" = "ai_status_sneaker_database",
	"Static" = "ai_status_static",
	"Sus" = "ai_status_sus",
	"Syndicat Meow" = "ai_status_syndicat_meow",
	"Tec" = "ai_status_tec",
	"Text" = "ai_status_text",
	"Terminal" = "ai_status_terminal",
	"Tokamak" = "ai_status_tokamak",
	"Too Deep" = "ai_status_too_deep",
	"Triumvirate" = "ai_status_triumvirate",
	"Void Donut" = "ai_status_voiddonut",
	"Weird" = "ai_status_weird",
	"Yes Man" = "ai_status_yes_man",

	"Allied Mastercomputer" = "ai_status_allied_mastercomputer",
	"Anon" = "ai_status_anon",
	"Atlantiscze" = "ai_status_atlantiscze",
	"Hippy" = "ai_status_hippy",
	"Mothman" = "ai_status_mothman",
	"Ravensdale" = "ai_status_ravensdale",
	"Serithi" = "ai_status_serithi",
	"Silver Ferret" = "ai_status_silverferret",
	"Wasp" = "ai_status_wasp",
	"Xerxes" = "ai_status_xerxes",
)))

// Combined list for AI status display preferences, including both emotion states and AI core display options
GLOBAL_LIST_INIT(ai_status_display_all_options, list())

// Initialize the combined list at runtime
/proc/init_ai_status_display_options()
	if(length(GLOB.ai_status_display_all_options)) // Already initialized
		return

	// Start with original emotes
	GLOB.ai_status_display_all_options = GLOB.ai_status_display_emotes.Copy()

	// Add only the default AI core display mappings.
	for(var/core_option in GLOB.ai_core_display_screens)
		if(!(core_option in GLOB.ai_core_to_status_display_mapping))
			continue
		GLOB.ai_status_display_all_options[core_option] = GLOB.ai_core_to_status_display_mapping[core_option]

GLOBAL_LIST_INIT(ai_hologram_category_options, list(
	AI_HOLOGRAM_CATEGORY_ANIMAL = list(
		AI_HOLOGRAM_BEAR,
		AI_HOLOGRAM_CARP,
		AI_HOLOGRAM_CAT,
		AI_HOLOGRAM_CAT_2,
		AI_HOLOGRAM_CHICKEN,
		AI_HOLOGRAM_CORGI,
		AI_HOLOGRAM_COW,
		AI_HOLOGRAM_CRAB,
		AI_HOLOGRAM_FOX,
		AI_HOLOGRAM_GOAT,
		AI_HOLOGRAM_PARROT,
		AI_HOLOGRAM_PUG,
		AI_HOLOGRAM_SPIDER,
	),
	AI_HOLOGRAM_CATEGORY_UNIQUE = list(
		AI_HOLOGRAM_DEFAULT,
		AI_HOLOGRAM_FACE,
		AI_HOLOGRAM_NARSIE,
		AI_HOLOGRAM_RATVAR,
		AI_HOLOGRAM_XENO,
		"Angel Projection",
		"Borb",
		"Biggest Fan",
		"Cloudkat",
		"Donut",
		"Green Face",
	),
))

// New items need to also be added to ai_hologram_icon_state list
GLOBAL_LIST_INIT(ai_hologram_icons, list(
	/* Animal */
	AI_HOLOGRAM_BEAR = 'icons/mob/simple/animal.dmi',
	AI_HOLOGRAM_CARP = 'icons/mob/simple/carp.dmi',
	AI_HOLOGRAM_CAT = 'icons/mob/simple/pets.dmi',
	AI_HOLOGRAM_CAT_2 = 'icons/mob/simple/pets.dmi',
	AI_HOLOGRAM_CHICKEN = 'icons/mob/simple/animal.dmi',
	AI_HOLOGRAM_CORGI = 'icons/mob/simple/pets.dmi',
	AI_HOLOGRAM_COW = 'icons/mob/simple/cows.dmi',
	AI_HOLOGRAM_CRAB = 'icons/mob/simple/animal.dmi',
	AI_HOLOGRAM_FOX = 'icons/mob/simple/pets.dmi',
	AI_HOLOGRAM_GOAT = 'icons/mob/simple/animal.dmi',
	AI_HOLOGRAM_PARROT = 'icons/mob/simple/animal.dmi',
	AI_HOLOGRAM_PUG = 'icons/mob/simple/pets.dmi',
	AI_HOLOGRAM_SPIDER = 'icons/mob/simple/arachnoid.dmi',
	/* Unique */
	AI_HOLOGRAM_DEFAULT = 'icons/mob/silicon/ai.dmi',
	AI_HOLOGRAM_FACE = 'icons/mob/silicon/ai.dmi',
	AI_HOLOGRAM_NARSIE = 'icons/mob/silicon/ai.dmi',
	AI_HOLOGRAM_RATVAR = 'icons/mob/silicon/ai.dmi',
	AI_HOLOGRAM_XENO = 'icons/mob/nonhuman-player/alien.dmi',
	"Angel Projection" = PSYCHONAUT_AI_HOLOGRAM_ICON,
	"Borb" = PSYCHONAUT_AI_HOLOGRAM_ICON,
	"Biggest Fan" = PSYCHONAUT_AI_HOLOGRAM_ICON,
	"Cloudkat" = PSYCHONAUT_AI_HOLOGRAM_ICON,
	"Donut" = PSYCHONAUT_AI_HOLOGRAM_ICON,
	"Green Face" = PSYCHONAUT_AI_HOLOGRAM_ICON,
))

// New items need to also be added to ai_hologram_icons list
GLOBAL_LIST_INIT(ai_hologram_icon_state, list(
	/* Animal */
	AI_HOLOGRAM_BEAR = "bear",
	AI_HOLOGRAM_CARP = "carp",
	AI_HOLOGRAM_CAT = "cat",
	AI_HOLOGRAM_CAT_2 = "cat2",
	AI_HOLOGRAM_CHICKEN = "chicken_brown",
	AI_HOLOGRAM_CORGI = "corgi",
	AI_HOLOGRAM_COW = "cow",
	AI_HOLOGRAM_CRAB = "crab",
	AI_HOLOGRAM_FOX = "fox",
	AI_HOLOGRAM_GOAT = "goat",
	AI_HOLOGRAM_PARROT = "parrot_fly",
	AI_HOLOGRAM_PUG = "pug",
	AI_HOLOGRAM_SPIDER = "guard",
	/* Unique */
	AI_HOLOGRAM_DEFAULT = "default",
	AI_HOLOGRAM_FACE = "floating face",
	AI_HOLOGRAM_NARSIE = "horror",
	AI_HOLOGRAM_RATVAR = "clock",
	AI_HOLOGRAM_XENO = "alienq",
	"Angel Projection" = "holo-angel",
	"Borb" = "holo-borb",
	"Biggest Fan" = "holo-biggestfan",
	"Cloudkat" = "holo-cloudkat",
	"Donut" = "holo-donut",
	"Green Face" = "holo-greenface",
))


GLOBAL_LIST_INIT(ai_core_display_screens, sort_list(list(
	":thinking:",
	"Alien",
	"Angel",
	"Banned",
	"Bliss",
	"Blue",
	"Clown",
	"Database",
	"Dorf",
	"Firewall",
	"Fuzzy",
	"Gentoo",
	"Glitchman",
	"Gondola",
	"Goon",
	"Hades",
	"HAL 9000",
	"Heartline",
	"Helios",
	"House",
	"Inverted",
	"Matrix",
	"Monochrome",
	"Murica",
	"Nanotrasen",
	"Not Malf",
	"Portrait",
	"President",
	"Rainbow",
	"Random",
	"Red October",
	"Red",
	"Static",
	"Syndicat Meow",
	"Text",
	"Too Deep",
	"Triumvirate-M",
	"Triumvirate",
	"Weird",

	"Allied Mastercomputer"
)))

GLOBAL_LIST_INIT(additional_ai_core_display_screens, sort_list(list(
	"Angry Face",
	"Anon",
	"Anima",
	"Atlantiscze",
	"Blob",
	"Boy",
	"Boy Malf",
	"Carrion",
	"Cat",
	"Cheese",
	"Company",
	"Dark Matter",
	"Extranet",
	"Facepunch",
	"Fabulous",
	"Flukie",
	"Girl",
	"Girl Malf",
	"Hippy",
	"Kitty",
	"Malicious",
	"Mothman",
	"Nadburn",
	"NT",
	"Plain",
	"Rainbow Slime",
	"Realistic Face",
	"Ravensdale",
	"SHODAN",
	"SHODAN Chill",
	"SHODAN Data",
	"SHODAN Pulse",
	"Serithi",
	"Silver Ferret",
	"Sneaker Database",
	"Sus",
	"Tec",
	"Terminal",
	"Tokamak",
	"Void Donut",
	"Wasp",
	"Xerxes",
	"Yes Man",
)))

GLOBAL_LIST_INIT(ai_core_display_screen_icons, list(
	"Allied Mastercomputer" = 'icons/psychonaut/ai_screens/allied_screens.dmi',
	"Angry Face" = 'icons/psychonaut/ai_screens/paradise_screens.dmi',
	"Anon" = 'icons/psychonaut/ai_screens/bluemoon_screens.dmi',
	"Anima" = 'icons/psychonaut/ai_screens/paradise_screens.dmi',
	"Atlantiscze" = 'icons/psychonaut/ai_screens/bluemoon_screens.dmi',
	"Blob" = 'icons/psychonaut/ai_screens/yog_screens.dmi',
	"Boy" = 'icons/psychonaut/ai_screens/monke_screens.dmi',
	"Boy Malf" = 'icons/psychonaut/ai_screens/monke_screens.dmi',
	"Carrion" = 'icons/psychonaut/ai_screens/donor_screens.dmi',
	"Cat" = 'icons/psychonaut/ai_screens/yog_screens.dmi',
	"Cheese" = 'icons/psychonaut/ai_screens/paradise_screens.dmi',
	"Company" = 'icons/psychonaut/ai_screens/monke_screens.dmi',
	"Dark Matter" = 'icons/psychonaut/ai_screens/paradise_screens.dmi',
	"Extranet" = 'icons/psychonaut/ai_screens/donor_screens.dmi',
	"Facepunch" = 'icons/psychonaut/ai_screens/monke_screens.dmi',
	"Fabulous" = 'icons/psychonaut/ai_screens/tgmc_screens.dmi',
	"Flukie" = 'icons/psychonaut/ai_screens/donor_screens.dmi',
	"Girl" = 'icons/psychonaut/ai_screens/monke_screens.dmi',
	"Girl Malf" = 'icons/psychonaut/ai_screens/monke_screens.dmi',
	"Hippy" = 'icons/psychonaut/ai_screens/bluemoon_screens.dmi',
	"Kitty" = 'icons/psychonaut/ai_screens/monke_screens.dmi',
	"Malicious" = 'icons/psychonaut/ai_screens/yog_screens.dmi',
	"Mothman" = 'icons/psychonaut/ai_screens/bluemoon_screens.dmi',
	"Nadburn" = 'icons/psychonaut/ai_screens/paradise_screens.dmi',
	"NT" = 'icons/psychonaut/ai_screens/paradise_screens.dmi',
	"Plain" = 'icons/psychonaut/ai_screens/yog_screens.dmi',
	"Rainbow Slime" = 'icons/psychonaut/ai_screens/paradise_screens.dmi',
	"Realistic Face" = 'icons/psychonaut/ai_screens/donor_screens.dmi',
	"Ravensdale" = 'icons/psychonaut/ai_screens/bluemoon_screens.dmi',
	"SHODAN" = 'icons/psychonaut/ai_screens/tgmc_screens.dmi',
	"SHODAN Chill" = 'icons/psychonaut/ai_screens/tgmc_screens.dmi',
	"SHODAN Data" = 'icons/psychonaut/ai_screens/tgmc_screens.dmi',
	"SHODAN Pulse" = 'icons/psychonaut/ai_screens/tgmc_screens.dmi',
	"Serithi" = 'icons/psychonaut/ai_screens/bluemoon_screens.dmi',
	"Silver Ferret" = 'icons/psychonaut/ai_screens/bluemoon_screens.dmi',
	"Sneaker Database" = 'icons/psychonaut/ai_screens/donor_screens.dmi',
	"Sus" = 'icons/psychonaut/ai_screens/monke_screens.dmi',
	"Tec" = 'icons/psychonaut/ai_screens/monke_screens.dmi',
	"Terminal" = 'icons/psychonaut/ai_screens/monke_screens.dmi',
	"Tokamak" = 'icons/psychonaut/ai_screens/donor_screens.dmi',
	"Void Donut" = 'icons/psychonaut/ai_screens/paradise_screens.dmi',
	"Wasp" = 'icons/psychonaut/ai_screens/bluemoon_screens.dmi',
	"Xerxes" = 'icons/psychonaut/ai_screens/bluemoon_screens.dmi',
	"Yes Man" = 'icons/psychonaut/ai_screens/monke_screens.dmi',
))

GLOBAL_LIST_INIT(ai_status_display_screen_icons, list(
	"Allied Mastercomputer" = 'icons/psychonaut/ai_screens/allied_status_screens.dmi',
	"Angry Face" = 'icons/psychonaut/ai_screens/paradise_status_screens.dmi',
	"Anon" = 'icons/psychonaut/ai_screens/bluemoon_status_screens.dmi',
	"Anima" = 'icons/psychonaut/ai_screens/paradise_status_screens.dmi',
	"Atlantiscze" = 'icons/psychonaut/ai_screens/bluemoon_status_screens.dmi',
	"Blob" = 'icons/psychonaut/ai_screens/yog_status_screens.dmi',
	"Boy" = 'icons/psychonaut/ai_screens/monke_status_screens.dmi',
	"Boy Malf" = 'icons/psychonaut/ai_screens/monke_status_screens.dmi',
	"Carrion" = 'icons/psychonaut/ai_screens/donor_status_screens.dmi',
	"Cat" = 'icons/psychonaut/ai_screens/yog_status_screens.dmi',
	"Cheese" = 'icons/psychonaut/ai_screens/paradise_status_screens.dmi',
	"Company" = 'icons/psychonaut/ai_screens/monke_status_screens.dmi',
	"Dark Matter" = 'icons/psychonaut/ai_screens/paradise_status_screens.dmi',
	"Extranet" = 'icons/psychonaut/ai_screens/donor_status_screens.dmi',
	"Facepunch" = 'icons/psychonaut/ai_screens/monke_status_screens.dmi',
	"Fabulous" = 'icons/psychonaut/ai_screens/tgmc_status_screens.dmi',
	"Flukie" = 'icons/psychonaut/ai_screens/donor_status_screens.dmi',
	"Girl" = 'icons/psychonaut/ai_screens/monke_status_screens.dmi',
	"Girl Malf" = 'icons/psychonaut/ai_screens/monke_status_screens.dmi',
	"Hippy" = 'icons/psychonaut/ai_screens/bluemoon_status_screens.dmi',
	"Kitty" = 'icons/psychonaut/ai_screens/monke_status_screens.dmi',
	"Malicious" = 'icons/psychonaut/ai_screens/yog_status_screens.dmi',
	"Mothman" = 'icons/psychonaut/ai_screens/bluemoon_status_screens.dmi',
	"Nadburn" = 'icons/psychonaut/ai_screens/paradise_status_screens.dmi',
	"NT" = 'icons/psychonaut/ai_screens/paradise_status_screens.dmi',
	"Plain" = 'icons/psychonaut/ai_screens/yog_status_screens.dmi',
	"Rainbow Slime" = 'icons/psychonaut/ai_screens/paradise_status_screens.dmi',
	"Realistic Face" = 'icons/psychonaut/ai_screens/donor_status_screens.dmi',
	"Ravensdale" = 'icons/psychonaut/ai_screens/bluemoon_status_screens.dmi',
	"SHODAN" = 'icons/psychonaut/ai_screens/tgmc_status_screens.dmi',
	"SHODAN Chill" = 'icons/psychonaut/ai_screens/tgmc_status_screens.dmi',
	"SHODAN Data" = 'icons/psychonaut/ai_screens/tgmc_status_screens.dmi',
	"SHODAN Pulse" = 'icons/psychonaut/ai_screens/tgmc_status_screens.dmi',
	"Serithi" = 'icons/psychonaut/ai_screens/bluemoon_status_screens.dmi',
	"Silver Ferret" = 'icons/psychonaut/ai_screens/bluemoon_status_screens.dmi',
	"Sneaker Database" = 'icons/psychonaut/ai_screens/donor_status_screens.dmi',
	"Sus" = 'icons/psychonaut/ai_screens/monke_status_screens.dmi',
	"Tec" = 'icons/psychonaut/ai_screens/monke_status_screens.dmi',
	"Terminal" = 'icons/psychonaut/ai_screens/monke_status_screens.dmi',
	"Tokamak" = 'icons/psychonaut/ai_screens/donor_status_screens.dmi',
	"Void Donut" = 'icons/psychonaut/ai_screens/paradise_status_screens.dmi',
	"Wasp" = 'icons/psychonaut/ai_screens/bluemoon_status_screens.dmi',
	"Xerxes" = 'icons/psychonaut/ai_screens/bluemoon_status_screens.dmi',
	"Yes Man" = 'icons/psychonaut/ai_screens/monke_status_screens.dmi',
))

GLOBAL_LIST_INIT(ai_core_display_screen_states, list(
	"Allied Mastercomputer" = "ai-allied_mastercomputer",
	"Angry Face" = "ai-angryface",
	"Anon" = "ai-anon",
	"Anima" = "ai-anima",
	"Atlantiscze" = "ai-atlantiscze",
	"Blob" = "ai-blob",
	"Boy" = "ai-boy",
	"Boy Malf" = "ai-boy-malf",
	"Carrion" = "carrion",
	"Cat" = "ai-cat",
	"Cheese" = "ai-cheese",
	"Company" = "ai-company",
	"Dark Matter" = "ai-darkmatter",
	"Extranet" = "extranet",
	"Facepunch" = "ai-facepunch",
	"Fabulous" = "ai-fabulous",
	"Flukie" = "flukie",
	"Girl" = "ai-girl",
	"Girl Malf" = "ai-girl-malf",
	"Hippy" = "ai-hippy",
	"Kitty" = "ai-kitty",
	"Malicious" = "ai-malicious",
	"Mothman" = "ai-mothman",
	"Nadburn" = "ai-nadburn",
	"NT" = "ai-nt",
	"Plain" = "ai-plain",
	"Portrait" = "ai-portrait",
	"Rainbow Slime" = "ai-rainbowslime",
	"Realistic Face" = "realisticface",
	"Ravensdale" = "ai-ravensdale",
	"SHODAN" = "ai-shodan",
	"SHODAN Chill" = "ai-shodan_chill",
	"SHODAN Data" = "ai-shodan_data",
	"SHODAN Pulse" = "ai-shodan_pulse",
	"Serithi" = "ai-serithi",
	"Silver Ferret" = "ai-silverferret",
	"Sneaker Database" = "sneaker_database",
	"Sus" = "ai-sus",
	"Tec" = "ai-tec",
	"Terminal" = "ai-terminal",
	"Tokamak" = "tokamak",
	"Void Donut" = "ai-voiddonut",
	"Wasp" = "ai-wasp",
	"Xerxes" = "ai-xerxes",
	"Yes Man" = "ai-yes-man",
))

GLOBAL_LIST_INIT(ai_core_display_dead_states, list(
	"Allied Mastercomputer" = "ai-allied_mastercomputer_dead",
	"Atlantiscze" = "ai-atlantiscze_dead",
	"Carrion" = "carrion-dead",
	"Flukie" = "flukiedead",
	"Hippy" = "ai-hippy_dead",
	"Realistic Face" = "realisticface-dead",
	"Ravensdale" = "ai-ravensdale_dead",
	"Serithi" = "ai-serithi_dead",
	"Sneaker Database" = "sneaker_database-dead",
	"Tokamak" = "tokamak-dead",
))

GLOBAL_LIST_INIT(ai_goon_core_skin_options, list(
	"Nanotrasen Standard" = "default",
	"Science" = "science",
	"Medical" = "medical",
	"Legacy Nanotrasen" = "ntold",
	"Bee" = "bee",
	"Shock" = "shock",
	"Gold" = "gold",
	"Engineering" = "engineering",
	"Soviet" = "soviet",
	"Modern Nanotrasen" = "nt",
	"Industrial" = "industrial",
	"Toy Pink" = "lgun",
	"DWAINE" = "dwaine",
	"AILES" = "ailes",
	"Salvage" = "salvage",
	"GardenGear" = "gardengear",
	"Toy Blue" = "telegun",
	"Kingsway" = "kingsway",
	"Syndicate" = "syndicate",
	"Clown" = "clown",
	"Mime" = "mime",
	"Tactical" = "tactical",
	"Mauxite" = "mauxite",
	"Flock" = "flock",
	"Pumpkin" = "pumpkin",
	"CRT" = "crt",
	"Rustic" = "rustic",
	"Cardboard" = "cardboard",
	"Regal" = "regal",
))

GLOBAL_LIST_INIT(ai_goon_core_skin_descriptions, list(
	"Nanotrasen Standard" = "The casing appears to be a standard Nanotrasen AI core.",
	"Science" = "The casing is made out of a white plastic and has a prominent purple stripe painted down the front.",
	"Medical" = "The casing is made out of a white plastic and has a prominent red stripe painted down the front.",
	"Legacy Nanotrasen" = "A much older model of Nanotrasen AI core. The stark white has faded to eggshell with time.",
	"Bee" = "The casing has been painted and given little plastic antennae to make it resemble a bee!",
	"Shock" = "The casing is painted a luminescent blue and has what looks to be neon light tubes built into it!",
	"Gold" = "The casing seems to be made out of gold. No, wait. Looking closer, you think that's actually pyrite.",
	"Engineering" = "The casing is made out of a buffed metal and has a prominent orange stripe painted down the front.",
	"Soviet" = "The latest in Soviet artificial intelligence technology. And by latest, you mean this thing looks like it's been collecting dust for decades.",
	"Modern Nanotrasen" = "A newer model of Nanotrasen AI core. It's been painted a greyish-blue, and proudly displays the NT logo below the screen.",
	"Industrial" = "The casing is made out of a sleek and polished alloy. It looks heavily reinforced- wait, no. No, that's just a really impressive paint job.",
	"Toy Pink" = "The casing is made out of pieces of colourful pink plastic clipped together. It looks like a toy.",
	"DWAINE" = "The casing has a label saying \"Thinktronic Data Systems, LLC\". Jeez, how old is this?",
	"AILES" = "A bulky computational powerhouse- or, at least, it would have been twenty-odd years ago. The logo below the screen has been scratched off with something sharp.",
	"Salvage" = "A significantly worse-for-wear Nanotrasen AI core, haphazardly repaired back to working order with what looks to be scrap metal and spare parts.",
	"GardenGear" = "\"Product of GardenGear\" is etched into the side of the casing.",
	"Toy Blue" = "The casing is made out of pieces of colourful blue plastic clipped together. It looks like a toy.",
	"Kingsway" = "'Kingsway Systems 29A' is etched into the aged plastic casing beneath the screen.",
	"Syndicate" = "The casing is covered in Syndicate markings! On second glance, it seems like the panels are pieces of toy plastic clipped together. Wow.",
	"Clown" = "Crayon and questionable stains constitute the majority of the casing's exterior. What the fuck even is this thing?",
	"Mime" = "The casing has been painted to clearly resemble a mime.",
	"Tactical" = "The casing is made out of a dark grey plastic and is covered in clearly purposeless grooves and fans and whatelse. Very tacticool.",
	"Mauxite" = "The core has been hammered together out of jagged sheets of mauxite.",
	"Flock" = "The casing is made out of a humming teal material. It pulses and flares to a strange rhythm.",
	"Pumpkin" = "The casing is made out of a pumpkin. Spooky!",
	"CRT" = "The core appears to be a... CRT television. Huh.",
	"Rustic" = "The core appears to be... a box. Where are the beveled edges?! This core isn't a weird octagonal prism at all, it's just a cube!",
	"Cardboard" = "The core appears to be made out of cardboard. Huh. ...Well, it's probably still just as good at opening doors.",
	"Regal" = "The core appears to be made out of a thick gold and green metal. Very fancy.",
))

GLOBAL_LIST_INIT(ai_goon_background_options, list(
	"Blue" = "ai_blue",
	"Grey" = "ai_grey",
	"White" = "ai_white",
	"Red" = "ai_red",
	"Green" = "ai_green",
	"Yellow" = "ai_yellow",
	"Pink" = "ai_pink",
	"Purple" = "ai_purple",
))

GLOBAL_LIST_INIT(ai_goon_light_mode_options, list(
	"Auto" = "auto",
	"APC Power" = "apc",
	"Battery Power" = "bat",
))

GLOBAL_LIST_INIT(ai_goon_face_options, list(
	"Classic Smile" = "ai_happy-dol",
	"White Screen 2" = "ai_white2",
	"BSOD" = "ai_bsod",
	"Tetris" = "ai_tetris",
	"Stunned" = "ai_stun-screen",
	"Annoyed" = "ai_annoyed-dol",
	"Annoyed (Inverted)" = "ai_annoyed-lod",
	"Baffled" = "ai_baffled-dol",
	"Baffled (Inverted)" = "ai_baffled-lod",
	"Blank" = "ai_blank-dol",
	"Blank (Inverted)" = "ai_blank-lod",
	"Cheeky" = "ai_cheeky-dol",
	"Cheeky (Inverted)" = "ai_cheeky-lod",
	"Colourbars" = "ai_colourbars",
	"Confused" = "ai_confused-dol",
	"Confused (Inverted)" = "ai_confused-lod",
	"Content" = "ai_content-dol",
	"Content (Inverted)" = "ai_content-lod",
	"Crecent" = "ai_crecent-dol",
	"Crecent (Inverted)" = "ai_crecent-lod",
	"Cursor" = "ai_cursor-dol",
	"Cursor (Inverted)" = "ai_cursor-lod",
	"Exclamation" = "ai_exclamation-dol",
	"Exclamation (Inverted)" = "ai_exclamation-lod",
	"Eye" = "ai_eye-dol",
	"Eye (Inverted)" = "ai_eye-lod",
	"Fidgety" = "ai_fidget-dol",
	"Fidgety (Inverted)" = "ai_fidget-lod",
	"Glitch" = "ai_glitch-dol",
	"Glitch (Inverted)" = "ai_glitch-lod",
	"Happy" = "ai_happy-dol",
	"Happy (Inverted)" = "ai_happy-lod",
	"Heart" = "ai_heart-dol",
	"Heart (Inverted)" = "ai_heart-lod",
	"Line" = "ai_line-dol",
	"Line (Inverted)" = "ai_line-lod",
	"Loading Bar" = "ai_loading-dol",
	"Loading Bar (Inverted)" = "ai_loading-lod",
	"Mad" = "ai_mad-dol",
	"Mad (Inverted)" = "ai_mad-lod",
	"Musical" = "ai_music-dol",
	"Musical (Inverted)" = "ai_music-lod",
	"Nanotrasen" = "ai_nanotrasen-dol",
	"Nanotrasen (Inverted)" = "ai_nanotrasen-lod",
	"Nervous" = "ai_nervous-dol",
	"Nervous (Inverted)" = "ai_nervous-lod",
	"Neutral" = "ai_neutral-dol",
	"Neutral (Inverted)" = "ai_neutral-lod",
	"Pensive" = "ai_pensive-dol",
	"Pensive (Inverted)" = "ai_pensive-lod",
	"Question" = "ai_question-dol",
	"Question (Inverted)" = "ai_question-lod",
	"Sad" = "ai_sad-dol",
	"Sad (Inverted)" = "ai_sad-lod",
	"Silly" = "ai_silly-dol",
	"Silly (Inverted)" = "ai_silly-lod",
	"Smug" = "ai_smug-dol",
	"Smug (Inverted)" = "ai_smug-lod",
	"Snoozing" = "ai_zzz-dol",
	"Snoozing (Inverted)" = "ai_zzz-lod",
	"Spooky" = "ai_spooky-dol",
	"Spooky (Inverted)" = "ai_spooky-lod",
	"Square" = "ai_square-dol",
	"Square (Inverted)" = "ai_square-lod",
	"Surprised" = "ai_surprised-dol",
	"Surprised (Inverted)" = "ai_surprised-lod",
	"Suspicious" = "ai_eyesemoji-dol",
	"Suspicious (Inverted)" = "ai_eyesemoji-lod",
	"Tamogatchi" = "ai_tamogatchi",
	"Text" = "ai_text-dol",
	"Text (Inverted)" = "ai_text-lod",
	"Tired" = "ai_tired-dol",
	"Tired (Inverted)" = "ai_tired-lod",
	"Triangle" = "ai_triangle-dol",
	"Triangle (Inverted)" = "ai_triangle-lod",
	"Unimpressed" = "ai_unimpressed-dol",
	"Unimpressed (Inverted)" = "ai_unimpressed-lod",
	"Unsure" = "ai_unsure-dol",
	"Unsure (Inverted)" = "ai_unsure-lod",
	"Very Happy" = "ai_veryhappy-dol",
	"Very Happy (Inverted)" = "ai_veryhappy-lod",
	"Wink" = "ai_wink-dol",
	"Wink (Inverted)" = "ai_wink-lod",
	"Wide Smile" = "ai_widesmile-dol",
	"Wide Smile (Inverted)" = "ai_widesmile-lod",
	"Sunglasses" = "ai_sunglasses-dol",
	"Sunglasses (Inverted)" = "ai_sunglasses-lod",
	"Devious" = "ai_devious-dol",
	"Devious (Inverted)" = "ai_devious-lod",
))

GLOBAL_VAR_INIT(ai_goon_face_options_initialized, FALSE)

GLOBAL_LIST_INIT(ai_goon_animated_face_options, list(
	"Classic Smile (Animated)" = "ai_happy-dol-flip",
	"Annoyed (Animated)" = "ai_annoyed-dol-flip",
	"Annoyed (Inverted, Animated)" = "ai_annoyed-lod-flip",
	"Baffled (Animated)" = "ai_baffled-dol-flip",
	"Baffled (Inverted, Animated)" = "ai_baffled-lod-flip",
	"Cheeky (Animated)" = "ai_cheeky-dol-flip",
	"Cheeky (Inverted, Animated)" = "ai_cheeky-lod-flip",
	"Colourbars (Animated)" = "ai_colourbars-flip",
	"Confused (Animated)" = "ai_confused-dol-flip",
	"Confused (Inverted, Animated)" = "ai_confused-lod-flip",
	"Content (Animated)" = "ai_content-dol-flip",
	"Content (Inverted, Animated)" = "ai_content-lod-flip",
	"Crecent (Animated)" = "ai_crecent-dol-flip",
	"Crecent (Inverted, Animated)" = "ai_crecent-lod-flip",
	"Cursor (Animated)" = "ai_cursor-dol-flip",
	"Cursor (Inverted, Animated)" = "ai_cursor-lod-flip",
	"Exclamation (Animated)" = "ai_exclamation-dol-flip",
	"Exclamation (Inverted, Animated)" = "ai_exclamation-lod-flip",
	"Eye (Animated)" = "ai_eye-dol-flip",
	"Eye (Inverted, Animated)" = "ai_eye-lod-flip",
	"Fidgety (Animated Bob)" = "ai_fidget-dol-flip",
	"Fidgety (Inverted, Animated Bob)" = "ai_fidget-lod-flip",
	"Glitch (Animated)" = "ai_glitch-dol-flip",
	"Glitch (Inverted, Animated)" = "ai_glitch-lod-flip",
	"Heart (Animated)" = "ai_heart-dol-flip",
	"Heart (Inverted, Animated)" = "ai_heart-lod-flip",
	"Line (Animated)" = "ai_line-dol-flip",
	"Line (Inverted, Animated)" = "ai_line-lod-flip",
	"Loading Bar (Animated)" = "ai_loading-dol-flip",
	"Loading Bar (Inverted, Animated)" = "ai_loading-lod-flip",
	"Mad (Animated)" = "ai_mad-dol-flip",
	"Mad (Inverted, Animated)" = "ai_mad-lod-flip",
	"Musical (Animated)" = "ai_music-dol-flip",
	"Musical (Inverted, Animated)" = "ai_music-lod-flip",
	"Nanotrasen (Animated)" = "ai_nanotrasen-dol-flip",
	"Nanotrasen (Inverted, Animated)" = "ai_nanotrasen-lod-flip",
	"Nervous (Animated Bob)" = "ai_nervous-dol-flip",
	"Nervous (Inverted, Animated Bob)" = "ai_nervous-lod-flip",
	"Neutral (Animated)" = "ai_neutral-dol-flip",
	"Neutral (Inverted, Animated)" = "ai_neutral-lod-flip",
	"Pensive (Animated)" = "ai_pensive-dol-flip",
	"Pensive (Inverted, Animated)" = "ai_pensive-lod-flip",
	"Question (Animated)" = "ai_question-dol-flip",
	"Question (Inverted, Animated)" = "ai_question-lod-flip",
	"Sad (Animated)" = "ai_sad-dol-flip",
	"Sad (Inverted, Animated)" = "ai_sad-lod-flip",
	"Silly (Animated)" = "ai_silly-dol-flip",
	"Silly (Inverted, Animated)" = "ai_silly-lod-flip",
	"Smug (Animated)" = "ai_smug-dol-flip",
	"Smug (Inverted, Animated)" = "ai_smug-lod-flip",
	"Snoozing (Animated)" = "ai_zzz-dol-flip",
	"Snoozing (Inverted, Animated)" = "ai_zzz-lod-flip",
	"Spooky (Animated)" = "ai_spooky-dol-flip",
	"Spooky (Inverted, Animated)" = "ai_spooky-lod-flip",
	"Square (Animated)" = "ai_square-dol-flip",
	"Square (Inverted, Animated)" = "ai_square-lod-flip",
	"Surprised (Animated)" = "ai_surprised-dol-flip",
	"Surprised (Inverted, Animated)" = "ai_surprised-lod-flip",
	"Suspicious (Animated)" = "ai_eyesemoji-dol-flip",
	"Suspicious (Inverted, Animated)" = "ai_eyesemoji-lod-flip",
	"Text (Animated)" = "ai_text-dol-flip",
	"Text (Inverted, Animated)" = "ai_text-lod-flip",
	"Tired (Animated)" = "ai_tired-dol-flip",
	"Tired (Inverted, Animated)" = "ai_tired-lod-flip",
	"Triangle (Animated)" = "ai_triangle-dol-flip",
	"Triangle (Inverted, Animated)" = "ai_triangle-lod-flip",
	"Unimpressed (Animated)" = "ai_unimpressed-dol-flip",
	"Unimpressed (Inverted, Animated)" = "ai_unimpressed-lod-flip",
	"Unsure (Animated)" = "ai_unsure-dol-flip",
	"Unsure (Inverted, Animated)" = "ai_unsure-lod-flip",
	"Very Happy (Animated)" = "ai_veryhappy-dol-flip",
	"Very Happy (Inverted, Animated)" = "ai_veryhappy-lod-flip",
	"Wink (Animated)" = "ai_wink-dol-flip",
	"Wink (Inverted, Animated)" = "ai_wink-lod-flip",
	"Wide Smile (Animated)" = "ai_widesmile-dol-flip",
	"Wide Smile (Inverted, Animated)" = "ai_widesmile-lod-flip",
	"Sunglasses (Animated)" = "ai_sunglasses-dol-flip",
	"Sunglasses (Inverted, Animated)" = "ai_sunglasses-lod-flip",
	"Devious (Animated)" = "ai_devious-dol-flip",
	"Devious (Inverted, Animated)" = "ai_devious-lod-flip",
))

/proc/init_ai_goon_face_options()
	if(GLOB.ai_goon_face_options_initialized)
		return
	GLOB.ai_goon_face_options += GLOB.ai_goon_animated_face_options
	GLOB.ai_goon_face_options_initialized = TRUE

/// A form of resolve_ai_icon that is guaranteed to never sleep.
/// Not always accurate, but always synchronous.
/proc/get_all_ai_core_display_options()
	var/static/list/all_ai_core_display_options
	if(!all_ai_core_display_options)
		all_ai_core_display_options = GLOB.ai_core_display_screens.Copy()
		all_ai_core_display_options |= GLOB.additional_ai_core_display_screens
		all_ai_core_display_options = sort_list(all_ai_core_display_options)
	return all_ai_core_display_options.Copy()

/proc/get_ai_display_state(display_name)
	if(!display_name)
		return "ai"
	return GLOB.ai_core_display_screen_states[display_name] || "ai-[LOWER_TEXT(display_name)]"

/proc/get_ai_display_icon(display_name, default_icon = 'icons/mob/silicon/ai.dmi')
	return GLOB.ai_core_display_screen_icons[display_name] || default_icon

/proc/get_ai_display_dead_state(display_name, alive_state = null, icon_file = null)
	if(display_name in GLOB.ai_core_display_dead_states)
		return GLOB.ai_core_display_dead_states[display_name]

	alive_state ||= get_ai_display_state(display_name)
	if(!alive_state)
		return "ai_dead"

	icon_file ||= get_ai_display_icon(display_name)
	var/default_dead_state = "[alive_state]_dead"
	if(icon_file && icon_exists(icon_file, default_dead_state))
		return default_dead_state
	return "ai_dead"

/proc/is_ai_goon_core_skin_state(core_skin)
	for(var/skin_name in GLOB.ai_goon_core_skin_options)
		if(GLOB.ai_goon_core_skin_options[skin_name] == core_skin)
			return TRUE
	return FALSE

/proc/is_ai_goon_face_state(face_state)
	init_ai_goon_face_options()
	for(var/face_name in GLOB.ai_goon_face_options)
		if(GLOB.ai_goon_face_options[face_name] == face_state)
			return TRUE
	return FALSE

/proc/is_ai_goon_background_state(background_state)
	for(var/background_name in GLOB.ai_goon_background_options)
		if(GLOB.ai_goon_background_options[background_name] == background_state)
			return TRUE
	return FALSE

/proc/is_ai_goon_light_mode(light_mode)
	for(var/light_mode_name in GLOB.ai_goon_light_mode_options)
		if(GLOB.ai_goon_light_mode_options[light_mode_name] == light_mode)
			return TRUE
	return FALSE

/proc/get_ai_goon_core_label(core_skin)
	for(var/skin_name in GLOB.ai_goon_core_skin_options)
		if(GLOB.ai_goon_core_skin_options[skin_name] == core_skin)
			return skin_name
	return "Nanotrasen Standard"

/proc/get_ai_goon_face_label(face_state)
	init_ai_goon_face_options()
	for(var/face_name in GLOB.ai_goon_face_options)
		if(GLOB.ai_goon_face_options[face_name] == face_state)
			return face_name
	return "Happy"

/proc/get_ai_goon_background_label(background_state)
	for(var/background_name in GLOB.ai_goon_background_options)
		if(GLOB.ai_goon_background_options[background_name] == background_state)
			return background_name
	return "Blue"

/proc/get_ai_goon_light_mode_label(light_mode)
	for(var/light_mode_name in GLOB.ai_goon_light_mode_options)
		if(GLOB.ai_goon_light_mode_options[light_mode_name] == light_mode)
			return light_mode_name
	return "Auto"

/proc/get_ai_goon_light_state(core_skin, light_mode = "auto", battery_power = FALSE)
	var/resolved_skin = is_ai_goon_core_skin_state(core_skin) ? core_skin : "default"
	var/resolved_mode = is_ai_goon_light_mode(light_mode) ? light_mode : "auto"
	var/power_suffix = battery_power ? "bat" : "apc"
	if(resolved_mode != "auto")
		power_suffix = resolved_mode
	var/light_state = "lights_[power_suffix]-[resolved_skin]"
	if(icon_exists('icons/psychonaut/ai_screens/goon_core.dmi', light_state))
		return light_state
	return null

/proc/resolve_ai_icon_sync(input)
	SHOULD_NOT_SLEEP(TRUE)

	if(!input || !(input in get_all_ai_core_display_options()))
		return "ai"
	else
		if(input == "Random")
			input = pick(GLOB.ai_core_display_screens - "Random")
		return get_ai_display_state(input)

/proc/resolve_ai_icon(input)
	if (input == "Portrait")
		var/datum/portrait_picker/tgui = new(usr)//create the datum
		tgui.ui_interact(usr)//datum has a tgui component, here we open the window
		return "ai-portrait" //just take this until they decide

	return resolve_ai_icon_sync(input)

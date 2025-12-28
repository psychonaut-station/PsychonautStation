#define UNCATEGORIZED_EVENTS "Uncategorized"

#define EVENT_TRACK_MUNDANE "mundane"
#define EVENT_TRACK_MODERATE "moderate"
#define EVENT_TRACK_MAJOR "major"
#define EVENT_TRACK_ROLESET "roleset"

/// When the event is combat oriented (spawning monsters, inherently hostile antags)
#define TAG_COMBAT "combat"
/// When the event is spooky (broken lights, some antags)
#define TAG_SPOOKY "spooky"
/// When the event is destructive in a decent capacity (meteors, blob)
#define TAG_DESTRUCTIVE "destructive"
/// When the event impacts most of the crewmembers in some capacity (comms blackout)
#define TAG_COMMUNAL "communal"
/// When the event targets a person for something (appendix, heart attack)
#define TAG_TARGETED "targeted"
/// When the event is positive and helps the crew, in some capacity (Shuttle Loan, Supply Pod)
#define TAG_POSITIVE "positive"
/// When one of the crewmembers becomes an antagonist
#define TAG_CREW_ANTAG "crew_antag"
/// When the antagonist event is focused around team cooperation.
#define TAG_TEAM_ANTAG "team_antag"
/// When one of the non-crewmember players becomes an antagonist
#define TAG_OUTSIDER_ANTAG "away_antag"
/// When the event is an external threat (meteors, nukies).
#define TAG_EXTERNAL "external"
/// When the event is an alien threat (blob, xenos)
#define TAG_ALIEN "alien"
/// When the event is magical in nature
#define TAG_MAGICAL "magical"
/// Whenthe event impacts the overmap
#define TAG_OVERMAP "overmap"
/// When the event requires the station to be in space (meteors, carp)
#define TAG_SPACE "space"
/// When the event requires the station to be planetary.
#define TAG_PLANETARY "planetary"

#define ALL_STORYTELLER_TAGS list( \
	TAG_COMBAT, \
	TAG_SPOOKY, \
	TAG_DESTRUCTIVE, \
	TAG_COMMUNAL, \
	TAG_TARGETED, \
	TAG_POSITIVE, \
	TAG_CREW_ANTAG, \
	TAG_TEAM_ANTAG, \
	TAG_OUTSIDER_ANTAG, \
	TAG_EXTERNAL, \
	TAG_ALIEN, \
	TAG_MAGICAL, \
	TAG_OVERMAP, \
)

// Storytellers
#define STORYTELLER_AMBUSH "The Ambush"
#define STORYTELLER_BETRAYER "The Betrayer"
#define STORYTELLER_BRUTE "The Brute"
#define STORYTELLER_CATACLYSM "The Cataclysm"
#define STORYTELLER_CLOWN "The Clown"
#define STORYTELLER_DESCENT "The Descent"
#define STORYTELLER_DROUGHT "The Drought"
#define STORYTELLER_EXHAUST "The Exhaust"
#define STORYTELLER_GATEKEEPER "The Gatekeeper"
#define STORYTELLER_GUIDE "The Guide"
#define STORYTELLER_HERMIT "The Hermit"
#define STORYTELLER_JESTER "The Jester"
#define STORYTELLER_MYSTIC "The Mystic"
#define STORYTELLER_NOBLEMAN "The Nobleman"
#define STORYTELLER_OPERATIVE "The Operative"
#define STORYTELLER_PRIMEORDIAL "The Primeordial"
#define STORYTELLER_PULSE "The Pulse"
#define STORYTELLER_REGULATOR "The Regulator"
#define STORYTELLER_SLEEPER "The Sleeper"
#define STORYTELLER_SNIPER "The Sniper"
#define STORYTELLER_SPECIALIST "The Specialist"
#define STORYTELLER_VANGUARD "The Vanguard"
#define STORYTELLER_WARRIOR "The Warrior"

// Settings
#define STORYTELLER_EVENT_WEIGHT_MULTIPLIERS "event_weight_multipliers"
#define STORYTELLER_TAG_MULTIPLIERS "tag_multipliers"
#define STORYTELLER_EVENT_REPETITION_MULTIPLIERS "event_repetition_multipliers"
#define STORYTELLER_GENERAL_MULTIPLIERS "general_multipliers"

/// Lower end for cooldown duration multiplier for storyteller
#define EXECUTION_MULTIPLIER_LOW "execution_multiplier_low"
/// Upper end for cooldown duration multiplier for storyteller
#define EXECUTION_MULTIPLIER_HIGH "execution_multiplier_high"

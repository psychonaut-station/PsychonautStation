/datum/round_event_control/mice_migration
	name = "Mice Migration"
	typepath = /datum/round_event/mice_migration
	weight = 10
	category = EVENT_CATEGORY_ENTITIES
	description = "A horde of mice arrives, and perhaps even the Rat King themselves."

/datum/round_event/mice_migration
	var/minimum_mice = 5
	var/maximum_mice = 15

/datum/round_event/mice_migration/announce(fake)
	// PSYCHONAUT EDIT ADDITION BEGIN - LOCALIZATION - Original:
	/*
	var/cause = pick("space-winter", "budget-cuts", "Ragnarok",
		"space being cold", "\[REDACTED\]", "climate change",
		"bad luck")
	var/plural = pick("a number of", "a horde of", "a pack of", "a swarm of",
		"a whoop of", "not more than [maximum_mice]")
	var/name = pick("rodents", "mice", "squeaking things",
		"wire eating mammals", "\[REDACTED\]", "energy draining parasites")
	var/movement = pick("migrated", "swarmed", "stampeded", "descended")
	var/location = pick("maintenance tunnels", "maintenance areas",
		"\[REDACTED\]", "place with all those juicy wires")

	priority_announce("Due to [cause], [plural] [name] have [movement] \
		into the [location].", "Migration Alert",
		'sound/mobs/non-humanoids/mouse/mousesqueek.ogg')
	*/
	var/cause = pick("Uzay soğuğu", "Bütçe kesintileri", "Kıyamet", "İklim değişikliği")
	var/plural = pick("birkaç", "bir sürü", "bir düzine", "yaklaşık [maximum_mice]")
	var/name = pick("kemirgen", "fare", "enerji̇ tüketen parazi̇t")
	var/movement = pick("göç ediyor.", "ilerliyor.", "izdiham ediyor.")
	var/location = pick("maintenance tünellerine", "maintenance bölgesine", "tüm o lezzetli kabloların olduğu yere")

	priority_announce("[cause] dolayısıyla, [plural] [name] [location] doğru \
		[movement]", "Kemirgen uyarısı",
		'sound/mobs/non-humanoids/mouse/mousesqueek.ogg')
	// PSYCHONAUT EDIT ADDITION END - LOCALIZATION

/datum/round_event/mice_migration/start()
	SSminor_mapping.trigger_migration(rand(minimum_mice, maximum_mice))

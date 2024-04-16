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
	var/cause = pick("Uzay soğuğu", "Bütçe kesintileri", "Ragnarok", "İklim değişikliği")
	var/plural = pick("birkaç", "bir sürü", "bir düzine", "en fazla [maximum_mice]")
	var/name = pick("kemirgen", "fare", "enerji̇ tüketen parazi̇t")
	var/movement = pick("göç ediyor.", "ilerliyor.", "izdiham ediyor.")
	var/location = pick("maintenance tünellerine", "maintenance bölgesine",
		"\[REDACTED\]", "place with all those juicy wires")

	priority_announce("[cause] nedeni ile, [plural] [name] [location] doğru \
		[movement]", "Kemirgen uyarısı",
		'sound/creatures/mousesqueek.ogg')

/datum/round_event/mice_migration/start()
	SSminor_mapping.trigger_migration(rand(minimum_mice, maximum_mice))

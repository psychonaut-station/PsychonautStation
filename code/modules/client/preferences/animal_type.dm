/datum/preference/choiced/animal_type
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "animal_type"
	should_generate_icons = TRUE

/datum/preference/choiced/animal_type/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/animal_type/init_possible_values()
	return GLOB.animal_job_types

/datum/preference/choiced/animal_type/create_default_value()
	return "Fox"

/datum/preference/choiced/animal_type/icon_for(value)
	return GLOB.animal_job_types[value]

/datum/preference/choiced/animal_type/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE
	return istype(preferences.get_highest_priority_job(), /datum/job/animal)

GLOBAL_LIST_INIT(animal_job_types, list(
	"Axolotl" = /mob/living/basic/axolotl,
	"Baby penguin" = /mob/living/basic/pet/penguin/baby,
	"Breadcat" = /mob/living/basic/pet/cat/breadcat,
	"Breaddog" = /mob/living/basic/pet/dog/breaddog,
	"Bull terrier" = /mob/living/basic/pet/dog/bullterrier,
	"Butterfly" = /mob/living/basic/butterfly,
	"Cat" = /mob/living/basic/pet/cat,
	"Chicken" = /mob/living/basic/chicken,
	"Chick" = /mob/living/basic/chick,
	"Corgi" = /mob/living/basic/pet/dog/corgi,
	"Cow" = /mob/living/basic/cow,
	"Crab" = /mob/living/basic/crab,
	"Deer" = /mob/living/basic/deer,
	"Fox" = /mob/living/basic/pet/fox,
	"Frog" = /mob/living/basic/frog,
	"Giant ant" = /mob/living/basic/ant,
	"Goat" = /mob/living/basic/goat,
	"Kitten" = /mob/living/basic/pet/cat/kitten,
	"Lightgeist" = /mob/living/basic/lightgeist,
	"Lizard" = /mob/living/basic/lizard,
	"Mothroach" = /mob/living/basic/mothroach,
	"Pug" = /mob/living/basic/pet/dog/pug,
	"Parrot" = /mob/living/basic/parrot,
	"Penguin" = /mob/living/basic/pet/penguin/emperor,
	"Polar bear" = /mob/living/basic/bear/snow,
	"Pony" = /mob/living/basic/pony,
	"Pig" = /mob/living/basic/pig,
	"Rabbit" = /mob/living/basic/rabbit,
	"Sheep" = /mob/living/basic/sheep,
	"Vada" = /mob/living/basic/vada,
))

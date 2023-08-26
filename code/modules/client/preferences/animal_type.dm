/datum/preference/choiced/animal_type
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "animal_type"
	should_generate_icons = TRUE

/datum/preference/choiced/animal_type/init_possible_values()
	return GLOB.animal_job_types

/datum/preference/choiced/animal_type/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/animal_type/create_default_value()
	return "Fox"

/datum/preference/choiced/animal_type/icon_for(value)
	return GLOB.animal_job_types[value]

/datum/preference/choiced/animal_type/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE
	return istype(preferences.get_highest_priority_job(), /datum/job/animal)

GLOBAL_LIST_INIT(animal_job_types, list(
	"Fox" = /mob/living/basic/pet/fox,
	"Parrot" = /mob/living/simple_animal/parrot,
	"Corgi" = /mob/living/basic/pet/dog/corgi,
	"Pug" = /mob/living/basic/pet/dog/pug,
	"Bull terrier" = /mob/living/basic/pet/dog/bullterrier,
	"Breaddog" = /mob/living/basic/pet/dog/breaddog,
	"Cat" = /mob/living/simple_animal/pet/cat,
	"Kitten" = /mob/living/simple_animal/pet/cat/kitten,
	"Breadcat" = /mob/living/simple_animal/pet/cat/breadcat,
	"Goat" = /mob/living/simple_animal/hostile/retaliate/goat,
	"Cow" = /mob/living/basic/cow,
	"Chicken" = /mob/living/basic/chicken,
	"Chick" = /mob/living/basic/chick,
	"Penguin" = /mob/living/basic/pet/penguin/emperor,
	"Baby penguin" = /mob/living/basic/pet/penguin/baby,
	"Sheep" = /mob/living/basic/sheep,
	"Pony" = /mob/living/basic/pony,
	"Pig" = /mob/living/basic/pig,
	"Deer" = /mob/living/basic/deer,
	"Rabbit" = /mob/living/basic/rabbit,
	"Axolotl" = /mob/living/basic/axolotl,
	"Butterfly" = /mob/living/basic/butterfly,
	"Crab" = /mob/living/basic/crab,
	"Frog" = /mob/living/basic/frog,
	"Lizard" = /mob/living/basic/lizard,
	"Mothroach" = /mob/living/basic/mothroach,
))

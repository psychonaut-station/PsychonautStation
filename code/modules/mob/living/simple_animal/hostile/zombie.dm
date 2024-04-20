/mob/living/simple_animal/hostile/zombie
	name = "Shambling Corpse"
	desc = "When there is no more room in hell, the dead will walk in outer space."
	icon = 'icons/mob/simple/simple_human.dmi'
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	sentience_type = SENTIENCE_HUMANOID
	speak_chance = 0
	stat_attack = HARD_CRIT //braains
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 21
	melee_damage_upper = 21
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/hallucinations/growl1.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE
	faction = list(FACTION_ZOMBIE)
	combat_mode = TRUE
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_plas" = 0, "max_plas" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	status_flags = CANPUSH
	death_message = "collapses, flesh gone in a pile of bones!"
	del_on_death = TRUE
	loot = list(/obj/effect/decal/remains/human)
	/// The probability that we give people real zombie infections on hit.
	var/infection_chance = 0
	/// Outfit the zombie spawns with for visuals.
	var/outfit = /datum/outfit/corpse_doctor

/mob/living/simple_animal/hostile/zombie/Initialize(mapload)
	. = ..()
	apply_dynamic_human_appearance(src, outfit, /datum/species/zombie, bloody_slots = ITEM_SLOT_OCLOTHING)

/mob/living/simple_animal/hostile/zombie/AttackingTarget(atom/attacked_target)
	. = ..()
	if(. && ishuman(target) && prob(infection_chance))
		try_to_zombie_infect(target)

/datum/outfit/corpse_doctor
	name = "Corpse Doctor"
	uniform = /obj/item/clothing/under/rank/medical/doctor/nurse
	shoes = /obj/item/clothing/shoes/sneakers/white
	back = /obj/item/storage/backpack/medic

/datum/outfit/corpse_assistant
	name = "Corpse Assistant"
	mask = /obj/item/clothing/mask/gas
	uniform = /obj/item/clothing/under/color/grey
	shoes = /obj/item/clothing/shoes/sneakers/black
	back = /obj/item/storage/backpack

/datum/outfit/honk_runner
	name = "Honk Honk Runner"
	mask = /obj/item/clothing/mask/gas/clown_hat
	uniform = /obj/item/clothing/under/rank/civilian/clown
	shoes = /obj/item/clothing/shoes/clown_shoes
	back = /obj/item/storage/backpack/clown

/datum/outfit/toolbox_guy
	name = "Toolbox Guy!!"
	mask = /obj/item/clothing/mask/facescarf
	uniform = /obj/item/clothing/under/misc/bouncer
	shoes = /obj/item/clothing/shoes/cowboy
	back = /obj/item/storage/backpack/duffelbag

/datum/outfit/shit_sec
	name = "Shit Sec!!"
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	suit = /obj/item/clothing/suit/armor/vest/alt/tactical_armor
	uniform = /obj/item/clothing/under/rank/security/head_of_security/alt
	shoes = /obj/item/clothing/shoes/combat/swat
	back = /obj/item/storage/backpack/ert/security

/datum/outfit/soldier_boss
	name = "Soldier Boss!!"
	suit = /obj/item/clothing/suit/armor/militia
	uniform = /obj/item/clothing/under/rank/centcom/military
	shoes = /obj/item/clothing/shoes/combat/swat
	back = /obj/item/storage/backpack/ert

/datum/outfit/pirate_rarr
	name = "Pirate Rarrr!!"
	suit = /obj/item/clothing/suit/costume/pirate
	uniform = /obj/item/clothing/under/costume/pirate
	shoes = /obj/item/clothing/shoes/pirate

/mob/living/simple_animal/hostile/zombie/shit_sec
	name = "Shit Sec!!"
	desc = "Shit Sec ;)"
	outfit = /datum/outfit/shit_sec
	maxHealth = 200
	health = 200
	melee_damage_lower = 28
	melee_damage_upper = 28
	speed = 1
	infection_chance = 2
	attack_sound = 'sound/weapons/punchmiss.ogg'
	death_sound =  'sound/voice/sec_death.ogg'
	death_message = "Noo :("
	speak_chance = 3
	speak = list("AM","EW")

/mob/living/simple_animal/hostile/zombie/toolbox_guy
	name = "Toolbox Guy!!"
	desc = "Get Robust :)"
	outfit = /datum/outfit/toolbox_guy
	maxHealth = 200
	health = 200
	melee_damage_lower = 27
	melee_damage_upper = 27
	speed = 1
	infection_chance = 2
	attack_sound = 'sound/weapons/punchmiss.ogg'
	death_sound =  'sound/voice/sec_death.ogg'
	death_message = "I'm Robusted..."
	speak_chance = 3
	speak = list("AM","EW")
	
/mob/living/simple_animal/hostile/zombie/honk_runner
	name = "Honk Honk Runner!!"
	desc = "Seni Şakalamak İstiyorum!!"
	outfit = /datum/outfit/honk_runner
	maxHealth = 60
	health = 60
	melee_damage_lower = 16
	melee_damage_upper = 16
	speed = 4
	infection_chance = 1
	attack_sound = 'sound/items/bikehorn.ogg'
	death_sound =  'sound/misc/sadtrombone.ogg'
	death_message = "Honk Honk :("
	speak_chance = 4
	speak = list("AM","EW","HONK")

/mob/living/simple_animal/hostile/zombie/felind_doc
	name = "Felind Doctor"
	desc = "Felind!!"
	outfit = /datum/outfit/corpse_doctor
	maxHealth = 200
	health = 200
	melee_damage_lower = 28
	melee_damage_upper = 28
	speed = 1
	infection_chance = 3
	attack_sound = 'sound/weapons/punchmiss.ogg'
	death_sound =  'sound/voice/sec_death.ogg'
	death_message = "Noo :("
	speak_chance = 3
	speak = list("AM","EW")

/mob/living/simple_animal/hostile/zombie/soldier_boss
	name = "Soldier Boss!!"
	desc = "Danger!!"
	outfit = /datum/outfit/soldier_boss
	maxHealth = 800
	health = 800
	melee_damage_lower = 30
	melee_damage_upper = 30
	speed = 2
	infection_chance = 8
	attack_sound = 'sound/weapons/punchmiss.ogg'
	death_sound =  'sound/voice/sec_death.ogg'
	death_message = "This is not the end..."
	speak_chance = 3
	speak = list("AM","EW","ROAR")

/mob/living/simple_animal/hostile/zombie/pirate_rarr
	name = "Pirate RARR!!"
	desc = "RARRR!!"
	outfit = /datum/outfit/pirate_rarr
	maxHealth = 300
	health = 300
	melee_damage_lower = 29
	melee_damage_upper = 29
	speed = 1
	infection_chance = 3
	attack_sound = 'sound/weapons/punchmiss.ogg'
	death_sound =  'sound/voice/sec_death.ogg'
	death_message = "This is not the end..."
	speak_chance = 3
	speak = list("AM","EW","RARR")

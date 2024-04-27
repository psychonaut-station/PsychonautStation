/mob/living/simple_animal/hostile/megafauna/tank
	name = "The Tank"
	desc = "Run or shoot?... RUN OR SHOOT?!"
	health = 1500
	maxHealth = 1500
	attack_verb_continuous = "rends"
	attack_verb_simple = "rends"
	attack_sound = 'sound/_psychonaut/tank_damage.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE
	icon = 'icons/psychonaut/mob/simple/boss.dmi'
	icon_state = "tank"
	icon_living = "tank"
	icon_dead = ""
	friendly_verb_continuous = "stares down"
	friendly_verb_simple = "stare down"
	speak_emote = list("roars")
	armour_penetration = 40
	melee_damage_lower = 40
	melee_damage_upper = 40
	speed = 2
	move_to_delay = 10
	ranged = TRUE
	pixel_x = -32
	base_pixel_x = -32
	maptext_height = 96
	maptext_width = 96
	crusher_loot = list(/obj/structure/closet/crate/necropolis/puzzle)
	loot = list(/obj/structure/closet/crate/necropolis/puzzle)
	butcher_results = list(/obj/item/stack/ore/diamond = 5, /obj/item/stack/sheet/sinew = 5, /obj/item/stack/sheet/bone = 30)
	var/swooping = NONE
	var/player_cooldown = 0
	gps_name = "The Tank"
	death_message = "Tell me, am I DEAD OR ARE YOU DEAD?"
	death_sound = 'sound/_psychonaut/tank_dead.ogg'
	faction = list(FACTION_ZOMBIE, FACTION_BOSS, FACTION_HELL)
	footstep_type = FOOTSTEP_MOB_HEAVY
	summon_line = "ROOOOOOOOAAAAAAAAAAAR!"
	/// Fire cone ability
	var/datum/action/cooldown/mob_cooldown/fire_breath/cone/fire_cone
	/// Meteors ability
	var/datum/action/cooldown/mob_cooldown/meteors/meteors
	/// Mass fire ability
	var/datum/action/cooldown/mob_cooldown/fire_breath/mass_fire/mass_fire


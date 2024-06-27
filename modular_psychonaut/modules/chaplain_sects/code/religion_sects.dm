/**** Necromancy Sect ****/

/datum/religion_sect/necro_sect
	name = "Necromancy"
	desc = "A sect dedicated to the revival and summoning of the dead. Sacrificing living animals grants you favor."
	quote = "An undead army is a must have!"
	tgui_icon = "skull"
	alignment = ALIGNMENT_EVIL
	max_favor = 10000
	desired_items = list(/obj/item/organ)
	rites_list = list(/datum/religion_rites/raise_dead, /datum/religion_rites/living_sacrifice, /datum/religion_rites/raise_undead)
	altar_icon = 'modular_psychonaut/modules/chaplain_sects/icons/altars.dmi'
	altar_icon_state = "convertaltar_necro"

// Necro bibles don't heal or do anything special apart from the standard holy water blessings
/datum/religion_sect/necro_sect/sect_bless(mob/living/blessed, mob/living/user)
	return TRUE

/datum/religion_sect/necro_sect/on_sacrifice(obj/item/N, mob/living/L)
	if(!istype(N, /obj/item/organ))
		return
	adjust_favor(10, L)
	to_chat(L, "<span class='notice'>You offer [N] to [GLOB.deity], pleasing them and gaining 10 favor in the process.</span>")
	qdel(N)
	return TRUE

/**** Carp Sect ****/

/datum/religion_sect/carp_sect
	name = "Followers of the Great Carp"
	desc = "A sect dedicated to the space carp and carp'sie, Offer the gods meat for favor."
	quote = "Drown the station in fish and water."
	tgui_icon = "fish"
	alignment = ALIGNMENT_NEUT
	max_favor = 10000
	desired_items = list(/obj/item/food/meat)
	rites_list = list(/datum/religion_rites/summon_carp, /datum/religion_rites/flood_area)
	altar_icon = 'modular_psychonaut/modules/chaplain_sects/icons/altars.dmi'
	altar_icon_state = "convertaltar_carp"

// Carp bibles don't heal or do anything special apart from the standard holy water blessings
/datum/religion_sect/carp_sect/sect_bless(mob/living/L, mob/living/user)
	return TRUE

/datum/religion_sect/carp_sect/on_sacrifice(obj/item/N, mob/living/L)
	if(!istype(N, /obj/item/food/meat))
		return
	adjust_favor(20, L)
	to_chat(L, "<span class='notice'>You offer [N] to [GLOB.deity], pleasing them and gaining 20 favor in the process.</span>")
	qdel(N)
	return TRUE

/**** Nature Sect ****/

/datum/religion_sect/plant_sect
	name = "Nature"
	desc = "A sect dedicated to nature, plants, and animals. Sacrificing seeds grants you favor."
	quote = "Living plant people? What has the world come to!"
	tgui_icon = "tree"
	alignment = ALIGNMENT_GOOD
	max_favor = 10000
	desired_items = list(/obj/item/seeds)
	rites_list = list(/datum/religion_rites/create_podperson, /datum/religion_rites/summon_animals)
	altar_icon = 'modular_psychonaut/modules/chaplain_sects/icons/altars.dmi'
	altar_icon_state = "convertaltar_nature"

// Plant bibles don't heal or do anything special apart from the standard holy water blessings
/datum/religion_sect/plant_sect/sect_bless(mob/living/blessed, mob/living/user)
	return TRUE

/datum/religion_sect/plant_sect/on_sacrifice(obj/item/N, mob/living/L)
	if(!istype(N, /obj/item/seeds))
		return
	adjust_favor(25, L)
	to_chat(L, "<span class='notice'>You offer [N] to [GLOB.deity], pleasing them and gaining 25 favor in the process.</span>")
	qdel(N)
	return TRUE

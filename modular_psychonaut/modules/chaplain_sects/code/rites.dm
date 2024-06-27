/**** Necromancy Sect ****/

/datum/religion_rites/raise_undead
	name = "Raise Undead"
	desc = "Converts dead or alive into skeletons."
	ritual_length = 50 SECONDS
	ritual_invocations = list(
		"Come forth from the abyss ...",
		"... enter our realm ...",
		"... become one with our world ...",
		"... rise ...",
		"... RISE! ...",
	)
	invoke_msg = "... RISE!!!"
	favor_cost = 1500

/datum/religion_rites/raise_undead/perform_rite(mob/living/user, atom/movable/religious_tool)
	if(!istype(religious_tool))
		to_chat(user, span_warning("This rite requires a religious device that individuals can be buckled to."))
		return FALSE
	if(LAZYLEN(religious_tool.buckled_mobs))
		to_chat(user, span_warning("You're going to convert the one buckled on [religious_tool]."))
	else
		if(!religious_tool.can_buckle) // yes, if you have somehow managed to have someone buckled to something that now cannot buckle, we will still let you perform the rite!
			to_chat(user, span_warning("This rite requires a religious device that individuals can be buckled to."))
			return FALSE
		if(isskeleton(user))
			to_chat(user, span_warning("You've already converted yourself. To convert others, they must be buckled to [religious_tool]."))
			return FALSE
		to_chat(user, span_warning("You're going to convert yourself with this ritual."))
	return ..()

/datum/religion_rites/raise_undead/invoke_effect(mob/living/user, atom/movable/religious_tool)
	if(!istype(religious_tool))
		CRASH("[name]'s perform_rite had a movable atom that has somehow turned into a non-movable!")
	var/mob/living/carbon/human/target
	if(!LAZYLEN(religious_tool.buckled_mobs))
		target = user
	else
		for(var/mob/living/carbon/human/buckled in religious_tool.buckled_mobs)
			target = buckled
			break
	if(!target)
		return FALSE
	target.set_species(/datum/species/skeleton)
	target.visible_message(span_notice("[target] has been converted by the rite of [name]!"))
	return ..()

/datum/religion_rites/raise_dead
	name = "Raise Dead"
	desc = "Revives a buckled dead creature or person."
	ritual_length = 40 SECONDS
	ritual_invocations = list(
		"Rejoin our world ...",
		"... come forth from the beyond ...",
		"... fresh life awaits you ...",
		"... return to us ...",
		"... by the power granted by the gods ...",
		"... you shall rise again ...",
	)
	invoke_msg = "Welcome back to the mortal plain."
	favor_cost = 1000

	var/mob/living/carbon/human/raise_target

/datum/religion_rites/raise_dead/perform_rite(mob/living/user, atom/movable/religious_tool)
	if(!istype(religious_tool))
		to_chat(user, "<span class='warning'>This rite requires a religious device that individuals can be buckled to.</span>")
		return FALSE
	if(!LAZYLEN(religious_tool.buckled_mobs))
		to_chat(user, "<span class='warning'>Nothing is buckled to the altar!</span>")
		return FALSE
	for(var/mob/living/carbon/target in religious_tool.buckled_mobs)
		if(target.stat != DEAD)
			to_chat(user, "<span class='warning'>You can only resurrect dead bodies, this one is still alive!</span>")
			return FALSE
		if(!target.mind)
			to_chat(user, "<span class='warning'>This creature has no soul...")
			return FALSE
		raise_target = target
		raise_target.notify_revival("Your soul is being summoned back to your body by mystical power!", source = src)
		return ..()
	to_chat(user, "<span class='warning'>Only carbon lifeforms can be properly resurrected!</span>")
	return FALSE

/datum/religion_rites/raise_dead/invoke_effect(mob/living/user, atom/movable/religious_tool)
	var/turf/altar_turf = get_turf(religious_tool)
	if(!(raise_target in religious_tool.buckled_mobs))
		to_chat(user, "<span class='warning'>The body is no longer on the altar!</span>")
		raise_target = null
		return FALSE
	if(!raise_target.mind)
		to_chat(user, "<span class='warning'>This creature's soul has left the pool...")
		raise_target = null
		return FALSE
	if(raise_target.stat != DEAD)
		to_chat(user, "<span class='warning'>The target has to stay dead for the rite to work! If they came back without your spiritual guidence... Who knows what could happen!?</span>")
		raise_target = null
		return FALSE
	raise_target.grab_ghost() // Shove them back in their body.
	raise_target.revive(HEAL_ALL) // Revive them.
	playsound(altar_turf, 'sound/magic/staff_healing.ogg', 50, TRUE)
	raise_target = null
	return ..()

/datum/religion_rites/living_sacrifice
	name = "Living Sacrifice"
	desc = "Sacrifice a non-sentient living buckled creature for favor."
	ritual_length = 25 SECONDS
	ritual_invocations = list(
		"To offer this being unto the gods ...",
		"... to feed them with its soul ...",
		"... so that they may consume all within their path ...",
		"... release their binding on this mortal plane ...",
		"... I offer you this living being ...",
	)
	invoke_msg = "... may it join the horde of undead, and become one with the souls of the damned. "

	var/mob/living/carbon/chosen_sacrifice

/datum/religion_rites/living_sacrifice/perform_rite(mob/living/user, atom/movable/religious_tool)
	if(!istype(religious_tool))
		to_chat(user, span_warning("This rite requires a religious device that individuals can be buckled to."))
		return FALSE
	if(!LAZYLEN(religious_tool.buckled_mobs))
		to_chat(user, span_warning("Nothing is buckled to the altar!"))
		return FALSE
	for(var/mob/living/carbon/corpse in religious_tool.buckled_mobs)
		chosen_sacrifice = corpse
		if(chosen_sacrifice.stat == DEAD)
			to_chat(user, span_warning("You can only sacrifice dead bodies, this one is still alive!"))
			return FALSE
		return ..()
	to_chat(user, span_warning("Only carbon lifeforms are accepted as sacrifices!"))
	return FALSE

/datum/religion_rites/living_sacrifice/invoke_effect(mob/living/user, atom/movable/religious_tool)
	var/turf/altar_turf = get_turf(religious_tool)
	if(!(chosen_sacrifice in religious_tool.buckled_mobs)) // checks one last time if the right creature is still buckled
		to_chat(user, "<span class='warning'>The right sacrifice is no longer on the altar!</span>")
		chosen_sacrifice = null
		return FALSE
	if(chosen_sacrifice.stat == DEAD)
		to_chat(user, "<span class='warning'>The sacrifice is no longer alive, it needs to be alive until the end of the rite!</span>")
		chosen_sacrifice = null
		return FALSE
	var/favor_gained = 200 + round(chosen_sacrifice.health * 2)
	GLOB.religious_sect?.adjust_favor(favor_gained, user)
	new /obj/effect/temp_visual/cult/blood/out(altar_turf)
	to_chat(user, "<span class='notice'>[GLOB.deity] absorbs [chosen_sacrifice], leaving blood and gore in its place. [GLOB.deity] rewards you with [favor_gained] favor.</span>")
	chosen_sacrifice.gib(TRUE, FALSE, TRUE)
	playsound(get_turf(religious_tool), 'sound/effects/bamf.ogg', 50, TRUE)
	chosen_sacrifice = null
	return ..()

/**** Carp Sect ****/

/datum/religion_rites/summon_carp
	name = "Summon Carp"
	desc = "Creates a Sentient Space Carp, if a soul is willing to take it. If not, the favor is refunded."
	ritual_length = 50 SECONDS
	ritual_invocations = list(
		"Grant us a new follower ...",
		"... let them enter our realm ...",
		"... become one with our world ...",
		"... to swim in our space ...",
		"... and help our cause ...",
	)
	invoke_msg = "... We summon thee, Holy Carp!"
	favor_cost = 500

/datum/religion_rites/summon_carp/invoke_effect(mob/living/user, atom/movable/religious_tool)
	var/turf/altar_turf = get_turf(religious_tool)
	new /obj/effect/temp_visual/bluespace_fissure(altar_turf)
	user.visible_message("<span class'notice'>A tear in reality appears above the altar!</span>")
	var/list/candidates = SSpolling.poll_ghost_candidates("Do you wish to be summoned as a Holy Carp?", ROLE_SENTIENCE, null, 10 SECONDS, POLL_IGNORE_SENTIENCE_POTION)
	if(!length(candidates))
		new /obj/effect/gibspawner/generic(altar_turf)
		user.visible_message("<span class='warning'>The carp pool was not strong enough to bring forth a space carp.")
		GLOB.religious_sect?.adjust_favor(400, user)
		return NOT_ENOUGH_PLAYERS
	var/mob/dead/observer/selected = pick_n_take(candidates)
	var/datum/mind/M = new /datum/mind(selected.key)
	var/carp_specie = pick(/mob/living/basic/carp/mega, /mob/living/basic/carp)
	var/mob/living/basic/carp = new carp_specie(altar_turf)
	carp.name = "Holy Space-Carp ([rand(1,999)])"
	carp.maxHealth += 75
	carp.health += 75
	M.transfer_to(carp)
	if(GLOB.religion)
		carp.mind?.holy_role = HOLY_ROLE_PRIEST
		to_chat(carp, "There is already an established religion onboard the station. You are an acolyte of [GLOB.deity]. Defer to the Chaplain.")
		GLOB.religious_sect?.on_conversion(carp)
	if(is_special_character(user))
		to_chat(carp, "<span class='userdanger'>You are grateful to have been summoned into this word by [user]. Serve [user.real_name], and assist [user.p_them()] in completing [user.p_their()] goals at any cost.</span>")
	else
		to_chat(carp, "<span class='big notice'>You are grateful to have been summoned into this world. You are now a member of this station's crew, Try not to cause any trouble.</span>")
	playsound(altar_turf, 'sound/effects/slosh.ogg', 50, TRUE)
	return ..()

/datum/religion_rites/flood_area
	name = "Flood Area"
	desc = "Flood the area with water vapor, great for learning to swim!"
	ritual_length = 25 SECONDS
	ritual_invocations = list(
		"We must swim ...",
		"... but to do so, we need water ...",
		"... grant us a great flood ...",
		"... soak us in your glory ...",
		"... we shall swim forever ...",
	)
	invoke_msg = "... in our own personal ocean."
	favor_cost = 200

/datum/religion_rites/flood_area/invoke_effect(mob/living/user, atom/movable/religious_tool)
	var/turf/open/T = get_turf(religious_tool)
	if(istype(T))
		T.atmos_spawn_air("water_vapor=5000;TEMP=255")
	return ..()

/**** Nature Sect ****/

/datum/religion_rites/summon_animals
	name = "Create Life"
	desc = "Creates a few animals, this can range from butterflys to giant frogs! Please be careful."
	ritual_length = 30 SECONDS
	ritual_invocations = list(
		"Great Mother ...",
		"... bring us new life ...",
		"... to join with our nature ...",
		"... and live amongst us ...",
	)
	invoke_msg = "... We summon thee, Animals from the Byond!" // might adjust to beyond due to ooc/ic/meta
	favor_cost = 500

/datum/religion_rites/summon_animals/perform_rite(mob/living/user, atom/religious_tool)
	var/turf/altar_turf = get_turf(religious_tool)
	new /obj/effect/temp_visual/bluespace_fissure(altar_turf)
	user.visible_message("<span class'notice'>A tear in reality begins forming above the altar!</span>")
	return ..()

/datum/religion_rites/summon_animals/invoke_effect(mob/living/user, atom/religious_tool)
	var/turf/altar_turf = get_turf(religious_tool)
	new /obj/effect/temp_visual/bluespace_fissure(altar_turf)
	user.visible_message("<span class'notice'>A tear in reality begins forms above the altar!</span>")
	for(var/i in 1 to 8)
		var/mob/living/simple_animal/S = create_random_mob(altar_turf, FRIENDLY_SPAWN)
		S.faction |= "neutral"
	playsound(altar_turf, 'sound/ambience/servicebell.ogg', 25, TRUE)
	if(prob(0.1))
		playsound(altar_turf, 'sound/effects/bamf.ogg', 100, TRUE)
		altar_turf.visible_message("<span class='boldwarning'>A large form seems to be forcing its way into your reality via the portal [user] opened! RUN!!!</span>")
		new /mob/living/basic/leaper(altar_turf)
	return ..()

/datum/religion_rites/create_podperson
	name = "Nature Conversion"
	desc = "Convert a human-esque individual into a being of nature. Buckle a human to convert them, otherwise it will convert you."
	ritual_length = 30 SECONDS
	ritual_invocations = list(
		"By the power of nature ...",
		"... We call upon you, in this time of need ...",
		"... to merge us with all that is natural ...",
	)
	invoke_msg = "... May the grass be greener on the other side, show us what it means to be one with nature!!"
	favor_cost = 300

/datum/religion_rites/create_podperson/perform_rite(mob/living/user, atom/movable/religious_tool)
	if(!istype(religious_tool))
		to_chat(user, span_warning("This rite requires a religious device that individuals can be buckled to."))
		return FALSE
	if(LAZYLEN(religious_tool.buckled_mobs))
		to_chat(user, span_warning("You're going to convert the one buckled on [religious_tool]."))
	else
		if(!religious_tool.can_buckle) // yes, if you have somehow managed to have someone buckled to something that now cannot buckle, we will still let you perform the rite!
			to_chat(user, span_warning("This rite requires a religious device that individuals can be buckled to."))
			return FALSE
		if(ispodperson(user))
			to_chat(user, span_warning("You've already converted yourself. To convert others, they must be buckled to [religious_tool]."))
			return FALSE
		to_chat(user, span_warning("You're going to convert yourself with this ritual."))
	return ..()

/datum/religion_rites/create_podperson/invoke_effect(mob/living/user, atom/movable/religious_tool)
	if(!istype(religious_tool))
		CRASH("[name]'s perform_rite had a movable atom that has somehow turned into a non-movable!")
	var/mob/living/carbon/human/target
	if(!LAZYLEN(religious_tool.buckled_mobs))
		target = user
	else
		for(var/mob/living/carbon/human/buckled in religious_tool.buckled_mobs)
			target = buckled
			break
	if(!target)
		return FALSE
	target.set_species(/datum/species/pod)
	target.visible_message(span_notice("[target] has been converted by the rite of [name]!"))
	return ..()

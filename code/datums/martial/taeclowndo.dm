/datum/action/cooldown/spell/conjure_item/summon_pie
	name = "Summon Creampie"
	desc = "A clown's weapon of choice.  Use this to summon a fresh pie, just waiting to acquaintain itself with someone's face."
	invocation_type = "none"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_HANDS_BLOCKED
	cooldown_time = 30 SECONDS
	button_icon = 'icons/obj/food/piecake.dmi'
	button_icon_state = "pie"
	spell_max_level = 1
	item_type = /obj/item/food/pie/cream

/datum/action/cooldown/spell/conjure_item/summon_pie/can_cast_spell(feedback = FALSE)
	return TRUE

/datum/action/cooldown/spell/pointed/banana_peel
	name = "Conjure Banana Peel"
	desc = "Make a banana peel appear out of thin air right under someone's feet!"
	button_icon = 'icons/obj/hydroponics/harvest.dmi'
	button_icon_state = "banana_peel"
	spell_max_level = 1
	cooldown_time = 10 SECONDS
	invocation_type = "none"
	active_msg = "You focus, your mind reaching to the clown dimension, ready to make a peel matrialize wherever you want!"
	deactive_msg = "You relax, the peel remaining right in the \"thin air\" it would appear out of."
	cast_range = 8

/datum/action/cooldown/spell/pointed/banana_peel/InterceptClickOn(mob/living/caller, params, atom/click_target)
	. = ..()
	var/target = get_turf(click_target)
	if(get_dist(caller,target)>cast_range)
		to_chat(caller, "<span class='notice'>\ Target is too far away!</span>")
		return
	new /obj/item/grown/bananapeel(target)

/datum/action/cooldown/spell/pointed/banana_peel/can_cast_spell(feedback = FALSE)
	return TRUE

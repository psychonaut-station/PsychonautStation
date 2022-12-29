/datum/antagonist/ntagent
	name = "\improper NT Agent"
	antag_hud_name = "ntagent"
	antagpanel_category = "Nanotrasen"
	show_name_in_check_antagonists = TRUE
	job_rank = ROLE_NT_AGENT
	show_to_ghosts = FALSE
	antag_moodlet = /datum/mood_event/focused
	preview_outfit = /datum/outfit/ntagent
	suicide_cry = "Syndicate i sikeyim!!!"

/datum/antagonist/ntagent/on_gain()
	. = ..()
	give_objective()
	ntagent_equipt_items()
	give_mindshield()

/datum/antagonist/ntagent/greet()
	. = ..()
	to_chat(owner, span_boldannounce("Sen bir Nanotrasen ajanısın. Amacın istasyonda bir tehlike söz konusu olursa o tehlikenin peşine düşmektir. Onun dışında istasyonda mesleğini yerine getirmek zorundasın. Eğer üstünde olmaması gereken bir şey ile security e yakalanırsan asla ve asla Nanotrasen ajanı olduğunu söylememelisin. Unutma ajan, ölmek de görevinin bir parçası."))
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/nanoagent.ogg', 200, FALSE, pressure_affected = FALSE, use_reverb = FALSE)

/datum/antagonist/ntagent/proc/ntagent_equipt_items(mob/living/carbon/human/ntagent = owner.current)
	return ntagent.equipOutfit(/datum/outfit/ntagent)

/datum/antagonist/ntagent/proc/give_objective()
	var/datum/objective/NTobjec = new()
	NTobjec.explanation_text = "Istasyonda bir tehlike var ise peşine düş ve kimliğini gizle."
	NTobjec.completed = TRUE
	NTobjec.owner = owner
	objectives |= NTobjec

/datum/antagonist/ntagent/proc/give_mindshield(mob/living/carbon/human/ntagent = owner.current)
	ADD_TRAIT(ntagent, TRAIT_MINDSHIELD, ROUNDSTART_TRAIT)

/datum/outfit/ntagent
	name = "Nanotrasen Agent"
	implants = list(/obj/item/implant/explosive,/obj/item/implant/nanouplink/starting)
	back = /obj/item/mod/control/pre_equipped/empty/ntagentmod
	l_hand = /obj/item/gun/energy/e_gun/advtaser
	r_hand = /obj/item/melee/energy/sword/saber/blue

/datum/outfit/ntagent/post_equip(mob/living/carbon/human/H, visualsOnly)
	var/obj/item/mod/module/armor_booster/booster = locate() in H.back
	booster.active = TRUE
	H.update_worn_back()

	var/obj/item/melee/energy/sword/sword = locate() in H.held_items
	if(sword.flags_1 & INITIALIZED_1)
		sword.attack_self()
	else //Atoms aren't initialized during the screenshots unit test, so we can't call attack_self for it as the sword doesn't have the transforming weapon component to handle the icon changes. The below part is ONLY for the antag screenshots unit test.
		sword.icon_state = "e_sword_on_blue"
		sword.inhand_icon_state = "e_sword_on_blue"
		sword.worn_icon_state = "e_sword_on_blue"
		H.update_held_items()
	//H.update_held_items()

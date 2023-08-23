#define ROBOTIC_LIGHT_BRUTE_MSG "marred"
#define ROBOTIC_MEDIUM_BRUTE_MSG "dented"
#define ROBOTIC_HEAVY_BRUTE_MSG "falling apart"

#define ROBOTIC_LIGHT_BURN_MSG "scorched"
#define ROBOTIC_MEDIUM_BURN_MSG "charred"
#define ROBOTIC_HEAVY_BURN_MSG "smoldering"

/obj/item/bodypart/head/ipc
	icon = 'icons/mob/human/species/ipc/bodyparts.dmi'
	icon_static = 'icons/mob/human/species/ipc/bodyparts.dmi'
	disabled_wound_penalty = 10
	icon_state = "blackipc_head"
	limb_id = "blackipc"
	attack_verb_simple = list("slapped", "punched")
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC | BODYTYPE_IPC
	brute_modifier = 1
	burn_modifier = 1.3
	dmg_overlay_type = "robotic"
	head_flags = NONE
	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG
	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT, CLONE = DEFAULT_CLONE_EXAMINE_TEXT)

/obj/item/bodypart/head/ipc/receive_damage(brute = 0, burn = 0, blocked = 0, updating_health = TRUE, required_bodytype = null, wound_bonus = 0, bare_wound_bonus = 0, sharpness = NONE, attack_direction = null, damage_source)
	. = ..()
	if(brute > 0 && prob(10) && owner)
		new /obj/effect/decal/cleanable/oil(owner.loc)
	if(owner)
		var/partdamage = get_damage()
		if(75 <= partdamage)
			if(prob(50))
				return drop_limb()

/obj/item/bodypart/head/ipc/emp_act(severity)
	. = ..()
	if(!.)
		return
	to_chat(owner, span_danger("Your [src.name]'s optical transponders glitch out and malfunction!"))

	var/glitch_duration = severity == EMP_HEAVY ? 15 SECONDS : 7.5 SECONDS

	owner.add_client_colour(/datum/client_colour/malfunction)

	addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living/carbon/human, remove_client_colour), /datum/client_colour/malfunction), glitch_duration)

/obj/item/bodypart/chest/ipc
	icon = 'icons/mob/human/species/ipc/bodyparts.dmi'
	icon_static = 'icons/mob/human/species/ipc/bodyparts.dmi'
	icon_state = "blackipc_chest"
	limb_id = "blackipc"
	attack_verb_simple = list("slapped", "punched")
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC | BODYTYPE_IPC
	brute_modifier = 1
	burn_modifier = 1.3
	dmg_overlay_type = "robotic"
	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT, CLONE = DEFAULT_CLONE_EXAMINE_TEXT)

/obj/item/bodypart/chest/ipc/receive_damage(brute = 0, burn = 0, blocked = 0, updating_health = TRUE, required_bodytype = null, wound_bonus = 0, bare_wound_bonus = 0, sharpness = NONE, attack_direction = null, damage_source)
	. = ..()
	if(brute > 0 && prob(10) && owner)
		new /obj/effect/decal/cleanable/oil(owner.loc)

/obj/item/bodypart/chest/ipc/emp_act(severity)
	. = ..()
	if(!.)
		return
	to_chat(owner, span_danger("Your [src.name]'s logic boards temporarily become unresponsive!"))
	if(severity == EMP_HEAVY)
		owner.Stun(6 SECONDS)
		owner.Shake(pixelshiftx = 5, pixelshifty = 2, duration = 4 SECONDS)
		return

	owner.Stun(3 SECONDS)
	owner.Shake(pixelshiftx = 3, pixelshifty = 0, duration = 2.5 SECONDS)

/obj/item/bodypart/arm/left/ipc
	icon = 'icons/mob/human/species/ipc/bodyparts.dmi'
	icon_static = 'icons/mob/human/species/ipc/bodyparts.dmi'
	icon_state = "blackipc_l_arm"
	limb_id = "blackipc"
	attack_verb_simple = list("kicked", "stomped")
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC | BODYTYPE_IPC
	brute_modifier = 1
	burn_modifier = 1.3
	dmg_overlay_type = "robotic"
	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT, CLONE = DEFAULT_CLONE_EXAMINE_TEXT)

/obj/item/bodypart/arm/left/ipc/receive_damage(brute = 0, burn = 0, blocked = 0, updating_health = TRUE, required_bodytype = null, wound_bonus = 0, bare_wound_bonus = 0, sharpness = NONE, attack_direction = null, damage_source)
	. = ..()
	if(brute > 0 && prob(10) && owner)
		new /obj/effect/decal/cleanable/oil(owner.loc)

/obj/item/bodypart/arm/right/ipc
	icon = 'icons/mob/human/species/ipc/bodyparts.dmi'
	icon_static = 'icons/mob/human/species/ipc/bodyparts.dmi'
	icon_state = "blackipc_r_arm"
	limb_id = "blackipc"
	attack_verb_simple = list("kicked", "stomped")
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC | BODYTYPE_IPC
	brute_modifier = 1
	burn_modifier = 1.3
	dmg_overlay_type = "robotic"
	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT, CLONE = DEFAULT_CLONE_EXAMINE_TEXT)

/obj/item/bodypart/arm/right/ipc/receive_damage(brute = 0, burn = 0, blocked = 0, updating_health = TRUE, required_bodytype = null, wound_bonus = 0, bare_wound_bonus = 0, sharpness = NONE, attack_direction = null, damage_source)
	. = ..()
	if(brute > 0 && prob(10) && owner)
		new /obj/effect/decal/cleanable/oil(owner.loc)

/obj/item/bodypart/leg/left/ipc
	icon = 'icons/mob/human/species/ipc/bodyparts.dmi'
	icon_static = 'icons/mob/human/species/ipc/bodyparts.dmi'
	icon_state = "blackipc_l_leg"
	limb_id = "blackipc"
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC | BODYTYPE_IPC
	brute_modifier = 1
	burn_modifier = 1.3
	dmg_overlay_type = "robotic"
	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT, CLONE = DEFAULT_CLONE_EXAMINE_TEXT)

/obj/item/bodypart/leg/left/ipc/receive_damage(brute = 0, burn = 0, blocked = 0, updating_health = TRUE, required_bodytype = null, wound_bonus = 0, bare_wound_bonus = 0, sharpness = NONE, attack_direction = null, damage_source)
	. = ..()
	if(brute > 0 && prob(10) && owner)
		new /obj/effect/decal/cleanable/oil(owner.loc)

/obj/item/bodypart/leg/left/ipc/emp_act(severity)
	. = ..()
	if(!.)
		return
	owner.Knockdown(severity == EMP_HEAVY ? 20 SECONDS : 10 SECONDS)
	if(owner.incapacitated(IGNORE_RESTRAINTS|IGNORE_GRAB)) // So the message isn't duplicated. If they were stunned beforehand by something else, then the message not showing makes more sense anyways.
		return
	to_chat(owner, span_danger("As your [src.name] unexpectedly malfunctions, it causes you to fall to the ground!"))

/obj/item/bodypart/leg/right/ipc
	icon = 'icons/mob/human/species/ipc/bodyparts.dmi'
	icon_static = 'icons/mob/human/species/ipc/bodyparts.dmi'
	icon_state = "blackipc_r_leg"
	limb_id = "blackipc"
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ROBOTIC | BODYTYPE_IPC
	brute_modifier = 1
	burn_modifier = 1.3
	dmg_overlay_type = "robotic"
	light_brute_msg = ROBOTIC_LIGHT_BRUTE_MSG
	medium_brute_msg = ROBOTIC_MEDIUM_BRUTE_MSG
	heavy_brute_msg = ROBOTIC_HEAVY_BRUTE_MSG

	light_burn_msg = ROBOTIC_LIGHT_BURN_MSG
	medium_burn_msg = ROBOTIC_MEDIUM_BURN_MSG
	heavy_burn_msg = ROBOTIC_HEAVY_BURN_MSG

	damage_examines = list(BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT, BURN = ROBOTIC_BURN_EXAMINE_TEXT, CLONE = DEFAULT_CLONE_EXAMINE_TEXT)

/obj/item/bodypart/leg/right/ipc/receive_damage(brute = 0, burn = 0, blocked = 0, updating_health = TRUE, required_bodytype = null, wound_bonus = 0, bare_wound_bonus = 0, sharpness = NONE, attack_direction = null, damage_source)
	. = ..()
	if(brute > 0 && prob(10) && owner)
		new /obj/effect/decal/cleanable/oil(owner.loc)

/obj/item/bodypart/leg/right/ipc/emp_act(severity)
	. = ..()
	if(!.)
		return
	owner.Knockdown(severity == EMP_HEAVY ? 20 SECONDS : 10 SECONDS)
	if(owner.incapacitated(IGNORE_RESTRAINTS|IGNORE_GRAB)) // So the message isn't duplicated. If they were stunned beforehand by something else, then the message not showing makes more sense anyways.
		return
	to_chat(owner, span_danger("As your [src.name] unexpectedly malfunctions, it causes you to fall to the ground!"))

#undef ROBOTIC_LIGHT_BRUTE_MSG
#undef ROBOTIC_MEDIUM_BRUTE_MSG
#undef ROBOTIC_HEAVY_BRUTE_MSG

#undef ROBOTIC_LIGHT_BURN_MSG
#undef ROBOTIC_MEDIUM_BURN_MSG
#undef ROBOTIC_HEAVY_BURN_MSG

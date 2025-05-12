/datum/species/ipc
	name = "\improper IPC"
	id = SPECIES_IPC
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN
	inherent_biotypes = MOB_ROBOTIC | MOB_HUMANOID
	species_language_holder = /datum/language_holder/ipc
	sexes = FALSE
	inherent_traits = list(
		TRAIT_NO_UNDERWEAR,
		TRAIT_GENELESS,
		TRAIT_NOBREATH,
		TRAIT_RESISTCOLD,
		TRAIT_LIVERLESS_METABOLISM,
		TRAIT_RADIMMUNE,
		TRAIT_TOXIMMUNE,
		TRAIT_NO_DNA_COPY,
		TRAIT_XENO_IMMUNE,
		TRAIT_NOHUNGER,
		TRAIT_NOTOOLFLASH,
		TRAIT_VIRUSIMMUNE,
		TRAIT_LIGHTBULB_REMOVER,
		TRAIT_MUTANT_COLORS,
	)
	meat = null
	exotic_blood = /datum/reagent/fuel/oil
	exotic_bloodtype = BLOOD_TYPE_OIL
	siemens_coeff = 0.8
	no_equip_flags = ITEM_SLOT_MASK
	mutant_organs = list(
		/obj/item/organ/voltage_protector,
		/obj/item/organ/cyberimp/arm/power_cord
	)
	mutanteyes = /obj/item/organ/eyes/robotic/basic
	mutantears = /obj/item/organ/ears/cybernetic
	mutanttongue = /obj/item/organ/tongue/robot
	mutantbrain = /obj/item/organ/brain/cybernetic/ipc
	mutantheart = /obj/item/organ/heart/cybernetic/tier2/ipc
	mutantlungs = null
	mutantliver = null
	mutantstomach = /obj/item/organ/stomach/ipc
	mutantappendix = null
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/ipc,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/ipc,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/ipc,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/ipc,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/ipc,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/ipc,
	)
	gibspawner_type = /obj/effect/gibspawner/robot/android
	allow_numbers_in_name = TRUE

/datum/species/ipc/on_species_gain(mob/living/carbon/human/ipc, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	RegisterSignal(ipc, COMSIG_CARBON_ATTEMPT_EAT, PROC_REF(try_eating))

/datum/species/ipc/on_species_loss(mob/living/carbon/human/old_ipc, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(old_ipc, COMSIG_CARBON_ATTEMPT_EAT)

/datum/species/ipc/proc/try_eating(mob/living/carbon/source, atom/eating)
	SIGNAL_HANDLER
	to_chat(source, span_notice("You have no mouth!"))
	INVOKE_ASYNC(source, TYPE_PROC_REF(/mob, emote), "scream")
	return COMSIG_CARBON_BLOCK_EAT

/datum/species/ipc/spec_life(mob/living/carbon/human/H, seconds_per_tick, times_fired)
	. = ..()
	if(H.health < H.crit_threshold && !HAS_TRAIT(H, TRAIT_NOCRITDAMAGE))
		H.adjustBruteLoss(1.5 * seconds_per_tick)

/datum/species/ipc/wash(mob/living/carbon/human/H)
	. = FALSE
	var/chest_covered = FALSE
	var/head_covered = FALSE
	for(var/obj/item/clothing/equipped in H.get_equipped_items())
		if((equipped.body_parts_covered & CHEST) && (equipped.get_armor_rating(BIO) == 100))
			chest_covered = TRUE
		if((equipped.body_parts_covered & HEAD) && (equipped.get_armor_rating(BIO) == 100))
			head_covered = TRUE
		if(head_covered && chest_covered)
			break
	if(!chest_covered || !head_covered)
		var/obj/item/organ/heart/heart = H.get_organ_slot(ORGAN_SLOT_HEART)
		if(heart && istype(heart, /obj/item/organ/heart/cybernetic))
			H.adjustFireLoss(rand(1,3))
		else
			H.adjustFireLoss(rand(5,15))
		return TRUE

/datum/species/ipc/randomize_features()
	var/list/features = ..()
	features["ipc_chassis"] = SSaccessories.ipc_chassis_list[pick(SSaccessories.ipc_chassis_list)]
	return features

/datum/species/ipc/get_features()
	var/list/features = ..()

	features += "feature_ipc_chassis"

	return features

/datum/species/ipc/replace_body(mob/living/carbon/target, datum/species/new_species)
	. = ..()
	var/datum/sprite_accessory/ipc_chassis/chassis_of_choice = SSaccessories.ipc_chassis_list[target.dna.features["ipc_chassis"]]
	if(chassis_of_choice)
		for(var/obj/item/bodypart/bodypart as anything in target.bodyparts)
			bodypart.icon = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
			bodypart.change_appearance('icons/psychonaut/mob/human/species/ipc/bodyparts.dmi', chassis_of_choice.icon_state, (chassis_of_choice.color_src == MUTANT_COLOR), FALSE)
			bodypart.update_limb()

/datum/species/ipc/get_species_description()
	return "The newest in artificial life, IPCs are entirely robotic, synthetic life, made of motors, circuits, and wires \
	- based on newly developed Postronic brain technology."

/datum/species/ipc/get_species_lore()
	return list(
		"Positronic intelligence really took off in the 26th century, and it is not uncommon to see independent, free-willed \
		robots on many human stations, particularly in fringe systems where standards are slightly lax and public opinion less relevant \
		to corporate operations.",
		"IPCs (Integrated Positronic Chassis) are a loose category of self-willed robots with a humanoid form, \
		generally self-owned after being 'born' into servitude; they are reliable and dedicated workers, albeit more than slightly \
		inhuman in outlook and perspective."
	)

/datum/species/ipc/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_BOLT,
			SPECIES_PERK_NAME = "Shockingly Tasty",
			SPECIES_PERK_DESC = "IPCs can feed on electricity from APCs, and do not otherwise need to eat.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = FA_ICON_ROBOT,
			SPECIES_PERK_NAME = "Robotic",
			SPECIES_PERK_DESC = "IPCs have an entirely robotic body, meaning medical care is typically done through Robotics or Engineering. \
			Whether this is helpful or not is heavily dependent on your coworkers. It does, however, mean you are usually able to perform self-repairs easily.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_BATTERY_QUARTER,
			SPECIES_PERK_NAME = "Cell Battery",
			SPECIES_PERK_DESC = "If you run out of charge, you can't move.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_MAGNET,
			SPECIES_PERK_NAME = "EMP Vulnerable",
			SPECIES_PERK_DESC = "IPCs organs are cybernetic, and thus susceptible to electromagnetic interference.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_DROPLET,
			SPECIES_PERK_NAME = "Short Circuit",
			SPECIES_PERK_DESC = "IPCs are not resistant to water, water creates a short circuit in IPC's.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_DNA,
			SPECIES_PERK_NAME = "Not Human After All",
			SPECIES_PERK_DESC = "There is no humanity behind the eyes of the Android, and as such, they have no DNA to genetically alter.",
		),
	)

	return to_add

/datum/species/ipc/handle_environment_pressure(mob/living/carbon/human/H, datum/gas_mixture/environment, seconds_per_tick, times_fired)
	. = ..()

	var/pressure = environment.return_pressure()
	var/adjusted_pressure = H.calculate_affecting_pressure(pressure)

	if(adjusted_pressure >= HAZARD_HIGH_PRESSURE && !HAS_TRAIT(H, TRAIT_RESISTHIGHPRESSURE))
		H.adjustBruteLoss(min(((adjusted_pressure / HAZARD_HIGH_PRESSURE) - 1) * PRESSURE_DAMAGE_COEFFICIENT, MAX_HIGH_PRESSURE_DAMAGE) * 1.5 * H.physiology.pressure_mod * seconds_per_tick, required_bodytype = BODYTYPE_ORGANIC | BODYTYPE_IPC)
	else if(adjusted_pressure < HAZARD_LOW_PRESSURE && !HAS_TRAIT(H, TRAIT_RESISTLOWPRESSURE))
		H.adjustBruteLoss(LOW_PRESSURE_DAMAGE * 1.5 * H.physiology.pressure_mod * seconds_per_tick, required_bodytype = BODYTYPE_ORGANIC | BODYTYPE_IPC)

////////////////////////////////////// ORGANS //////////////////////////////////////
// Voltage Protector Organ
/obj/item/organ/voltage_protector
	name = "high voltage protector"
	desc = "This organ regulates the high electrical voltage coming into your body."
	icon_state = "implant-power"
	slot = ORGAN_SLOT_VOLTPROTECT
	organ_flags = ORGAN_ROBOTIC
	zone = BODY_ZONE_CHEST

/obj/item/organ/voltage_protector/on_mob_insert(mob/living/carbon/owner)
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT, PROC_REF(on_electrocute))

/obj/item/organ/voltage_protector/on_mob_remove(mob/living/carbon/owner)
	. = ..()
	UnregisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT)

/obj/item/organ/voltage_protector/proc/on_electrocute(datum/source, shock_damage, siemens_coeff = 1, flags = NONE)
	SIGNAL_HANDLER
	if(flags & SHOCK_ILLUSION)
		return
	owner.apply_damages(brain = 10)

/obj/item/organ/cyberimp/arm/power_cord
	name = "power cord implant"
	desc = "An internal power cord hooked up to a battery. Useful if you run on volts."
	items_to_create = list(/obj/item/apc_powercord)
	slot = ORGAN_SLOT_RIGHT_ARM_AUG

////////////////////////////////////// ITEMS //////////////////////////////////////

/obj/item/apc_powercord
	name = "power cord"
	desc = "An internal power cord hooked up to a battery. Useful if you run on electricity. Not so much otherwise."
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "wire1"

/obj/item/apc_powercord/Initialize(mapload)
	. = ..()
	register_item_context()

/obj/item/apc_powercord/add_item_context(datum/source, list/context, atom/target, mob/living/user)
	if (!isapc(target))
		return NONE

	context[SCREENTIP_CONTEXT_LMB] = "Drain Power"
	context[SCREENTIP_CONTEXT_RMB] = "Transfer Power"

	return CONTEXTUAL_SCREENTIP_SET

/obj/item/apc_powercord/afterattack(atom/target, mob/user, click_parameters)
	if(!isapc(target) || !ishuman(user) || !target.Adjacent(user))
		return ..()
	user.changeNext_move(CLICK_CD_MELEE)
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/stomach/ipc/stomach = H.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(!istype(stomach))
		to_chat(H, span_warning("There is nothing in your body to charge."))
	if(!stomach?.cell)
		to_chat(H, span_warning("You try to siphon energy from \the [target], but your power cell is gone!"))
		return

	if(istype(H) && H.nutrition >= NUTRITION_LEVEL_ALMOST_FULL)
		to_chat(user, span_warning("You are already fully charged!"))
		return

	if(istype(target, /obj/machinery/power/apc))
		var/obj/machinery/power/apc/A = target
		if(A.cell)
			A.ipc_interact(H, click_parameters)
			H.diag_hud_set_humancell()
			return
		else
			to_chat(user, span_warning("There is not enough charge to draw from that APC."))
			return

////////////////////////////////////////////////////////////////////////////////////////
/datum/action/innate/change_monitor
	name = "Change Monitor Emote"
	check_flags = NONE
	button_icon_state = "ipc_monitor"
	button_icon = 'icons/psychonaut/mob/actions/actions_silicon.dmi'
	background_icon_state = "bg_tech"
	overlay_icon_state = "bg_tech_border"
	var/emotion_icon = /datum/bodypart_overlay/simple/ipcscreen

/datum/action/innate/change_monitor/Grant(mob/grant_to)
	. = ..()
	RegisterSignal(grant_to, COMSIG_LIVING_DEATH, PROC_REF(on_dead))
	RegisterSignal(grant_to, COMSIG_LIVING_REVIVE, PROC_REF(on_revive))

/datum/action/innate/change_monitor/Remove(mob/M)
	var/mob/living/carbon/C = M
	if(!istype(C))
		return
	remove_overlay(C)
	UnregisterSignal(C, list(COMSIG_LIVING_DEATH, COMSIG_LIVING_REVIVE))
	return ..()

/datum/action/innate/change_monitor/Activate()
	var/mob/living/carbon/C = owner
	if(!istype(C))
		return
	var/obj/item/bodypart/head/ipc/head = C.get_bodypart(BODY_ZONE_HEAD)
	if(!istype(head))
		return
	var/list/possible_overlays = typesof(/datum/bodypart_overlay/simple/ipcscreen)
	var/list/built_radial_list = list()
	var/list/items = list()
	for(var/datum/bodypart_overlay/simple/ipcscreen/overlay as anything in possible_overlays)
		if(overlay.job && !istype(C.mind.assigned_role, overlay.job))
			continue
		if(overlay.locked && !(head.obj_flags & EMAGGED))
			continue
		var/datum/radial_menu_choice/option = new
		option.image = image(icon = overlay::icon, icon_state = overlay::icon_state)
		if(overlay.locked)
			option.warning = TRUE
		built_radial_list[overlay.name] = option
		items[overlay.name] = overlay
	var/picked_emote = show_radial_menu(C, C, built_radial_list, radius = 36)
	if(isnull(picked_emote))
		return
	emotion_icon = items[picked_emote]
	give_overlay(C, head, items[picked_emote])

/datum/action/innate/change_monitor/proc/give_overlay(mob/living/carbon/C, obj/item/bodypart/bodypart, datum/bodypart_overlay/simple/ipcscreen/overlay_typepath)
	if(!bodypart)
		return null
	remove_overlay(C)
	if(!isnull(overlay_typepath::icon_state))
		var/datum/bodypart_overlay/simple/ipcscreen/overlay = new overlay_typepath()
		if(overlay.locked)
			var/image/holo_animation = image('icons/psychonaut/mob/human/species/ipc/ipc_screens.dmi', C, "hologram")
			flick_overlay_global(holo_animation, GLOB.clients, 0.6 SECONDS)
		bodypart.add_bodypart_overlay(overlay)
	C.update_body_parts()
	return

/datum/action/innate/change_monitor/proc/remove_overlay(mob/living/carbon/C)
	var/obj/item/bodypart/bodypart = C.get_bodypart(BODY_ZONE_HEAD)
	if(!bodypart)
		return
	var/datum/bodypart_overlay/simple/ipcscreen/overlay = (locate(/datum/bodypart_overlay/simple/ipcscreen) in bodypart.bodypart_overlays)
	if(overlay)
		bodypart.remove_bodypart_overlay(overlay)
		qdel(overlay)
	C.update_body_parts()

/datum/action/innate/change_monitor/proc/on_dead(mob/living/carbon/C, gibbed)
	SIGNAL_HANDLER
	if(!istype(C))
		return
	var/obj/item/bodypart/head/ipc/head = C.get_bodypart(BODY_ZONE_HEAD)
	if(!istype(head))
		return
	give_overlay(C, head, /datum/bodypart_overlay/simple/ipcscreen/ipcdead)

/datum/action/innate/change_monitor/proc/on_revive(mob/living/carbon/C)
	SIGNAL_HANDLER
	if(!istype(C))
		return
	var/obj/item/bodypart/head/ipc/head = C.get_bodypart(BODY_ZONE_HEAD)
	if(!istype(head))
		return
	give_overlay(C, head, emotion_icon)

//Screen
/datum/bodypart_overlay/simple/ipcscreen
	icon = 'icons/psychonaut/mob/human/species/ipc/ipc_screens.dmi'
	layers = EXTERNAL_ADJACENT
	var/name = "Off"
	var/attached_body_zone = BODY_ZONE_HEAD
	var/datum/job/job = null
	var/locked = FALSE

/datum/bodypart_overlay/simple/ipcscreen/ipcsmile
	name = "Smile"
	icon_state = "smile"

/datum/bodypart_overlay/simple/ipcscreen/ipcuwu
	name = "Uwu"
	icon_state = "uwu"

/datum/bodypart_overlay/simple/ipcscreen/ipcstare
	name = "Stare"
	icon_state = "stare"

/datum/bodypart_overlay/simple/ipcscreen/ipcalert
	name = "Alert"
	icon_state = "alert"

/datum/bodypart_overlay/simple/ipcscreen/ipccool
	name = "Cool"
	icon_state = "cool"

/datum/bodypart_overlay/simple/ipcscreen/ipcdead
	name = "Dead"
	icon_state = "dead"

/datum/bodypart_overlay/simple/ipcscreen/ipcnt
	name = "Nanotrasen"
	icon_state = "nt"

/datum/bodypart_overlay/simple/ipcscreen/ipcheartline
	name = "Heart Line"
	icon_state = "heartline"

/datum/bodypart_overlay/simple/ipcscreen/ipcreddot
	name = "Red Dot"
	icon_state = "reddot"

/datum/bodypart_overlay/simple/ipcscreen/ipcturk
	name = "Turk"
	icon_state = "turk"

/datum/bodypart_overlay/simple/ipcscreen/ipcclown
	name = "Clown"
	icon_state = "clown"
	job = /datum/job/clown

/datum/bodypart_overlay/simple/ipcscreen/ipcmime
	name = "Mime"
	icon_state = "mime"
	job = /datum/job/mime

/datum/bodypart_overlay/simple/ipcscreen/ipcpinball
	name = "Pinball"
	icon_state = "pinball"

/datum/bodypart_overlay/simple/ipcscreen/ipcnoerp
	name = "No Erp"
	icon_state = "noerp"

/datum/bodypart_overlay/simple/ipcscreen/ipcpaicat
	name = "Cat"
	icon_state = "paicat"

/datum/bodypart_overlay/simple/ipcscreen/ipcskull
	name = "Skull"
	icon_state = "skull"

/datum/bodypart_overlay/simple/ipcscreen/ipcmonkey
	name = "Monkey"
	icon_state = "monkey"

/datum/bodypart_overlay/simple/ipcscreen/ipcnerd
	name = "Nerd"
	icon_state = "nerd"

/datum/bodypart_overlay/simple/ipcscreen/gasmask
	name = "Gas Mask"
	icon_state = "gas-mask"

/datum/bodypart_overlay/simple/ipcscreen/breath
	name = "Breath"
	icon_state = "breath"

/datum/bodypart_overlay/simple/ipcscreen/angry
	name = "Angry"
	icon_state = "angry"

/datum/bodypart_overlay/simple/ipcscreen/flushed
	name = "Flushed"
	icon_state = "flushed"

/datum/bodypart_overlay/simple/ipcscreen/pleading
	name = "Pleading"
	icon_state = "pleading"

/datum/bodypart_overlay/simple/ipcscreen/joy
	name = "Joy"
	icon_state = "joy"

/datum/bodypart_overlay/simple/ipcscreen/monoeye
	name = "Mono Eye"
	icon_state = "monoeye"

/datum/bodypart_overlay/simple/ipcscreen/heart
	name = "Heart"
	icon_state = "heart"

/datum/bodypart_overlay/simple/ipcscreen/syndicate
	name = "Syndicate"
	icon = 'icons/mob/clothing/mask.dmi'
	icon_state = "syndicate"
	locked = TRUE

/datum/bodypart_overlay/simple/ipcscreen/facehugger
	name = "Facehugger"
	icon = 'icons/mob/clothing/mask.dmi'
	icon_state = "facehugger"
	locked = TRUE

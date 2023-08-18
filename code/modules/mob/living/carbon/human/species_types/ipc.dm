/datum/species/ipc
	name = "\improper Ipc"
	id = SPECIES_IPC
	examine_limb_id = SPECIES_HUMAN
	inherent_traits = list(
		TRAIT_NO_UNDERWEAR,
		TRAIT_CAN_USE_FLIGHT_POTION,
		TRAIT_GENELESS,
		TRAIT_NOBREATH,
		TRAIT_NOCLONELOSS,
		TRAIT_RESISTCOLD,
		TRAIT_NOFIRE,
		TRAIT_LIVERLESS_METABOLISM,
		TRAIT_PIERCEIMMUNE,
		TRAIT_VIRUSIMMUNE,
		TRAIT_RADIMMUNE,
		TRAIT_TOXIMMUNE,
		TRAIT_NOBLOOD,
		TRAIT_NO_DNA_COPY,
		TRAIT_NO_TRANSFORMATION_STING,
		TRAIT_XENO_IMMUNE,
		TRAIT_NOHUNGER,
		TRAIT_NOTOOLFLASH,
	)
	ass_image = 'icons/ass/assmachine.png'
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	meat = null
	mutantbrain = /obj/item/organ/internal/brain/basic_posibrain
	mutanttongue = /obj/item/organ/internal/tongue/robot
	mutantstomach = /obj/item/organ/internal/stomach/ipc/high
	mutantappendix = null
	mutantheart = null
	mutantliver = null
	mutantlungs = null
	mutanteyes = /obj/item/organ/internal/eyes/robotic/basic
	mutantears = /obj/item/organ/internal/ears/cybernetic
	mutant_organs = list(/obj/item/organ/internal/voltprotector)
	external_organs = list(
		/obj/item/organ/external/ipchead = "Blackhead",
	)
	species_language_holder = /datum/language_holder/synthetic
	wing_types = list(/obj/item/organ/external/wings/functional/robotic)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	no_equip_flags = ITEM_SLOT_MASK
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/ipc,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/ipc,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/ipc,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/ipc,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/ipc,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/ipc,
	)
	var/emageffect = FALSE

/datum/species/ipc/random_name(gender,unique,lastname)
	var/randname = "[pick(GLOB.posibrain_names)] [rand(1,999)]"
	return randname

/datum/species/ipc/on_species_gain(mob/living/carbon/C)
	. = ..()
	RegisterSignal(C, COMSIG_ATOM_EMAG_ACT, PROC_REF(on_emag_act))
	RegisterSignal(C, COMSIG_CARBON_ATTEMPT_EAT, PROC_REF(try_eating))
	var/obj/item/organ/internal/brain/brain = C.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(brain && brain.zone != BODY_ZONE_CHEST)
		brain.zone = BODY_ZONE_CHEST
	C.set_safe_hunger_level()

/datum/species/ipc/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_ATOM_EMAG_ACT)
	UnregisterSignal(C, COMSIG_CARBON_ATTEMPT_EAT)

/datum/species/ipc/proc/try_eating(mob/living/carbon/source, atom/eating)
	SIGNAL_HANDLER
	source.balloon_alert(source, "You dont have a mouth!")
	INVOKE_ASYNC(source, TYPE_PROC_REF(/mob, emote), "scream")
	return COMSIG_CARBON_BLOCK_EAT

/datum/species/ipc/spec_life(mob/living/carbon/human/H, seconds_per_tick, times_fired)
	. = ..()
	if(H.health < H.crit_threshold && !HAS_TRAIT(H, TRAIT_NOCRITDAMAGE))
		H.adjustBruteLoss(1.5 * seconds_per_tick)

/datum/species/ipc/proc/on_emag_act(mob/living/carbon/human/H, mob/user)
	SIGNAL_HANDLER
	if(emageffect)
		return FALSE
	emageffect = TRUE
	if(user)
		to_chat(user, span_notice("You tap [H] on the back with your card."))
	H.visible_message(span_danger("2 protrusions appeared on [H] head"))
	update_no_equip_flags(H, NONE)
	return TRUE

/datum/species/ipc/get_features()
	var/list/features = ..()

	features += "feature_ipc_monitor"

	return features

/datum/species/ipc/randomize_features(mob/living/carbon/human/human_mob)
	human_mob.dna.features["ipc_monitor"] = pick(GLOB.ipc_monitor_list)
	randomize_external_organs(human_mob)

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
			SPECIES_PERK_ICON = "bolt",
			SPECIES_PERK_NAME = "Shockingly Tasty",
			SPECIES_PERK_DESC = "Ipcs can feed on electricity from APCs, and do not otherwise need to eat.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = "robot",
			SPECIES_PERK_NAME = "Robotic",
			SPECIES_PERK_DESC = "IPCs have an entirely robotic body, meaning medical care is typically done through Robotics or Engineering. \
			Whether this is helpful or not is heavily dependent on your coworkers. It does, however, mean you are usually able to perform self-repairs easily.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "battery-quarter",
			SPECIES_PERK_NAME = "Cell Battery",
			SPECIES_PERK_DESC = "If you run out of charge, you can't move.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "magnet",
			SPECIES_PERK_NAME = "EMP Vulnerable",
			SPECIES_PERK_DESC = "IPC organs are cybernetic, and thus susceptible to electromagnetic interference.",
		),
	)

	return to_add

/datum/species/ipc/create_pref_liver_perks()
	RETURN_TYPE(/list)
	return list()

/// DATUMS

/datum/action/innate/change_monitor
	name = "Change Monitor Emote"
	check_flags = NONE
	button_icon_state = "ipc_monitor"
	button_icon = 'icons/mob/actions/actions_silicon.dmi'
	background_icon_state = "bg_tech"
	overlay_icon_state = "bg_tech_border"
	var/static/possible_overlays = list(
		"off",
		"smile",
		"uwu",
		"null",
		"alert",
		"cool",
		"dead",
		"nt",
		"heartline",
		"reddot",
		"glitchman",
		"turk",
	)
	var/emotion_icon = "off"
	var/datum/bodypart_overlay/simple/ipcscreen/currentoverlay

/datum/action/innate/change_monitor/Activate()
	var/mob/living/carbon/human/H = owner
	var/new_image = tgui_input_list(H, "Select your new display image", "Display Image", possible_overlays)
	change_monitor_emote(new_image)

/datum/action/innate/change_monitor/proc/change_monitor_emote(emote)
	var/mob/living/carbon/human/H = owner
	emotion_icon = emote
	for(var/path in subtypesof(/datum/bodypart_overlay/simple/ipcscreen))
		var/datum/bodypart_overlay/simple/ipcscreen/realemote = new path()
		if(realemote.icon_state == "ipc-[emotion_icon]")
			currentoverlay = H.give_ipcscreen_overlay(path)
		else
			continue
////////////////////////////////////// ORGANS //////////////////////////////////////////////////////
//Voltage Protector Organ
/obj/item/organ/internal/voltprotector
	name = "High Voltage Protector"
	desc = "This organ regulates the high electrical voltage coming into your body."
	icon_state = "volt_protector"
	slot = ORGAN_SLOT_VOLTPROTECT
	organ_flags = ORGAN_ROBOTIC
	zone = BODY_ZONE_CHEST

/obj/item/organ/internal/voltprotector/on_insert(mob/living/carbon/owner)
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT, PROC_REF(on_electrocute))

/obj/item/organ/internal/voltprotector/on_remove(mob/living/carbon/owner)
	. = ..()
	UnregisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT)

/obj/item/organ/internal/voltprotector/proc/on_electrocute(datum/source, shock_damage, siemens_coeff = 1, flags = NONE)
	SIGNAL_HANDLER
	if(flags & SHOCK_ILLUSION)
		return
	owner.apply_damages(brain = 10)


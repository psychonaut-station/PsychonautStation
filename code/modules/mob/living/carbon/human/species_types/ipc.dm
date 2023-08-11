/datum/species/ipc
	name = "Ipc"
	id = SPECIES_IPC
	examine_limb_id = SPECIES_HUMAN
	inherent_traits = list(
		TRAIT_NO_UNDERWEAR,
		TRAIT_CAN_USE_FLIGHT_POTION,
		TRAIT_GENELESS,
		TRAIT_LIMBATTACHMENT,
		TRAIT_NOBREATH,
		TRAIT_NOCLONELOSS,
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
	)

	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	meat = null
	mutantbrain = /obj/item/organ/internal/brain/advanced_posibrain
	mutanttongue = /obj/item/organ/internal/tongue/robot
	mutantstomach = /obj/item/organ/internal/stomach/ipc/high
	mutantappendix = null
	mutantheart = null
	mutantliver = null
	mutantlungs = null
	mutanteyes = /obj/item/organ/internal/eyes/robotic/shield
	mutantears = /obj/item/organ/internal/ears/cybernetic
	mutant_organs = list(/obj/item/organ/internal/voltprotector)
	external_organs = list(
		/obj/item/organ/external/ipchead = "Blackhead",
	)
	species_language_holder = /datum/language_holder/synthetic
	wing_types = list(/obj/item/organ/external/wings/functional/robotic)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN
	no_equip_flags = ITEM_SLOT_EYES | ITEM_SLOT_MASK
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/ipc,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/ipc,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/ipc,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/ipc,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/ipc,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/ipc,
	)
	var/emageffect = FALSE

/datum/species/ipc/on_species_gain(mob/living/carbon/C)
	. = ..()
	RegisterSignal(C, COMSIG_ATOM_EMAG_ACT, PROC_REF(on_emag_act))
	var/obj/item/organ/internal/brain/brain = C.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(brain)
		brain.zone = BODY_ZONE_CHEST
	C.set_safe_hunger_level()

/datum/species/ipc/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_ATOM_EMAG_ACT)

/datum/species/ipc/spec_life(mob/living/carbon/human/H, seconds_per_tick, times_fired)
	. = ..()
	if(H.health < H.crit_threshold)
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

/datum/action/innate/change_monitor
	name = "Change Monitor Emote"
	check_flags = NONE
	button_icon_state = "ipc_monitor"
	button_icon = 'icons/mob/actions/actions_silicon.dmi'
	background_icon_state = "bg_tech"
	overlay_icon_state = "bg_tech_border"
	var/static/possible_overlays = list(
		"off" = image(icon = 'icons/mob/species/ipc/ipc-screens.dmi', icon_state = "ipc-off"),
		"smile" = image(icon = 'icons/mob/species/ipc/ipc-screens.dmi', icon_state = "ipc-smile"),
		"uwu" = image(icon = 'icons/mob/species/ipc/ipc-screens.dmi', icon_state = "ipc-uwu"),
		"null" = image(icon = 'icons/mob/species/ipc/ipc-screens.dmi', icon_state = "ipc-null"),
		"alert" = image(icon = 'icons/mob/species/ipc/ipc-screens.dmi', icon_state = "ipc-alert"),
		"cool" = image(icon = 'icons/mob/species/ipc/ipc-screens.dmi', icon_state = "ipc-cool"),
		"dead" = image(icon = 'icons/mob/species/ipc/ipc-screens.dmi', icon_state = "ipc-dead"),
		"nt" = image(icon = 'icons/mob/species/ipc/ipc-screens.dmi', icon_state = "ipc-nt"),
		"heartline" = image(icon = 'icons/mob/species/ipc/ipc-screens.dmi', icon_state = "ipc-heartline"),
		"reddot" = image(icon = 'icons/mob/species/ipc/ipc-screens.dmi', icon_state = "ipc-reddot"),
		"glitchman" = image(icon = 'icons/mob/species/ipc/ipc-screens.dmi', icon_state = "ipc-glitchman"),
		"turk" = image(icon = 'icons/mob/species/ipc/ipc-screens.dmi', icon_state = "ipc-turk")
	)

/datum/action/innate/change_monitor/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = owner
	var/obj/item/bodypart/head/original_head = H.get_bodypart(BODY_ZONE_HEAD)
	if(!original_head || !istype(original_head, /obj/item/bodypart/head/ipc))
		return FALSE
	return TRUE

/datum/action/innate/change_monitor/Activate()
	var/mob/living/carbon/human/H = owner
	var/obj/item/bodypart/head/ipc/original_head = H.get_bodypart(BODY_ZONE_HEAD)
	var/picked_emote = show_radial_menu(H, H, possible_overlays, radius = 36)
	original_head.change_monitor_emote(picked_emote)

////////////////////////////////////// ORGANS //////////////////////////////////////////////////////
//Ipc head organ
/obj/item/organ/external/ipchead
	name = "ipc monitor"
	desc = "IPC Head Monitor"
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_IPC_MONITOR
	use_mob_sprite_as_obj_sprite = TRUE
	bodypart_overlay = /datum/bodypart_overlay/mutant/ipchead
	var/datum/action/innate/change_monitor/change_monitor

/obj/item/organ/external/ipchead/on_insert(mob/living/carbon/organ_owner)
	. = ..()
	change_monitor = new
	change_monitor.Grant(organ_owner)

/obj/item/organ/external/ipchead/on_remove(mob/living/carbon/organ_owner)
	. = ..()
	if(change_monitor)
		change_monitor.Remove(organ_owner)

/obj/item/organ/external/ipchead/on_life(seconds_per_tick, times_fired)
	. = ..()
	if(change_monitor)
		change_monitor.build_all_button_icons()

/datum/bodypart_overlay/mutant/ipchead
	layers = ALL_EXTERNAL_OVERLAYS
	feature_key = "ipc_monitor"

//Voltage Protector Organ
/obj/item/organ/internal/voltprotector
	name = "High Voltage Protector"
	desc = "This organ regulates the high electrical voltage coming into your body."
	icon_state = "volt_protector"
	slot = ORGAN_SLOT_VOLTPROTECT
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


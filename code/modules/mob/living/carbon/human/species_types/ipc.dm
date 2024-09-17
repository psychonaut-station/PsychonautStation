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
	)
	meat = null
	exotic_blood = /datum/reagent/fuel/oil
	exotic_bloodtype = "LPG"
	siemens_coeff = 0.8
	no_equip_flags = ITEM_SLOT_EYES | ITEM_SLOT_MASK
	body_markings = list(/datum/bodypart_overlay/simple/body_marking/ipc = "Black")
	mutant_organs = list(
		/obj/item/organ/internal/voltage_protector,
		/obj/item/organ/internal/cyberimp/arm/power_cord
	)
	mutanteyes = /obj/item/organ/internal/eyes/robotic/basic
	mutantears = /obj/item/organ/internal/ears/cybernetic
	mutanttongue = /obj/item/organ/internal/tongue/robot
	mutantbrain = /obj/item/organ/internal/brain/cybernetic/ipc
	mutantheart = /obj/item/organ/internal/heart/cybernetic/tier2
	mutantlungs = null
	mutantliver = null
	mutantstomach = /obj/item/organ/internal/stomach/ipc
	mutantappendix = null
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/ipc,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/ipc,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/ipc,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/ipc,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/ipc,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/ipc,
	)
	gibspawner = /obj/effect/gibspawner/robot/android

/datum/species/ipc/on_species_gain(mob/living/carbon/human/ipc, datum/species/old_species, pref_load)
	. = ..()
	RegisterSignal(ipc, COMSIG_ATOM_EXPOSED_WATER, PROC_REF(water_act))
	RegisterSignal(ipc, COMSIG_CARBON_ATTEMPT_EAT, PROC_REF(try_eating))

/datum/species/ipc/on_species_loss(mob/living/carbon/human/ipc, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(ipc, list(COMSIG_ATOM_EXPOSED_WATER, COMSIG_CARBON_ATTEMPT_EAT))

/datum/species/ipc/proc/try_eating(mob/living/carbon/source, atom/eating)
	SIGNAL_HANDLER
	to_chat(source, span_notice("You have no mouth!"))
	INVOKE_ASYNC(source, TYPE_PROC_REF(/mob, emote), "scream")
	return COMSIG_CARBON_BLOCK_EAT

/datum/species/ipc/spec_life(mob/living/carbon/human/H, seconds_per_tick, times_fired)
	. = ..()
	if(H.health < H.crit_threshold && !HAS_TRAIT(H, TRAIT_NOCRITDAMAGE))
		H.adjustBruteLoss(1.5 * seconds_per_tick)

/datum/species/ipc/proc/water_act(atom/exposed)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/exposed_ipc = exposed
	var/chest_covered = FALSE
	var/head_covered = FALSE
	for(var/obj/item/clothing/equipped in exposed_ipc.get_equipped_items())
		if((equipped.body_parts_covered & CHEST) && (equipped.get_armor_rating(BIO) == 100))
			chest_covered = TRUE
		if((equipped.body_parts_covered & HEAD) && (equipped.get_armor_rating(BIO) == 100))
			head_covered = TRUE
		if(head_covered && chest_covered)
			break
	if(!chest_covered || !head_covered)
		var/obj/item/organ/internal/heart/heart = exposed_ipc.get_organ_slot(ORGAN_SLOT_HEART)
		if(heart && istype(heart, /obj/item/organ/internal/heart/cybernetic))
			exposed_ipc.adjustFireLoss(rand(1,3))
		else
			exposed_ipc.adjustFireLoss(rand(5,15))
		return

/datum/species/ipc/randomize_features()
	var/list/features = ..()
	features["ipc_chassis"] = SSaccessories.ipc_chassis_list[pick(SSaccessories.ipc_chassis_list)]
	return features

/datum/species/ipc/get_features()
	var/list/features = ..()

	features += "feature_ipc_chassis"

	return features

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
/obj/item/organ/internal/voltage_protector
	name = "high voltage protector"
	desc = "This organ regulates the high electrical voltage coming into your body."
	icon_state = "implant-power"
	slot = ORGAN_SLOT_VOLTPROTECT
	organ_flags = ORGAN_ROBOTIC
	zone = BODY_ZONE_CHEST

/obj/item/organ/internal/voltage_protector/on_mob_insert(mob/living/carbon/owner)
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT, PROC_REF(on_electrocute))

/obj/item/organ/internal/voltage_protector/on_mob_remove(mob/living/carbon/owner)
	. = ..()
	UnregisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT)

/obj/item/organ/internal/voltage_protector/proc/on_electrocute(datum/source, shock_damage, siemens_coeff = 1, flags = NONE)
	SIGNAL_HANDLER
	if(flags & SHOCK_ILLUSION)
		return
	owner.apply_damages(brain = 10)

/obj/item/organ/internal/cyberimp/arm/power_cord
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

/obj/item/apc_powercord/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!istype(target, /obj/machinery/power/apc) || !ishuman(user) || !proximity_flag)
		return ..()
	user.changeNext_move(CLICK_CD_MELEE)
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/internal/stomach/ipc/stomach = H.get_organ_slot(ORGAN_SLOT_STOMACH)
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
		if(A.cell && A.cell.charge > A.cell.maxcharge/4)
			A.ipc_interact(H)
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
	var/emotion_icon

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
	var/list/item_images = list()
	var/list/items = list()
	for(var/datum/bodypart_overlay/simple/ipcscreen/overlay as anything in possible_overlays)
		if(overlay.job && !istype(C.mind.assigned_role, overlay.job))
			continue
		var/image/item_image = image(icon = overlay::icon, icon_state = overlay::icon_state)
		item_images[overlay.name] = item_image
		items[overlay.name] = overlay
	var/picked_emote = show_radial_menu(C, C, item_images, radius = 36)
	if(isnull(picked_emote))
		return
	emotion_icon = items[picked_emote]
	give_overlay(C, head, items[picked_emote])

/datum/action/innate/change_monitor/proc/give_overlay(mob/living/carbon/C, obj/item/bodypart/bodypart, overlay_typepath)
	if(!bodypart)
		return null
	var/datum/bodypart_overlay/simple/ipcscreen/overlay = new overlay_typepath()
	remove_overlay(C)
	bodypart.add_bodypart_overlay(overlay)
	C.update_body_parts()
	return overlay

/datum/action/innate/change_monitor/proc/remove_overlay(mob/living/carbon/C)
	var/obj/item/bodypart/bodypart = C.get_bodypart(BODY_ZONE_HEAD)
	if(!bodypart)
		return
	var/datum/bodypart_overlay/simple/ipcscreen/overlay = (locate(/datum/bodypart_overlay/simple/ipcscreen) in bodypart.bodypart_overlays)
	if(overlay)
		bodypart.remove_bodypart_overlay(overlay)
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
	icon_state = "ipc-off"
	layers = EXTERNAL_ADJACENT
	var/name = "Off"
	var/attached_body_zone = BODY_ZONE_HEAD
	var/datum/job/job = null

/datum/bodypart_overlay/simple/ipcscreen/ipcsmile
	name = "Smile"
	icon_state = "ipc-smile"

/datum/bodypart_overlay/simple/ipcscreen/ipcuwu
	name = "Uwu"
	icon_state = "ipc-uwu"

/datum/bodypart_overlay/simple/ipcscreen/ipcnull
	name = "Null"
	icon_state = "ipc-null"

/datum/bodypart_overlay/simple/ipcscreen/ipcalert
	name = "Alert"
	icon_state = "ipc-alert"

/datum/bodypart_overlay/simple/ipcscreen/ipccool
	name = "Cool"
	icon_state = "ipc-cool"

/datum/bodypart_overlay/simple/ipcscreen/ipcdead
	name = "Dead"
	icon_state = "ipc-dead"

/datum/bodypart_overlay/simple/ipcscreen/ipcnt
	name = "Nanotrasen"
	icon_state = "ipc-nt"

/datum/bodypart_overlay/simple/ipcscreen/ipcheartline
	name = "Heart Line"
	icon_state = "ipc-heartline"

/datum/bodypart_overlay/simple/ipcscreen/ipcreddot
	name = "Red Dot"
	icon_state = "ipc-reddot"

/datum/bodypart_overlay/simple/ipcscreen/ipcglitchman
	name = "Glitch"
	icon_state = "ipc-glitchman"

/datum/bodypart_overlay/simple/ipcscreen/ipcturk
	name = "Turk"
	icon_state = "ipc-turk"

/datum/bodypart_overlay/simple/ipcscreen/ipcclown
	name = "Clown"
	icon_state = "ipc-clown"
	job = /datum/job/clown

/datum/bodypart_overlay/simple/ipcscreen/ipcmime
	name = "Mime"
	icon_state = "ipc-mime"
	job = /datum/job/mime

/datum/bodypart_overlay/simple/ipcscreen/ipcpinball
	name = "Pinball"
	icon_state = "ipc-pinball"

/datum/bodypart_overlay/simple/ipcscreen/ipcnoerp
	name = "No Erp"
	icon_state = "ipc-noerp"

/datum/bodypart_overlay/simple/ipcscreen/ipcpaicat
	name = "Cat"
	icon_state = "ipc-paicat"

/datum/bodypart_overlay/simple/ipcscreen/ipcskull
	name = "Skull"
	icon_state = "ipc-skull"

/datum/bodypart_overlay/simple/ipcscreen/ipcmonkey
	name = "Monkey"
	icon_state = "ipc-monkey"

/datum/bodypart_overlay/simple/ipcscreen/ipcnerd
	name = "Nerd"
	icon_state = "ipc-nerd"

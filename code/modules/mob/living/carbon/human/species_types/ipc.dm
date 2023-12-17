/datum/species/ipc
	name = "\improper IPC"
	id = SPECIES_IPC
	examine_limb_id = SPECIES_HUMAN
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
	ass_image = 'icons/ass/assmachine.png'
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	meat = null
	exotic_blood = /datum/reagent/fuel/oil
	exotic_bloodtype = "LPG"
	dust_anim = "dust-h"
	gib_anim = "gibbed-h"
	gibspawner = /obj/effect/gibspawner/robot/android
	decalremains = /obj/effect/decal/remains/robot
	mutantbrain = /obj/item/organ/internal/brain/basic_posibrain
	mutanttongue = /obj/item/organ/internal/tongue/robot
	mutantstomach = /obj/item/organ/internal/stomach/ipc
	mutantheart = /obj/item/organ/internal/heart/ipc
	mutantappendix = null
	mutantliver = null
	mutantlungs = null
	mutanteyes = /obj/item/organ/internal/eyes/robotic/basic
	mutantears = /obj/item/organ/internal/ears/cybernetic
	mutant_organs = list(/obj/item/organ/internal/voltprotector)
	external_organs = list(
		/obj/item/organ/external/ipchead = "Black",
	)
	mutant_bodyparts = list("ipc_chassis" = "Black")
	species_language_holder = /datum/language_holder/synthetic
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

/datum/species/ipc/update_quirk_mail_goodies(mob/living/carbon/human/recipient, datum/quirk/quirk, list/mail_goodies = list())
	if(istype(quirk, /datum/quirk/blooddeficiency))
		mail_goodies += list(
			/obj/item/reagent_containers/blood/oil
		)
	mail_goodies += list(/obj/item/stock_parts/cell/high, /obj/item/weldingtool/mini, /obj/item/stack/cable_coil)
	return ..()

/datum/species/ipc/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_ipc_name()

	var/randname = ipc_name()

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/ipc/on_species_gain(mob/living/carbon/C)
	. = ..()
	RegisterSignal(C, COMSIG_CARBON_ATTEMPT_EAT, PROC_REF(try_eating))
	var/obj/item/organ/internal/brain/brain = C.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(brain && brain.zone != BODY_ZONE_CHEST)
		brain.zone = BODY_ZONE_CHEST
	C.set_safe_hunger_level()
	C.gib_type = /obj/effect/decal/cleanable/robot_debris
	update_mail_goodies(C)

/datum/species/ipc/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_CARBON_ATTEMPT_EAT)
	var/obj/item/organ/internal/brain/brain = C.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(brain)
		brain.zone = initial(brain.zone)
	C.gib_type = /obj/effect/decal/cleanable/blood/gibs

/datum/species/ipc/proc/try_eating(mob/living/carbon/source, atom/eating)
	SIGNAL_HANDLER
	to_chat(source, span_notice("You dont have a mouth!"))
	INVOKE_ASYNC(source, TYPE_PROC_REF(/mob, emote), "scream")
	return COMSIG_CARBON_BLOCK_EAT

/datum/species/ipc/spec_life(mob/living/carbon/human/H, seconds_per_tick, times_fired)
	. = ..()
	if(H.health < H.crit_threshold && !HAS_TRAIT(H, TRAIT_NOCRITDAMAGE))
		H.adjustBruteLoss(1.5 * seconds_per_tick)

/datum/species/ipc/proc/apply_water(mob/living/carbon/human/H)
	var/obj/item/organ/internal/heart/heart = H.get_organ_slot(ORGAN_SLOT_HEART)
	if(heart && istype(heart, /obj/item/organ/internal/heart/ipc))
		H.adjustFireLoss(rand(1,3))
	else
		H.adjustFireLoss(rand(5,15))
	return

/datum/species/ipc/get_features()
	var/list/features = ..()
	features += "feature_ipc_chassis"
	return features

/datum/species/ipc/replace_body(mob/living/carbon/C, datum/species/new_species)
	..()

	var/datum/sprite_accessory/ipc_chassis/chassis_of_choice = GLOB.ipc_chassis_list[C.dna.features["ipc_chassis"]]
	var/list/newfinal_bodypart_overrides = new_species.bodypart_overrides.Copy()
	for(var/obj/item/bodypart/BP as() in C.bodyparts) //Override bodypart data as necessary
		var/newpath = newfinal_bodypart_overrides?[BP.body_zone]
		if(newpath)
			BP.limb_id = chassis_of_choice.icon_state
			BP.update_limb()

/datum/species/ipc/randomize_features(mob/living/carbon/human/human_mob)
	var/list/features = ..()
	var/random_thing_text = pick(GLOB.ipc_chassis_list)	// Gets random feature name. Ex: Black or Bishop Cyberkinetics...
	features["ipc_monitor"] = random_thing_text
	features["ipc_chassis"] = random_thing_text
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
			SPECIES_PERK_ICON = "bolt",
			SPECIES_PERK_NAME = "Shockingly Tasty",
			SPECIES_PERK_DESC = "IPCs can feed on electricity from APCs, and do not otherwise need to eat.",
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
			SPECIES_PERK_DESC = "IPCs organs are cybernetic, and thus susceptible to electromagnetic interference.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "droplet",
			SPECIES_PERK_NAME = "Short Circuit",
			SPECIES_PERK_DESC = "IPCs are not resistant to water, water creates a short circuit in IPC's.",
		),
	)

	return to_add

/datum/species/ipc/create_pref_liver_perks()
	RETURN_TYPE(/list)
	return list()

/datum/species/ipc/handle_environment_pressure(mob/living/carbon/human/H, datum/gas_mixture/environment, seconds_per_tick, times_fired)
	. = ..()

	var/pressure = environment.return_pressure()
	var/adjusted_pressure = H.calculate_affecting_pressure(pressure)

	if(adjusted_pressure >= HAZARD_HIGH_PRESSURE && !HAS_TRAIT(H, TRAIT_RESISTHIGHPRESSURE))
		H.adjustBruteLoss(min(((adjusted_pressure / HAZARD_HIGH_PRESSURE) - 1) * PRESSURE_DAMAGE_COEFFICIENT, MAX_HIGH_PRESSURE_DAMAGE) * 1.5 * H.physiology.pressure_mod * seconds_per_tick, required_bodytype = BODYTYPE_ORGANIC | BODYTYPE_IPC)
	else if(adjusted_pressure < HAZARD_LOW_PRESSURE && !HAS_TRAIT(H, TRAIT_RESISTLOWPRESSURE))
		H.adjustBruteLoss(LOW_PRESSURE_DAMAGE * 1.5 * H.physiology.pressure_mod * seconds_per_tick, required_bodytype = BODYTYPE_ORGANIC | BODYTYPE_IPC)

/// DATUMS

/datum/action/innate/change_monitor
	name = "Change Monitor Emote"
	check_flags = NONE
	button_icon_state = "ipc_monitor"
	button_icon = 'icons/psychonaut/mob/actions/actions_silicon.dmi'
	background_icon_state = "bg_tech"
	overlay_icon_state = "bg_tech_border"
	var/static/list/possible_overlays = list(
		"off" = /datum/bodypart_overlay/simple/ipcscreen/ipcoff,
		"smile" = /datum/bodypart_overlay/simple/ipcscreen/ipcsmile,
		"uwu" = /datum/bodypart_overlay/simple/ipcscreen/ipcuwu,
		"null" = /datum/bodypart_overlay/simple/ipcscreen/ipcnull,
		"alert" = /datum/bodypart_overlay/simple/ipcscreen/ipcalert,
		"cool" = /datum/bodypart_overlay/simple/ipcscreen/ipccool,
		"dead" = /datum/bodypart_overlay/simple/ipcscreen/ipcdead,
		"nt" = /datum/bodypart_overlay/simple/ipcscreen/ipcnt,
		"heartline" = /datum/bodypart_overlay/simple/ipcscreen/ipcheartline,
		"reddot" = /datum/bodypart_overlay/simple/ipcscreen/ipcreddot,
		"glitchman" = /datum/bodypart_overlay/simple/ipcscreen/ipcglitchman,
		"turk" = /datum/bodypart_overlay/simple/ipcscreen/ipcturk,
		"clown" = /datum/bodypart_overlay/simple/ipcscreen/ipcclown,
		"mime" = /datum/bodypart_overlay/simple/ipcscreen/ipcmime,
		"pinball" = /datum/bodypart_overlay/simple/ipcscreen/ipcpinball,
		"noerp" = /datum/bodypart_overlay/simple/ipcscreen/ipcnoerp,
		"paicat" = /datum/bodypart_overlay/simple/ipcscreen/ipcpaicat,
		"skull" = /datum/bodypart_overlay/simple/ipcscreen/ipcskull,
		"monkey" = /datum/bodypart_overlay/simple/ipcscreen/ipcmonkey,
		"nerd" = /datum/bodypart_overlay/simple/ipcscreen/ipcnerd,
	)
	var/emotion_icon = "off"
	var/datum/bodypart_overlay/simple/ipcscreen/currentoverlay

/datum/action/innate/change_monitor/Activate()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	var/list/items = list()
	for(var/overlay_option in possible_overlays)
		if(overlay_option == "clown" || overlay_option == "mime")
			continue
		var/datum/bodypart_overlay/simple/ipcscreen/screen = possible_overlays[overlay_option]
		var/image/item_image = image(icon = initial(screen.icon), icon_state = initial(screen.icon_state))
		items += list("[overlay_option]" = item_image)
	if(istype(H.mind.assigned_role, /datum/job/clown))
		items += list("clown" = image(icon = 'icons/psychonaut/mob/human/species/ipc/ipc_screens.dmi', icon_state = "ipc-clown"))
	if(istype(H.mind.assigned_role, /datum/job/mime))
		items += list("mime" = image(icon = 'icons/psychonaut/mob/human/species/ipc/ipc_screens.dmi', icon_state = "ipc-mime"))
	var/picked_emote = show_radial_menu(H, H, items, radius = 36)
	if(isnull(picked_emote))
		return
	emotion_icon = picked_emote
	currentoverlay = H.give_ipcscreen_overlay(possible_overlays[picked_emote])

/datum/action/innate/change_monitor/Remove(mob/M)
	var/mob/living/carbon/human/H = M
	H.remove_ipcscreen_overlay()
	return ..()

////////////////////////////////////// ORGANS //////////////////////////////////////////////////////
// Voltage Protector Organ
/obj/item/organ/internal/voltprotector
	name = "high voltage protector"
	desc = "This organ regulates the high electrical voltage coming into your body."
	icon = 'icons/psychonaut/obj/medical/organs/organs.dmi'
	icon_state = "volt_protector"
	slot = ORGAN_SLOT_VOLTPROTECT
	organ_flags = ORGAN_ROBOTIC
	zone = BODY_ZONE_CHEST

/obj/item/organ/internal/voltprotector/on_mob_insert(mob/living/carbon/owner)
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT, PROC_REF(on_electrocute))

/obj/item/organ/internal/voltprotector/on_mob_remove(mob/living/carbon/owner)
	. = ..()
	UnregisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT)

/obj/item/organ/internal/voltprotector/proc/on_electrocute(datum/source, shock_damage, siemens_coeff = 1, flags = NONE)
	SIGNAL_HANDLER
	if(flags & SHOCK_ILLUSION)
		return
	owner.apply_damages(brain = 10)

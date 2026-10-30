/obj/item/organ/cyberimp/arm
	abstract_type = /obj/item/organ/cyberimp/arm
	name = "arm-mounted implant"
	desc = "An implant that goes in your arm to improve it."
	zone = BODY_ZONE_R_ARM
	slot = ORGAN_SLOT_RIGHT_ARM_AUG
	w_class = WEIGHT_CLASS_SMALL
	valid_zones = list(
		BODY_ZONE_R_ARM = ORGAN_SLOT_RIGHT_ARM_AUG,
		BODY_ZONE_L_ARM = ORGAN_SLOT_LEFT_ARM_AUG,
	)

/obj/item/organ/cyberimp/arm/swap_zone(target_zone)
	. = ..()
	update_overlay_state()

/obj/item/organ/cyberimp/arm/get_overlay_state()
	return "[aug_overlay][zone == BODY_ZONE_L_ARM ? "_left" : "_right"]"

<<<<<<< HEAD
/obj/item/organ/cyberimp/arm/on_mob_insert(mob/living/carbon/arm_owner)
	. = ..()
	RegisterSignal(arm_owner, COMSIG_CARBON_POST_ATTACH_LIMB, PROC_REF(on_limb_attached))
	on_limb_attached(arm_owner, arm_owner.hand_bodyparts[zone == BODY_ZONE_R_ARM ? RIGHT_HANDS : LEFT_HANDS])

/obj/item/organ/cyberimp/arm/on_mob_remove(mob/living/carbon/arm_owner)
	. = ..()
	UnregisterSignal(arm_owner, COMSIG_CARBON_POST_ATTACH_LIMB)
	on_limb_detached(hand)

/obj/item/organ/cyberimp/arm/proc/on_limb_attached(mob/living/carbon/source, obj/item/bodypart/limb)
	SIGNAL_HANDLER
	if(!limb || QDELETED(limb) || limb.body_zone != zone)
		return
	handle_attachment(limb)

/obj/item/organ/cyberimp/arm/proc/handle_attachment(obj/item/bodypart/limb)
	if(hand)
		on_limb_detached(hand)
	RegisterSignal(limb, COMSIG_BODYPART_REMOVED, PROC_REF(on_limb_detached))
	RegisterSignal(limb, COMSIG_QDELETING, PROC_REF(on_limb_qdel))
	hand = limb

/obj/item/organ/cyberimp/arm/proc/on_limb_detached(obj/item/bodypart/source)
	SIGNAL_HANDLER
	if(source != hand || QDELETED(hand))
		return
	UnregisterSignal(hand, COMSIG_BODYPART_REMOVED)
	UnregisterSignal(hand, COMSIG_QDELETING)
	hand = null

/obj/item/organ/cyberimp/arm/proc/on_limb_qdel()
	UnregisterSignal(hand, COMSIG_BODYPART_REMOVED)
	UnregisterSignal(hand, COMSIG_QDELETING)
	hand = null

=======
>>>>>>> bf6f771a1e221e06938978e36bbaf78543f85ebe
/obj/item/organ/cyberimp/arm/toolkit
	abstract_type = /obj/item/organ/cyberimp/arm/toolkit
	name = "arm-mounted toolkit"
	desc = "You shouldn't see this! Adminhelp and report this as an issue on github!"
	icon_state = "toolkit_generic"
	actions_types = list(/datum/action/item_action/organ_action/toggle)
	/// The item that the user currently has deployed.
	VAR_FINAL/obj/item/active_item = null
	/// Used to store a list of all items inside, for multi-item implants.
	VAR_FINAL/list/items_list = list() // I would use contents, but they shuffle on every activation/deactivation leading to interface inconsistencies.
	/// Sound played when extending
	var/extend_sound = 'sound/vehicles/mecha/mechmove03.ogg'
	/// Sound played when retracting
	var/retract_sound = 'sound/vehicles/mecha/mechmove03.ogg'
	/// Do we have a separate icon_state for the hand overlay?
	var/hand_state = TRUE

/datum/action/item_action/organ_action/toggle/toolkit
	desc = "You can also activate your empty hand or the tool in your hand to open the tools radial menu."

/obj/item/organ/cyberimp/arm/toolkit/Initialize(mapload)
	. = ..()

	for(var/typepath in get_init_items())
		var/atom/new_item = new typepath(src)
		prepare_init_item(new_item)
		items_list |= new_item

	if(hand_state)
		// Overlay is done in two layers, "[state]" and "[state]_hand"
		bodypart_aug?.add_layer("hand", BODYPARTS_HIGH_LAYER)

/obj/item/organ/cyberimp/arm/toolkit/Destroy()
	active_item = null
	QDEL_LIST(items_list)
	return ..()

/// Generates and returns the list of items we need to initialize for our organs
/obj/item/organ/cyberimp/arm/toolkit/proc/get_init_items() as /list
	PROTECTED_PROC(TRUE)
	RETURN_TYPE(/list/obj/item)

	return list()

/// Prepares an item for the items_list.
/obj/item/organ/cyberimp/arm/toolkit/proc/prepare_init_item(obj/item/new_item)
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	new_item.set_custom_materials(null)
	new_item.resistance_flags = EVERYTHING_PROOF
	new_item.slot_flags = NONE
	ADD_TRAIT(new_item, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)

/obj/item/organ/cyberimp/arm/toolkit/on_mob_insert(mob/living/carbon/organ_owner)
	. = ..()
	//We're nodrop, but we'll watch for the drop hotkey anyway and then stow if possible.
	//FIXME: This makes it so that AI-controlled mobs can't drop their items... hook into dropped signal instead
	RegisterSignal(organ_owner, COMSIG_KB_MOB_DROPITEM_DOWN, PROC_REF(on_drop_key))

/obj/item/organ/cyberimp/arm/toolkit/on_mob_remove(mob/living/carbon/organ_owner)
	. = ..()
	Retract()
	UnregisterSignal(organ_owner, COMSIG_KB_MOB_DROPITEM_DOWN)

/obj/item/organ/cyberimp/arm/toolkit/on_bodypart_insert(obj/item/bodypart/limb)
	. = ..()
	RegisterSignal(limb, COMSIG_ITEM_ATTACK_SELF, PROC_REF(on_limb_attack_self))

<<<<<<< HEAD
/obj/item/organ/cyberimp/arm/toolkit/on_limb_detached(obj/item/bodypart/source)
	if(source != hand || QDELETED(hand))
		return
	UnregisterSignal(hand, list(COMSIG_BODYPART_REMOVED, COMSIG_QDELETING, COMSIG_ITEM_ATTACK_SELF))
	hand = null

/obj/item/organ/cyberimp/arm/toolkit/on_limb_qdel()
	UnregisterSignal(hand, COMSIG_ITEM_ATTACK_SELF)
	return ..()

/obj/item/organ/cyberimp/arm/toolkit/proc/on_item_attack_self()
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(ui_action_click))
=======
/obj/item/organ/cyberimp/arm/toolkit/on_bodypart_remove(obj/item/bodypart/limb)
	. = ..()
	UnregisterSignal(limb, COMSIG_ITEM_ATTACK_SELF)
>>>>>>> bf6f771a1e221e06938978e36bbaf78543f85ebe

/obj/item/organ/cyberimp/arm/toolkit/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF || !IS_ROBOTIC_ORGAN(src))
		return
	if(prob(15/severity) && owner)
		to_chat(owner, span_warning("The electromagnetic pulse causes [src] to malfunction!"))
		// give the owner an idea about why his implant is glitching
		Retract()

/obj/item/organ/cyberimp/arm/toolkit/proc/on_limb_attack_self()
	SIGNAL_HANDLER
	if(owner)
		INVOKE_ASYNC(src, PROC_REF(try_swap_item), owner)

/obj/item/organ/cyberimp/arm/toolkit/proc/on_drop_key(mob/living/carbon/host)
	SIGNAL_HANDLER
	if(!host)
		return //How did we even get here
	if(bodypart_owner != host.hand_bodyparts[host.active_hand_index])
		return //wrong hand
	if(Retract())
		return COMSIG_KB_ACTIVATED

/obj/item/organ/cyberimp/arm/toolkit/proc/Retract()
	if(!active_item)
		return FALSE

	if(owner) // This could run as the arm gets severed
		owner.visible_message(
			span_notice("[owner] retracts [active_item] back into [owner.p_their()] [parse_zone(zone)]."),
			span_notice("[active_item] snaps back into your [parse_zone(zone)]."),
			span_hear("You hear a short mechanical noise."),
		)

		owner.transferItemToLoc(active_item, src, TRUE)
	else
		active_item.forceMove(src)

	UnregisterSignal(active_item, list(COMSIG_ITEM_ATTACK_SELF, COMSIG_ITEM_ATTACK_SELF_SECONDARY))
	active_item = null
	playsound(get_turf(src), retract_sound, 50, TRUE)
	return TRUE

/obj/item/organ/cyberimp/arm/toolkit/proc/Extend(obj/item/augment)
	if(active_item || !(augment in items_list))
		return

	var/desired_hand_index = bodypart_owner.held_index
	var/obj/item/interfering_item = owner.get_item_for_held_index(desired_hand_index)
	if(interfering_item)
		if(!owner.dropItemToGround(interfering_item))
			to_chat(owner, span_warning("[interfering_item] prevents you from using [src]!"))
			return
		to_chat(owner, span_notice("You drop [interfering_item] to activate [src]."))

	if(!owner.put_in_hand(augment, desired_hand_index, ignore_anim = TRUE))
		return
	active_item = augment
	if(length(items_list) > 1)
		RegisterSignals(active_item, list(COMSIG_ITEM_ATTACK_SELF, COMSIG_ITEM_ATTACK_SELF_SECONDARY), PROC_REF(on_inhand_use)) // secondary for welders

	playsound(get_turf(owner), extend_sound, 50, TRUE)
	owner.visible_message(
		span_notice("[owner] extends [active_item] from [owner.p_their()] [parse_zone(zone)]."),
		span_notice("You extend [active_item] from your [parse_zone(zone)]."),
		span_hear("You hear a short mechanical noise.")
		)

/obj/item/organ/cyberimp/arm/toolkit/proc/on_inhand_use(obj/item/source, mob/user)
	SIGNAL_HANDLER
	Retract()
	INVOKE_ASYNC(src, PROC_REF(try_swap_item), user)

/obj/item/organ/cyberimp/arm/toolkit/proc/try_swap_item(mob/user)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/item_count = items_list.len

	if((organ_flags & ORGAN_FAILING) || !item_count)
		to_chat(owner, span_warning("\The [src] doesn't respond. [p_they()] seem[p_s()] to be broken..."))
		return

	if(active_item)
		Retract()
	else if(item_count == 1)
		Extend(items_list[1])
	else if(!user.client)
		Extend(pick(items_list))
	else
		var/list/choice_list = list()
		for(var/obj/item/choice_item as anything in items_list)
			choice_list[choice_item] = image(choice_item)

		var/obj/item/choice = show_radial_menu(owner, owner, choice_list)
		if(QDELETED(src) || QDELETED(owner) || IS_UNCONSCIOUS_OR_CRIT(owner) || QDELETED(choice) || active_item)
			return
		Extend(choice)

/obj/item/organ/cyberimp/arm/toolkit/ui_action_click(mob/user, actiontype)
	try_swap_item(user)

/obj/item/organ/cyberimp/arm/toolkit/gun
	abstract_type = /obj/item/organ/cyberimp/arm/toolkit/gun

/obj/item/organ/cyberimp/arm/toolkit/gun/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(prob(30/severity) && owner && !(organ_flags & ORGAN_FAILING))
		Retract()
		owner.visible_message(span_danger("A loud bang comes from [owner]\'s [parse_zone(zone)]!"))
		playsound(get_turf(owner), 'sound/items/weapons/flashbang.ogg', 100, TRUE)
		to_chat(owner, span_userdanger("You feel an explosion erupt inside your [parse_zone(zone)] as your implant breaks!"))
		owner.adjust_fire_stacks(20)
		owner.ignite_mob()
		owner.adjust_fire_loss(25)
		organ_flags |= ORGAN_FAILING

/obj/item/organ/cyberimp/arm/toolkit/gun/laser
	name = "arm-mounted laser implant"
	desc = "A variant of the arm cannon implant that fires lethal laser beams. The cannon emerges from the subject's arm and remains inside when not in use."
	icon_state = "arm_laser"

/obj/item/organ/cyberimp/arm/toolkit/gun/laser/get_init_items()
	return list(/obj/item/gun/energy/laser/mounted/augment)

/obj/item/organ/cyberimp/arm/toolkit/gun/taser
	name = "arm-mounted taser implant"
	desc = "A variant of the arm cannon implant that fires electrodes and disabler shots. The cannon emerges from the subject's arm and remains inside when not in use."
	icon_state = "arm_taser"

/obj/item/organ/cyberimp/arm/toolkit/gun/taser/get_init_items()
	return list(/obj/item/gun/energy/e_gun/advtaser/mounted)

/obj/item/organ/cyberimp/arm/toolkit/toolset
	name = "integrated toolset implant"
	desc = "A stripped-down version of the engineering cyborg toolset, designed to be installed on subject's arm. Contain advanced versions of every tool."
	icon_state = "toolkit_engineering"
	aug_overlay = "toolkit_engi"
	actions_types = list(/datum/action/item_action/organ_action/toggle/toolkit)
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.25, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 0.75, /datum/material/silver = SHEET_MATERIAL_AMOUNT * 0.75)

/obj/item/organ/cyberimp/arm/toolkit/toolset/get_init_items()
	return list(
		/obj/item/screwdriver/cyborg,
		/obj/item/wrench/cyborg,
		/obj/item/weldingtool/largetank/cyborg,
		/obj/item/crowbar/cyborg,
		/obj/item/wirecutters/cyborg,
		/obj/item/multitool/cyborg,
	)

/obj/item/organ/cyberimp/arm/toolkit/toolset/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(locate(/obj/item/knife/combat/cyborg) in items_list)
		return FALSE

	var/obj/item/knife/combat/cyborg/new_knife = new(src)
	prepare_init_item(new_knife)
	items_list |= new_knife
	balloon_alert(user, "integrated knife unlocked")
	return TRUE

//The order of the item list for this implant is not alphabetized due to it actually affecting how it shows up playerside when opening the implant
/obj/item/organ/cyberimp/arm/toolkit/paperwork
	name = "integrated paperwork implant"
	desc = "A highly sought out implant among heads of personnel, and other high up command staff in Nanotrasen. This implant allows the user to always have the tools necessary for paperwork handy"
	icon_state = "toolkit_engineering"
	aug_overlay = "toolkit_engi"
	actions_types = list(/datum/action/item_action/organ_action/toggle/toolkit)

/obj/item/stamp/mod/toolkit
	name = "integrated electronic stamp"

/obj/item/organ/cyberimp/arm/toolkit/paperwork/get_init_items()
	return list(
		/obj/item/pen/fountain,
		/obj/item/clipboard,
		/obj/item/taperecorder,
		/obj/item/lighter,
		/obj/item/laser_pointer,
		/obj/item/stamp/mod/toolkit,
	)

/obj/item/organ/cyberimp/arm/toolkit/paperwork/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(locate(/obj/item/stamp/chameleon) in items_list)
		return FALSE

	var/obj/item/stamp/chameleon/new_stamp = new(src)
	prepare_init_item(new_stamp)
	items_list |= new_stamp
	balloon_alert(user, "experimental stamp unlocked")
	return TRUE

/obj/item/organ/cyberimp/arm/toolkit/esword
	name = "arm-mounted energy blade"
	desc = "An illegal and highly dangerous cybernetic implant that can project a deadly blade of concentrated energy."

/obj/item/organ/cyberimp/arm/toolkit/esword/get_init_items()
	return list(/obj/item/melee/energy/blade/hardlight)

/obj/item/organ/cyberimp/arm/toolkit/medibeam
	name = "integrated medical beamgun"
	desc = "A cybernetic implant that allows the user to project a healing beam from their hand."
	icon_state = "toolkit_surgical"
	aug_overlay = "toolkit_med"

/obj/item/organ/cyberimp/arm/toolkit/medibeam/get_init_items()
	return list(/obj/item/gun/medbeam)

/obj/item/organ/cyberimp/arm/toolkit/flash
	name = "integrated high-intensity photon projector" //Why not
	desc = "An integrated projector mounted onto a user's arm that is able to be used as a powerful flash."
	aug_overlay = "toolkit"

/obj/item/organ/cyberimp/arm/toolkit/flash/get_init_items()
	return list(/obj/item/assembly/flash/armimplant)

/obj/item/organ/cyberimp/arm/toolkit/baton
	name = "arm electrification implant"
	desc = "An illegal combat implant that allows the user to administer disabling shocks from their arm."
	aug_overlay = "toolkit"

/obj/item/organ/cyberimp/arm/toolkit/baton/get_init_items()
	return list(/obj/item/borg/stun)

/obj/item/organ/cyberimp/arm/toolkit/combat
	name = "combat cybernetics implant"
	desc = "A powerful cybernetic implant that contains combat modules built into the user's arm."
	aug_overlay = "toolkit"

/obj/item/organ/cyberimp/arm/toolkit/combat/get_init_items()
	return list(
		/obj/item/melee/energy/blade/hardlight,
		/obj/item/gun/medbeam,
		/obj/item/borg/stun,
		/obj/item/assembly/flash/armimplant,
	)

/obj/item/organ/cyberimp/arm/toolkit/surgery
	name = "surgical toolset implant"
	desc = "A set of surgical tools hidden behind a concealed panel on the user's arm."
	icon_state = "toolkit_surgical"
	aug_overlay = "toolkit_med"
	actions_types = list(/datum/action/item_action/organ_action/toggle/toolkit)
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.25, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 0.75, /datum/material/silver = SHEET_MATERIAL_AMOUNT * 0.75)

/obj/item/organ/cyberimp/arm/toolkit/surgery/get_init_items()
	return list(
		/obj/item/retractor/augment,
		/obj/item/hemostat/augment,
		/obj/item/cautery/augment,
		/obj/item/surgicaldrill/augment,
		/obj/item/scalpel/augment,
		/obj/item/circular_saw/augment,
		/obj/item/surgical_drapes,
	)

/obj/item/organ/cyberimp/arm/toolkit/surgery/emagged
	name = "hacked surgical toolset implant"
	desc = "A set of surgical tools hidden behind a concealed panel on the user's arm. This one seems to have been tampered with."
	aug_overlay = "toolkit_med"

/obj/item/organ/cyberimp/arm/toolkit/surgery/emagged/get_init_items()
	return ..() | /obj/item/knife/combat/cyborg

/obj/item/organ/cyberimp/arm/toolkit/surgery/cruel
	name = "morbid surgical toolset implant"
	desc = "A modified set of surgical tools hidden behind a concealed panel on the user's arm. These tools seem twisted and cruel, designed to maximize pain while operating with incredible precision."
	icon_state = "toolkit_surgical_cruel"
	aug_overlay = "toolkit_med"
	actions_types = list(/datum/action/item_action/organ_action/toggle/toolkit)

/obj/item/organ/cyberimp/arm/toolkit/surgery/cruel/get_init_items()
	return list(
		/obj/item/retractor/cruel/augment,
		/obj/item/hemostat/cruel/augment,
		/obj/item/cautery/cruel/augment,
		/obj/item/surgicaldrill/cruel/augment,
		/obj/item/scalpel/cruel/augment,
		/obj/item/circular_saw/cruel/augment,
		/obj/item/surgical_drapes,
	)

<<<<<<< HEAD
/obj/item/organ/cyberimp/arm/toolkit/janitor
	name = "janitorial toolset implant"
	desc = "A set of janitorial tools hidden behind a concealed panel on the user's arm."
	icon = 'icons/psychonaut/obj/medical/organs/organs.dmi'
	icon_state = "toolkit_janitor"
	items_to_create = list(
		/obj/item/lightreplacer,
		/obj/item/holosign_creator,
		/obj/item/soap/nanotrasen,
		/obj/item/reagent_containers/spray/cyborg_drying,
		/obj/item/mop/advanced,
		/obj/item/paint/paint_remover,
		/obj/item/reagent_containers/cup/beaker/large,
		/obj/item/reagent_containers/spray/cleaner
	)
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.25, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 0.75, /datum/material/silver = SHEET_MATERIAL_AMOUNT * 0.75)

/obj/item/organ/cyberimp/arm/toolkit/janitor/emag_act()
	if(obj_flags & EMAGGED)
		return FALSE
	to_chat(usr, span_notice("You unlock [src]'s integrated deluxe cleaning supplies!"))
	items_list += WEAKREF(new /obj/item/soap/syndie(src)) //We add not replace.
	items_list += WEAKREF(new /obj/item/reagent_containers/spray/cyborg_lube(src))
	var/obj/emagged_lightreplacer = new /obj/item/lightreplacer(src)
	emagged_lightreplacer.obj_flags |= EMAGGED
	items_list += WEAKREF(emagged_lightreplacer)
	obj_flags |= EMAGGED
	return TRUE

/obj/item/organ/cyberimp/arm/toolkit/paramedic
	name = "paramedic toolset implant"
	desc = "A set of rescue tools hidden behind a concealed panel on the user's arm."
	icon = 'icons/psychonaut/obj/medical/organs/organs.dmi'
	icon_state = "toolkit_paramedic"
	items_to_create = list(
		/obj/item/emergency_bed/silicon,
		/obj/item/sensor_device,
		/obj/item/pinpointer/crew,
	)
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.25, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 0.75, /datum/material/silver = SHEET_MATERIAL_AMOUNT * 0.75)

/obj/item/organ/cyberimp/arm/toolkit/atmospherics
	name = "atmospherics toolset implant"
	desc = "A set of atmospheric tools hidden behind a concealed panel on the user's arm."
	icon = 'icons/psychonaut/obj/medical/organs/organs.dmi'
	icon_state = "toolkit_atmosph"
	items_to_create = list(
		/obj/item/extinguisher,
		/obj/item/analyzer,
		/obj/item/crowbar/cyborg,
		/obj/item/wrench/cyborg,
		/obj/item/holosign_creator/atmos,
		/obj/item/pipe_dispenser,
	)
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.25, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 0.75, /datum/material/silver = SHEET_MATERIAL_AMOUNT * 0.75)

/obj/item/organ/cyberimp/arm/toolkit/botany
	name = "botany arm implant"
	desc = "A rather simple arm implant containing tools used in gardening and botanical research."
	icon = 'icons/psychonaut/obj/medical/organs/organs.dmi'
	icon_state = "toolkit_hydro"
	items_to_create = list(
		/obj/item/cultivator,
		/obj/item/shovel/spade,
		/obj/item/hatchet,
		/obj/item/plant_analyzer,
		/obj/item/geneshears,
		/obj/item/secateurs,
		/obj/item/storage/bag/plants,
		/obj/item/storage/bag/plants/portaseeder
	)
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.25, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 0.75, /datum/material/silver = SHEET_MATERIAL_AMOUNT * 0.75)

/obj/item/organ/cyberimp/arm/toolkit/mantis
	name = "C.H.R.O.M.A.T.A. mantis blade implants"
	desc = "High tech mantis blade implants, easily portable weapon, that has a high wound potential."
	icon = 'icons/psychonaut/obj/weapons/sword.dmi'
	icon_state = "mantis"
	items_to_create = list(/obj/item/mantis_blade)

/obj/item/organ/cyberimp/arm/toolkit/mantis/syndicate
	name = "A.R.A.S.A.K.A. mantis blade implants"
	desc = "Modernized mantis blade designed coined by Tiger operatives, much sharper blade with energy actuators makes it a much deadlier weapon."
	icon_state = "syndie_mantis"
	organ_flags = parent_type::organ_flags | ORGAN_HIDDEN
	items_to_create = list(/obj/item/mantis_blade/syndicate)

/obj/item/organ/cyberimp/arm/toolkit/mantis/shield
	name = "S.A.Y.A. arm defense system implants"
	desc = "Shield blade implants that allow user to block upcoming attacks at the cost of mobility and offense."
	icon_state = "shield_mantis"
	items_to_create = list(/obj/item/mantis_blade/shield)

#define DOAFTER_SOURCE_STRONGARM_INTERACTION "strongarm interaction"

=======
>>>>>>> bf6f771a1e221e06938978e36bbaf78543f85ebe
// Strong-Arm Implant //

#define DOAFTER_SOURCE_STRONGARM_INTERACTION "strongarm interaction"

/obj/item/organ/cyberimp/arm/strongarm
	name = "\proper Strong-Arm empowered musculature implant"
	desc = "When implanted, this cybernetic implant will enhance the muscles of the arm to deliver more power-per-action. Install one in each arm \
		to pry open doors with your bare hands!"
	icon_state = "muscle_implant"
	zone = BODY_ZONE_R_ARM
	slot = ORGAN_SLOT_RIGHT_ARM_MUSCLE
	valid_zones = list(
		BODY_ZONE_R_ARM = ORGAN_SLOT_RIGHT_ARM_MUSCLE,
		BODY_ZONE_L_ARM = ORGAN_SLOT_LEFT_ARM_MUSCLE,
	)
	aug_overlay = "strongarm"

	/// The amount of damage the implant adds to the lower punching force of our arm.
	var/lower_punch_damage = 0
	/// The amount of damage the implant adds to the upper punching force of our arm.
	var/upper_punch_damage = 2
	/// The amount of punch effectiveness (AKA accuracy and crit potential) the implant adds to our arm
	var/punch_effectiveness_added = 10
	/// How much extra damage does our implant allow the implanted while grabbing someone and they are unable to break the grapple?
	var/bonus_grab_damage = 20
	/// Biotypes we apply an additional amount of damage too
	var/biotype_bonus_targets = MOB_SPECIAL | MOB_MINING
	/// Extra damage dealt to our targeted mobs
	var/biotype_bonus_damage = 20
	/// IF true, the throw attack will not smash people into walls
	var/non_harmful_throw = TRUE
	/// How far away your attack will throw your oponent
	var/attack_throw_range = 1
	/// Minimum throw power of the attack
	var/throw_power_min = 1
	/// Maximum throw power of the attack
	var/throw_power_max = 4
	/// How long will the implant malfunction if it is EMP'd
	var/emp_base_duration = 9 SECONDS
	/// How long before we get another slam punch against a human; consider that these usually come in pairs
	var/slam_cooldown_duration = 5 SECONDS
	/// Tracks how soon we can perform another slam attack
	COOLDOWN_DECLARE(slam_cooldown)

/obj/item/organ/cyberimp/arm/strongarm/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/strongarm)

/obj/item/organ/cyberimp/arm/strongarm/on_mob_insert(mob/living/carbon/arm_owner)
	. = ..()
	if(ishuman(arm_owner)) //Sorry, only humans
		RegisterSignal(arm_owner, COMSIG_LIVING_EARLY_UNARMED_ATTACK, PROC_REF(on_attack_hand))

/obj/item/organ/cyberimp/arm/strongarm/on_mob_remove(mob/living/carbon/arm_owner)
	. = ..()
	UnregisterSignal(arm_owner, COMSIG_LIVING_EARLY_UNARMED_ATTACK)

/obj/item/organ/cyberimp/arm/strongarm/on_bodypart_insert(obj/item/bodypart/arm)
	. = ..()
	arm.unarmed_damage_low += lower_punch_damage
	arm.unarmed_damage_high += upper_punch_damage
	arm.unarmed_effectiveness += punch_effectiveness_added
	arm.unarmed_grab_damage_bonus += bonus_grab_damage

/obj/item/organ/cyberimp/arm/strongarm/on_bodypart_remove(obj/item/bodypart/arm)
	. = ..()
	arm.unarmed_damage_low -= lower_punch_damage
	arm.unarmed_damage_high -= upper_punch_damage
	arm.unarmed_effectiveness -= punch_effectiveness_added
	arm.unarmed_grab_damage_bonus -= bonus_grab_damage

/obj/item/organ/cyberimp/arm/strongarm/emp_act(severity)
	. = ..()
	if((organ_flags & ORGAN_FAILING) || . & EMP_PROTECT_SELF)
		return
	owner.balloon_alert(owner, "your arm spasms wildly!")
	organ_flags |= ORGAN_FAILING
	addtimer(CALLBACK(src, PROC_REF(reboot)), 90 / severity)

/obj/item/organ/cyberimp/arm/strongarm/proc/reboot()
	organ_flags &= ~ORGAN_FAILING
	owner.balloon_alert(owner, "your arm stops spasming!")

/obj/item/organ/cyberimp/arm/strongarm/proc/on_attack_hand(mob/living/carbon/human/source, atom/target, proximity, modifiers)
	SIGNAL_HANDLER

	if(source.get_active_hand() != bodypart_owner || !proximity)
		return NONE
	if(!source.combat_mode || LAZYACCESS(modifiers, RIGHT_CLICK))
		return NONE
	if(!isliving(target))
		return NONE
	if(HAS_TRAIT(source, TRAIT_HULK)) //NO HULK
		return NONE
	if(!COOLDOWN_FINISHED(src, slam_cooldown) && ishuman(target))
		return NONE
	if(!source.can_unarmed_attack())
		return COMPONENT_SKIP_ATTACK

	var/mob/living/living_target = target
	var/picked_hit_type = pick("punch", "smash", "pummel", "bash", "slam")

	if(organ_flags & ORGAN_FAILING)
		if(source.body_position != LYING_DOWN && living_target != source && prob(50))
			to_chat(source, span_danger("You try to [picked_hit_type] [living_target], but lose your balance and fall!"))
			source.Knockdown(3 SECONDS)
			source.forceMove(get_turf(living_target))
		else
			to_chat(source, span_danger("Your muscles spasm!"))
			source.Paralyze(1 SECONDS)
		return COMPONENT_CANCEL_ATTACK_CHAIN

	var/ground_bounce = FALSE // funny flavor. if you hit someone who's floored you slam them into the ground, breaking tiles
	var/turf/target_turf = get_turf(living_target)

	/* Damage calculations operate on the same math used in /datum/species/proc/harm():
	* Unarmed damage is randomized between an upper and lower value.
	* The lower value is determined by taking the damage value from the limb, and then increasing that value based on athletics level (min upper value)
	* The upper value is determiend by taking the damage value from the limb, and then seeing if we have the strength trait, providing extra damage.
	* The end result is that the more investment into athletics, the more precise the damage is, without necessarily increasing the potential damage.
	*/

	// Our attacking limb
	var/obj/item/bodypart/attacking_bodypart = bodypart_owner
	// The upper damage, calculated first as it will be used to cap our potential lower damage.
	var/potential_upper_damage = attacking_bodypart.unarmed_damage_high + (HAS_TRAIT(source, TRAIT_STRENGTH) ? 2 : 0)
	// The lower damage, which is capped by potential_upper_damage
	var/potential_lower_damage = min(attacking_bodypart.unarmed_damage_low + (source.mind?.get_skill_level(/datum/skill/athletics) || 0), potential_upper_damage)
	// Finally, we determine the actual damage roll.
	var/potential_damage = rand(potential_lower_damage, potential_upper_damage)
	// This value is used to determine armour penetration.
	var/potential_effectiveness = attacking_bodypart.unarmed_effectiveness
	// This is a damage and penetration multiplier if our target is grabbed when we deliver our punch.
	var/potential_pummel_bonus = attacking_bodypart.unarmed_pummeling_bonus

	if(living_target.pulledby && living_target.pulledby.grab_state >= GRAB_AGGRESSIVE) // get pummeled idiot
		potential_damage *= potential_pummel_bonus
		potential_effectiveness *= potential_pummel_bonus
		if(living_target.body_position == LYING_DOWN)
			ground_bounce = TRUE

	var/is_correct_biotype = living_target.mob_biotypes & biotype_bonus_targets
	if(biotype_bonus_targets && is_correct_biotype) //If we are punching one of our special biotype targets, increase the damage floor by a factor of two.
		potential_damage += biotype_bonus_damage

	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		if(human_target.check_block(source, potential_damage, "[source]'s' [picked_hit_type]"))
			source.do_attack_animation(target)
			playsound(living_target.loc, 'sound/items/weapons/punchmiss.ogg', 25, TRUE, -1)
			log_combat(source, target, "attempted to [picked_hit_type]", "muscle implant")
			return COMPONENT_CANCEL_ATTACK_CHAIN

	source.do_attack_animation(target, ATTACK_EFFECT_SMASH)
	playsound(living_target.loc, 'sound/items/weapons/punch1.ogg', 25, TRUE, -1)

	// Some mobs gib when killed, so we're logging early. At this point, we're definitely hitting, so...
	living_target.visible_message(
		span_danger("[source] [picked_hit_type]ed [living_target][ground_bounce ? " into [target_turf]" : ""]!"),
		span_userdanger("You're [picked_hit_type]ed by [source][ground_bounce ? " into [target_turf]" : ""]!"),
		span_hear("You hear a sickening sound of flesh hitting flesh!"),
		COMBAT_MESSAGE_RANGE,
		source,
	)

	to_chat(source, span_danger("You [picked_hit_type] [target][ground_bounce ? " into [target_turf]" : ""]!"))

	log_combat(source, target, "[picked_hit_type]ed", "muscle implant")

	if(ishuman(target))
		COOLDOWN_START(src, slam_cooldown, slam_cooldown_duration)

	var/target_zone = living_target.get_random_valid_zone(source.zone_selected)
	var/armor_block = living_target.run_armor_check(target_zone, MELEE, armour_penetration = potential_effectiveness)
	living_target.apply_damage(potential_damage * 2, attacking_bodypart.attack_type, target_zone, armor_block)

	if(source.body_position != LYING_DOWN && !QDELETED(living_target)) //Throw them if we are standing and we didn't somehow just completely obliterate the target
		var/atom/throw_target = get_edge_target_turf(living_target, source.dir)
		living_target.throw_at(throw_target, attack_throw_range, rand(throw_power_min,throw_power_max), source, gentle = non_harmful_throw)
		if(ground_bounce)
			if(isfloorturf(target_turf))
				var/turf/open/floor/crunched = target_turf
				crunched.crush() // crunch
	else if (ground_bounce) // Just in case our target mob somehow evaporated during this process, we still leave an obliterated tile in their wake
		if(isfloorturf(target_turf))
			var/turf/open/floor/crunched = target_turf
			crunched.crush() // again, crunch

	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/status_effect/organ_set_bonus/strongarm
	id = "organ_set_bonus_strongarm"
	organs_needed = 2
	bonus_activate_text = span_notice("Your improved arms allow you to open airlocks by force with your bare hands!")
	bonus_deactivate_text = span_notice("You can no longer force open airlocks with your bare hands.")
	required_biotype = NONE

/datum/status_effect/organ_set_bonus/strongarm/enable_bonus(obj/item/organ/inserted_organ)
	. = ..()
	if(!.)
		return
	owner.AddElement(/datum/element/door_pryer, pry_time = 6 SECONDS, interaction_key = DOAFTER_SOURCE_STRONGARM_INTERACTION)

/datum/status_effect/organ_set_bonus/strongarm/disable_bonus(obj/item/organ/removed_organ)
	. = ..()
	owner.RemoveElement(/datum/element/door_pryer, pry_time = 6 SECONDS, interaction_key = DOAFTER_SOURCE_STRONGARM_INTERACTION)

#undef DOAFTER_SOURCE_STRONGARM_INTERACTION

/obj/item/organ/cyberimp/arm/ammo_counter
	name = "S.M.A.R.T. ammo logistics system"
	desc = "Special inhand implant that transmits the current ammo and energy data straight to the user's arm screen."
	icon = 'icons/psychonaut/obj/medical/organs/organs.dmi'
	icon_state = "hand_implant"
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 2, /datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/diamond = HALF_SHEET_MATERIAL_AMOUNT)

	var/atom/movable/screen/cybernetics/ammo_counter/counter_ref
	var/obj/item/gun/our_gun

/obj/item/organ/cyberimp/arm/ammo_counter/Insert(mob/living/carbon/M, special = FALSE, movement_flags)
	. = ..()
	RegisterSignal(M, COMSIG_LIVING_PICKED_UP_ITEM, PROC_REF(add_to_hand))

/obj/item/organ/cyberimp/arm/ammo_counter/Remove(mob/living/carbon/M, special = FALSE, movement_flags)
	. = ..()
	UnregisterSignal(M, COMSIG_LIVING_PICKED_UP_ITEM)
	our_gun = null
	update_hud_elements()

/obj/item/organ/cyberimp/arm/ammo_counter/proc/update_hud_elements()
	SIGNAL_HANDLER
	if(!owner || !owner?.hud_used)
		return


	var/datum/hud/H = owner.hud_used

	var/hud_key = zone == BODY_ZONE_L_ARM ? HUD_MOB_AMMO_COUNTER_L : HUD_MOB_AMMO_COUNTER_R

	if(!our_gun)
		if(!H.screen_objects[hud_key])
			return
		H.remove_screen_object(counter_ref)
		counter_ref = null
		return


	if(!H.screen_objects[hud_key])
		var/ui_loc = zone == BODY_ZONE_L_ARM ? ui_hand_position_y(1,1,9) : ui_hand_position_y(2,1,9)
		counter_ref = H.add_screen_object(/atom/movable/screen/cybernetics/ammo_counter, hud_key, HUD_GROUP_STATIC, null, ui_loc, TRUE)

	counter_ref?.update_counter(our_gun)

/obj/item/organ/cyberimp/arm/ammo_counter/proc/add_to_hand(datum/source, obj/item/maybegun)
	SIGNAL_HANDLER

	var/obj/item/bodypart/bp = owner.get_active_hand()

	if(bp.body_zone != zone)
		return

	if(istype(maybegun,/obj/item/gun/ballistic) || istype(maybegun,/obj/item/gun/energy))
		our_gun = maybegun
		RegisterSignal(owner, COMSIG_MOB_FIRED_GUN, PROC_REF(update_hud_elements))
		RegisterSignal(our_gun, COMSIG_ATOM_UPDATE_APPEARANCE, PROC_REF(update_hud_elements))
		RegisterSignal(our_gun, COMSIG_ITEM_DROPPED, PROC_REF(remove_from_hand))

	update_hud_elements()

/obj/item/organ/cyberimp/arm/ammo_counter/proc/remove_from_hand(datum/source, mob/user)
	SIGNAL_HANDLER

	if(our_gun != source)
		return

	UnregisterSignal(owner, COMSIG_MOB_FIRED_GUN)
	UnregisterSignal(source, COMSIG_ATOM_UPDATE_APPEARANCE)
	UnregisterSignal(source, COMSIG_ITEM_DROPPED)

	our_gun = null
	update_hud_elements()

/obj/item/organ/cyberimp/arm/ammo_counter/syndicate
	organ_flags = parent_type::organ_flags | ORGAN_HIDDEN

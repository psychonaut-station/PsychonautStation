/obj/item/ipc_suit
	name = "ipc endoskeleton"
	desc = "A complex metal backbone with standard limb sockets and pseudomuscle anchors."
	icon = 'icons/psychonaut/mob/human/species/ipc/bodyparts.dmi'
	icon_state = "ipc_suit"
	w_class = WEIGHT_CLASS_GIGANTIC
	var/list/features

	var/obj/item/organ/internal/brain/basic_posibrain/brain
	var/obj/item/organ/internal/tongue/robot/tongue
	var/obj/item/organ/internal/eyes/robotic/eye
	var/obj/item/organ/internal/ears/cybernetic/ear
	var/obj/item/organ/external/ipchead/monitor
	var/obj/item/organ/internal/stomach/ipc/stomach
	var/obj/item/organ/internal/heart/ipc/heart
	var/obj/item/organ/internal/voltprotector/voltprotector
	var/obj/item/bodypart/head/ipc/head
	var/obj/item/bodypart/chest/ipc/chest
	var/obj/item/bodypart/arm/left/ipc/leftarm
	var/obj/item/bodypart/arm/right/ipc/rightarm
	var/obj/item/bodypart/leg/left/ipc/leftleg
	var/obj/item/bodypart/leg/right/ipc/rightleg

/obj/item/ipc_suit/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/item/ipc_suit/Destroy()
	QDEL_NULL(brain)
	QDEL_NULL(tongue)
	QDEL_NULL(eye)
	QDEL_NULL(ear)
	QDEL_NULL(monitor)
	QDEL_NULL(stomach)
	QDEL_NULL(heart)
	QDEL_NULL(voltprotector)
	QDEL_NULL(head)
	QDEL_NULL(chest)
	QDEL_NULL(leftarm)
	QDEL_NULL(rightarm)
	QDEL_NULL(leftleg)
	QDEL_NULL(rightleg)
	return ..()

/obj/item/ipc_suit/update_overlays()
	. = ..()
	if(leftarm)
		. += "[initial(leftarm.icon_state)]"
	if(rightarm)
		. += "[initial(rightarm.icon_state)]"
	if(chest)
		. += "[initial(chest.icon_state)]"
	if(leftleg)
		. += "[initial(leftleg.icon_state)]"
	if(rightleg)
		. += "[initial(rightleg.icon_state)]"
	if(head)
		. += "[initial(head.icon_state)]"
	if(monitor)
		. += "[initial(monitor.icon_state)]"

/obj/item/ipc_suit/attackby(obj/item/weapon, mob/user, params)
	if(istype(weapon, /obj/item/bodypart/chest/ipc))
		var/obj/item/bodypart/chest/ipc/newchest = weapon
		if(chest)
			to_chat(user, span_warning("You have already inserted the chest!"))
			return
		else
			if(!user.transferItemToLoc(weapon, src))
				return
			chest = newchest
			to_chat(user, span_notice("You insert the chest."))
			update_appearance()
			return
	else if(istype(weapon, /obj/item/bodypart/head/ipc))
		var/obj/item/bodypart/head/ipc/newhead = weapon
		if(head)
			to_chat(user, span_warning("You have already inserted the head!"))
			return
		else
			if(!user.transferItemToLoc(weapon, src))
				return
			head = newhead
			to_chat(user, span_notice("You insert head."))
			update_appearance()
			return
	else if(istype(weapon, /obj/item/bodypart/arm/left/ipc))
		var/obj/item/bodypart/arm/left/ipc/newleftarm = weapon
		if(leftarm)
			to_chat(user, span_warning("You have already inserted the arm!"))
			return
		else
			if(!user.transferItemToLoc(weapon, src))
				return
			leftarm = newleftarm
			to_chat(user, span_notice("You insert arm."))
			update_appearance()
			return
	else if(istype(weapon, /obj/item/bodypart/arm/right/ipc))
		var/obj/item/bodypart/arm/right/ipc/newrightarm = weapon
		if(rightarm)
			to_chat(user, span_warning("You have already inserted the arm!"))
			return
		else
			if(!user.transferItemToLoc(weapon, src))
				return
			rightarm = newrightarm
			to_chat(user, span_notice("You insert arm."))
			update_appearance()
			return
	else if(istype(weapon, /obj/item/bodypart/leg/left/ipc))
		var/obj/item/bodypart/leg/left/ipc/newleftleg = weapon
		if(leftleg)
			to_chat(user, span_warning("You have already inserted the leg!"))
			return
		else
			if(!user.transferItemToLoc(weapon, src))
				return
			leftleg = newleftleg
			to_chat(user, span_notice("You insert leg."))
			update_appearance()
			return
	else if(istype(weapon, /obj/item/bodypart/leg/right/ipc))
		var/obj/item/bodypart/leg/right/ipc/newrightleg = weapon
		if(rightleg)
			to_chat(user, span_warning("You have already inserted the leg!"))
			return
		else
			if(!user.transferItemToLoc(weapon, src))
				return
			rightleg = newrightleg
			to_chat(user, span_notice("You insert leg."))
			update_appearance()
			return
	else if(istype(weapon, /obj/item/organ/internal/brain/basic_posibrain))
		var/obj/item/organ/internal/brain/basic_posibrain/newbrain = weapon
		if(brain)
			to_chat(user, span_warning("You have already inserted the brain!"))
			return
		else
			if(!chest)
				to_chat(user, span_warning("There is no chest!"))
				return
			if(!user.transferItemToLoc(weapon, src))
				return
			brain = newbrain
			to_chat(user, span_notice("You insert the brain."))
			update_appearance()
			return
	else if(istype(weapon, /obj/item/organ/internal/tongue/robot))
		var/obj/item/organ/internal/tongue/robot/newtongue = weapon
		if(tongue)
			to_chat(user, span_warning("You have already inserted the tongue!"))
			return
		else
			if(!head)
				to_chat(user, span_warning("There is no head!"))
				return
			if(!user.transferItemToLoc(weapon, src))
				return
			tongue = newtongue
			to_chat(user, span_notice("You insert tongue."))
			update_appearance()
			return
	else if(istype(weapon, /obj/item/organ/internal/eyes/robotic))
		var/obj/item/organ/internal/eyes/robotic/neweye = weapon
		if(eye)
			to_chat(user, span_warning("You have already inserted the eye!"))
			return
		else
			if(!head)
				to_chat(user, span_warning("There is no head!"))
				return
			if(!user.transferItemToLoc(weapon, src))
				return
			eye = neweye
			to_chat(user, span_notice("You insert eye."))
			update_appearance()
			return
	else if(istype(weapon, /obj/item/organ/internal/ears/cybernetic))
		var/obj/item/organ/internal/ears/cybernetic/newear = weapon
		if(ear)
			to_chat(user, span_warning("You have already inserted the ear!"))
			return
		else
			if(!head)
				to_chat(user, span_warning("There is no head!"))
				return
			if(!user.transferItemToLoc(weapon, src))
				return
			ear = newear
			to_chat(user, span_notice("You insert ear."))
			update_appearance()
			return
	else if(istype(weapon, /obj/item/organ/external/ipchead))
		var/obj/item/organ/external/ipchead/newmonitor = weapon
		if(monitor)
			to_chat(user, span_warning("You have already inserted the monitor!"))
			return
		else
			if(!head)
				to_chat(user, span_warning("There is no head!"))
				return
			if(!user.transferItemToLoc(weapon, src))
				return
			monitor = newmonitor
			to_chat(user, span_notice("You insert monitor."))
			update_appearance()
			return
	else if(istype(weapon, /obj/item/organ/internal/stomach/ipc))
		var/obj/item/organ/internal/stomach/ipc/newstomach = weapon
		if(stomach)
			to_chat(user, span_warning("You have already inserted the stomach!"))
			return
		else
			if(!chest)
				to_chat(user, span_warning("There is no chest!"))
				return
			if(!newstomach.cell)
				to_chat(user, span_warning("There is no cell in stomach!"))
				return
			if(!user.transferItemToLoc(weapon, src))
				return
			stomach = newstomach
			to_chat(user, span_notice("You insert the stomach."))
			update_appearance()
			return
	else if(istype(weapon, /obj/item/organ/internal/heart/ipc))
		var/obj/item/organ/internal/heart/ipc/newheart = weapon
		if(heart)
			to_chat(user, span_warning("You have already inserted the heart!"))
			return
		else
			if(!chest)
				to_chat(user, span_warning("There is no chest!"))
				return
			if(!user.transferItemToLoc(weapon, src))
				return
			heart = newheart
			to_chat(user, span_notice("You insert the heart."))
			update_appearance()
			return
	else if(istype(weapon, /obj/item/organ/internal/voltprotector))
		var/obj/item/organ/internal/voltprotector/newvoltprotector = weapon
		if(voltprotector)
			to_chat(user, span_warning("You have already inserted the volt protector!"))
			return
		else
			if(!chest)
				to_chat(user, span_warning("There is no chest!"))
				return
			if(!user.transferItemToLoc(weapon, src))
				return
			voltprotector = newvoltprotector
			to_chat(user, span_notice("You insert volt protector."))
			update_appearance()
			return
	return ..()

/obj/item/ipc_suit/crowbar_act(mob/living/user, obj/item/prytool)
	..()
	var/turf/drop_loc = drop_location()
	if(brain || tongue || eye || ear || monitor || stomach || heart || voltprotector || head || leftarm || rightarm || leftleg || rightleg)
		prytool.play_tool_sound(src)
		to_chat(user, span_notice("You remove the organs from [src]."))
		brain?.forceMove(drop_loc)
		tongue?.forceMove(drop_loc)
		eye?.forceMove(drop_loc)
		ear?.forceMove(drop_loc)
		monitor?.forceMove(drop_loc)
		stomach?.forceMove(drop_loc)
		heart?.forceMove(drop_loc)
		voltprotector?.forceMove(drop_loc)
		head?.forceMove(drop_loc)
		chest?.forceMove(drop_loc)
		leftarm?.forceMove(drop_loc)
		rightarm?.forceMove(drop_loc)
		leftleg?.forceMove(drop_loc)
		rightleg?.forceMove(drop_loc)

		brain = null
		tongue = null
		eye = null
		ear = null
		monitor = null
		stomach = null
		heart = null
		voltprotector = null
		head = null
		chest = null
		leftarm = null
		rightarm = null
		leftleg = null
		rightleg = null
		update_appearance()
	else
		to_chat(user, span_warning("There is no organ to remove from [src]."))
	return TRUE

/obj/item/ipc_suit/screwdriver_act(mob/living/user, obj/item/screwtool)
	..()
	. = TRUE
	if(!(brain && tongue && eye && ear && monitor && stomach && heart && voltprotector && head && chest && leftarm && rightarm && leftleg && rightleg))
		to_chat(user, span_warning("There are unattached parts or organs!"))
		return
	if(screwtool.use_tool(src, user, 5 SECONDS))
		screwtool.play_tool_sound(src)
		var/mob/living/carbon/human/ipcman = new /mob/living/carbon/human(loc)
		qdel(ipcman.get_organ_slot(ORGAN_SLOT_BRAIN))
		var/datum/species/ipc/ipcspecie = new /datum/species/ipc
		ipcspecie.mutantstomach = stomach
		ipcspecie.mutanteyes = eye
		ipcspecie.mutantears = ear
		ipcspecie.external_organs = list(monitor)
		ipcman.real_name = "[pick(GLOB.posibrain_names)] [rand(1,999)]"
		brain.Insert(ipcman)
		ipcman.hardset_dna(null, null, null, ipcman.real_name, null, ipcspecie, null)
		forceMove(ipcman)

/obj/item/ipc_suit/examine(mob/user)
	. = ..()
	var/list/nicelist = list()
	if(!brain)
		nicelist += "Brain"
	if(!tongue)
		nicelist += "Tongue"
	if(!eye)
		nicelist += "Eye"
	if(!ear)
		nicelist += "Ear"
	if(!monitor)
		nicelist += "Monitor"
	if(!stomach)
		nicelist += "Stomach"
	if(!heart)
		nicelist += "Heart"
	if(!voltprotector)
		nicelist += "Voltage-Protector"
	if(!head)
		nicelist += "Head"
	if(!chest)
		nicelist += "Chest"
	if(!leftarm)
		nicelist += "Left arm"
	if(!rightarm)
		nicelist += "Right arm"
	if(!leftleg)
		nicelist += "Left leg"
	if(!rightleg)
		nicelist += "Right leg"
	. += span_info("It requires [english_list(nicelist, "no more organs")].")

// For testing
/obj/item/ipc_suit/brainless
	tongue = new /obj/item/organ/internal/tongue/robot
	eye = new /obj/item/organ/internal/eyes/robotic
	ear = new /obj/item/organ/internal/ears/cybernetic
	monitor = new /obj/item/organ/external/ipchead/black
	heart = new /obj/item/organ/internal/heart/ipc
	stomach = new /obj/item/organ/internal/stomach/ipc
	voltprotector = new /obj/item/organ/internal/voltprotector
	head = new /obj/item/bodypart/head/ipc
	chest = new /obj/item/bodypart/chest/ipc
	leftarm = new /obj/item/bodypart/arm/left/ipc
	rightarm = new /obj/item/bodypart/arm/right/ipc
	leftleg = new /obj/item/bodypart/leg/left/ipc
	rightleg = new /obj/item/bodypart/leg/right/ipc

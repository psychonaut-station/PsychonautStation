//MARK: Operation datum
/datum/surgery_operation/organ/shadow_thrall_tumor
	name = "Shadow Thrall Tumor Extraction"
	rnd_name = "Neurosurgery (Shadow Thrall Tumor Extraction)"
	desc = "Extract the parasitic hive node from the patient's brain."
	target_type = /obj/item/organ/brain/shadow/tumor_thrall
	implements = list(/obj/item/flashlight = 0.5)
	time = 10 SECONDS
	all_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_BONE_SAWED
	any_surgery_states_blocked = SURGERY_VESSELS_UNCLAMPED

/datum/surgery_operation/organ/shadow_thrall_tumor/tool_check(obj/item/tool)
	if(!istype(tool, /obj/item/flashlight))
		return FALSE
	var/obj/item/flashlight/flashlight = tool
	return flashlight.light_on

/datum/surgery_operation/organ/shadow_thrall_tumor/state_check(obj/item/organ/brain/shadow/tumor_thrall/organ)
	if(!istype(organ))
		return FALSE
	if(!organ.owner)
		return FALSE
	return organ.owner.get_organ_slot(ORGAN_SLOT_BRAIN_THRALL) == organ

/datum/surgery_operation/organ/shadow_thrall_tumor/on_success(obj/item/organ/brain/shadow/tumor_thrall/organ, mob/living/surgeon, obj/item/tool, list/operation_args)
	if(!organ || QDELETED(organ))
		return
	organ.mob_remove(organ.owner, special = FALSE, movement_flags = NO_ID_TRANSFER)
	qdel(organ)

// MARK: Shadows Thrall Organs
/obj/item/organ/brain/shadow/shadowling
	name = "shadowling swarm brain"
	desc = "A writhing mass of shadowy matter binding its host to the Hive."
	slot = ORGAN_SLOT_BRAIN

/obj/item/organ/brain/shadow/tumor_thrall
	name = "shadow thrall tumor"
	desc = "A parasitic hive node that enmeshes the host's mind."
	slot = ORGAN_SLOT_BRAIN_THRALL

/obj/item/organ/brain/shadow/tumor_thrall/Initialize(mapload)
	. = ..()
	organ_flags &= ~ORGAN_VITAL

/obj/item/organ/brain/shadow/tumor_thrall/Insert(mob/living/carbon/receiver, special = FALSE, movement_flags)
	. = ..()
	if(!.)
		return FALSE
	receiver?.mind?.add_antag_datum(/datum/antagonist/shadow_thrall)
	RegisterSignal(receiver, COMSIG_ATOM_EXAMINE, PROC_REF(on_holder_examine))
	to_chat(receiver, span_danger("A freezing whisper permeates your mind... You have been enslaved!"))

/obj/item/organ/brain/shadow/tumor_thrall/on_mob_remove(mob/living/carbon/organ_owner, special = FALSE, movement_flags)
	organ_owner?.mind?.remove_antag_datum(/datum/antagonist/shadow_thrall)
	UnregisterSignal(organ_owner, COMSIG_ATOM_EXAMINE)
	if(organ_owner)
		to_chat(organ_owner, span_notice("The binding cold recedes from your mind. You are yourself once more!"))

	. = ..()

/obj/item/organ/brain/shadow/tumor_thrall/proc/on_holder_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = source
	if(!istype(H) || !ismob(user))
		return
	if(H.get_organ_slot(ORGAN_SLOT_BRAIN_THRALL) != src)
		return
	if(!user.Adjacent(H))
		return
	if(H.wear_mask)
		return
	examine_list += span_warning("[capitalize(H.p_their())] face is unnaturally contorted and hollow.")

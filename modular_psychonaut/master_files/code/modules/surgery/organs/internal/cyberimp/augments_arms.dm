/obj/item/organ/cyberimp/arm/on_mob_remove(mob/living/carbon/arm_owner)
	. = ..()
	UnregisterSignal(arm_owner, COMSIG_CARBON_POST_ATTACH_LIMB)

/obj/item/organ/cyberimp/arm/on_limb_attached(mob/living/carbon/source, obj/item/bodypart/limb)
	. = ..()
	if(!limb || QDELETED(limb) || limb.body_zone != zone)
		return
	RegisterSignal(limb, COMSIG_QDELETING, PROC_REF(on_limb_qdel))

/obj/item/organ/cyberimp/arm/on_limb_detached(obj/item/bodypart/source)
	. = ..()
	if(source != hand || QDELETED(hand))
		return
	UnregisterSignal(hand, COMSIG_QDELETING)

/obj/item/organ/cyberimp/arm/proc/on_limb_qdel()
	UnregisterSignal(hand, COMSIG_BODYPART_REMOVED)
	UnregisterSignal(hand, COMSIG_QDELETING)
	hand = null

/obj/item/organ/cyberimp/arm/toolkit/on_mob_remove(mob/living/carbon/arm_owner)
	. = ..()
	UnregisterSignal(arm_owner, COMSIG_KB_MOB_DROPITEM_DOWN)

/obj/item/organ/cyberimp/arm/toolkit/on_limb_qdel()
	UnregisterSignal(hand, COMSIG_ITEM_ATTACK_SELF)
	return ..()

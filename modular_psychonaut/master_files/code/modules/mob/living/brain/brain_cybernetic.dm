/obj/item/organ/brain/cybernetic/ipc
	name = "ipc brain"
	desc = "A mechanical brain found inside of ipc's. Not to be confused with a positronic brain."
	zone = BODY_ZONE_CHEST

/obj/item/organ/brain/cybernetic/ipc/examine(mob/user)
	. = ..()
	. += span_notice("Alt+Click to change the organ zone!")

/obj/item/organ/brain/cybernetic/ipc/click_alt(mob/living/living_user)
	if(zone == BODY_ZONE_CHEST)
		zone = BODY_ZONE_HEAD
	else if(zone == BODY_ZONE_HEAD)
		zone = BODY_ZONE_CHEST
	balloon_alert(living_user, "zone setted to [zone]")

/obj/item/organ/brain/cybernetic/ipc/attack(mob/living/carbon/target, mob/user)
	if(!isipc(target) && zone != BODY_ZONE_HEAD)
		return
	return ..()

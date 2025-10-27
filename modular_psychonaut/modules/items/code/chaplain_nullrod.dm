/**
 * Title:
 * 	Chapter Tech Priest Kit
 * Description:
 * 	Adds a new chaplain nullrod
 * Related files:
 *  `modular_psychonaut/master_files/icons/obj/weapons/chaplain.dmi`
 *  `modular_psychonaut/master_files/icons/mob/clothing/back.dmi`
 *  `modular_psychonaut/master_files/icons/mob/inhands/weapons/chaplain_lefthand.dmi`
 *  `modular_psychonaut/master_files/icons/mob/inhands/weapons/chaplain_righthand.dmi`
 * Credits:
 * 	Ureus
 */
/obj/item/nullrod/mace
	name = "space mace"
	desc = "This mace is looks like its from a space chaplain 40 thousand miles away."
	icon = 'modular_psychonaut/master_files/icons/obj/weapons/chaplain.dmi'
	icon_state = "crozius"
	inhand_icon_state = "crozius"
	worn_icon_state = "crozius"
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/back.dmi'
	lefthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/weapons/chaplain_lefthand.dmi'
	righthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/weapons/chaplain_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	attack_verb_continuous = list("smashes", "bashes", "crunches")
	attack_verb_simple = list("smash", "bash", "crunch")
	menu_description = "A space mace. Can be worn on the back."

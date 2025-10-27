/**
 * Title:
 * 	Chapter Chaplain Kit
 * Description:
 * 	Adds a new chaplain drip
 * Related files:
 *  `modular_psychonaut/master_files/icons/obj/clothing/head/chaplain.dmi`
 *  `modular_psychonaut/master_files/icons/mob/clothing/head/chaplain.dmi`
 *  `modular_psychonaut/master_files/icons/obj/clothing/suits/chaplain.dmi`
 *  `modular_psychonaut/master_files/icons/mob/clothing/suits/chaplain.dmi`
 *  `modular_psychonaut/master_files/icons/obj/clothing/shoes.dmi`
 *  `modular_psychonaut/master_files/icons/mob/clothing/feet.dmi`
 * Credits:
 * 	Ureus
 */
/obj/item/storage/box/holy/chapter
	name = "Chapter Chaplain kit"
	typepath_for_preview = /obj/item/clothing/suit/chaplainsuit/armor/chapter

/obj/item/storage/box/holy/chapter/PopulateContents()
	new /obj/item/clothing/head/helmet/chaplain/chapter(src)
	new /obj/item/clothing/suit/chaplainsuit/armor/chapter(src)
	new /obj/item/clothing/shoes/chapter(src)

/obj/item/clothing/head/helmet/chaplain/chapter
	name = "chapter chaplain helmet"
	desc = "For God-Emperor of Mankind!"
	icon_state = "rg_chaphelmet"
	inhand_icon_state = null
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/head/chaplain.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/head/chaplain.dmi'

/obj/item/clothing/suit/chaplainsuit/armor/chapter
	name = "chapter chaplain suit"
	desc = "For God-Emperor of Mankind!"
	icon_state = "rg_chapsuit"
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/suits/chaplain.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/suits/chaplain.dmi'
	inhand_icon_state = null
	slowdown = 0

/obj/item/clothing/shoes/chapter
	name = "chapter chaplain boots"
	desc = "Anti-heresy boots!"
	icon_state = "rg_boots"
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/shoes.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/feet.dmi'
	resistance_flags = NONE
	fastening_type = SHOES_SLIPON

/**
 * Title:
 * 	Chapter Tech Priest Kit
 * Description:
 * 	Adds a new chaplain drip
 * Related files:
 *  `modular_psychonaut/master_files/icons/obj/clothing/head/chaplain.dmi`
 *  `modular_psychonaut/master_files/icons/mob/clothing/head/chaplain.dmi`
 *  `modular_psychonaut/master_files/icons/obj/clothing/suits/chaplain.dmi`
 *  `modular_psychonaut/master_files/icons/mob/clothing/suits/chaplain.dmi`
 * Credits:
 * 	Ureus
 */
/obj/item/storage/box/holy/tech
	name = "Tech Priest Kit"
	typepath_for_preview = /obj/item/clothing/suit/hooded/chaplain_hoodie/tech

/obj/item/storage/box/holy/tech/PopulateContents()
	new /obj/item/clothing/suit/hooded/chaplain_hoodie/tech(src)

/obj/item/clothing/suit/hooded/chaplain_hoodie/tech
	name = "tech priest cloak"
	desc = "Specially made cloak for Machine god believers. Offers some protection."
	icon_state = "chaplain_tech"
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/suits/chaplain.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/suits/chaplain.dmi'
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/chaplainsuit_armor_weaker
	hoodtype = /obj/item/clothing/head/hooded/chaplain_hood/tech
	hood_up_affix = ""

/obj/item/clothing/head/hooded/chaplain_hood/tech
	name = "tech priest hood"
	desc = "A divine hood for Machine God believers."
	icon_state = "chaplain_techhood"
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/head/chaplain.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/head/chaplain.dmi'
	armor_type = /datum/armor/chaplainsuit_armor_weaker

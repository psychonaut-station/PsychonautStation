/**
 * Title:
 * 	Tactical Helmet-Armour
 * Description:
 * 	Adds tactical helmet and armor to security vendor
 * Related files:
 *  `code/modules/vending/security.dm`
 *  `modular_psychonaut/master_files/icons/obj/clothing/head/helmet.dmi`
 *  `modular_psychonaut/master_files/icons/mob/clothing/head/helmet.dmi`
 *  `modular_psychonaut/master_files/icons/mob/clothing/suits/armor.dmi`
 *  `modular_psychonaut/master_files/icons/mob/clothing/suits/armor.dmi`
 * Credits:
 * 	Agalargaming
 *  Rengan
*/
/obj/item/clothing/head/helmet/alt/tactical
	name = "Tactical helmet"
	base_icon_state = "tactical_helmet"
	icon_state = "tactical_helmet"
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/head/helmet.dmi'

/obj/item/clothing/suit/armor/vest/alt/tactical_armor
	name = "Tactical armor vest"
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/suits/armor.dmi'
	icon_state = "tactical_armor"

/**
 * Title:
 * 	Hos Special Drips
 * Description:
 * 	Adds hos special drip
 * Related files:
 *  `modular_psychonaut/master_files/code/game/objects/items/storage/garment.dm`
 *  `modular_psychonaut/master_files/icons/obj/clothing/head/hats.dmi`
 *  `modular_psychonaut/master_files/icons/mob/clothing/head/hats.dmi`
 *  `modular_psychonaut/master_files/icons/obj/clothing/suits/armor.dmi`
 *  `modular_psychonaut/master_files/icons/mob/clothing/suits/armor.dmi`
 *  `modular_psychonaut/master_files/icons/obj/clothing/cloaks.dmi`
 *  `modular_psychonaut/master_files/icons/mob/clothing/neck.dmi`
 * Credits:
 *  Robotduinom
 *  Vicirdek
 * 	Agalargaming
*/
/obj/item/clothing/head/hats/hos/special
	name = "special cap"
	desc = "Mal huseyin. Derdimi acikliyorum?."
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/head/hats.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/head/hats.dmi'
	icon_state = "hoscapspecial"

/obj/item/clothing/suit/armor/hos/special
	name = "special armored jacket"
	desc = "Huseyin kim amk"
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/suits/armor.dmi'
	icon_state = "hosjacketspecial"

/obj/item/clothing/neck/cloak/hos/special
	name = "head of security's cloak"
	desc = "Senin dostum dediğin fake insanlar senin iktiri oktan dertlerini dinlerken müge anliya mi benziyor"
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/cloaks.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/neck.dmi'
	icon_state = "hoscloakspecial"

/**
 * Title:
 * 	Manager Jacket
 * Description:
 * 	Adds Manager Jacket from limbus company
 * Related files:
 *  `code/modules/vending/clothesmate.dm`
 *  `modular_psychonaut/master_files/icons/obj/clothing/suits/jacket.dmi`
 *  `modular_psychonaut/master_files/icons/mob/clothing/suits/jacket.dmi`
 * Credits:
 *  Auraden
 *  Ragnarok0
*/
/obj/item/clothing/suit/jacket/dante
	name = "manager jacket"
	desc = "An oversized jacket. %90 cotton %10 winrate"
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/suits/jacket.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/suits/jacket.dmi'
	icon_state = "dante"

/**
 * Title:
 * 	Ghost Mask
 * Description:
 * 	Adds Ghost Mask
 * Related files:
 *  `code/modules/vending/wardrobes.dm`
 *  `modular_psychonaut/master_files/icons/obj/clothing/masks.dmi`
 *  `modular_psychonaut/master_files/icons/mob/clothing/mask.dmi`
 * Credits:
 *  Robotduinom
 *  Vicirdek
*/
/obj/item/clothing/mask/gas/ghost_mask
	name = "ghost mask"
	desc = "What has two legs and bleeds?"
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/masks.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/mask.dmi'
	icon_state = "ghost_mask"
	custom_price = PAYCHECK_CREW * 7
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT
	flags_inv = HIDEEARS|HIDEFACE|HIDEFACIALHAIR|HIDEHAIR|HIDESNOUT
	visor_flags = BLOCK_GAS_SMOKE_EFFECT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT|HIDEEARS
	w_class = WEIGHT_CLASS_SMALL
	flags_cover = MASKCOVERSMOUTH
	visor_flags_cover = MASKCOVERSMOUTH
	inhand_icon_state = null

/**
 * Title:
 * 	Cross Necklace
 * Description:
 * 	Adds cross necklace
 * Related files:
 *  `code/modules/vending/wardrobes.dm`
 *  `modular_psychonaut/master_files/icons/obj/clothing/neck.dmi`
 *  `modular_psychonaut/master_files/icons/mob/clothing/neck.dmi`
 * Credits:
 *  MrEmre12
*/
/obj/item/clothing/neck/necklace/jhon
	name = "cross necklace"
	desc = "don't be afraid john."
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/neck.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/neck.dmi'
	icon_state = "cross"


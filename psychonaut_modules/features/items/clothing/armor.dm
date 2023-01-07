/obj/item/clothing/suit/armor/vest/alt/brig_physician
	icon = 'psychonaut_modules/icons/obj/armor.dmi'
	worn_icon = 'psychonaut_modules/icons/mob/armor.dmi'
	icon_state = "armor_bp"

/obj/item/clothing/head/helmet/brig_physician
	name = "medical helmet"
	desc = "A bulletproof combat helmet designed specially for physicians."
	icon = 'psychonaut_modules/icons/obj/helmet.dmi'
	worn_icon = 'psychonaut_modules/icons/mob/helmet.dmi'
	icon_state = "helmet_bp"
	inhand_icon_state = "helmet"
	armor_type = /datum/armor/helmet_brig_physician
	dog_fashion = null

/datum/armor/helmet_brig_physician
	melee = 15
	bullet = 60
	laser = 10
	energy = 10
	bomb = 40
	bio = 0
	fire = 50
	acid = 50
	wound = 5

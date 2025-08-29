/obj/item/chemvat_tank
	name = "chemvat tank"

	icon_state = "chemvat_back"
	icon = 'icons/psychonaut/obj/clothing/back.dmi'
	worn_icon = 'icons/psychonaut/mob/clothing/back.dmi'
	worn_icon_state = "chemvat_back"

	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK

	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/item/chemvat_tank/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, INNATE_TRAIT)

/obj/item/clothing/mask/chemvat
	name = "chemvat mask"
	icon_state = "chemvat_mask"
	icon = 'icons/psychonaut/obj/clothing/masks.dmi'
	worn_icon = 'icons/psychonaut/mob/clothing/mask.dmi'
	worn_icon_state = "chemvat_mask"
	lefthand_file = null
	righthand_file = null

	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/item/clothing/mask/chemvat/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, INNATE_TRAIT)

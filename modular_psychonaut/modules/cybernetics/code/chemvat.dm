/obj/item/chemvat_tank
	name = "chemvat tank"

	icon_state = "chemvat_back"
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/back.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/back.dmi'
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
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/masks.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/back.dmi'
	worn_icon_state = "chemvat_mask"
	lefthand_file = null
	righthand_file = null

	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/item/clothing/mask/chemvat/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, INNATE_TRAIT)

/obj/effect/temp_visual/chempunk
	icon = 'modular_psychonaut/master_files/icons/effects/96x96.dmi'
	icon_state = "chempunk"
	pixel_x = -32 //So the big ol' 96x96 sprite shows up right
	pixel_y = -32
	layer = BELOW_MOB_LAYER
	duration = 5

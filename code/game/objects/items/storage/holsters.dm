
/obj/item/storage/belt/holster
	name = "shoulder holster"
	desc = "A rather plain but still cool looking holster that can hold a handgun."
	icon_state = "holster"
	inhand_icon_state = "holster"
	worn_icon_state = "holster"
	alternate_worn_layer = UNDER_SUIT_LAYER
	w_class = WEIGHT_CLASS_BULKY
	storage_type = /datum/storage/holster

/obj/item/storage/belt/holster/equipped(mob/user, slot)
	. = ..()
	if(slot & (ITEM_SLOT_BELT|ITEM_SLOT_SUITSTORE))
		ADD_CLOTHING_TRAIT(user, TRAIT_GUNFLIP)

/obj/item/storage/belt/holster/dropped(mob/user)
	. = ..()
	REMOVE_CLOTHING_TRAIT(user, TRAIT_GUNFLIP)

/obj/item/storage/belt/holster/energy
	name = "energy shoulder holsters"
	desc = "A rather plain pair of shoulder holsters with a bit of insulated padding inside. Designed to hold energy weaponry."
	storage_type = /datum/storage/holster/energy

/obj/item/storage/belt/holster/energy/thermal
	name = "thermal shoulder holsters"
	desc = "A rather plain pair of shoulder holsters with a bit of insulated padding inside. Meant to hold a twinned pair of thermal pistols, but can fit several kinds of energy handguns as well."

/obj/item/storage/belt/holster/energy/thermal/PopulateContents()
	generate_items_inside(list(
		/obj/item/gun/energy/laser/thermal/inferno = 1,
		/obj/item/gun/energy/laser/thermal/cryo = 1,
	),src)

/obj/item/storage/belt/holster/energy/disabler
	desc = "A rather plain pair of shoulder holsters with a bit of insulated padding inside. Designed to hold energy weaponry. A production stamp indicates that it was shipped with a disabler."

/obj/item/storage/belt/holster/energy/disabler/PopulateContents()
	new /obj/item/gun/energy/disabler(src)

/obj/item/storage/belt/holster/energy/laser_pistol
	desc = "A rather plain pair of shoulder holsters with a bit of insulated padding inside. Designed to hold energy weaponry. A production stamp indicates that it was shipped with a Type 5C laser pistol."

/obj/item/storage/belt/holster/energy/laser_pistol/PopulateContents()
	new /obj/item/gun/energy/laser/pistol(src)

/obj/item/storage/belt/holster/energy/smoothbore
	desc = "A rather plain pair of shoulder holsters with a bit of insulated padding inside. Designed to hold energy weaponry. Seems it was meant to fit two smoothbores."

/obj/item/storage/belt/holster/energy/smoothbore/PopulateContents()
	generate_items_inside(list(
		/obj/item/gun/energy/disabler/smoothbore = 2,
	),src)

/obj/item/storage/belt/holster/detective
	name = "detective's holster"
	desc = "A holster able to carry handguns and some ammo. WARNING: Badasses only."
	w_class = WEIGHT_CLASS_BULKY
	storage_type = /datum/storage/holster/detective

/obj/item/storage/belt/holster/detective/full/PopulateContents()
	generate_items_inside(list(
		/obj/item/ammo_box/speedloader/c38 = 2,
		/obj/item/gun/ballistic/revolver/c38/detective = 1,
	), src)

/obj/item/storage/belt/holster/detective/full/ert
	name = "marine's holster"
	desc = "Wearing this makes you feel badass, but you suspect it's just a repainted detective's holster from the NT surplus."
	icon_state = "syndicate_holster"
	inhand_icon_state = "syndicate_holster"
	worn_icon_state = "syndicate_holster"

/obj/item/storage/belt/holster/detective/full/ert/PopulateContents()
	generate_items_inside(list(
		/obj/item/ammo_box/magazine/m45 = 2,
		/obj/item/gun/ballistic/automatic/pistol/m1911 = 1,
	),src)

/obj/item/storage/belt/holster/chameleon
	name = "syndicate holster"
	desc = "A hip holster that uses chameleon technology to disguise itself, due to the added chameleon tech, it cannot be mounted onto armor."
	icon_state = "syndicate_holster"
	inhand_icon_state = "syndicate_holster"
	worn_icon_state = "syndicate_holster"
	w_class = WEIGHT_CLASS_NORMAL
	actions_types = list(/datum/action/item_action/chameleon/change/belt)
	storage_type = /datum/storage/holster/chameleon

/obj/item/storage/belt/holster/nukie
	name = "operative holster"
	desc = "A deep shoulder holster capable of holding almost any form of firearm and its ammo."
	icon_state = "syndicate_holster"
	inhand_icon_state = "syndicate_holster"
	worn_icon_state = "syndicate_holster"
	w_class = WEIGHT_CLASS_BULKY
	storage_type = /datum/storage/holster/nukie

/obj/item/storage/belt/holster/nukie/cowboy
	desc = "A deep shoulder holster capable of holding almost any form of small firearm and its ammo. This one's specialized for handguns."
	storage_type = /datum/storage/holster/nukie/cowboy

/obj/item/storage/belt/holster/nukie/cowboy/full/PopulateContents()
	generate_items_inside(list(
		/obj/item/ammo_box/speedloader/c357 = 2,
		/obj/item/gun/ballistic/revolver/cowboy/nuclear = 1,
	), src)

/obj/item/storage/belt/holster/flarepouch
	name = "flare pouch"
	desc = "A pouch designed to hold flares and a single flaregun. Refillable with a M94 flare pack."
	icon = 'icons/psychonaut/obj/clothing/belts.dmi'
	icon_state = "flare"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	storage_type = /datum/storage/holster/flarepouch

/obj/item/storage/belt/holster/flarepouch/PopulateContents()
	generate_items_inside(list(
		/obj/item/ammo_casing/a25mm = 26,
		/obj/item/gun/ballistic/flarelauncher = 1,
	), src)

/obj/item/storage/belt/holster/flarepouch/update_icon_state()
	. = ..()
	var/obj/item/gun/ballistic/flarelauncher/launcher = locate() in contents
	icon_state = "[initial(icon_state)][launcher ? "_full" : null]"

/obj/item/storage/belt/holster/flarepouch/item_interaction_secondary(mob/user, obj/item/weapon, list/modifiers)
	if(!istype(weapon, /obj/item/gun/ballistic/flarelauncher))
		return ..()

	var/obj/item/gun/ballistic/flarelauncher/flare_gun = weapon

	if(flare_gun.chambered || LAZYLEN(flare_gun.magazine.stored_ammo) == flare_gun.magazine.max_ammo)
		return ITEM_INTERACT_BLOCKING

	var/obj/item/ammo_casing/a25mm/flare = locate() in contents
	if(!flare)
		return ITEM_INTERACT_BLOCKING

	atom_storage.remove_single(user, flare, get_turf(user))
	user.put_in_hands(flare)
	flare_gun.load_gun(flare, user)

	return ITEM_INTERACT_SUCCESS

/obj/item/storage/belt/holster/flarepouch/attack_hand(mob/user, list/modifiers)
	if(loc != user)
		return ..()

	var/obj/item/flare = locate(/obj/item/gun/ballistic/flarelauncher) in contents

	if(!flare)
		flare = locate(/obj/item/ammo_casing/a25mm) in contents

	if(!flare)
		return ..()

	atom_storage.remove_single(user, flare, get_turf(user))
	user.put_in_hands(flare)
	return TRUE

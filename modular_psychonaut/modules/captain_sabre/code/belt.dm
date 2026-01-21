/obj/item/storage/belt/sheath/sabre
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/belts.dmi'
	base_icon_state = "sheath_red"
	lefthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/clothing/belts_lefthand.dmi'
	righthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/clothing/belts_righthand.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/belts.dmi'
	w_class = WEIGHT_CLASS_BULKY
	interaction_flags_click = parent_type::interaction_flags_click | NEED_DEXTERITY | NEED_HANDS

/obj/item/storage/belt/sheath/sabre/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/sabre_sheath, infinite = FALSE)

/obj/item/storage/belt/sheath/sabre/update_icon_state()
	. = ..()
	icon_state = base_icon_state
	inhand_icon_state = base_icon_state
	worn_icon_state = base_icon_state

	var/obj/item/melee/sabre/sabre = locate() in contents
	if(!isnull(sabre))
		icon_state += "-[sabre.icon_state]"
		inhand_icon_state += "-[sabre.icon_state]"
		worn_icon_state += "-[sabre.icon_state]"

/datum/atom_skin/sabre_sheath
	abstract_type = /datum/atom_skin/sabre_sheath
	change_base_icon_state = TRUE
	change_inhand_icon_state = TRUE
	var/sabre_icon
	var/sabre_lefthand_icon
	var/sabre_righthand_icon
	var/sabre_icon_state

/datum/atom_skin/sabre_sheath/red
	preview_name = "Red"
	new_icon = 'modular_psychonaut/master_files/icons/obj/clothing/belts.dmi'
	new_icon_state = "sheath_red"
	new_lefthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/clothing/belts_lefthand.dmi'
	new_righthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/clothing/belts_righthand.dmi'
	new_worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/belts.dmi'
	sabre_icon = 'modular_psychonaut/master_files/icons/obj/weapons/sword.dmi'
	sabre_lefthand_icon = 'modular_psychonaut/master_files/icons/mob/inhands/weapons/swords_lefthand.dmi'
	sabre_righthand_icon = 'modular_psychonaut/master_files/icons/mob/inhands/weapons/swords_righthand.dmi'
	sabre_icon_state = "sabre_red"

/datum/atom_skin/sabre_sheath/black
	preview_name = "Black"
	new_icon = 'modular_psychonaut/master_files/icons/obj/clothing/belts.dmi'
	new_icon_state = "sheath_black"
	new_lefthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/clothing/belts_lefthand.dmi'
	new_righthand_file = 'modular_psychonaut/master_files/icons/mob/inhands/clothing/belts_righthand.dmi'
	new_worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/belts.dmi'
	sabre_icon = 'modular_psychonaut/master_files/icons/obj/weapons/sword.dmi'
	sabre_lefthand_icon = 'modular_psychonaut/master_files/icons/mob/inhands/weapons/swords_lefthand.dmi'
	sabre_righthand_icon = 'modular_psychonaut/master_files/icons/mob/inhands/weapons/swords_righthand.dmi'
	sabre_icon_state = "sabre_black"

/datum/atom_skin/sabre_sheath/apply(atom/apply_to)
	var/obj/item/melee/sabre/sabre = locate() in apply_to.contents
	if(!istype(sabre))
		to_chat(apply_to.loc, span_warning("[apply_to] cannot be reskinned because the it's empty."))
		return FALSE
	. = ..()
	APPLY_VAR_OR_RESET_INITIAL(sabre, icon, sabre_icon, reset_missing)
	APPLY_VAR_OR_RESET_INITIAL(sabre, lefthand_file, sabre_lefthand_icon, reset_missing)
	APPLY_VAR_OR_RESET_INITIAL(sabre, righthand_file, sabre_righthand_icon, reset_missing)
	APPLY_VAR_OR_RESET_INITIAL(sabre, icon_state, sabre_icon_state, reset_missing)
	APPLY_VAR_OR_RESET_INITIAL(sabre, inhand_icon_state, sabre_icon_state, reset_missing)
	sabre.update_appearance()
	sabre.update_slot_icon()

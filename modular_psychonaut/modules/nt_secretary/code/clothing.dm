/obj/item/radio/headset/headset_com/nt_secretary
	name = "secretary radio headset"
	desc = "A headset for listening the commanding channel."
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/headsets.dmi'
	icon_state = "secretary_headset"

/obj/item/clothing/head/hats/nt_secretary
	name = "\improper Nt Secretary cap"
	desc = "The cap of the Nt Secretary, stylish!."
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/head/hats.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/head/hats.dmi'
	icon_state = "nt_secretary"

/obj/item/clothing/neck/tie/blue/nt_secretary
	name = "secretary tie"
	greyscale_colors = SECRETARY_BLUE

/obj/item/clothing/neck/tie/blue/nt_secretary/tied
	is_tied = TRUE

/datum/outfit/plasmaman/nt_secretary
	name = "Secretary Plasmaman"

	uniform = /obj/item/clothing/under/plasmaman/nt_secretary
	gloves = /obj/item/clothing/gloves/color/plasmaman/white
	head = /obj/item/clothing/head/helmet/space/plasmaman/nt_secretary

/obj/item/clothing/head/helmet/space/plasmaman/nt_secretary
	name = "Nt secretary plasma envirosuit helmet"
	desc = "A special containment helmet designed for secretaries."
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/head/plasmaman_hats.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/head/plasmaman_head.dmi'
	icon_state = "secretary_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/under/plasmaman/nt_secretary
	name = "Nt secretary plasma envirosuit"
	desc = "It's an envirosuit worn by Nanotrasen secretaries."
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/under/plasmaman.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/under/plasmaman.dmi'
	icon_state = "secretary_envirosuit"
	inhand_icon_state = null

/obj/item/clothing/under/rank/centcom/nt_secretary
	name = "\improper Nanotrasen secretary's jumpsuit"
	desc = "It's a jumpsuit worn by Nanotrasen secretaries."
	icon = 'modular_psychonaut/master_files/icons/obj/clothing/under/centcom.dmi'
	worn_icon = 'modular_psychonaut/master_files/icons/mob/clothing/under/centcom.dmi'
	icon_state = "nt_secretary"
	can_adjust = FALSE

/obj/item/storage/box/syndicate/sandy
	name = "Sandevistan Bundle"
	desc = "This is a set containing a sandevistan autosurgeon, allowing you to outspeed targets!"
	icon_state = "syndiebox"
	illustration = "writing_syndie"

/obj/item/storage/box/syndicate/sandy/PopulateContents()
	new /obj/item/autosurgeon/syndicate/sandy(src)

/obj/item/storage/box/syndicate/mantis
	name = "Mantis Blade Bundle"
	desc = "A box containing autosurgeons for two mantis blade implants, one for each arm."
	icon_state = "syndiebox"
	illustration = "writing_syndie"

/obj/item/storage/box/syndicate/mantis/PopulateContents()
	new /obj/item/autosurgeon/syndicate/mantis(src)
	new /obj/item/autosurgeon/syndicate/mantis(src)

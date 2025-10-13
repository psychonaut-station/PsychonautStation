/obj/item/robot_model
	/// Sets icon file for cyborg_base_icon
	var/cyborg_base_iconfile = 'icons/mob/silicon/robots.dmi'

/obj/item/robot_model/cargo
	name = "Cargo"
	basic_modules = list(
		/obj/item/assembly/flash/cyborg,
		/obj/item/crowbar/cyborg,
		/obj/item/stamp/borg,
		/obj/item/stack/package_wrap,
		/obj/item/stack/wrapping_paper,
		/obj/item/dest_tagger,
		/obj/item/hand_labeler/borg,
		/obj/item/pen,
		/obj/item/extinguisher/mini,
		/obj/item/borg/cyborg_clamp,
		/obj/item/borg/apparatus/sheet_manipulator,
		/obj/item/storage/bag/mail/borg,
		/obj/item/boxcutter,
		/obj/item/borg/apparatus/paper_holder,
		/obj/item/universal_scanner/robot
	)
	radio_channels = list(RADIO_CHANNEL_SUPPLY)
	emag_modules = list(
		/obj/item/borg/paperplane_crossbow,
	)
	borg_skins = list(
		"Cyclops" = list(SKIN_ICON = 'modular_psychonaut/master_files/icons/mob/silicon/robots.dmi', SKIN_ICON_STATE = "cargo"),
	)
	cyborg_base_iconfile = 'modular_psychonaut/master_files/icons/mob/silicon/robots.dmi'
	cyborg_base_icon = "cargo"
	model_select_icon = "standard"
	hat_offset = 0
	canDispose = TRUE

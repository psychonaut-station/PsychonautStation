/**
 * Title:
 * 	Goldie Zippo Skin
 * Description:
 * 	Adds a new zippo skin
 * Related files:
 * 	`code/game/objects/items/lighter.dm`
 *  `modular_psychonaut/master_files/icons/obj/cigarettes.dmi`
 * Credits:
 * 	Makaru
 * 	Rengan
 */
/obj/item/lighter
	var/static/list/icon_overrides = list(
		"goldie" = 'modular_psychonaut/master_files/icons/obj/cigarettes.dmi',
	)

/obj/item/lighter/create_lighter_overlay()
	return mutable_appearance(icon_overrides[overlay_state] || icon, "lighter_overlay_[overlay_state][lit ? "-on" : ""]")

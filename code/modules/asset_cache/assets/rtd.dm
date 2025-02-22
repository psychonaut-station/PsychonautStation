/datum/asset/spritesheet/rtd
	name = "rtd"

/datum/asset/spritesheet/rtd/create_spritesheets()
	//some tiles may share the same icon but have different properties to animate that icon
	//so we keep track of what icons we registered
	var/list/registered = list()

	for(var/main_root in GLOB.floor_designs)
		for(var/sub_category in GLOB.floor_designs[main_root])
			for(var/list/design in  GLOB.floor_designs[main_root][sub_category])
				if(!design["datum"])
					populate_rtd_datums()
				var/datum/tile_info/tile_data = design["datum"]
				var/list/directions = tile_data.tile_directions_numbers || list(SOUTH)
				for(var/direction as anything in directions)
					var/sprite_name = sanitize_css_class_name("[tile_data.icon_file]-[tile_data.icon_state]-[dir2text(direction)]")
					if(registered[sprite_name])
						continue
					var/icon/icon = icon(tile_data.icon_file, tile_data.icon_state, direction)
					if(ispath(tile_data.tile_type, /obj/item/stack/tile/carpet/neon))
						var/turf/open/floor/carpet/neon/neon_carpet = tile_data.turf_type
						var/color_code = replacetext(initial(neon_carpet.neon_color), "#", "")
						sprite_name = sanitize_css_class_name("[tile_data.icon_file]-[tile_data.icon_state]-[color_code]-[dir2text(direction)]")
						if(registered[sprite_name])
							continue
						var/icon/neon_icon = icon( \
							icon = initial(neon_carpet.neon_icon) || initial(neon_carpet.icon), \
							icon_state = initial(neon_carpet.neon_icon_state) || initial(neon_carpet.icon_state) \
						)
						neon_icon.Blend(initial(neon_carpet.neon_color), ICON_MULTIPLY)
						icon.Blend(neon_icon, ICON_OVERLAY)
					Insert(sprite_name, icon)
					registered[sprite_name] = TRUE

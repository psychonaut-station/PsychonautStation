/datum/asset/spritesheet_batched/rtd
	name = "rtd"

/datum/asset/spritesheet_batched/rtd/create_spritesheets()
	var/list/registered = list()

	for(var/main_root in GLOB.floor_designs)
		for(var/sub_category in GLOB.floor_designs[main_root])
			for(var/list/design in GLOB.floor_designs[main_root][sub_category])
				if(!design["datum"])
					populate_rtd_datums()
				var/datum/tile_info/tile_data = design["datum"]
				var/list/directions = tile_data.tile_directions_numbers || list(SOUTH)
				for(var/direction in directions)
					var/sprite_name = sanitize_css_class_name("[tile_data.icon_file]-[tile_data.icon_state]-[dir2text(direction)]")
					if(registered[sprite_name])
						continue
					var/datum/universal_icon/icon = uni_icon(tile_data.icon_file, tile_data.icon_state, direction)
					if(ispath(tile_data.tile_type, /obj/item/stack/tile/carpet/neon))
						var/turf/open/floor/carpet/neon/neon_carpet = tile_data.turf_type
						var/color_code = replacetext(neon_carpet::neon_color, "#", "")
						sprite_name = sanitize_css_class_name("[tile_data.icon_file]-[tile_data.icon_state]-[color_code]-[dir2text(direction)]")
						if(registered[sprite_name])
							continue
						var/neon_icon_file = neon_carpet::neon_icon || neon_carpet::icon
						var/neon_icon_state = "[neon_carpet::neon_icon_state || neon_carpet::base_icon_state]-0"
						var/datum/universal_icon/neon_icon = uni_icon(neon_icon_file, neon_icon_state)
						neon_icon.blend_color(neon_carpet::neon_color, ICON_MULTIPLY)
						icon.blend_icon(neon_icon, ICON_OVERLAY)
					insert_icon(sprite_name, icon)
					registered[sprite_name] = TRUE

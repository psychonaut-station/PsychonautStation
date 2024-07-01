/datum/asset/spritesheet/rtd
	name = "rtd"

/datum/asset/spritesheet/rtd/create_spritesheets()
	//some tiles may share the same icon but have diffrent properties to animate that icon
	//so we keep track of what icons we registered
	var/list/registered = list()

	for(var/main_root in GLOB.floor_designs)
		for(var/sub_category in GLOB.floor_designs[main_root])
			for(var/list/design in  GLOB.floor_designs[main_root][sub_category])
				var/obj/item/stack/tile/type = design["type"]
				var/icon_state = initial(type.icon_state)
				if(registered[icon_state])
					continue

				// PSYCHONAUT EDIT CHANGE START - RTD - ORIGINAL:
				// Insert(sprite_name = icon_state, I = 'icons/obj/tiles.dmi', icon_state = icon_state)
				// registered[icon_state] = TRUE
				var/sprite_name = icon_state
				var/icon/icon = icon('icons/obj/tiles.dmi', icon_state)

				if(ispath(type, /obj/item/stack/tile/carpet/neon))
					var/obj/item/stack/tile/carpet/neon/neon_carpet = type
					sprite_name += "-[replacetext(neon_carpet::neon_color, "#", "")]"

					if(registered[sprite_name])
						continue

					var/icon/neon_icon = icon( \
						neon_carpet::neon_icon || neon_carpet::icon, \
						neon_carpet::neon_icon_state || neon_carpet::icon_state \
					)

					neon_icon.Blend(neon_carpet::neon_color, ICON_MULTIPLY)
					icon.Blend(neon_icon, ICON_OVERLAY)

				Insert(sprite_name = sprite_name, I = icon)
				registered[sprite_name] = TRUE
				// PSYCHONAUT EDIT CHANGE END

				var/list/tile_directions = design["tile_rotate_dirs"]
				if(tile_directions == null)
					continue

				for(var/direction as anything in tile_directions)
					//we can rotate the icon is css for these directions
					if(direction in GLOB.tile_dont_rotate)
						continue

					//but for these directions we have to do some hacky stuff
					var/icon/img = icon(icon = 'icons/obj/tiles.dmi', icon_state = icon_state)
					switch(direction)
						if(NORTHEAST)
							img.Turn(-180)
							var/icon/east_rotated = icon(icon = 'icons/obj/tiles.dmi', icon_state = icon_state)
							east_rotated.Turn(-90)
							img.Blend(east_rotated,ICON_MULTIPLY)
							img.SetIntensity(2,2,2)
						if(NORTHWEST)
							img.Turn(-180)
							var/icon/west_rotated = icon(icon = 'icons/obj/tiles.dmi', icon_state = icon_state)
							west_rotated.Turn(90)
							img.Blend(west_rotated,ICON_MULTIPLY)
							img.SetIntensity(2,2,2)
						if(SOUTHEAST)
							var/icon/east_rotated = icon(icon = 'icons/obj/tiles.dmi', icon_state = icon_state)
							east_rotated.Turn(-90)
							img.Blend(east_rotated,ICON_MULTIPLY)
							img.SetIntensity(2,2,2)
						if(SOUTHWEST)
							var/icon/west_rotated = icon(icon = 'icons/obj/tiles.dmi', icon_state = icon_state)
							west_rotated.Turn(90)
							img.Blend(west_rotated,ICON_MULTIPLY)
							img.SetIntensity(2,2,2)
					Insert(sprite_name = "[icon_state]-[dir2text(direction)]", I = img)

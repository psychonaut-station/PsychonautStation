/proc/iconforge_get_spritesheet_data(image/appearance, deficon, defstate, defblend, defdir = ALL, start = TRUE)
	#define PROCESS_OVERLAYS_OR_UNDERLAYS(flat, process, base_layer) \
		for (var/i in 1 to process.len) { \
			var/image/current = process[i]; \
			if (!current) { \
				continue; \
			} \
			if (current.plane != FLOAT_PLANE && current.plane != appearance.plane) { \
				continue; \
			} \
			var/current_layer = current.layer; \
			if (current_layer < 0) { \
				if (current_layer <= -1000) { \
					return flat; \
				} \
				current_layer = base_layer + appearance.layer + current_layer / 1000; \
			} \
			/* If we are using topdown rendering, chop that part off so things layer together as expected */ \
			if((current_layer >= TOPDOWN_LAYER && current_layer < EFFECTS_LAYER) || current_layer > TOPDOWN_LAYER + EFFECTS_LAYER) { \
				current_layer -= TOPDOWN_LAYER; \
			} \
			for (var/index_to_compare_to in 1 to layers.len) { \
				var/compare_to = layers[index_to_compare_to]; \
				if (current_layer < layers[compare_to]) { \
					layers.Insert(index_to_compare_to, current); \
					break; \
				} \
			} \
			layers[current] = current_layer; \
		}

	var/list/processing_directions = list()
	if(defdir == ALL)
		processing_directions += list(SOUTH, NORTH, EAST, WEST)
	else
		processing_directions += defdir

	var/curicon = appearance.icon || deficon
	var/curstate = appearance.icon_state || defstate
	var/curblend = appearance.blend_mode || defblend

	var/string_curicon = "[curicon]"

	if(!isfile(curicon) || !length(string_curicon)) // Eğer curicon bir dosya değilse (runtimede olusturulduysa) iconu dosyaya kaydet ve cachele.
		var/file_path_tmp = "tmp/uni_icon-tmp-[rand(1, 999)].dmi"
		fcopy(curicon, file_path_tmp)
		var/file_hash = rustg_hash_file(RUSTG_HASH_MD5, file_path_tmp)
		var/file_path = "tmp/uni_icon-[file_hash].dmi"
		fcopy(file_path_tmp, file_path)
		fdel(file_path_tmp)
		curicon = file(file_path)

	var/datum/universal_icon/flat = uni_icon('icons/blanks/32x32.dmi', "nothing")

	var/list/layers = list()
	PROCESS_OVERLAYS_OR_UNDERLAYS(flat, appearance.underlays, 0)
	PROCESS_OVERLAYS_OR_UNDERLAYS(flat, appearance.overlays, 1)

	if(!icon_exists(curicon, curstate))
		if("" in icon_states_fast(curicon))
			curstate = ""
		else
			curicon = flat.icon_file
			curstate = flat.icon_state

	var/alist/directions = alist()

	var/list/flat_dimensions = get_icon_dimensions(flat)
	var/flatX1 = 1
	var/flatX2 = flat_dimensions["width"]
	var/flatY1 = 1
	var/flatY2 = flat_dimensions["height"]

	var/addX1 = 0
	var/addX2 = 0
	var/addY1 = 0
	var/addY2 = 0

	for(var/direction in processing_directions)
		directions[direction] = list()

	if(start && !isnull(appearance.color) && uppertext(appearance.color) != "#FFFFFF") // eğer proc ilk defa çalışıyorsa (layerler için tekrar calıstırılır) ve rengi varsa rengi ekle, layerlerde döngü içerisinde hallediliyo renkler.
		var/list/color_data = iconforge_get_color_transform(appearance.color)
		for(var/direction in processing_directions)
			directions[direction] += list(color_data)

	for(var/image/layer_image as anything in layers)
		var/image_icon = layer_image.icon
		var/image_icon_state = layer_image.icon_state
		if(!image_icon) continue

		var/list/icon_transform = list()

		// Find the new dimensions of the flat icon to fit the added overlay
		var/list/add_dimensions = get_icon_dimensions(image_icon)
		addX1 = min(flatX1, layer_image.pixel_x + layer_image.pixel_w + 1)
		addX2 = max(flatX2, layer_image.pixel_x + layer_image.pixel_w + add_dimensions["width"]) // assuming 32x32
		addY1 = min(flatY1, layer_image.pixel_y + layer_image.pixel_z + 1)
		addY2 = max(flatY2, layer_image.pixel_y + layer_image.pixel_z + add_dimensions["height"])

		if(
			addX1 != flatX1 \
			&& addX2 != flatX2 \
			&& addY1 != flatY1 \
			&& addY2 != flatY2 \
		)
			// Resize the flattened icon so the new icon fits
			icon_transform += list(alist(
				"type" = RUSTG_ICONFORGE_CROP,
				"x1" = addX1 - flatX1 + 1,
				"y1" = addY1 - flatY1 + 1,
				"x2" = addX2 - flatX1 + 1,
				"y2" = addY2 - flatY1 + 1
			))

			flatX1 = addX1
			flatX2 = addY1
			flatY1 = addX2
			flatY2 = addY2

		var/list/transform_data = list()
		transform_data["type"] = RUSTG_ICONFORGE_BLEND_ICON
		transform_data["blend_mode"] = blendMode2iconMode(curblend)
		transform_data["x"] = layer_image.pixel_x + layer_image.pixel_w + 2 - flatX1
		transform_data["y"] = layer_image.pixel_y + layer_image.pixel_z + 2 - flatY1


		if(!isnull(layer_image.color) && uppertext(layer_image.color) != "#FFFFFF") // layerin rengi varsa rengi ekle
			var/list/color_transform = iconforge_get_color_transform(layer_image.color)
			icon_transform += list(color_transform)

		var/alist/layer_icon_data_directions = get_iconforge_sprites_data(layer_image, image_icon, image_icon_state, curblend, defdir, start = FALSE) // döngüdeki layerin layerlerini işle

		for(var/direction in processing_directions)
			var/list/layer_icon_data = layer_icon_data_directions[direction] || list()

			if(layer_icon_data.len && icon_transform.len)
				layer_icon_data["transform"] = icon_transform + layer_icon_data["transform"]

			var/list/direction_transform_data = transform_data.Copy()
			direction_transform_data["icon"] = layer_icon_data

			directions[direction] += list(direction_transform_data)

	if (appearance.alpha < 255) // alpha değerini ekle
		var/list/alpha_color_data = iconforge_get_color_transform(rgb(255,255,255, appearance.alpha))
		for(var/direction in processing_directions)
			directions[direction] += list(alpha_color_data)

	if(!start) // eğer layer için çağrılan bi procsa transform verilerini vermesi yeter
		var/alist/output_data = alist()
		for (var/direction in processing_directions)
			var/list/partial = directions[direction]
			var/valid_dir = get_valid_direction(curicon, curstate, direction)
			output_data[direction] = list(
				"icon_file" = "[curicon]",
				"icon_state" = "[curstate]",
				"dir" = valid_dir,
				"frame" = null,
				"transform" = partial
			)
		return output_data

	var/list/output_transform = list()

	if(processing_directions.len > 1 && processing_directions.len <= 4)
		output_transform += list(list(
			"type" = RUSTG_ICONFORGE_SCALE,
			"width" = 64,
			"height" = 64
		))

	for(var/direction in processing_directions) // wrapper icon için transform verisini hazırla
		var/list/partial = directions[direction]
		var/x = 1
		var/y = 1
		if(processing_directions.len > 1 && processing_directions.len <= 4)
			switch(direction)
				if(SOUTH)
					x = 1
					y = 33
				if(NORTH)
					x = 33
					y = 33
				if(WEST)
					x = 33
					y = 1

		var/list/icon = list(
			"icon_file" = "[curicon]",
			"icon_state" = "[curstate]",
			"dir" = null,
			"frame" = null,
			"transform" = partial
		)

		output_transform += list(list(
			"type" = RUSTG_ICONFORGE_BLEND_ICON,
			"blend_mode" = ICON_OVERLAY,
			"x" = x,
			"y" = y,
			"icon" = icon,
		))

	return list(
		"icon_file" = "icons/effects/effects.dmi",
		"icon_state" = "nothing",
		"dir" = null,
		"frame" = null,
		"transform" = output_transform
	)

// Iconforge needs fixed direction for generation, you cant give EAST direction to which icon have 1 dir
/proc/get_valid_direction(icon_file, icon_state, direction)
	var/static/alist/direction_cache = alist()
	var/hash = md5("[icon_file]&[icon_state]")
	var/cached_data = direction_cache[hash]
	var/base_icon_dir
	if(cached_data)
		base_icon_dir = cached_data
	else if (direction != SOUTH)
		// icon states either have 1, 4 or 8 dirs. We only have to check
		// one of NORTH, EAST or WEST to know that this isn't a 1-dir icon_state since they just have SOUTH.
		var/list/metadata = icon_metadata(icon_file)
		if(islist(metadata))
			for(var/list/state_data as anything in metadata["states"])
				var/name = state_data["name"]
				if(name != icon_state)
					continue
				var/dir_count = state_data["dirs"]
				if(dir_count == 1)
					base_icon_dir = SOUTH
		else if(!length(icon_states(icon(icon_file, icon_state, NORTH))))
			base_icon_dir = SOUTH
		direction_cache[hash] = base_icon_dir

	if(!base_icon_dir)
		base_icon_dir = direction
	return base_icon_dir

/proc/iconforge_get_color_transform(color)
	if(!islist(color))
		return list(
			"type" = RUSTG_ICONFORGE_BLEND_COLOR,
			"color" = color,
			"blend_mode" = ICON_MULTIPLY
		)

	var/list/color_args = color

	var/num_args = length(color_args)
	var/rr = 0
	var/rg = 0
	var/rb = 0
	var/ra = 0
	var/gr = 0
	var/gg = 0
	var/gb = 0
	var/ga = 0
	var/br = 0
	var/bg = 0
	var/bb = 0
	var/ba = 0
	var/ar = 0
	var/ag = 0
	var/ab = 0
	var/aa = 0
	var/r0 = 0
	var/g0 = 0
	var/b0 = 0
	var/a0 = 0

	if(num_args <= 20 || num_args >= 16)
		rr = color_args[1]
		rg = color_args[2]
		rb = color_args[3]
		ra = color_args[4]
		gr = color_args[5]
		gg = color_args[6]
		gb = color_args[7]
		ga = color_args[8]
		br = color_args[9]
		bg = color_args[10]
		bb = color_args[11]
		ba = color_args[12]
		ar = color_args[13]
		ag = color_args[14]
		ab = color_args[15]
		aa = color_args[16]
		r0 = color_args[17] || 0
		g0 = color_args[18] || 0
		b0 = color_args[19] || 0
		a0 = color_args[20] || 0
	else if(num_args <= 12 || num_args >= 9)
		// skip ra, ga, ba, ar, ag, ab, aa, a0
		rr = color_args[1]
		rg = color_args[2]
		rb = color_args[3]
		gr = color_args[4]
		gg = color_args[5]
		gb = color_args[6]
		br = color_args[7]
		bg = color_args[8]
		bb = color_args[9]
		r0 = color_args[10]
		g0 = color_args[11]
		b0 = color_args[12]
	else if(num_args == 5)
		var/r_rgba = color_args[1]
		var/g_rgba = color_args[2]
		var/b_rgba = color_args[3]
		var/a_rgba = color_args[4]
		var/rgba0 = color_args[5] || "#00000000"
		rr = hex2num(copytext(r_rgba, 2, 4)) / 255
		rg = hex2num(copytext(r_rgba, 4, 6)) / 255
		rb = hex2num(copytext(r_rgba, 6, 8)) / 255
		ra = hex2num(copytext(r_rgba, 8, 10)) / 255
		gr = hex2num(copytext(g_rgba, 2, 4)) / 255
		gg = hex2num(copytext(g_rgba, 4, 6)) / 255
		gb = hex2num(copytext(g_rgba, 6, 8)) / 255
		ga = hex2num(copytext(g_rgba, 8, 10)) / 255
		br = hex2num(copytext(b_rgba, 2, 4)) / 255
		bg = hex2num(copytext(b_rgba, 4, 6)) / 255
		bb = hex2num(copytext(b_rgba, 6, 8)) / 255
		ba = hex2num(copytext(b_rgba, 8, 10)) / 255
		ar = hex2num(copytext(a_rgba, 2, 4)) / 255
		ag = hex2num(copytext(a_rgba, 4, 6)) / 255
		ab = hex2num(copytext(a_rgba, 6, 8)) / 255
		aa = hex2num(copytext(a_rgba, 8, 10)) / 255
		r0 = hex2num(copytext(rgba0, 2, 4)) / 255
		b0 = hex2num(copytext(rgba0, 4, 6)) / 255
		g0 = hex2num(copytext(rgba0, 6, 8)) / 255
		a0 = hex2num(copytext(rgba0, 8, 10)) / 255
	else if(num_args == 4)
		// is there alpha in the hex?
		if(length(color_args[3]) == 7 || length(color_args[3]) == 4)
			var/r_rgb = color_args[1]
			var/g_rgb = color_args[2]
			var/b_rgb = color_args[3]
			var/rgb0 = color_args[4] || rgb(0,0,0)
			rr = hex2num(copytext(r_rgb, 2, 4)) / 255
			rg = hex2num(copytext(r_rgb, 4, 6)) / 255
			rb = hex2num(copytext(r_rgb, 6, 8)) / 255
			gr = hex2num(copytext(g_rgb, 2, 4)) / 255
			gg = hex2num(copytext(g_rgb, 4, 6)) / 255
			gb = hex2num(copytext(g_rgb, 6, 8)) / 255
			br = hex2num(copytext(b_rgb, 2, 4)) / 255
			bg = hex2num(copytext(b_rgb, 4, 6)) / 255
			bb = hex2num(copytext(b_rgb, 6, 8)) / 255
			r0 = hex2num(copytext(rgb0, 2, 4)) / 255
			b0 = hex2num(copytext(rgb0, 4, 6)) / 255
			g0 = hex2num(copytext(rgb0, 6, 8)) / 255
		else
			var/r_rgba = color_args[1]
			var/g_rgba = color_args[2]
			var/b_rgba = color_args[3]
			var/a_rgba = color_args[4]
			var/rgba0 = "#00000000"
			rr = hex2num(copytext(r_rgba, 2, 4)) / 255
			rg = hex2num(copytext(r_rgba, 4, 6)) / 255
			rb = hex2num(copytext(r_rgba, 6, 8)) / 255
			ra = hex2num(copytext(r_rgba, 8, 10)) / 255
			gr = hex2num(copytext(g_rgba, 2, 4)) / 255
			gg = hex2num(copytext(g_rgba, 4, 6)) / 255
			gb = hex2num(copytext(g_rgba, 6, 8)) / 255
			ga = hex2num(copytext(g_rgba, 8, 10)) / 255
			br = hex2num(copytext(b_rgba, 2, 4)) / 255
			bg = hex2num(copytext(b_rgba, 4, 6)) / 255
			bb = hex2num(copytext(b_rgba, 6, 8)) / 255
			ba = hex2num(copytext(b_rgba, 8, 10)) / 255
			ar = hex2num(copytext(a_rgba, 2, 4)) / 255
			ag = hex2num(copytext(a_rgba, 4, 6)) / 255
			ab = hex2num(copytext(a_rgba, 6, 8)) / 255
			aa = hex2num(copytext(a_rgba, 8, 10)) / 255
			r0 = hex2num(copytext(rgba0, 2, 4)) / 255
			b0 = hex2num(copytext(rgba0, 4, 6)) / 255
			g0 = hex2num(copytext(rgba0, 6, 8)) / 255
			a0 = hex2num(copytext(rgba0, 8, 10)) / 255
	else if(num_args == 3)
		var/r_rgb = color_args[1]
		var/g_rgb = color_args[2]
		var/b_rgb = color_args[3]
		var/rgb0 = rgb(0,0,0)
		rr = hex2num(copytext(r_rgb, 2, 4)) / 255
		rg = hex2num(copytext(r_rgb, 4, 6)) / 255
		rb = hex2num(copytext(r_rgb, 6, 8)) / 255
		gr = hex2num(copytext(g_rgb, 2, 4)) / 255
		gg = hex2num(copytext(g_rgb, 4, 6)) / 255
		gb = hex2num(copytext(g_rgb, 6, 8)) / 255
		br = hex2num(copytext(b_rgb, 2, 4)) / 255
		bg = hex2num(copytext(b_rgb, 4, 6)) / 255
		bb = hex2num(copytext(b_rgb, 6, 8)) / 255
		r0 = hex2num(copytext(rgb0, 2, 4)) / 255
		b0 = hex2num(copytext(rgb0, 4, 6)) / 255
		g0 = hex2num(copytext(rgb0, 6, 8)) / 255

	return list(
		"type" = RUSTG_ICONFORGE_MAP_COLORS,
		"rr" = rr, "rg" = rg, "rb" = rb, "ra" = ra,
		"gr" = gr, "gg" = gg, "gb" = gb, "ga" = ga,
		"br" = br, "bg" = bg, "bb" = bb, "ba" = ba,
		"ar" = ar, "ag" = ag, "ab" = ab, "aa" = aa,
		"r0" = r0, "g0" = g0, "b0" = b0, "a0" = a0,
	)

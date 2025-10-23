/proc/ui_hand_position_y(i,y_offset = 0,y_pixel_offset = 0) //values based on old hand ui positions (CENTER:-/+16,SOUTH:5)
	var/x_off = -(!(i % 2))
	var/y_off = round((i-1) / 2) + y_offset
	return"CENTER+[x_off]:16,SOUTH+[y_off]:[5 + y_pixel_offset]"

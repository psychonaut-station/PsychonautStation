#define CREDIT_ROLL_SPEED 9 SECONDS
#define CREDIT_SPAWN_SPEED 1 SECONDS
#define CREDIT_ANIMATE_HEIGHT (16 * world.icon_size)
#define CREDIT_EASE_DURATION 2.2 SECONDS
#define CREDITS_PATH "[global.config.directory]/contributors.dmi"

/client/proc/RollCredits()
	set waitfor = FALSE
	if(!fexists(CREDITS_PATH) || !prefs?.read_preference(/datum/preference/toggle/show_roundend_credits))
		return
	LAZYINITLIST(credits)
	var/list/_credits = credits
	add_verb(src, /client/proc/ClearCredits)
	var/static/list/credit_order_for_this_round
	if(isnull(credit_order_for_this_round))
		SScredits.draft()
		SScredits.finalize()
		credit_order_for_this_round = list()
		credit_order_for_this_round += SScredits.episode_string
		credit_order_for_this_round += ""
		credit_order_for_this_round += SScredits.disclaimers_string
		credit_order_for_this_round += SScredits.cast_string
		var/list/admins = shuffle(SScredits.admin_pref_images)
		var/admins_length = length(admins)
		var/y_offset = 0
		if(admins_length)
			credit_order_for_this_round += "<center>The Admin Bus</center>"
			for(var/i in 1 to admins_length)
				var/x_offset = -8
				for(var/b in 1 to 7)
					var/atom/movable/screen/map_view/char_preview/picked = pick_n_take(admins)
					if(!picked)
						break
					picked.pixel_x = x_offset
					picked.pixel_y = y_offset
					x_offset += 70
					credit_order_for_this_round += picked

		var/list/patrons = shuffle(SScredits.patrons_pref_images)
		var/patrons_length = length(patrons)
		if(patrons_length)
			credit_order_for_this_round += "<center>Our Lovely Patrons</center>"
			for(var/i in 1 to patrons_length)
				var/x_offset = -8
				for(var/b in 1 to 7)
					var/atom/movable/screen/map_view/char_preview/picked = pick_n_take(patrons)
					if(!picked)
						break
					picked.pixel_x = x_offset
					picked.pixel_y = y_offset
					x_offset += 70
					credit_order_for_this_round += picked

		for(var/obj/effect/title_card_object/MA as anything in SScredits.major_event_icons)
			credit_order_for_this_round += MA
			var/list/antagonist_icons = SScredits.major_event_icons[MA]
			for(var/i in 1 to length(antagonist_icons))
				var/x_offset = -8
				for(var/b in 1 to 7)
					if(!length(antagonist_icons))
						break
					var/reference = pick(antagonist_icons)
					var/atom/movable/screen/map_view/char_preview/picked = antagonist_icons[reference]
					antagonist_icons -= reference
					if(!picked)
						break
					picked.pixel_x = x_offset
					picked.pixel_y = y_offset
					x_offset += 70
					credit_order_for_this_round += picked


	var/count = 0
	for(var/I in credit_order_for_this_round)
		if(!credits)
			return
		if(istype(I, /obj/effect/title_card_object)) //huge image sleep
			sleep(CREDIT_SPAWN_SPEED * 3.3)
			count = 0
		if(count && !istype(I, /atom/movable/screen/map_view/char_preview))
			sleep(CREDIT_SPAWN_SPEED)

		_credits += new /atom/movable/screen/credit(null, null, I, src)
		if(istype(I, /atom/movable/screen/map_view/char_preview))
			count++
			if(count >= 7)
				count = 0
				sleep(CREDIT_SPAWN_SPEED)
		if(!istype(I, /atom/movable/screen/map_view/char_preview))
			sleep(CREDIT_SPAWN_SPEED)
			count = 0
	sleep(CREDIT_ROLL_SPEED - CREDIT_SPAWN_SPEED)
	remove_verb(src, /client/proc/ClearCredits)

/client/proc/ClearCredits()
	set name = "Hide Credits"
	set category = "OOC"
	remove_verb(src, /client/proc/ClearCredits)
	QDEL_LIST(credits)
	credits = null

/atom/movable/screen/credit
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 0
	plane = SPLASHSCREEN_PLANE
	screen_loc = "3,1"
	var/client/parent
	var/matrix/target

/atom/movable/screen/credit/Initialize(mapload, datum/hud/hud_owner, credited, client/P)
	. = ..()
	icon = CREDITS_PATH
	parent = P
	var/view = P?.view
	var/list/offsets = screen_loc_to_offset("3,1", view)

	if(istype(credited, /atom/movable/screen/map_view/char_preview))
		var/atom/movable/screen/map_view/char_preview/choice = credited
		choice.plane = plane
		choice.screen_loc = screen_loc
		choice.alpha = alpha
		maptext_width = choice.maptext_width
		maptext = choice.maptext
		appearance = choice.appearance
		screen_loc = offset_to_screen_loc(offsets[1] + choice.pixel_x, offsets[2] + choice.pixel_y)
		add_overlay(choice)

	if(istype(credited, /mutable_appearance))
		var/mutable_appearance/choice = credited
		choice.plane = plane
		choice.screen_loc = screen_loc
		choice.alpha = alpha
		maptext_width = choice.maptext_width
		maptext = choice.maptext
		appearance = choice.appearance
		screen_loc = offset_to_screen_loc(offsets[1] + choice.pixel_x, offsets[2] + choice.pixel_y)
		add_overlay(choice)

	if(istype(credited, /obj/effect/title_card_object))
		var/obj/effect/title_card_object/choice = credited
		choice.plane = plane
		choice.screen_loc = screen_loc
		choice.alpha = alpha
		maptext_width = choice.maptext_width
		maptext = choice.maptext
		appearance = choice.appearance
		screen_loc = offset_to_screen_loc(offsets[1] + choice.pixel_x, offsets[2] + choice.pixel_y)
		add_overlay(choice)

	if(istext(credited))
		maptext = MAPTEXT_PIXELLARI(credited)
		maptext_x = world.icon_size + 8
		maptext_y = (world.icon_size / 2) - 4
		maptext_width = world.icon_size * 12
		maptext_height = world.icon_size * 2

	var/matrix/M = matrix(transform)
	M.Translate(0, CREDIT_ANIMATE_HEIGHT)
	animate(src, transform = M, time = CREDIT_ROLL_SPEED)
	target = M
	animate(src, alpha = 255, time = CREDIT_EASE_DURATION, flags = ANIMATION_PARALLEL)
	addtimer(CALLBACK(src, PROC_REF(FadeOut)), CREDIT_ROLL_SPEED - CREDIT_EASE_DURATION)
	QDEL_IN(src, CREDIT_ROLL_SPEED)
	parent?.screen += src

/atom/movable/screen/credit/Destroy()
	icon = null
	if(parent)
		parent.screen -= src
		LAZYREMOVE(parent.credits, src)
		parent = null
	return ..()

/atom/movable/screen/credit/proc/FadeOut()
	animate(src, alpha = 0, transform = target, time = CREDIT_EASE_DURATION)

#undef CREDIT_ANIMATE_HEIGHT
#undef CREDIT_EASE_DURATION
#undef CREDIT_ROLL_SPEED
#undef CREDIT_SPAWN_SPEED
#undef CREDITS_PATH

// PSYCHONAUT EDIT ADDITION BEGIN - CREDITS - Original:
// #define CREDIT_ROLL_SPEED (12.5 SECONDS)
// #define CREDIT_SPAWN_SPEED (1 SECONDS)
// #define CREDIT_ANIMATE_HEIGHT (14 * ICON_SIZE_Y)
// #define CREDIT_EASE_DURATION (2.2 SECONDS)
// #define CREDITS_PATH "[global.config.directory]/contributors.dmi"
#define CREDIT_ROLL_SPEED 9 SECONDS
#define CREDIT_SPAWN_SPEED 1 SECONDS
#define CREDIT_ANIMATE_HEIGHT (16 * world.icon_size)
#define CREDIT_EASE_DURATION 2.2 SECONDS
// PSYCHONAUT EDIT ADDITION END - CREDITS

/client/proc/RollCredits()
	set waitfor = FALSE
	// PSYCHONAUT EDIT ADDITION BEGIN - CREDITS - Original:
	/*
	if(!fexists(CREDITS_PATH))
		return
	var/icon/credits_icon = new(CREDITS_PATH)
	LAZYINITLIST(credits)
	var/list/_credits = credits
	add_verb(src, /client/proc/ClearCredits)
	var/static/list/credit_order_for_this_round
	if(isnull(credit_order_for_this_round))
		credit_order_for_this_round = list("Thanks for playing!") + (shuffle(icon_states(credits_icon)) - "Thanks for playing!")
	for(var/I in credit_order_for_this_round)
		if(!credits)
			return
		_credits += new /atom/movable/screen/credit(null, null, I, src, credits_icon)
		sleep(CREDIT_SPAWN_SPEED)
	sleep(CREDIT_ROLL_SPEED - CREDIT_SPAWN_SPEED)
	remove_verb(src, /client/proc/ClearCredits)
	qdel(credits_icon)
	*/
	if(!prefs?.read_preference(/datum/preference/toggle/show_roundend_credits))
		return
	LAZYINITLIST(credits)
	var/list/_credits = credits
	add_verb(src, /client/proc/ClearCredits)
	var/list/credit_order_for_this_round = SScredits.credit_order_for_this_round

	var/count = 0
	for(var/I in credit_order_for_this_round)
		if(!credits)
			return
		if(istype(I, /obj/effect/title_card_object)) //huge image sleep
			sleep(CREDIT_SPAWN_SPEED * 3.3)
			count = 0
		if(count && !istype(I, /mutable_appearance) && !istype(I, /obj/effect/cast_object))
			sleep(CREDIT_SPAWN_SPEED)

		_credits += new /atom/movable/screen/credit(null, null, I, src)
		if(istype(I, /mutable_appearance))
			count++
			if(count >= 6)
				count = 0
				sleep(CREDIT_SPAWN_SPEED)
		else if(istype(I, /obj/effect/cast_object))
			count++
			if(count >= 2)
				count = 0
				sleep(CREDIT_SPAWN_SPEED)
		else
			sleep(CREDIT_SPAWN_SPEED)
			count = 0
	sleep(CREDIT_ROLL_SPEED - CREDIT_SPAWN_SPEED)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/client, ClearCredits))
	// PSYCHONAUT EDIT ADDITION END - CREDITS

/client/proc/ClearCredits()
	set name = "Hide Credits"
	set category = "OOC"
	remove_verb(src, /client/proc/ClearCredits)
	QDEL_LIST(credits)
	credits = null

/atom/movable/screen/credit
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 0
	screen_loc = "3.1" // PSYCHONAUT EDIT ADDITION - CREDITS - Original: screen_loc = "12,1"
	plane = SPLASHSCREEN_PLANE
	var/client/parent

// PSYCHONAUT EDIT ADDITION BEGIN - CREDITS - Original:
/*
/atom/movable/screen/credit/Initialize(mapload, datum/hud/hud_owner, credited, client/P, icon/I)
	. = ..()
	icon = I
	parent = P
	icon_state = credited
	maptext = MAPTEXT_PIXELLARI(credited)
	maptext_x = ICON_SIZE_X + 8
	maptext_y = (ICON_SIZE_Y / 2) - 4
	maptext_width = ICON_SIZE_X * 6
*/
/atom/movable/screen/credit/Initialize(mapload, datum/hud/hud_owner, credited, client/P)
	. = ..()
	parent = P
	var/view = P?.view
	var/list/offsets = screen_loc_to_offset("3,1", view)

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

	if(istype(credited, /obj/effect/cast_object))
		var/obj/effect/cast_object/choice = credited
		maptext = MAPTEXT_PIXELLARI(choice.maptext)
		maptext_x = choice.maptext_x
		maptext_y = choice.maptext_y
		maptext_width = choice.maptext_width
		maptext_height = choice.maptext_height

	if(istext(credited))
		maptext = MAPTEXT_PIXELLARI(credited)
		maptext_x = world.icon_size + 8
		maptext_y = (world.icon_size / 2) - 4
		maptext_width = world.icon_size * 12
		maptext_height = world.icon_size * 3
// PSYCHONAUT EDIT ADDITION END - CREDITS

	var/matrix/M = matrix(transform)
	M.Translate(0, CREDIT_ANIMATE_HEIGHT)
	animate(src, transform = M, time = CREDIT_ROLL_SPEED)
	animate(src, alpha = 255, time = CREDIT_EASE_DURATION, flags = ANIMATION_PARALLEL)
	addtimer(CALLBACK(src, PROC_REF(FadeOut)), CREDIT_ROLL_SPEED - CREDIT_EASE_DURATION)
	QDEL_IN(src, CREDIT_ROLL_SPEED)
	// PSYCHONAUT EDIT ADDITION BEGIN - CREDITS - Original:
	/*
	if(parent)
		parent.screen += src
	*/
	// PSYCHONAUT EDIT ADDITION END - CREDITS
	parent.screen += src

/atom/movable/screen/credit/Destroy()
	// PSYCHONAUT EDIT ADDITION BEGIN - CREDITS - Original:
	/*
	icon = null
	if(parent)
		parent.screen -= src
		LAZYREMOVE(parent.credits, src)
		parent = null
	return ..()
	*/
	if(parent)
		parent.screen -= src
		parent.credits -= src
		parent = null
	return ..()
	// PSYCHONAUT EDIT ADDITION END - CREDITS

/atom/movable/screen/credit/proc/FadeOut()
	animate(src, alpha = 0, time = CREDIT_EASE_DURATION, flags = ANIMATION_PARALLEL)

// PSYCHONAUT EDIT ADDITION BEGIN - CREDITS - Original:
// #undef CREDIT_ANIMATE_HEIGHT
// #undef CREDIT_EASE_DURATION
// #undef CREDIT_ROLL_SPEED
// #undef CREDIT_SPAWN_SPEED
// #undef CREDITS_PATH
#undef CREDIT_ANIMATE_HEIGHT
#undef CREDIT_EASE_DURATION
#undef CREDIT_ROLL_SPEED
#undef CREDIT_SPAWN_SPEED
// PSYCHONAUT EDIT ADDITION END - CREDITS

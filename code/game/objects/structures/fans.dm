//Fans
/obj/structure/fans
	icon = 'icons/obj/mining_zones/survival_pod.dmi'
	icon_state = "fans"
	name = "environmental regulation system"
	desc = "A large machine releasing a constant gust of air."
	anchored = TRUE
	density = TRUE
	var/buildstacktype = /obj/item/stack/sheet/iron
	var/buildstackamount = 5
	can_atmos_pass = ATMOS_PASS_NO

/obj/structure/fans/atom_deconstruct(disassembled = TRUE)
	if(buildstacktype)
		new buildstacktype(loc,buildstackamount)

/obj/structure/fans/wrench_act(mob/living/user, obj/item/I)
	user.visible_message(span_warning("[user] disassembles [src]."),
		span_notice("You start to disassemble [src]..."), span_hear("You hear clanking and banging noises."))
	if(I.use_tool(src, user, 20, volume=50))
		deconstruct(TRUE)
	return TRUE

/obj/structure/fans/tiny
	name = "tiny fan"
	desc = "A tiny fan, releasing a thin gust of air."
	layer = ABOVE_NORMAL_TURF_LAYER
	density = FALSE
	icon_state = "fan_tiny"
	buildstackamount = 2

/obj/structure/fans/Initialize(mapload)
	. = ..()
	air_update_turf(TRUE, TRUE)

/obj/structure/fans/Destroy()
	air_update_turf(TRUE, FALSE)
	. = ..()

//Invisible, indestructible fans
/obj/structure/fans/tiny/invisible
	name = "air flow blocker"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	invisibility = INVISIBILITY_ABSTRACT

/obj/structure/fans/tiny/shield
	name = "shuttle bay shield"
	desc = "An tenuously thin energy shield only capable of holding in air, but not solid objects or people."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old" // We should probably get these their own icon at some point
	light_color = LIGHT_COLOR_BLUE
	light_range = 4

/obj/structure/fans/tiny/craftable
	buildstackamount = 5
	max_integrity = 100

/obj/structure/fans/tiny/craftable/welder_act(mob/living/user, obj/item/I)
	if(atom_integrity < max_integrity)
		if(!I.tool_start_check(user, amount = 1))
			return ITEM_INTERACT_SUCCESS
		user.visible_message( \
			span_notice("[user] starts to repair [src]."), \
			span_notice("You begin repairing [src]..."), \
			span_hear("You hear welding."))
		add_fingerprint(user)
		if(I.use_tool(src, user, 4 SECONDS, volume = 50))
			atom_integrity = max_integrity
			user.visible_message( \
				span_notice("[user] finishes reparing [src]."), \
				span_notice("You finish repairing [src]."))
	else
		to_chat(user, span_notice("\The [src] doesn't need repairing."))

	return ITEM_INTERACT_SUCCESS

/obj/structure/fans/tiny/craftable/wrench_act(mob/living/user, obj/item/I)
	to_chat(user, span_notice("You begin to unfasten [src]..."))

	if(I.use_tool(src, user, 2 SECONDS, volume = 50))
		user.visible_message( \
			"[user] unfastens [src].", \
			span_notice("You unfasten [src]."), \
			span_hear("You hear ratchet."))
		add_fingerprint(user)
		deconstruct(TRUE)

		return ITEM_INTERACT_SUCCESS

	return ..()

/obj/structure/fans/tiny/craftable/deconstruct(disassembled = TRUE)
	if(!(obj_flags & NO_DECONSTRUCTION))
		if(disassembled)
			var/obj/item/tinyfan_assembly/frame = new(loc)
			transfer_fingerprints_to(frame)
		else
			if(buildstacktype)
				new buildstacktype(loc, buildstackamount)
	SEND_SIGNAL(src, COMSIG_OBJ_DECONSTRUCT, disassembled)
	qdel(src)

/obj/item/tinyfan_assembly
	name = "tiny fan assembly"
	desc = "A tiny fan, releasing a thin gust of air."
	icon = 'icons/obj/mining_zones/survival_pod.dmi'
	icon_state = "fan_tiny_assembly"

/obj/item/tinyfan_assembly/wrench_act(mob/living/user, obj/item/tool)
	. = ..()

	if(!isturf(loc))
		return TRUE

	for(var/obj/structure/fans/tiny/fan in loc)
		to_chat(user, span_warning("There is already a tiny fan at that location!"))
		return TRUE

	add_fingerprint(user)

	var/obj/structure/fans/tiny/craftable/fan = new(loc)
	transfer_fingerprints_to(fan)

	tool.play_tool_sound(src)
	user.visible_message( \
		"[user] fastens [src].", \
		span_notice("You fasten [src]."), \
		span_hear("You hear ratcheting."))

	qdel(src)

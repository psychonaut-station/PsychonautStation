
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

/obj/structure/fans/tiny/craftable/atom_deconstruct(disassembled = TRUE)
	if(disassembled)
		var/obj/item/tinyfan_assembly/frame = new(loc)
		transfer_fingerprints_to(frame)
	else
		if(buildstacktype)
			new buildstacktype(loc, buildstackamount)

/obj/item/tinyfan_assembly
	name = "tiny fan assembly"
	desc = "A tiny fan, releasing a thin gust of air."
	icon = 'modular_psychonaut/master_files/icons/obj/mining_zones/survival_pod.dmi'
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

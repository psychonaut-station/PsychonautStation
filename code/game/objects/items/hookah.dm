#define INTERNAL_VOLUME 50
#define MAX_FUEL 30
#define FUEL_PER_COAL 30
#define FUEL_CONSUME_INTERVAL 30 SECONDS

#define SMOKE_CONSUME_INTERVAL 1 SECONDS
#define SMOKE_CONSUME_AMOUNT 0.1

#define INHALE_COOLDOWN 5 SECONDS
#define BASE_COUGH_STAMINA_LOSS 5

#define BASE_INHALE_VOLUME 3
#define BASE_INHALE_LIMIT 3

#define MAX_FOOD_ITEMS 5

#define RADIAL_CLEAR image(icon = 'icons/psychonaut/obj/radial.dmi', icon_state = "eject")
#define RADIAL_EXTINGUISH image(icon = 'icons/psychonaut/obj/radial.dmi', icon_state = "extinguish")
#define RADIAL_BLOW image(icon = 'icons/psychonaut/obj/radial.dmi', icon_state = "blow")

#define OPTION_CLEAR "Clear the bowl"
#define OPTION_EXTINGUISH "Extinguish coals"
#define OPTION_BLOW "Light up"

/obj/item/hookah
	name = "hookah"
	desc = "A simple glass water hookah. Perfect for a relaxing break in the dorms."
	icon = 'icons/psychonaut/obj/hookah.dmi'
	icon_state = "hookah"
	max_integrity = 50
	integrity_failure = 0
	inhand_icon_state = "beaker"
	w_class = WEIGHT_CLASS_HUGE

	/// Mouthpiece that belongs to this hookah
	var/obj/item/hookah_mouthpiece/hookah_mouthpiece
	var/fuel = 0
	var/lit = FALSE
	COOLDOWN_DECLARE(fuel_consume_cooldown)
	COOLDOWN_DECLARE(smoke_decrease_cooldown)
	/// Food ingredients inside the bowl
	var/list/food_items = list()
	/// How well smoked is this hookah?
	var/smoke_amount = 0
	var/particle_type

/obj/item/hookah/add_context(atom/source, list/context, atom/target, mob/user)
	. = ..()
	context[SCREENTIP_CONTEXT_RMB] = "Take mouthpiece"
	context[SCREENTIP_CONTEXT_ALT_RMB] = "Action"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/hookah/examine()
	. = ..()
	var/list/food_item_list = list()
	for(var/obj/item/food/food_item in food_items)
		food_item_list += food_item.name
	. += span_notice("In the bowl: [english_list(food_item_list, nothing_text = "empty", and_text = " and ", comma_text = ", ")].")
	. += span_info("Alt + right click to access options.")
	if(lit)
		. += span_notice("[capitalize(src.name)] is lit.")

/obj/item/hookah/Initialize(mapload)
	. = ..()
	hookah_mouthpiece = new(src, src)
	update_appearance(UPDATE_OVERLAYS)
	create_reagents(INTERNAL_VOLUME, TRANSPARENT)
	register_context()

/obj/item/hookah/update_overlays()
	. = ..()
	if(hookah_mouthpiece in contents)
		. += "pipe"
	if(fuel > 0)
		. += "coal"
	if(lit)
		. += "coal_lit"
		. += emissive_appearance(icon, "lit_overlay", src, alpha = src.alpha)

/obj/item/hookah/proc/return_mouthpiece(obj/item/hookah_mouthpiece/current_mouthpiece)
	if(hookah_mouthpiece != current_mouthpiece)
		return FALSE

	if(hookah_mouthpiece in contents)
		return FALSE

	current_mouthpiece.disconnect()
	current_mouthpiece.forceMove(src)
	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/item/hookah/attack_hand_secondary(mob/user, list/modifiers)
	if(ismob(loc))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(!(hookah_mouthpiece in contents))
		balloon_alert(user, "already taken!")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	take_mouthpiece(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/hookah/proc/take_mouthpiece(mob/user)
	user.put_in_hands(hookah_mouthpiece)
	hookah_mouthpiece.connect_to(user)
	to_chat(user, span_notice("You take the mouthpiece in hand."))
	update_appearance(UPDATE_OVERLAYS)

/obj/item/hookah/proc/try_light(obj/item/lighter_object, mob/user)
	var/msg = lighter_object.ignition_effect(src, user)
	if(!msg)
		return FALSE

	if(lit)
		to_chat(user, span_warning("[capitalize(src.name)] is already lit!"))
		return FALSE

	if(!fuel)
		to_chat(user, span_warning("There are no coals in [src.name]!"))
		return FALSE

	visible_message(msg)
	ignite()
	return TRUE

/obj/item/hookah/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(tool == hookah_mouthpiece)
		return_mouthpiece(tool)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/hookah_coals))
		add_coals(user, tool)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/food))
		add_food(user, tool)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/reagent_containers))
		add_reagents(user, tool)
		return ITEM_INTERACT_SUCCESS

	if(try_light(tool, user))
		return
	return NONE

/obj/item/hookah/proc/add_coals(mob/user, obj/item/hookah_coals/coal)
	if(fuel + FUEL_PER_COAL > MAX_FUEL)
		to_chat(user, span_warning("There are already enough coals in [src.name]!"))
		return
	fuel += FUEL_PER_COAL
	qdel(coal)
	to_chat(user, span_notice("You add coals to [src.name]."))

/obj/item/hookah/proc/add_food(mob/user, obj/item/food/food_item)
	if(length(food_items) >= MAX_FOOD_ITEMS)
		to_chat(user, span_warning("There are already enough ingredients in [src.name]!"))
		return
	food_items += food_item
	food_item.forceMove(src)
	to_chat(user, span_notice("You add [food_item.name] to [src.name]."))

/obj/item/hookah/proc/add_reagents(mob/user, obj/item/reagent_containers/container)
	if(istype(container, /obj/item/reagent_containers/applicator/pill))
		return

	if(!container.reagents.total_volume)
		to_chat(user, span_warning("There is nothing inside [container.name]!"))
		return

	var/transferred = container.reagents.trans_to(src, container.amount_per_transfer_from_this)
	if(transferred <= 0)
		to_chat(user, span_warning("There is no space in [src.name]!"))
		return

	user.visible_message(
		span_notice("[user] pours something into [src.name]."),
		span_notice("You pour [transferred] units of liquid into [src.name].")
	)

/obj/item/hookah/process()
	if(!lit || !fuel)
		return PROCESS_KILL

	if(COOLDOWN_FINISHED(src, fuel_consume_cooldown))
		fuel = max(fuel - 1, 0)
		COOLDOWN_START(src, fuel_consume_cooldown, FUEL_CONSUME_INTERVAL)
		if(fuel <= 0)
			put_out()
			return PROCESS_KILL

	if(COOLDOWN_FINISHED(src, smoke_decrease_cooldown) && (smoke_amount - SMOKE_CONSUME_AMOUNT >= 0))
		smoke_amount -= SMOKE_CONSUME_AMOUNT
		COOLDOWN_START(src, smoke_decrease_cooldown, SMOKE_CONSUME_INTERVAL)

/obj/item/hookah/click_alt_secondary(mob/user)
	if(!ishuman(user))
		return CLICK_ACTION_BLOCKING
	var/list/hookah_radial_options = list()
	if(lit)
		hookah_radial_options[OPTION_EXTINGUISH] = RADIAL_EXTINGUISH

	if((length(food_items) || reagents.total_volume) && lit)
		hookah_radial_options[OPTION_BLOW] = RADIAL_BLOW

	if(length(food_items) || reagents.total_volume)
		hookah_radial_options[OPTION_CLEAR] = RADIAL_CLEAR

	var/choice = show_radial_menu(user, src, hookah_radial_options, require_near = TRUE)

	if(!choice)
		return CLICK_ACTION_BLOCKING

	switch(choice)
		if(OPTION_EXTINGUISH)
			if(!lit)
				return CLICK_ACTION_BLOCKING

			to_chat(user, span_notice("You start extinguishing [src.name]..."))
			if(!do_after(user, 2 SECONDS, src))
				return CLICK_ACTION_BLOCKING

			put_out()
			return CLICK_ACTION_SUCCESS

		if(OPTION_BLOW)
			if(!lit)
				return CLICK_ACTION_BLOCKING

			if(!length(food_items) && !reagents.total_volume)
				to_chat(user, span_warning("There are no ingredients in [src.name]!"))
				return CLICK_ACTION_BLOCKING

			var/mob/living/living_user = user
			if(!(hookah_mouthpiece in living_user.held_items))
				return CLICK_ACTION_BLOCKING

			user.visible_message(span_notice("[user] takes a deep drag..."), span_notice("You take a deep drag..."))
			playsound(src, 'sound/_psychonaut/hookah_bubble.ogg', 40)
			if(!do_after(user, 5 SECONDS, src))
				return CLICK_ACTION_BLOCKING

			hookah_mouthpiece.inhale_smoke(living_user, BASE_INHALE_VOLUME * 2, TRUE)
			return CLICK_ACTION_SUCCESS

		if(OPTION_CLEAR)
			if(!do_after(user, 2 SECONDS, src))
				return CLICK_ACTION_BLOCKING

			reagents.clear_reagents()
			QDEL_LIST(food_items)
			to_chat(user, span_notice("You clear the bowl of [src.name]."))
			return CLICK_ACTION_SUCCESS

/obj/item/hookah/proc/ignite()
	particle_type = /particles/smoke/cig/big
	add_shared_particles(particle_type)
	lit = TRUE
	START_PROCESSING(SSmachines, src)
	visible_message(span_notice("The coals inside [src.name] slowly begin to glow red."))
	update_appearance()
	set_light(2, 1, LIGHT_COLOR_ORANGE)
	smoke_amount = 30
	COOLDOWN_START(src, fuel_consume_cooldown, FUEL_CONSUME_INTERVAL)
	COOLDOWN_START(src, smoke_decrease_cooldown, SMOKE_CONSUME_INTERVAL)

/obj/item/hookah/proc/put_out()
	lit = FALSE
	visible_message(span_notice("The coals inside [src.name] return to their usual color."))
	update_appearance()
	if(!fuel)
		STOP_PROCESSING(SSmachines, src)
	stop_smoke()
	set_light(0)
	smoke_amount = 0

/obj/item/hookah/proc/stop_smoke()
	if(particle_type)
		remove_shared_particles(particle_type)
		particle_type = null

/obj/item/hookah/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(QDELETED(src))
		return
	atom_destruction()

/obj/item/hookah/atom_destruction(damage_flag)
	fuel = 0
	new /obj/item/shard(get_turf(src))
	if(reagents.total_volume)
		reagents.expose(get_turf(src), TOUCH)

	for(var/obj/item/food/some_food in food_items)
		var/turf/drop_loc = get_turf(src)
		var/obj/item/food/food_item = some_food
		if(food_item.reagents.total_volume)
			food_item.reagents.expose(drop_loc, TOUCH)
		qdel(food_item)

	if(hookah_mouthpiece)
		qdel(hookah_mouthpiece)

	QDEL_LIST(food_items)
	visible_message(span_warning("[capitalize(src.name)] shatters into pieces with a crack!"))
	playsound(src, SFX_SHATTER, 50)
	return ..()

/obj/item/hookah/pickup(mob/user)
	. = ..()
	if(hookah_mouthpiece && !(hookah_mouthpiece in contents))
		return_mouthpiece(hookah_mouthpiece)
		to_chat(user, span_notice("The mouthpiece returns to [src.name]."))

/obj/item/hookah/Destroy()
	stop_smoke()

	QDEL_LIST(food_items)
	if(hookah_mouthpiece)
		hookah_mouthpiece.source_hookah = null
		hookah_mouthpiece.disconnect()
		QDEL_NULL(hookah_mouthpiece)

	set_light(0)
	return ..()

/obj/item/hookah_mouthpiece
	name = "mouthpiece"
	desc = "A mouthpiece made of some light metal. Something is engraved on its handle."
	icon = 'icons/psychonaut/obj/hookah.dmi'
	icon_state = "mouthpiece"
	w_class = WEIGHT_CLASS_BULKY
	var/obj/item/hookah/source_hookah
	var/datum/beam/beam
	var/atom/attached_to
	COOLDOWN_DECLARE(inhale_cooldown)
	var/currently_inhaling = FALSE

/obj/item/hookah_mouthpiece/Initialize(mapload, obj/item/hookah/hookah)
	. = ..()
	if(hookah)
		source_hookah = hookah
	else
		stack_trace("Hookah mouthpiece created without hookah!")
		return INITIALIZE_HINT_QDEL

/obj/item/hookah_mouthpiece/proc/connect_to(mob/living_mob)
	if(!source_hookah || !living_mob)
		return FALSE

	attached_to = living_mob
	beam = source_hookah.Beam(
		living_mob,
		icon = 'icons/effects/beam.dmi',
		icon_state = "1-full",
		beam_color = COLOR_BLACK,
		layer = BELOW_MOB_LAYER,
		override_origin_pixel_y = 0,
	)

	RegisterSignal(living_mob, COMSIG_MOVABLE_MOVED, PROC_REF(check_distance))
	return TRUE

/obj/item/hookah_mouthpiece/proc/disconnect()
	if(attached_to)
		UnregisterSignal(attached_to, COMSIG_MOVABLE_MOVED)
		attached_to = null
	QDEL_NULL(beam)

/obj/item/hookah_mouthpiece/proc/check_distance()
	if(!source_hookah || !attached_to)
		return

	if((get_dist(source_hookah, attached_to) <= 1) && isturf(attached_to.loc))
		return

	if(ismob(attached_to))
		var/mob/user = attached_to
		user.dropItemToGround(src)
		to_chat(user, span_warning("You let go of [source_hookah.name]."))
	disconnect()

/obj/item/hookah_mouthpiece/Destroy()
	if(source_hookah)
		source_hookah.stop_smoke()
		source_hookah.hookah_mouthpiece = null
	disconnect()
	return ..()

/obj/item/hookah_mouthpiece/dropped(mob/user)
	. = ..()
	currently_inhaling = FALSE
	if(source_hookah)
		source_hookah.return_mouthpiece(src)

/obj/item/hookah_mouthpiece/attack_self(mob/user)
	if(!source_hookah?.lit || !ishuman(user))
		return ..()
	start_inhale(user)

/obj/item/hookah_mouthpiece/attack(mob/living/target_mob, mob/living/user)
	if(target_mob == user && source_hookah.lit)
		start_inhale(target_mob)
		return
	return ..()

/obj/item/hookah_mouthpiece/proc/start_inhale(mob/living/carbon/human/living_user)
	if(currently_inhaling)
		return

	if(!source_hookah || !source_hookah.reagents.total_volume)
		to_chat(living_user, span_warning("There is no liquid in [src.name]!"))
		return

	currently_inhaling = TRUE
	living_user.visible_message(span_notice("[living_user] inhales from [src.name]."), span_notice("You inhale..."))
	playsound(src, 'sound/_psychonaut/hookah_bubble.ogg', 40)
	if(!do_after(living_user, 2 SECONDS, src))
		currently_inhaling = FALSE
		return
	inhale_smoke(living_user, BASE_INHALE_VOLUME)
	currently_inhaling = FALSE

/obj/item/hookah_mouthpiece/proc/inhale_smoke(target_mob, amount, skip_calculations = FALSE)
	var/mob/living/living_user = target_mob
	if(HAS_TRAIT(living_user, TRAIT_NOBREATH))
		to_chat(living_user, span_warning("You cannot take a breath!"))
		return

	if(!source_hookah?.reagents)
		return

	var/datum/reagents/these_reagents = source_hookah.reagents
	for(var/obj/item/food/some_food_item in source_hookah.food_items)
		if(!some_food_item.reagents)
			qdel(some_food_item)
			continue

		some_food_item.reagents.trans_to(these_reagents, amount / length(source_hookah.food_items))
		if(!some_food_item.reagents.total_volume)
			source_hookah.food_items -= some_food_item
			qdel(some_food_item)

	var/smoke_efficiency = min(source_hookah.smoke_amount, 100) / 100
	var/amount_to_transfer = skip_calculations ? amount : amount * smoke_efficiency
	var/amount_to_waste = amount - amount_to_transfer
	var/transferred = these_reagents.trans_to(living_user, amount_to_transfer, methods = INHALE)

	if(transferred)
		to_chat(living_user, span_notice("You inhale smoke from [src.name]."))
		living_user.add_mood_event("smoked", /datum/mood_event/smoked)

		if(!COOLDOWN_FINISHED(src, inhale_cooldown) || transferred > BASE_INHALE_LIMIT)
			living_user.visible_message(span_warning(pick("[living_user] starts coughing!", "[living_user] winces while coughing.", "[living_user] chokes!")), span_warning(pick("Your head is spinning...", "You cough, wincing from a sharp tingling in your throat.", "You choke!")))
			living_user.emote("cough")
			living_user.adjust_stamina_loss(BASE_COUGH_STAMINA_LOSS * (transferred / BASE_INHALE_LIMIT))

		switch(smoke_efficiency * 100)
			if(-INFINITY to 20)
				to_chat(living_user, span_warning("Your throat feels like it's burning..."))
				living_user.emote("cough")
			if(20 to 40)
				to_chat(living_user, span_notice("Slightly bitter."))
			if(40 to 80)
				to_chat(living_user, span_notice("Quite a pleasant taste..."))
			else
				to_chat(living_user, span_notice("Not bad smoke."))

		COOLDOWN_START(src, inhale_cooldown, INHALE_COOLDOWN)
		source_hookah.smoke_amount = min(source_hookah.smoke_amount + rand(amount * 2, amount), 100)
		addtimer(CALLBACK(src, PROC_REF(delayed_puff), living_user, amount_to_waste), 1 SECONDS)

/obj/item/hookah_mouthpiece/proc/delayed_puff(mob/user, amount)
	if(!source_hookah || QDELETED(source_hookah))
		return
	do_chem_smoke(amount / 5, null, user.loc, carry = source_hookah.reagents, amount = amount * 0.2, smoke_type = /obj/effect/particle_effect/fluid/smoke/chem/quick)

/obj/item/hookah_coals
	name = "hookah coals"
	desc = "Dense coals, finely shaped into cubes."
	icon = 'icons/psychonaut/obj/hookah.dmi'
	icon_state = "coals"
	custom_premium_price = PAYCHECK_CREW * 1.5
	w_class = WEIGHT_CLASS_SMALL

/obj/item/hookah_coals/examine()
	. = ..()
	. += span_info("There are three cubes in the pile.")

#undef INTERNAL_VOLUME
#undef MAX_FUEL
#undef FUEL_PER_COAL
#undef FUEL_CONSUME_INTERVAL
#undef SMOKE_CONSUME_INTERVAL
#undef SMOKE_CONSUME_AMOUNT
#undef INHALE_COOLDOWN
#undef BASE_COUGH_STAMINA_LOSS
#undef BASE_INHALE_VOLUME
#undef BASE_INHALE_LIMIT
#undef MAX_FOOD_ITEMS
#undef RADIAL_CLEAR
#undef RADIAL_EXTINGUISH
#undef RADIAL_BLOW
#undef OPTION_CLEAR
#undef OPTION_EXTINGUISH
#undef OPTION_BLOW
